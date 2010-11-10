unit UFrmHistoryOrders;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, Sheet, Menus, ExtCtrls, StdCtrls, Tabs, ComCtrls;

type
  TFrmHistoryOrders = class(TForm)
    PopupMenu1: TPopupMenu;
    Cancelar1: TMenuItem;
    Timer1: TTimer;
    Editar1: TMenuItem;
    Panel1: TPanel;
    Shape1: TShape;
    Shape2: TShape;
    Label1: TLabel;
    Label2: TLabel;
    Shape3: TShape;
    Label3: TLabel;
    Shape4: TShape;
    Label4: TLabel;
    Label5: TLabel;
    Shape5: TShape;
    Label6: TLabel;
    CheckBox1: TCheckBox;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    HistorySheet: TSheet;
    StartStopSheet: TSheet;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure HistorySheetDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure Cancelar1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Editar1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TabSet1Change(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure HistorySheetMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
    OrderMassRequest: Boolean;

  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    procedure FilterLines( Market : String);
  end;

var
  FrmHistoryOrders: TFrmHistoryOrders;

implementation

uses UFrmMainTreeView, UFrmBrokerBuy, UFrmBrokerSell;

{$R *.dfm}

procedure TFrmHistoryOrders.Cancelar1Click(Sender: TObject);
var MsgSend : String;
    BMsg:TBytes;
    Unique:Integer;
begin
 if MessageDlg('Deseja realmente cancelar a ordem Nº ' + HistorySheet.SelectedQuote,mtConfirmation,[mbYEs,mbNo],0) = mrYes then
 begin
//   if ( Copy(HistorySheet.Cells[4,HistorySheet.Row],1,3) <> 'DOL' ) And ( Copy(HistorySheet.Cells[4,HistorySheet.Row],1,3) <> 'WIN' ) And
//   ( Copy(HistorySheet.Cells[4,HistorySheet.Row],1,3) <> 'IND' ) then
//   begin

     MsgSend:='35=OC' + #1 +
            '5017=0' + #1 +
            '37='+HistorySheet.SelectedQuote + #1 +
            '5162=' + FrmMainTreeView.ShadownCode + #1 + #3;

     BMsg:=FrmMainTreeView.StrToBytes(MsgSend);
     FrmMainTreeView.Broker.IOHandler.WriteDirect(BMsg);


//   end
//   else
//   begin
//
//   Randomize;
//
//   Unique:= Random(9000);
//
//     MsgSend:='35=F' + #01 +
//         '49=' + FrmMainTreeView.RouterLibrary1.FixSession.Username + #01 +
//         '56=' + FrmMainTreeView.RouterLibrary1.FixSession.TargetCompId+ #01 +
//         '34=' + FrmMainTreeView.RouterLibrary1.FixSession.IncrementOutMsgSeq + #01 +
//         '52=' + FormatDateTime('yyyymmdd-hh:nn:ss',Now) + #01 +
//         '11=' + IntToStr(Unique) + #01 +
//         '37='  + HistorySheet.SelectedQuote + #01 +
//         '55=' + HistorySheet.Cells[4,HistorySheet.Row] + #01 +
//         '48=' + HistorySheet.Cells[4,HistorySheet.Row] + #01 +
//         '22=8' + #01 +
//         '207=XBMF' + #01;
//
//         if HistorySheet.Cells[3,HistorySheet.Row] = 'Compra' then
//         MsgSend:=MsgSend +  '54=1' + #01
//         else
//         MsgSend:=MsgSend +  '54=2' + #01;
//
//
//         MsgSend:=MsgSend+ '38=' + HistorySheet.Cells[6,HistorySheet.Row] + #01 +
//         '453=1' + #01 +
//         '448=' + FrmMainTreeView.RouterLibrary1.FixSession.Username + #01 +
//         '452=36' + #01 +
//         '447=D' + #01 +
//         '60=' +FormatDateTime('yyyymmdd-hh:nn:ss',Now) + #01 +
//         '41=' + FrmMainTreeView.RouterLibrary1.FixSession.Username + #01;
//
//
//         MsgSend:= '8=FIX.4.4' + #01 +
//               '9=' + IntToStr(Length(MsgSend)) + #01 + MsgSend;
//
//          MsgSend:=MsgSend + FrmMainTreeView.RouterLibrary1.GenerateCheckSum(MsgSend);
//
//          FrmMainTreeView.Memo1.Lines.Add(MsgSend);
//
//         FrmMainTreeView.Fix.IOHandler.WriteLn(MsgSend);
//
//   end;


end;
end;

procedure TFrmHistoryOrders.CheckBox1Click(Sender: TObject);
begin
 if CheckBox1.Checked then
 Self.FormStyle:=fsStayOnTop
 else
 Self.FormStyle:=fsNormal;

end;

procedure TFrmHistoryOrders.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle:= Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent:= GetDesktopWindow;
end;

procedure TFrmHistoryOrders.Editar1Click(Sender: TObject);
begin
  if HistorySheet.GetValue(clVar,HistorySheet.SelectedQuote) = 'Compra' then
  begin
    FrmBrokerBuy.LabeledEdit1.Text:= HistorySheet.GetValue(clBuy,HistorySheet.SelectedQuote);
    FrmBrokerBuy.LabeledEdit2.Text:= HistorySheet.GetValue(clStatus,HistorySheet.SelectedQuote);
    FrmBrokerBuy.LabeledEdit3.Text:= FrmBrokerBuy.ChangeDecimalSeparator( HistorySheet.GetValue(clSell,HistorySheet.SelectedQuote),'.',',');
    FrmBrokerBuy.Label23.Caption:=HistorySheet.SelectedQuote;
    FrmBrokerBuy.Label22.Visible:=True;
    FrmBrokerBuy.Label23.Visible:=True;
    FrmBrokerBuy.Edit:=True;
    FrmBrokerBuy.Show;
    FrmBrokerBuy.LabeledEdit1.SetFocus;
  end
  else
  begin
    FrmBrokerSell.LabeledEdit1.Text:= HistorySheet.GetValue(clBuy,HistorySheet.SelectedQuote);
    FrmBrokerSell.LabeledEdit2.Text:= HistorySheet.GetValue(clStatus,HistorySheet.SelectedQuote);
    FrmBrokerSell.LabeledEdit3.Text:= FrmBrokerBuy.ChangeDecimalSeparator( HistorySheet.GetValue(clSell,HistorySheet.SelectedQuote),'.',',');
    FrmBrokerSell.Label23.Caption:=HistorySheet.SelectedQuote;
    FrmBrokerSell.Label22.Visible:=True;
    FrmBrokerSell.Label23.Visible:=True;
    FrmBrokerSell.Edit:=True;
    FrmBrokerSell.Show;
    FrmBrokerSell.LabeledEdit1.SetFocus;
  end;


end;

procedure TFrmHistoryOrders.FilterLines(Market: String);
var
  I: Integer;
  Msg:String;
  MsgSend:String;
  BMsgSend:TBytes;
begin
 if Market = 'Bovespa' then
 begin
//    //Vamos solicitar aqui o FOV - Lista de Ordens
//    MsgSend:= '35=FOV' + #1 + '5017=5' + #1 + '5013=T' + #1 + '5487=0' +#1 +
//                 '9999=0' + #1 + '5262=1' + #1 + '5209=1' + #1 + '5019='+ FrmMainTreeView.MarketID + #1 + '5463=0' + #1 +#3;
//    BMsgSend:=FrmMainTreeView.StrToBytes(MsgSend);
//    FrmMainTreeView.Broker.IOHandler.WriteDirect(BMsgSend);
//    FrmMainTreeView.Broker.IOHandler.WriteBufferFlush;
   for I := 1 to HistorySheet.RowCount - 1 do
   begin
     if ( Copy(HistorySheet.Cells[4,I],1,3) <> 'DOL' ) And ( Copy(HistorySheet.Cells[4,I],1,3) <> 'WIN' ) And
     ( Copy(HistorySheet.Cells[4,I],1,3) <> 'IND' )  then
     begin
       HistorySheet.RowHeights[I] := HistorySheet.DefaultRowHeight;
     end
     else
     begin
       HistorySheet.RowHeights[I] := -1;
     end;
   end;
 end
 else if Market = 'BMF' then
 begin
//   //Solicita historico de mensagens
//   Msg:= '35=AF' + #01 +
//   '49=' + FrmMainTreeView.RouterLibrary1.FixSession.Username + #01 +
//         '56=' + FrmMainTreeView.RouterLibrary1.FixSession.TargetCompId+ #01 +
//         '34=' + FrmMainTreeView.RouterLibrary1.FixSession.IncrementOutMsgSeq + #01 +
//         '52=' + FormatDateTime('yyyymmdd-hh:nn:ss',Now) + #01 +
//   '584=' + IntToStr(Random(9000))+ #01 +
//   '585=8' +  #01 +
//   '10034=2' + #01 +
//   '78=1' + #01 +
//   '79=3810' + #01 +
//   '5487=4' + #01 +
//   '39=0' + #01 +
//   '39=2' + #01 +
//   '39=4' + #01 +
//   '39=8' + #01;
//
//   Msg:= '8=FIX.4.4' + #01 +
//               '9=' + IntToStr(Length(Msg)) + #01 + Msg;
//
//  Msg:=Msg + FrmMainTreeView.RouterLibrary1.GenerateCheckSum(Msg);
//
//  FrmMainTreeView.Memo1.Lines.Add(Msg);
//
//  FrmMainTreeView.Fix.IOHandler.WriteLn(Msg);
   for I := 1 to HistorySheet.RowCount - 1 do
   begin
   if ( Copy(HistorySheet.Cells[4,I],1,3) = 'DOL' ) Or ( Copy(HistorySheet.Cells[4,I],1,3) = 'WIN' ) Or
     ( Copy(HistorySheet.Cells[4,I],1,3) = 'IND' )  then
     begin
       HistorySheet.RowHeights[I] := HistorySheet.DefaultRowHeight;
     end
     else
     begin
       HistorySheet.RowHeights[I] := -1;
     end;
   end;
 end
 else
 begin
   for I := 1 to HistorySheet.RowCount - 1 do
   begin
     HistorySheet.RowHeights[I] := HistorySheet.DefaultRowHeight;
   end;
 end;
end;

procedure TFrmHistoryOrders.FormCreate(Sender: TObject);
begin
 OrderMassRequest:=False;
end;

procedure TFrmHistoryOrders.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  FrmMainTreeView.FormKeyDown(Sender,Key,Shift);
end;

procedure TFrmHistoryOrders.FormShow(Sender: TObject);
var Msg:String;
begin
 CheckBox1Click(Self);

 Randomize;

 if not OrderMassRequest and FrmMainTreeView.Fix.Connected then
 begin
   //Solicita historico de mensagens
   Msg:= '35=AF' + #01 +
   '49=' + FrmMainTreeView.RouterLibrary1.FixSession.Username + #01 +
         '56=' + FrmMainTreeView.RouterLibrary1.FixSession.TargetCompId+ #01 +
         '34=' + FrmMainTreeView.RouterLibrary1.FixSession.IncrementOutMsgSeq + #01 +
         '52=' + FormatDateTime('yyyymmdd-hh:nn:ss',Now) + #01 +
   '584=' + IntToStr(Random(9000))+ #01 +
   '585=8' +  #01 +
   '10034=1' + #01 +
   '78=1' + #01 +
   '79=' + FrmMainTreeView.RouterLibrary1.FixSession.Username + #01;

   Msg:= '8=FIX.4.4' + #01 +
               '9=' + IntToStr(Length(Msg)) + #01 + Msg;

  Msg:=Msg + FrmMainTreeView.RouterLibrary1.GenerateCheckSum(Msg);

  FrmMainTreeView.Memo1.Lines.Add(Msg);

  FrmMainTreeView.Fix.IOHandler.WriteLn(Msg);

  OrderMassRequest:=True;
 end;
end;

procedure TFrmHistoryOrders.HistorySheetDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if HistorySheet.Cells[11,ARow] = 'Executada' then
  begin
    with HistorySheet.Canvas do
    begin
      Brush.Color:=clLime;
      FillRect(Rect);
      TextRect(Rect,Rect.Left + 3,Rect.Top + 3,HistorySheet.Cells[ACol,ARow]);
    end;
  end;
  if HistorySheet.Cells[11,ARow] = 'Rejeitada' then
  begin
    with HistorySheet.Canvas do
    begin
      Brush.Color:=clRed;
      FillRect(Rect);
      TextRect(Rect,Rect.Left + 3,Rect.Top + 3,HistorySheet.Cells[ACol,ARow]);
    end;
  end;
  if HistorySheet.Cells[11,ARow] = 'Recebida' then
  begin
    with HistorySheet.Canvas do
    begin
      Brush.Color:=clYellow;
      FillRect(Rect);
      TextRect(Rect,Rect.Left + 3,Rect.Top + 3,HistorySheet.Cells[ACol,ARow]);
    end;
  end;
  if HistorySheet.Cells[11,ARow] = 'Cancelada' then
  begin
    with HistorySheet.Canvas do
    begin
      Brush.Color:=RGB(0,128,255);
      FillRect(Rect);
      TextRect(Rect,Rect.Left + 3,Rect.Top + 3,HistorySheet.Cells[ACol,ARow]);
    end;
  end;
end;

procedure TFrmHistoryOrders.HistorySheetMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Col, Row: Integer;
begin
  if Button = mbRight then
  begin
	HistorySheet.MouseToCell(X, Y, Col, Row);
	HistorySheet.Col := Col;
	HistorySheet.Row := Row;
  HistorySheet.SetQuoteByCell;
  end;
end;

procedure TFrmHistoryOrders.TabSet1Change(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
 case NewTab of
   0: FilterLines('Todos');
   1: FilterLines('Bovespa');
   2: FilterLines('BMF');
 end;
end;

procedure TFrmHistoryOrders.Timer1Timer(Sender: TObject);
begin
  HistorySheet.Repaint;
end;

end.
