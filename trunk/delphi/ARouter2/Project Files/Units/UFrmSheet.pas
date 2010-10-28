{ TODO : Colocar os textos do formulario na unit de msgs. }
unit UFrmSheet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, StdCtrls, Buttons, ComCtrls, Menus, IdGlobal;

type
  TFrmSheet = class(TForm)
    Sheet: TStringGrid;
    Panel1: TPanel;
    lblEdtNewSymbol: TLabeledEdit;
    StatusBar1: TStatusBar;
    btnOpenDeleteSheet: TBitBtn;
    btnNewSheet: TBitBtn;
    btnDeleteSymbol: TBitBtn;
    btnClearSheet: TBitBtn;
    PopupMenu1: TPopupMenu;
    DeleteSymbol: TMenuItem;
    btnAddSymbol: TBitBtn;
    procedure btnAddSymbolClick(Sender: TObject);
    procedure SheetDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure btnOpenDeleteSheetClick(Sender: TObject);
    procedure btnNewSheetClick(Sender: TObject);
    procedure btnDeleteSymbolClick(Sender: TObject);
    procedure SheetKeyPress(Sender: TObject; var Key: Char);
    procedure btnClearSheetClick(Sender: TObject);
    procedure DeleteSymbolClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    function AppPath:String;
  public
    { Public declarations }
    SheetName:String;
    procedure ClearSheet;
    procedure Save;
    procedure Load(Name:String);
    procedure SetValue(Col, Row:Integer; Value:String);
    function GetSymbolLine(Symbol:String):Integer;
  end;

 {Thread de Leitura dos dados para a planilha}
 {$M+}
 TSheetThread = class(TThread)
  private
    FSheet: TFrmSheet;
  protected
    procedure Execute; override;
  published
    property SheetForm:TFrmSheet read FSheet;
  public
    constructor Create(ASheet : TFrmSheet); reintroduce;

 end;
 {$M-}

var
  FrmSheet: TFrmSheet;
  ThreadRead : TSheetThread;
implementation

uses UFrmOpenSheet, UConsts, UFrmConnectionControl;

{$R *.dfm}

procedure TFrmSheet.btnOpenDeleteSheetClick(Sender: TObject);
begin
 {Configura o filelist para exibir arquivos da pasta de instalação}
 FrmOpenSheet.FileListBox1.Directory:=AppPath;
 {Carrega Lista de arquivos}
 FrmOpenSheet.FileListBox1.Update;
 {Exibe o formulario de escolha de planilha}
 FrmOpenSheet.ShowModal;
end;

procedure TFrmSheet.btnNewSheetClick(Sender: TObject);
var NewSheetName:String;
begin
  {Pergunta o novo nome da planilha}
  NewSheetName:=InputBox(SSheet_Caption_NewSheet, SSheet_Prompt_NewSheet, '');

  if(NewSheetName<>'')then
  begin
    {Limpa Planilha Atual}
    ClearSheet;

    {Configura novo nome}
    SheetName:=NewSheetName+'.sht';

    {Salva a planilha}
    Save;
  end;
end;

procedure TFrmSheet.btnDeleteSymbolClick(Sender: TObject);
var
  Col: Integer;
  Row: Integer;
begin
    {Se não foi a ultima linha, sobre todas as outras}
    if (Sheet.Row < Sheet.RowCount-1) And (SheetName<>'') then
    begin
      for Col := 0 to Sheet.ColCount - 1 do
      begin
        for Row := Sheet.Row to Sheet.RowCount - 1 do
        begin
          Sheet.Cells[Col,Row]:=Sheet.Cells[Col,Row+1];
        end;
      end; // for Col
    end  // if Row
    else
    begin
     // Ultima linha, apenas limpa
     for Col := 0 to Sheet.ColCount - 1 do
      begin
         Sheet.Cells[Col,Sheet.Row]:='';
      end; // for Col
    end;

    {Se não for a unica linha da planilha}
    if Sheet.Row > 1 then
    Sheet.RowCount:=Sheet.RowCount-1;

    Save;
end;

procedure TFrmSheet.btnClearSheetClick(Sender: TObject);
begin
 if SheetName<>'' then
 begin
  ClearSheet;
  Save;
 end;
end;

function TFrmSheet.AppPath: String;
begin
  Result:=ExtractFilePath(ParamStr(0));
end;

procedure TFrmSheet.btnAddSymbolClick(Sender: TObject);
begin
 if(lblEdtNewSymbol.Text<>'') And (SheetName<>'')then
 begin
   {Adiciona na planilha de cotações}
   if(Sheet.Cells[0,1]='')then
   begin
     {Se a primeira linha estiver vazia, coloca nela}
     Sheet.Cells[0,1]:=UpperCase(lblEdtNewSymbol.Text);
   end
   else
   begin
     {Caso contrario, adiciona uma nova linha e coloca nela o ativo}
     Sheet.RowCount:=Sheet.RowCount+1;
     Sheet.Cells[0,Sheet.RowCount-1]:=UpperCase(lblEdtNewSymbol.Text);
   end;

   Save;

   SignalConnection.SendMsg('sqt ' + lblEdtNewSymbol.Text);

   lblEdtNewSymbol.Clear;
 end
 else if SheetName='' then
      MessageDlg(SSheet_AddSymbol_WithSheetNameEmpty,mtInformation,[mbOk],0);
end;

procedure TFrmSheet.ClearSheet;
var
  Col: Integer;
begin
 Sheet.RowCount:=2;
 for Col := 0 to Sheet.ColCount - 1 do
 Sheet.Cells[Col,1]:='';
end;

procedure TFrmSheet.DeleteSymbolClick(Sender: TObject);
begin
  btnDeleteSymbolClick(Self);
end;

procedure TFrmSheet.FormCreate(Sender: TObject);
begin
 {Carrega nome das colunas}
 Sheet.Cells[0,0]:=SSheet_ColumnName_Symbol;
 Sheet.Cells[1,0]:=SSheet_ColumnName_LastPrice;
 Sheet.Cells[2,0]:=SSheet_ColumnName_Percent;
 Sheet.Cells[3,0]:=SSheet_ColumnName_Bid;
 Sheet.Cells[4,0]:=SSheet_ColumnName_Ask;
 Sheet.Cells[5,0]:=SSheet_ColumnName_High;
 Sheet.Cells[6,0]:=SSheet_ColumnName_Low;
 Sheet.Cells[7,0]:=SSheet_ColumnName_Open;
 Sheet.Cells[8,0]:=SSheet_ColumnName_Close;
 Sheet.Cells[9,0]:=SSheet_ColumnName_Busines;
 ThreadRead:=TSheetThread.Create(Self);
end;

function TFrmSheet.GetSymbolLine(Symbol: String): Integer;
var R:Integer;
    L:Integer;
begin
  L:=-1;
  for R := 1 to Sheet.RowCount-1 do
  begin
    if Sheet.Cells[0,R] = Symbol then
    begin
      L:=R;
      Break;
    end;
  end;
  Result:=L;
end;

procedure TFrmSheet.Load(Name: String);
var SymbolList:TStringList;
  I: Integer;
begin
  if FileExists(Name) then
  begin
    {Limpa Linhas atuais}
    ClearSheet;
    {Cria instancia para arquivo}
    SymbolList:=TStringList.Create;
    SymbolList.LoadFromFile(Name);
    {Varre arquivo}
    for I := 0 to SymbolList.Count - 1 do
    begin
      {Adiciona na planilha de cotações}
      if(Sheet.Cells[0,1]='')then
      begin
       {Se a primeira linha estiver vazia, coloca nela}
       Sheet.Cells[0,1]:=UpperCase(SymbolList[I]);
      end
      else
      begin
        {Caso contrario, adiciona uma nova linha e coloca nela o ativo}
        Sheet.RowCount:=Sheet.RowCount+1;
        Sheet.Cells[0,Sheet.RowCount-1]:=UpperCase(SymbolList[I]);
      end;
    end;

    SheetName:=ExtractFileName( Name );
    {Atualiza barra de status}
    StatusBar1.Panels.Items[0].Text:=SSheet_Panel_SheetName + SheetName;
    if(Sheet.Cells[0,1]<>'')then
    StatusBar1.Panels.Items[1].Text:=SSheet_Panel_SymbolsQty+IntToStr(Sheet.RowCount-1)
    else
    StatusBar1.Panels.Items[1].Text:=SSheet_Panel_SymbolsQty+IntToStr(Sheet.RowCount-2);

    {Limpa instancia para arquivo}
    SymbolList.Free;
  end;
end;

procedure TFrmSheet.Save;
var SymbolList : TStringList;
  L: Integer;
begin
 SymbolList:= TStringList.Create;

 for L := 1 to Sheet.RowCount do
 begin
   if(Sheet.Cells[0,L] <> '') then
   begin
     SymbolList.Add(Sheet.Cells[0,L]);
   end;
 end;

 SymbolList.SaveToFile(AppPath+SheetName);

 {Atualiza barra de status}
 StatusBar1.Panels.Items[0].Text:=SSheet_Panel_SheetName + SheetName;
 if(Sheet.Cells[0,1]<>'')then
 StatusBar1.Panels.Items[1].Text:=SSheet_Panel_SymbolsQty+IntToStr(Sheet.RowCount-1)
 else
 StatusBar1.Panels.Items[1].Text:=SSheet_Panel_SymbolsQty+IntToStr(Sheet.RowCount-2);
end;

procedure TFrmSheet.SetValue(Col, Row: Integer; Value: String);
begin
 {Verifica se tem o ! no final}
 if Copy(Value,Length(Value),1)='!' then
  Sheet.Cells[Col,Row]:=Copy(Value,1,Length(Value)-1)
 else
  Sheet.Cells[Col,Row]:=Value;
end;

procedure TFrmSheet.SheetDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var BgColor:TColor;
    FontColor:TColor;
    X:Integer;
begin
 if(ARow>=1)then
 begin

   {Zebra}
   if Odd(ARow) then
   begin
     BgColor:=$00400000;
   end
   else
   begin
     BgColor:=$00770000;
   end;

   FontColor:=clWhite;

   with Sheet.Canvas do
   begin
     Brush.Color:=BgColor;
     FillRect(Rect);
     Font:=Sheet.Font;
     Font.Color:=FontColor;
     Font.Style:=Font.Style + [fsBold];
   end;
   {Fim Zebra}

   {Alinhamento à direita}
   with Sheet.Canvas do
   begin
     X:= Rect.Left + ( ( Rect.Right - Rect.Left) - TextWidth(Sheet.Cells[ACol,ARow]) - 3);
     TextRect(Rect,X ,Rect.Top + 3,Sheet.Cells[ACol,ARow]);
   end;

 end; // if ARow>=1
end;

procedure TFrmSheet.SheetKeyPress(Sender: TObject; var Key: Char);
begin
lblEdtNewSymbol.Text:=Key;
lblEdtNewSymbol.SetFocus;
lblEdtNewSymbol.SelStart:=Length(lblEdtNewSymbol.Text);
end;

{ TSheetThread }

constructor TSheetThread.Create(ASheet: TFrmSheet);
begin
  FSheet:=ASheet;
  inherited Create(False);
end;

procedure TSheetThread.Execute;
var Data:TStringList;
    Row,I,L:Integer;
    Line:String;
begin
  Data:=TStringList.Create;
  Row:=0;

  while not Terminated do
  begin

    while SignalConnection.GetDataCount > Row do
    begin
      Line:=SignalConnection.GetDataLine(Row);
      SplitColumns(Line, Data, ':');

      if Data[0]='T' then
      begin
        L:=FSheet.GetSymbolLine(Data[1]);
        for I := 3 to Data.Count-1 do
        begin
          if Odd(I) then
          begin
            if Data[I]='2' then
              if L>0 then
               FSheet.SetValue(1,L,Data[I+1]);
            if Data[I]='3' then
              if L>0 then
               FSheet.SetValue(3,L,Data[I+1]);
            if Data[I]='4' then
              if L>0 then
               FSheet.SetValue(4,L,Data[I+1]);
            if Data[I]='8' then
              if L>0 then
               FSheet.SetValue(9,L,Data[I+1]);
            if Data[I]='700' then
              if L>0 then
               FSheet.SetValue(2,L,Data[I+1]);
          end;
        end;
      end;

      Data.Clear;
      Row:=Row+1;
      L:=-1;
    end;
    {Aguarda 100 milisegundos, sem isso o processo fica muito pesado,
    consumindo muito a CPU}
    Sleep(100);
  end;

end;

end.
