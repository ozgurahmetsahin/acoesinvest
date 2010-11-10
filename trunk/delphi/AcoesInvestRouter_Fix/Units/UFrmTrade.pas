unit UFrmTrade;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, Sheet, StdCtrls, ExtCtrls,IdException,IdExceptionCore, Menus,
  Buttons;

type
  TFrmTrade = class(TForm)
    TradeSheet: TSheet;
    Edit1: TEdit;
    Button1: TButton;
    Panel1: TPanel;
    Label1: TLabel;
    PopupMenu1: TPopupMenu;
    MoverparCima1: TMenuItem;
    Moverparabaixo1: TMenuItem;
    N1: TMenuItem;
    Excluirativo1: TMenuItem;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    N2: TMenuItem;
    Book5Melhores1: TMenuItem;
    Resumodoativo1: TMenuItem;
    N3: TMenuItem;
    Compra1: TMenuItem;
    Venda1: TMenuItem;
    BalloonHint1: TBalloonHint;
    CheckBox1: TCheckBox;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure MoverparCima1Click(Sender: TObject);
    procedure Moverparabaixo1Click(Sender: TObject);
    procedure Excluirativo1Click(Sender: TObject);
    procedure TradeSheetDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure TradeSheetKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TradeSheetKeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Book5Melhores1Click(Sender: TObject);
    procedure Compra1Click(Sender: TObject);
    procedure Venda1Click(Sender: TObject);
    procedure Resumodoativo1Click(Sender: TObject);
    procedure TradeSheetDblClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    procedure Save;
    procedure Load;
    procedure UpColor(ACol : Integer; ARow:Integer);
  end;

var
  FrmTrade: TFrmTrade;

implementation

uses UFrmMainTreeView, UFrmTradeCentral, UFrmBrokerBuy,UFrmBrokerSell,
  UFrmMiniBook, UFrmAbstractSymbol, UThrdDaileonFwRead;

{$R *.dfm}

procedure TFrmTrade.Book5Melhores1Click(Sender: TObject);
var j:integer;
    s:String;
begin
  for j := 1 to 20 do
  begin
    if not Assigned(FrmMainTreeView.FrmsBooks[j]) then
    begin
      s:=TradeSheet.SelectedQuote;
      Application.CreateForm(TFrmMiniBook,FrmMiniBook);
      FrmMainTreeView.FrmsBooks[j]:=FrmMiniBook;
      FrmMiniBook.Symbol:=UpperCase(s);
      FrmMiniBook.Edit1.Text:=UpperCase(s);
      FrmMiniBook.Button1Click(Self);
      FrmMiniBook.Show;
      break;
    end;
  end;
end;

procedure TFrmTrade.Button1Click(Sender: TObject);
begin
  try
   //Se não existir na listagem geral, adiciona
   if Edit1.Text <> '' then
   begin
     if(Edit1.Text = 'showmelog') then
     begin
       FrmMainTreeView.Show;
       exit;
     end;

     if(not FrmTrade.TradeSheet.FindQuote(Edit1.Text)) then
     TradeSheet.NewLine(Edit1.Text)
     else
     MessageDlg('Esse ativo já existe em sua planilha.',mtInformation,[mbOK],0);

     SignalThread.WriteLn('sqt ' + LowerCase(Edit1.Text));

     if( not FrmCentral.CentralSheet.FindQuote(Edit1.Text) ) then
     FrmCentral.AddSymbol(Edit1.Text);

     Save;

     Edit1.Clear;
   end;
  except
    on E: EIdNotConnected do
    begin
      FrmMainTreeView.MsgErr:='Você não está conectado.';
      FrmMainTreeView.ShowMsgErr;
    end;
    on E: EAccessViolation do
    begin
      FrmMainTreeView.MsgErr:='Não foi possível enviar a solicitação ao servidor.';
      FrmMainTreeView.ShowMsgErr;
    end;
    on E: EIdConnClosedGracefully do
    begin
      FrmMainTreeView.MsgErr:='Não há uma conexão ativa.';
      FrmMainTreeView.ShowMsgErr;
    end;
  end;

end;

procedure TFrmTrade.CheckBox1Click(Sender: TObject);
begin
 if CheckBox1.Checked then
 Self.FormStyle:=fsStayOnTop
 else
 Self.FormStyle:=fsNormal;
end;

procedure TFrmTrade.Compra1Click(Sender: TObject);
var Key : Word;
    Shift : TShiftState;
begin
  Key:=116;
  TradeSheetKeyDown(Self,Key,Shift);
end;

procedure TFrmTrade.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle:= Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent:= GetDesktopWindow;
end;

procedure TFrmTrade.Excluirativo1Click(Sender: TObject);
begin
  TradeSheet.DelLine(TradeSheet.SelectedQuote);
  Save;
end;

procedure TFrmTrade.Load;
var SymbolList:TStringList;
  I: Integer;
begin
  if FileExists(ExtractFilePath(ParamStr(0))+'symbols.txt') then
  begin
    FrmTrade.TradeSheet.ClearLines;
    SymbolList:=TStringList.Create;
    SymbolList.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'symbols.txt');
    for I := 0 to SymbolList.Count - 1 do
    begin
     if( not FrmCentral.CentralSheet.FindQuote(SymbolList.Strings[I])) then
     FrmCentral.AddSymbol(SymbolList.Strings[I])
     else
     begin
      SignalThread.WriteLn('sqt ' + SymbolList.Strings[I]);
     end;

     TradeSheet.NewLine(SymbolList.Strings[I]);


    end;
  end;
end;

procedure TFrmTrade.Moverparabaixo1Click(Sender: TObject);
begin
  TradeSheet.MoveDownLine;
  Save;
end;

procedure TFrmTrade.MoverparCima1Click(Sender: TObject);
begin
  TradeSheet.MoveUpLine;
  Save;
end;

procedure TFrmTrade.Resumodoativo1Click(Sender: TObject);
begin
 FrmAbstractSymbol:=TFrmAbstractSymbol.Create(Application);
 FrmAbstractSymbol.Edit1.Text:=TradeSheet.SelectedQuote;
 FrmAbstractSymbol.Button1Click(Self);
 FrmAbstractSymbol.Show;
end;

procedure TFrmTrade.Save;
var SymbolList : TStringList;
  L: Integer;
begin
 try
 SymbolList:= TStringList.Create;

 for L := 1 to TradeSheet.RowCount do
 begin
   if(TradeSheet.Cells[0,L] <> '') then
   begin
     SymbolList.Add(TradeSheet.Cells[0,L]);
   end;
 end;

 SymbolList.SaveToFile(ExtractFilePath(ParamStr(0)) + 'symbols.txt');
 except
   on E:Exception do
   FrmMainTreeView.Memo1.Lines.Add(E.Message);
 end;

end;

procedure TFrmTrade.SpeedButton1Click(Sender: TObject);
begin
  Excluirativo1Click(Self);
end;

procedure TFrmTrade.SpeedButton2Click(Sender: TObject);
begin
 if MessageDlg('Deseja realmente limpar esta planilha?',mtConfirmation,[mbYes,mbNo],0) = mrYEs then
 begin
   TradeSheet.ClearLines;
   Save;
 end;
end;

procedure TFrmTrade.Timer1Timer(Sender: TObject);
begin
 TradeSheet.Repaint;
end;

procedure TFrmTrade.TradeSheetDblClick(Sender: TObject);
begin
 if TradeSheet.Col = 3 then
 begin
   if(FrmMainTreeView.Broker.Connected) then
   begin
   FrmBrokerSell.LabeledEdit1.Text:=TradeSheet.SelectedQuote;

     FrmBrokerSell.LabeledEdit3.Text:=FrmBrokerBuy.ChangeDecimalSeparator(FrmCentral.CentralSheet.GetValue(clLast,FrmBrokerBuy.LabeledEdit1.Text),'.',',');

     if Copy(TradeSheet.SelectedQuote,Length(TradeSheet.SelectedQuote),1) = 'F' then
     FrmBrokerSell.LabeledEdit2.Text:='1'
     else
     FrmBrokerSell.LabeledEdit2.Text:='100';

     FrmBrokerSell.LabeledEdit3.Text:='';

     FrmBrokerSell.LabeledEdit3.Text:=FrmBrokerBuy.ChangeDecimalSeparator(FrmCentral.CentralSheet.GetValue(clLast,TradeSheet.SelectedQuote),'.',',');

     FrmBrokerSell.CalcTotal;

     FrmBrokerSell.Label23.Caption:='';
     FrmBrokerSell.Label22.Visible:=False;
     FrmBrokerSell.Label23.Visible:=False;
     FrmBrokerSell.LabeledEdit4.Visible:=False;

     FrmBrokerSell.Show;
   end;
 end else if TradeSheet.Col = 4 then
          begin
          if(FrmMainTreeView.Broker.Connected) then
   begin
            FrmBrokerBuy.LabeledEdit1.Text:=TradeSheet.SelectedQuote;

           FrmBrokerBuy.LabeledEdit3.Text:=FrmBrokerBuy.ChangeDecimalSeparator(FrmCentral.CentralSheet.GetValue(clLast,FrmBrokerBuy.LabeledEdit1.Text),'.',',');

           if Copy(TradeSheet.SelectedQuote,Length(TradeSheet.SelectedQuote),1) = 'F' then
           FrmBrokerBuy.LabeledEdit2.Text:='1'
           else
           FrmBrokerBuy.LabeledEdit2.Text:='100';

           FrmBrokerBuy.LabeledEdit3.Text:='';

           FrmBrokerBuy.LabeledEdit3.Text:=FrmBrokerBuy.ChangeDecimalSeparator(FrmCentral.CentralSheet.GetValue(clLast,TradeSheet.SelectedQuote),'.',',');

           FrmBrokerBuy.CalcTotal;

           FrmBrokerBuy.Label23.Caption:='';
           FrmBrokerBuy.Label22.Visible:=False;
           FrmBrokerBuy.Label23.Visible:=False;
           FrmBrokerBuy.LabeledEdit4.Visible:=False;

           FrmBrokerBuy.Show;
          end;
          end;

end;

procedure TFrmTrade.TradeSheetDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var X:Integer;
begin

 if ARow>=1 then
 begin

  {ZebraColor}
  with TradeSheet.Canvas do
  begin
    if Odd(ARow) then
    Brush.Color:=TradeSheet.OddColorLine
    else
    Brush.Color:=TradeSheet.EvenColorLine;
    FillRect(Rect);
    Font:=TradeSheet.Font;
    Font.Color:=TradeSheet.FontColorPaint;
    Font.Style:=Font.Style + [fsBold];
    X:= Rect.Left + ( ( Rect.Right - Rect.Left) - TextWidth(TradeSheet.Cells[ACol,ARow]) - 3);
    TextRect(Rect,X ,Rect.Top + 3,TradeSheet.Cells[ACol,ARow]);
  end; {ZebraColor}

  case ACol of
    2:
    begin
      with TradeSheet.Canvas do
      begin
        if(Copy(TradeSheet.Cells[ACol,ARow],1,1) = '-') then
        Brush.Color:=clRed
        else
        Brush.Color:=clLime;
        FillRect(Rect);
        Font:=TradeSheet.Font;
        Font.Color:=clBlack;
        Font.Style:=Font.Style + [fsBold];
        X:= Rect.Left + ( ( Rect.Right - Rect.Left) - TextWidth(TradeSheet.Cells[ACol,ARow]) - 3);
        TextRect(Rect,X ,Rect.Top + 3,TradeSheet.Cells[ACol,ARow]);
      end;
    end;
  end;

 end; {ARow >= 1}

end;

procedure TFrmTrade.TradeSheetKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

 case Key of
   33: MoverparCima1Click(Self);
   34: Moverparabaixo1Click(Self);
   116:
   begin
     FrmBrokerBuy.LabeledEdit1.Text:=TradeSheet.SelectedQuote;

     FrmBrokerBuy.LabeledEdit3.Text:=FrmBrokerBuy.ChangeDecimalSeparator(FrmCentral.CentralSheet.GetValue(clLast,FrmBrokerBuy.LabeledEdit1.Text),'.',',');

     if (Copy(TradeSheet.SelectedQuote,1,3) = 'WIN') OR (Copy(TradeSheet.SelectedQuote,Length(TradeSheet.SelectedQuote),1) = 'F') then
     FrmBrokerBuy.LabeledEdit2.Text:='1'
     else
     FrmBrokerBuy.LabeledEdit2.Text:='100';

     FrmBrokerBuy.LabeledEdit3.Text:='';

     FrmBrokerBuy.LabeledEdit3.Text:=FrmBrokerBuy.ChangeDecimalSeparator(FrmCentral.CentralSheet.GetValue(clLast,TradeSheet.SelectedQuote),'.',',');

     FrmBrokerBuy.CalcTotal;

     FrmBrokerBuy.Label23.Caption:='';
     FrmBrokerBuy.Label22.Visible:=False;
     FrmBrokerBuy.Label23.Visible:=False;
     if(FrmMainTreeView.Broker.Connected)then
     FrmBrokerBuy.Show;
   end;
   120:
   begin
     FrmBrokerSell.LabeledEdit1.Text:=TradeSheet.SelectedQuote;

     FrmBrokerSell.LabeledEdit3.Text:=FrmBrokerBuy.ChangeDecimalSeparator(FrmCentral.CentralSheet.GetValue(clLast,FrmBrokerBuy.LabeledEdit1.Text),'.',',');

     if (Copy(TradeSheet.SelectedQuote,1,3) = 'WIN') OR (Copy(TradeSheet.SelectedQuote,Length(TradeSheet.SelectedQuote),1) = 'F') then
     FrmBrokerSell.LabeledEdit2.Text:='1'
     else
     FrmBrokerSell.LabeledEdit2.Text:='100';

     FrmBrokerSell.LabeledEdit3.Text:='';

     FrmBrokerSell.LabeledEdit3.Text:=FrmBrokerBuy.ChangeDecimalSeparator(FrmCentral.CentralSheet.GetValue(clLast,TradeSheet.SelectedQuote),'.',',');

     FrmBrokerSell.CalcTotal;

     FrmBrokerSell.Label23.Caption:='';
     FrmBrokerSell.Label22.Visible:=False;
     FrmBrokerSell.Label23.Visible:=False;
     if(FrmMainTreeView.Broker.Connected)then
     FrmBrokerSell.Show;
   end;
 end;

end;

procedure TFrmTrade.TradeSheetKeyPress(Sender: TObject; var Key: Char);
begin
  Edit1.Text:=Key;
  Edit1.SetFocus;
  Edit1.SelStart:=Length(Edit1.Text);
end;

procedure TFrmTrade.UpColor(ACol, ARow: Integer);
begin

end;

procedure TFrmTrade.Venda1Click(Sender: TObject);
var Key:Word;
    Shift : TShiftState;
begin
  Key:=120;
  TradeSheetKeyDown(Self,Key,Shift);
end;

end.
