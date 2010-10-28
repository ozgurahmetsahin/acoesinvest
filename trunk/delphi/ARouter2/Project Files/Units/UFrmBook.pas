unit UFrmBook;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, Grids, StdCtrls, Buttons, IdGlobal,
  Tabs, AppEvnts, IniFiles;

type
  TFrmBook = class(TForm)
    Panel1: TPanel;
    StringGrid1: TStringGrid;
    TabSet1: TTabSet;
    Panel2: TPanel;
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    CheckBox1: TCheckBox;
    procedure Menu_ConnOnOffClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure TabSet1Change(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure CheckBox1Click(Sender: TObject);
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    LTrade:Integer;
    LBook: Integer;
    ListBuy:TStringList;
    ListSell:TStringList;
    ListData:TStringList;
    FSymbol: String;
  public
    { Public declarations }
    procedure NotConnected;
    procedure AddLine(Line, Direction, Value, Qty, Broker: String);
    procedure UpdateLine(NewLine, OldLine, Direction, Value, Qty, Broker: String);
    procedure DelLine(Line,Direction,DelType: String);
    procedure UpdateBuyers;
    procedure UpdateSellers;
  published
    property Symbol:String read FSymbol write FSymbol;
  end;
  {$M+}
  TBookThread = class(TThread)
   private
    FBook: TFrmBook;
   protected
    procedure Execute; override;
   published
    property BookForm:TFrmBook read FBook;
   public
    constructor Create(ABook:TFrmBook); reintroduce;
  end;
  {$M-}

var
  FrmBook: TFrmBook;
  BookThread:TBookThread;

implementation

uses UFrmConnectionControl, UFrmMain;

{$R *.dfm}

procedure TFrmBook.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {Finaliza Thread}
  BookThread.Terminate;
  {Limpa Form da memória}
  Action:=caFree;
end;

procedure TFrmBook.FormCreate(Sender: TObject);
begin
 LTrade:=0;
 LBook:=0;

 ListBuy:=TStringList.Create;
 ListSell:=TStringList.Create;
 ListData:=TStringList.Create;

 Menu_ConnOnOffClick(Self);

 BookThread:=TBookThread.Create(Self);
end;

procedure TFrmBook.FormShow(Sender: TObject);
begin
  Edit1.SetFocus;
end;

procedure TFrmBook.Menu_ConnOnOffClick(Sender: TObject);
begin
 // Cria Thread de Conexao e configura as
 // propriedades.
 StringGrid1.Cells[0,0]:='Comprador';
 StringGrid1.Cells[1,0]:='Quantidade';
 StringGrid1.Cells[2,0]:='Preço';
 StringGrid1.Cells[3,0]:='Preço';
 StringGrid1.Cells[4,0]:='Quantidade';
 StringGrid1.Cells[5,0]:='Vendedor';
end;


procedure TFrmBook.NotConnected;
begin
  MessageDlg('Não foi possível solicitar os dados ao servidor.', mtError,[mbOk],0);
end;

procedure TFrmBook.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var BrokeRageFile : TIniFile;
begin
 if ARow >=1 then
 begin
  with StringGrid1.Canvas do
  begin
    case ARow of
       1 : Brush.Color:=RGB(241,234,180);
       2 : Brush.Color:=RGB(234,204,21);
       3 : Brush.Color:=RGB(140,213,43);
       4 : Brush.Color:=RGB(0,170,0);
       5 : Brush.Color:=RGB(132,193,255);
       else
        begin
          if Odd(ARow) then
          Brush.Color:=$00400000
          else
          Brush.Color:=$00770000;
        end;
    end;
   FillRect(Rect);
   Font:=StringGrid1.Font;
   Font.Style:=Font.Style + [fsBold];
   if ARow <= 5 then
   Font.Color:=clBlack
   else
   Font.Color:=clWhite;
   TextRect(Rect,Rect.Left + 3,Rect.Top + 3,StringGrid1.Cells[ACol,ARow]);

   if (ACol = 0 ) or ( ACol = 5 ) then
    begin
    BrokeRageFile:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'brokerages.ini');
    TextRect(Rect,Rect.Left + 3,Rect.Top + 3,BrokeRageFile.ReadString('brokerage',StringGrid1.Cells[ACol,ARow],''));
    BrokeRageFile.Free;
    end;

  end;


 end;
end;

procedure TFrmBook.TabSet1Change(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
  case NewTab of
    0: StringGrid1.RowCount:=6;
    1: StringGrid1.RowCount:=11;
    2: StringGrid1.RowCount:=16;
    3: StringGrid1.RowCount:=5000;
  end;
end;

procedure TFrmBook.AddLine(Line, Direction, Value, Qty, Broker: String);
var LO,LN,K,I:Integer;
    DataLine:String;
begin
 try
 DataLine:=Line+':'+Value+':'+Qty+':'+Broker;
 if Direction = 'A' then
 begin
   ListBuy.Add(DataLine);
 end
 else
 begin
   ListSell.Add(DataLine);
 end;
 except
   on E:Exception do
//   FrmMain.Memo1.Lines.Add('A:'+E.Message);
 end;
end;


procedure TFrmBook.UpdateBuyers;
var I:Integer;
    S:TStringList;
begin
  S:=TStringList.Create;
  for I := 0 to ListBuy.Count-1 do
  begin
    SplitColumns(ListBuy.Strings[I],S,':');
    StringGrid1.Cells[0,I+1]:=S[3];
    StringGrid1.Cells[1,I+1]:=S[2];
    StringGrid1.Cells[2,I+1]:=S[1];
  end;
  FreeAndNil(S);
end;

procedure TFrmBook.UpdateLine(NewLine, OldLine, Direction, Value, Qty, Broker: String);
var LO,LN,K,I:Integer;
     DataLine:String;
begin
   DataLine:=NewLine+':'+Value+':'+Qty+':'+Broker;
   LN:=StrToInt(NewLine);
   LO:=StrToInt(OldLine);
  if Direction = 'A' then
  begin
    if LN <> LO then
    begin
      try
       try
        if ListBuy.Count > LO then
        ListBuy.Delete(LO);
       except
         on E:Exception do
//            FrmMain.Memo1.Lines.Add('U:'+E.Message);
       end;
      finally
       ListBuy.Insert(LN,DataLine);
      end;
    end
    else
    begin
      ListBuy.Strings[LN]:=DataLine;
    end;
    end
  else
  begin
    if LN <> LO then
    begin
      try
       try
        if ListSell.Count > LO then
        ListSell.Delete(LO);
       except
         on E:Exception do
//         FrmMain.Memo1.Lines.Add('U:'+E.Message);
       end;
      finally
       ListSell.Insert(LN,DataLine);
      end;
    end
    else
    begin
      ListSell.Strings[LN]:=DataLine;
    end;
  end;

end;

procedure TFrmBook.UpdateSellers;
var I:Integer;
    S:TStringList;
begin
  S:=TStringList.Create;
  for I := 0 to ListSell.Count-1 do
  begin
    SplitColumns(ListSell.Strings[I],S,':');
    StringGrid1.Cells[3,I+1]:=S[1];
    StringGrid1.Cells[4,I+1]:=S[2];
    StringGrid1.Cells[5,I+1]:=S[3];
  end;
  FreeAndNil(S);
end;

procedure TFrmBook.ApplicationEvents1Exception(Sender: TObject; E: Exception);
begin
 Abort;
end;

procedure TFrmBook.BitBtn1Click(Sender: TObject);
begin
 SignalConnection.SendMsg('bqt '+ Edit1.Text);
 Self.Caption:='Livro de Ofertas [' +  UpperCase(Edit1.Text) + ']';
 Symbol:=UpperCase(Edit1.Text);
end;

procedure TFrmBook.CheckBox1Click(Sender: TObject);
begin
 if CheckBox1.Checked then
 Self.FormStyle:=fsStayOnTop
 else
 Self.FormStyle:=fsNormal;
end;

procedure TFrmBook.DelLine(Line,Direction,DelType: String);
var I,L:Integer;
    DataLine:String;
begin
  try
  L:=StrToInt(Line);
  if Direction='A' then
  begin
    if ListBuy.Count >= L then
    begin
      ListBuy.Delete(L);
    end;
  end
  else
  begin
    if ListSell.Count >= L then
    begin
      ListSell.Delete(L);
    end;
  end;
  except
    on E:Exception do
//    FrmMain.Memo1.Lines.Add('D:'+E.Message);
  end;
end;


{ TBookThread }

constructor TBookThread.Create(ABook: TFrmBook);
begin
  FBook:=ABook;
  inherited Create(False);
end;

procedure TBookThread.Execute;
var Data:TStringList;
    Row,I,L:Integer;
    Line:String;
    IsUpdate:Boolean;
begin
  Data:=TStringList.Create;
  Row:=0;

  while not Terminated do
  begin
    IsUpdate:=False;

    while SignalConnection.GetDataCount > Row do
    begin
      Line:=SignalConnection.GetDataLine(Row);
      SplitColumns(Line, Data, ':');

      if (Data[0]='B') And (Data[1]=FBook.Symbol) then
      begin
        // Analisamos se é tipo A ( Adiciona )
        if(Data[2]='A')then
        FBook.AddLine(Data[3], Data[4], Data[5], Data[6], Data[7]);

        // Analisamos se é tipo U ( Atualiza )
        if(Data[2]='U')then
        FBook.UpdateLine(Data[3], Data[4],Data[5], Data[6], Data[7], Data[8]);

        // Analisamos se é tipo D ( Deleta )
        if(Data[2]='D')then
         if(Data[3] <> '3')then
         FBook.DelLine(Data[5], Data[4], Data[3]);

        IsUpdate:=True;
      end;
      Data.Clear;
      Row:=Row+1;
      L:=-1;
    end;
    {Aguarda 100 milisegundos, sem isso o processo fica muito pesado,
    consumindo muito a CPU}
    Sleep(100);

    {Atualiza Lista}
    if IsUpdate then
    begin
      Synchronize(FBook.UpdateBuyers);
      Synchronize(FBook.UpdateSellers);
    end;

    if Terminated then
    Break;
  end;
end;

end.
