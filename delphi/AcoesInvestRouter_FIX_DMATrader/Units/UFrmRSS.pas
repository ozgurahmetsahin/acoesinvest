unit UFrmRSS;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, xmldom, XMLIntf, XMLDoc, msxmldom, ComCtrls,
  StdCtrls, ExtCtrls,UrlMon, ImgList, ToolWin, Buttons, OleCtrls, SHDocVw;

type
  TFrmNews = class(TForm)
    CoolBar1: TCoolBar;
    SpeedButton2: TSpeedButton;
    Panel1: TPanel;
    Panel2: TPanel;
    ListTitles: TListView;
    Splitter1: TSplitter;
    DescriptionReader: TWebBrowser;
    XMLDoc: TXMLDocument;
    Timer1: TTimer;
    procedure ListTitlesClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure GetRSS(URL : String);
  end;

var
  FrmNews: TFrmNews;

implementation
{$R *.dfm}

uses ExtActns;//to be able to iuse TDownLoadURL

function DownloadURLFile(const ADPXMLBLOG, ADPLocalFile : TFileName) : boolean;
begin
  Result:=True;

  with TDownLoadURL.Create(nil) do
  try
    URL:=ADPXMLBLOG;
    Filename:=ADPLocalFile;
    try
      ExecuteTarget(nil);
    except
      Result:=False;
    end;
  finally
    Free;
  end;
end;

procedure TFrmNews.FormShow(Sender: TObject);
begin
 SpeedButton2Click(Self);
end;

procedure TFrmNews.GetRSS(URL : String);
var
  ADPLocalFile : TFileName;
  STitle,
  sDesc,
  sData : WideString;
  I,
  StartTag,StartTagTitle,StartTagText, StartTagData,
  EndTagTitle,EndTagText, EndTagData: Integer;
  K: Integer;
  DescriptionFile : TStringList;
begin
  ADPLocalFile := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'news.xml';

  Screen.Cursor:=crHourglass;
  try
    if not DownloadURLFile(URL, ADPLocalFile)  then
    begin
      Screen.Cursor:=crDefault;
      Raise Exception.CreateFmt('Unable to connect to the Internet, make sure you are connected!',[]);
      Exit;
    end;

    if not FileExists(ADPLocalFile) then
    begin
      Screen.Cursor:=crDefault;
      raise exception.Create('Can''t locate the *headlines* file?!');
      Exit;
    end;

    ListTitles.Clear;

    XMLDoc.FileName := ADPLocalFile;
    XMLDoc.Active:=True;

    for I := 0 to XMLDoc.XML.Count - 1 do
    begin
//       ShowMessage(XMLDoc.XML.Strings[I]);

       // Varre linha a procura de <
       for K := 1 to Length(XMLDoc.XML.Strings[I]) - 1 do
       begin
         if(Copy(XMLDoc.XML.Strings[I],K,8) = '<titulo>')then
         begin
           StartTag:=1;
           StartTagTitle:=K + 8;
         end;
         if(Copy(XMLDoc.XML.Strings[I],K,9) = '</titulo>')then
         begin
           StartTag:=3;
           EndTagTitle:=K - (StartTagTitle - 8);
         end;

         if(Copy(XMLDoc.XML.Strings[I],K,6) = '<data>')then
         begin
           StartTag:=5;
           StartTagData:=K + 6;
         end;
         if(Copy(XMLDoc.XML.Strings[I],K,7) = '</data>')then
         begin
           StartTag:=6;
           EndTagData:=K - (StartTagData - 6);
         end;

         if(Copy(XMLDoc.XML.Strings[I],K,7) = '<texto>')then
         begin
           StartTag:=2;
           StartTagText:=K + 7;
         end;
         if(Copy(XMLDoc.XML.Strings[I],K,8) = '</texto>')then
         begin
           StartTag:=4;
           EndTagText:=K - (StartTagText - 7);
           break;
         end;

         if(StartTag = 1)then
          STitle:=STitle + Copy(XMLDoc.XML.Strings[I],K,1);

         if StartTag = 2 then
         sDesc := sDesc + Copy(XMLDoc.XML.Strings[I],K,1);

         if(StartTag = 5)then
         sData:=sData + Copy(XMLDoc.XML.Strings[I],K,1);
       end;

       if StartTag = 4 then
       begin
//       if(Copy(XMLDoc.XML.Strings[I],StartTag,8) = '<titulo>')then
//       begin
//         STitle:=Copy(XMLDoc.XML.Strings[I],StartTag+8,EndTag - (StartTag + 8));
         if(Copy(STitle,9,2)='<!')then
         ListTitles.Items.Add.Caption:=Copy(sData,7,EndTagData) +' - '+ Copy(STitle,18,EndTagTitle - 20)
         else
         ListTitles.Items.Add.Caption:=Copy(sData,7,EndTagData) +' - '+ Copy(STitle,9,EndTagTitle);
//       end;
//
//       if(Copy(XMLDoc.XML.Strings[I],StartTag,7) = '<texto>')then
//       begin
//
//       SDesc:=Copy(XMLDoc.XML.Strings[I],StartTag+16,EndTag - (StartTag + 19));

       {Armazena descrição}
       DescriptionFile:=TStringList.Create;

       DescriptionFile.Add('<html><head><style>body{font-family: verdana, tahoma;font-size: 0.7em;line-height: 1.3em;padding: 0; margin: 0;}'
       +'.title {font-size: 1.6em; font-family: arial, verdana, tahoma; font-weight: bold;'
       +'letter-spacing: -1px; line-height: 1.1em;}</style></head><body>');

       DescriptionFile.Add('<span class="title">');

       if(Copy(STitle,9,2)='<!')then
        DescriptionFile.Add(Copy(STitle,18,EndTagTitle - 20))
       else
        DescriptionFile.Add(Copy(STitle,9,EndTagTitle));

       DescriptionFile.Add('</span><br/>');
       DescriptionFile.Add('</b><br/><br/>');
       if(Copy(SDesc,9,2)='<!')then
        DescriptionFile.Add(Copy(SDesc,17,Length(SDesc)-10))
       else
        DescriptionFile.Add(Copy(SDesc,8,Length(SDesc)-10));

       DescriptionFile.Add('<br/><br/>');
       DescriptionFile.Add('<br/>');
       DescriptionFile.Add('<hr>');
       DescriptionFile.Add('</body></html>');
       DescriptionFile.SaveToFile(ExtractFilePath(ParamStr(0)) + IntToStr( ListTitles.Items.Count - 1 ) + '.html');

       STitle:='';
       sDesc:='';
       sData:='';
       StartTag:=3;
       end;
       //      end;
    end;

  finally
    //DeleteFile(ADPLocalFile);
    Screen.Cursor:=crDefault;
  end;
end;
//var XMLRss : TXMLDocument;
//    Node : IXMLNode;
//    NodeDesc : IXMLNode;
//    NodeID : Integer;
//    DescriptionFile : TStringList;
//    TimeRcpt : String;
//begin
// try
//   {Faz download do arquivo}
//   DownloadURLFile(URL,ExtractFilePath(ParamStr(0)) + 'news.xml');
//
//   {Arquivo existe}
//   if FileExists(ExtractFilePath(ParamStr(0)) +'news.xml') then
//   begin
//     {Cria leitor do arquivo XML}
//     XMLRss := TXMLDocument.Create(Self);
//
//     {Abre arquivo XML}
//     with XMLRss do
//     begin
//       FileName:=ExtractFilePath(ParamStr(0)) +'news.xml';
//       Active:=True;
//     end;
//
//     {Variavel de controle para armazenar as descricoes}
//     NodeID:=ListTitles.Items.Count;
//
//     NodeDesc:= XMLRss.DocumentElement.ChildNodes.FindNode('noticias');
//
//     {Obtem primeira tag(node) 'item'}
//     Node:= XMLRss.DocumentElement.ChildNodes.First.ChildNodes.FindNode('noticia');
//
//     {Repete até ficar nulo}
//     repeat
//       {Adiciona titulo}
//       ListTitles.Items.Add.Caption:= Node.ChildNodes['titulo'].Text;
//
//       {Armazena descrição}
//       DescriptionFile:=TStringList.Create;
//
//       DescriptionFile.Add('<html><head><style>body{font-family: verdana, tahoma;font-size: 0.7em;line-height: 1.3em;padding: 0; margin: 0;}'
//       +'.title {font-size: 1.6em; font-family: arial, verdana, tahoma; font-weight: bold;'
//       +'letter-spacing: -1px; line-height: 1.1em;}</style></head><body>');
//
//       DescriptionFile.Add('<span class="title">');
//
//       DescriptionFile.Add(Node.ChildNodes['titulo'].Text);
//
//       DescriptionFile.Add('</span><br/>');
//
//       DescriptionFile.Add('Notícia recebida às <b>');
//       TimeRcpt:=Copy(Node.ChildNodes['pubDate'].Text,Length(Node.ChildNodes['pubDate'].Text) - 13,8);
//       if TimeRcpt = '' then
//       TimeRcpt:=TimeToStr(Time);
//       DescriptionFile.Add(TimeRcpt);
//       DescriptionFile.Add('</b><br/><br/>');
//       DescriptionFile.Add(Node.ChildNodes['texto'].Text);
//       DescriptionFile.Add('<br/><br/>');
//       DescriptionFile.Add('<a href='+ #39 + Node.ChildNodes['link'].Text + #39 +'> Leia mais... </a>');
//       DescriptionFile.Add(' <i>( ' +  NodeDesc.ChildNodes['texto'].Text + ' )</i>' );
//       DescriptionFile.Add('<br/>');
//       DescriptionFile.Add('<hr>');
//       DescriptionFile.Add('</body></html>');
//       DescriptionFile.SaveToFile(ExtractFilePath(ParamStr(0)) + IntToStr(NodeID) + '.html');
//       DescriptionFile.Free;
//       Inc(NodeID,1);
//       {Proximo item}
//       Node:= Node.NextSibling;
//     until
//       Node = nil;
//
//     XMLRss.Active:=False;
//     XMLRss.Free;
//
//
//   end;
//
// except on E: Exception do
//   ShowMessage(e.Message);
// end;
//end;

procedure TFrmNews.ListTitlesClick(Sender: TObject);
begin
  if ListTitles.ItemIndex >=0 then  
  DescriptionReader.Navigate(ExtractFilePath(ParamStr(0)) + IntToStr(ListTitles.ItemIndex) + '.html' );
end;

procedure TFrmNews.SpeedButton2Click(Sender: TObject);
begin
 GetRSS('http://www.tecnicaassessoria.com.br/tecnicahb/app/webroot/xml/noticias.xml');
 //GetRSS('http://z.about.com/6/g/delphi/b/index.xml');
end;

procedure TFrmNews.Timer1Timer(Sender: TObject);
begin
 if Self.Showing then
  if Self.Active then
  SpeedButton2Click(Self);
end;

end.
