unit UFrmStartStop;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Buttons,DateUtils,IdException,IdExceptionCore,
  Grids, Sheet, Menus;

type
  TFrmStartStop = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    DateTimePicker1: TDateTimePicker;
    LabeledEdit4: TLabeledEdit;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Stop: TTabSheet;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Shape1: TShape;
    LabeledEdit5: TLabeledEdit;
    LabeledEdit6: TLabeledEdit;
    DateTimePicker2: TDateTimePicker;
    Label2: TLabel;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    GroupBox2: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Shape2: TShape;
    GroupBox3: TGroupBox;
    LabeledEdit7: TLabeledEdit;
    LabeledEdit9: TLabeledEdit;
    GroupBox4: TGroupBox;
    LabeledEdit8: TLabeledEdit;
    LabeledEdit10: TLabeledEdit;
    PopupMenu1: TPopupMenu;
    Cancelar1: TMenuItem;
    procedure LabeledEdit2Change(Sender: TObject);
    procedure LabeledEdit3Change(Sender: TObject);
    procedure LabeledEdit4Change(Sender: TObject);
    procedure LabeledEdit3KeyPress(Sender: TObject; var Key: Char);
    procedure LabeledEdit4KeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
    procedure LabeledEdit5Change(Sender: TObject);
    procedure LabeledEdit6Change(Sender: TObject);
    procedure LabeledEdit7Change(Sender: TObject);
    procedure LabeledEdit9Change(Sender: TObject);
    procedure LabeledEdit8Change(Sender: TObject);
    procedure LabeledEdit10Change(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure LabeledEdit7KeyPress(Sender: TObject; var Key: Char);
    procedure LabeledEdit9KeyPress(Sender: TObject; var Key: Char);
    procedure LabeledEdit8KeyPress(Sender: TObject; var Key: Char);
    procedure LabeledEdit10KeyPress(Sender: TObject; var Key: Char);
    procedure PageControl1Change(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure StartStopSheetMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Cancelar1Click(Sender: TObject);
  private
    { Private declarations }
  protected
   procedure CreateParams(var Params:TCreateParams); override;
  public
    { Public declarations }
    procedure Calc;
    procedure Calc2;
  end;

var
  FrmStartStop: TFrmStartStop;

implementation

uses UFrmMainTreeView;

{$R *.dfm}

{ TFrmStartStop }

procedure TFrmStartStop.BitBtn1Click(Sender: TObject);
var MsgStart : String;
    BMsgStart : TBytes;
begin

//Monta a Msg para o broker
  MsgStart:= '35=OSB' + #1 +
             '5017=0' + #1 +  '117=' + LabeledEdit1.Text + #1 +
             '53=' + LabeledEdit2.Text + #1 +
             '5022=' + FrmMainTreeView.ChangeDecimalSeparator(LabeledEdit3.Text,',','.') + #1 +
             '44=' + FrmMainTreeView.ChangeDecimalSeparator(LabeledEdit4.Text,',','.') + #1 +
             '5018=2' + #1 +
             '5019=' + FrmMainTreeView.MarketID + #1 +
             '5013=C' + #1 +
             '432=' + FormatDateTime('YYYYMMDD',DateTimePicker1.Date) + #1;

             MsgStart:=MsgStart + '5020=0' + #1 + #3;

             FrmMainTreeView.Memo1.Lines.Add(MsgStart);

  BMsgStart:=FrmMainTreeView.StrToBytes(MsgStart);

  FrmMainTreeView.LabelReturn:=Label3;

  FrmMainTreeView.Broker.IOHandler.WriteDirect(BMsgStart);

  FrmMainTreeView.Broker.IOHandler.WriteBufferFlush;

end;

procedure TFrmStartStop.BitBtn2Click(Sender: TObject);
begin
  Self.Close;
end;

procedure TFrmStartStop.BitBtn3Click(Sender: TObject);
var MsgStop : String;
    BMsgStop : TBytes;
begin
  //Monta a Msg
  MsgStop := '35=OSS' + #1 +
             '5017=0' + #1 +
             '117='  + LabeledEdit5.Text + #1 +
             '53=' + LabeledEdit6.Text + #1 +
             '5031=' + FrmMainTreeView.ChangeDecimalSeparator(LabeledEdit7.Text,',','.') + #1 +
             '5032=' + FrmMainTreeView.ChangeDecimalSeparator(LabeledEdit9.Text,',','.') + #1 +
             '5033=' + FrmMainTreeView.ChangeDecimalSeparator(LabeledEdit8.Text,',','.') + #1 +
             '5034=' + FrmMainTreeView.ChangeDecimalSeparator(LabeledEdit10.Text,',','.')+ #1 +
             '5018=2' + #1 + '5013=C' + #1 +
             '432=' + FormatDateTime('YYYYMMDD',DateTimePicker2.Date) + #1 +
             '5019=' + FrmMainTreeView.MarketID + #1 + '5020=0' + #1 + #3;

   BMsgStop:=FrmMainTreeView.StrToBytes(MsgStop);

   FrmMainTreeView.LabelReturn:=Label6;

   try
     FrmMainTreeView.Broker.IOHandler.WriteDirect(BMsgStop);
     FrmMainTreeView.Broker.IOHandler.WriteBufferFlush;
   except
     on E: EIdConnClosedGracefully do
    begin
       FrmMainTreeView.MsgErr:='Você não está conectado ao servidor.';
       FrmMainTreeView.ShowMsgErr;
    end;

    on E: Exception do
     begin
       FrmMainTreeView.MsgErr:='Não foi possível enviar sua ordem.';
       FrmMainTreeView.ShowMsgErr;
     end;
   end;
end;

procedure TFrmStartStop.BitBtn4Click(Sender: TObject);
begin
  Self.Close;
end;

procedure TFrmStartStop.Calc;
var qtde : Integer;
    price : Double;
    r : Double;
begin
 Label3.Font.Color:=$000000C4;

 if ( LabeledEdit2.Text = '' ) or ( LabeledEdit3.Text = '' ) or ( LabeledEdit4.Text = '' ) then
 begin
   Label3.Caption:='Preencha todos os campos corretamente.';
 end
 else
 begin
   try
     qtde:= StrToInt(LabeledEdit2.Text);
     price:=StrToFloat(LabeledEdit4.Text);
     r:= price * qtde;
     //Label8.Caption:=FormatFloat('0.00',r);

     //Recomendações -- Lote padrão, e qtde fracionaria
     if Copy(LabeledEdit1.Text,Length(LabeledEdit1.Text),1) <> 'F' then
     begin
       if qtde mod 100 <> 0 then
       Label3.Caption:='O ativo escolhido é um lote padrão e a quantidade é fracionária.'
       else
       Label3.Caption:='';
     end
     else
     begin
       // Lote Fracionario e qtde padrao
       if qtde div 100 >= 1 then
       Label3.Caption:='O ativo possui uma quantidade padrão.'
       else
       Label3.Caption:='';
     end;

     if price = 0 then
     Label3.Caption:='O preço está nulo.';

   except
    on E: Exception do
    begin
     //Label8.Caption:='0.00';
    end;

   end;

 end;

end;

procedure TFrmStartStop.Calc2;
var qtde : Integer;
begin
 Label6.Font.Color:=$000000C4;

   try
     qtde:= StrToInt(LabeledEdit6.Text);
     //Recomendações -- Lote padrão, e qtde fracionaria
     if Copy(LabeledEdit5.Text,Length(LabeledEdit5.Text),1) <> 'F' then
     begin
       if qtde mod 100 <> 0 then
       Label6.Caption:='O ativo escolhido é um lote padrão e a quantidade é fracionária.'
       else
       Label6.Caption:='';
     end
     else
     begin
       // Lote Fracionario e qtde padrao
       if qtde div 100 >= 1 then
       Label6.Caption:='O ativo possui uma quantidade padrão.'
       else
       Label6.Caption:='';
     end;

   except

    on E: Exception do
    begin
     //Label8.Caption:='0.00';
    end;

   end;

end;

procedure TFrmStartStop.Cancelar1Click(Sender: TObject);
var MsgStartStopCancel : String;
    BMsgStartStopCancel:TBytes;
begin
//  MsgStartStopCancel:='35=OCSS' + #1 +
//                      '5017=0' + #1 +
//                      '37=' + StartStopSheet.Cells[0,StartStopSheet.Row] + #1;
//
//                      if StartStopSheet.GetValue(clPicture,StartStopSheet.SelectedQuote) = 'Start' then
//                      MsgStartStopCancel:=MsgStartStopCancel+'5035=0' + #1
//                      else
//                      MsgStartStopCancel:=MsgStartStopCancel + '5035=1' + #1;
//
//                      MsgStartStopCancel:=MsgStartStopCancel + '117=' + StartStopSheet.GetValue(clLast,StartStopSheet.SelectedQuote) + #1 +
//                      '5162=' + FrmMainTreeView.ShadownCode +#1 + #3;
//
//  BMsgStartStopCancel:= FrmMainTreeView.StrToBytes(MsgStartStopCancel);
//
//  if MessageDlg('Deseja realmente cancelar a ordem ' + StartStopSheet.Cells[0,StartStopSheet.Row] + '?',mtConfirmation,[mbYEs,MbNo],0) = mrYes then
//  begin
//    FrmMainTreeView.AddLogMsg(MsgStartStopCancel);
//    FrmMainTreeView.Broker.IOHandler.WriteDirect(BMsgStartStopCancel);
//    FrmMainTreeView.Broker.IOHandler.WriteBufferFlush;
//  end;

end;

procedure TFrmStartStop.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle:= Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent:= GetDesktopWindow;
end;

procedure TFrmStartStop.FormShow(Sender: TObject);
begin
  Label5.Caption:=FrmMainTreeView.ClientName;
  Label8.Caption:=FrmMainTreeView.ClientName;
  DateTimePicker1.Date:=Today;
  DateTimePicker2.Date:=Today;
  PageControl1.ActivePageIndex:=0;

  PageControl1Change(Self);
end;

procedure TFrmStartStop.LabeledEdit10Change(Sender: TObject);
begin
  Calc2;
end;

procedure TFrmStartStop.LabeledEdit10KeyPress(Sender: TObject; var Key: Char);
begin
if not ( Key in ['0'..'9',Char(8),DecimalSeparator] )  then
 Key:=#0;
end;

procedure TFrmStartStop.LabeledEdit1Change(Sender: TObject);
begin
  Calc;
end;

procedure TFrmStartStop.LabeledEdit2Change(Sender: TObject);
begin
  Calc;
end;

procedure TFrmStartStop.LabeledEdit3Change(Sender: TObject);
begin
  Calc;
end;

procedure TFrmStartStop.LabeledEdit3KeyPress(Sender: TObject; var Key: Char);
begin
if not ( Key in ['0'..'9',Char(8),DecimalSeparator] )  then
 Key:=#0;
end;

procedure TFrmStartStop.LabeledEdit4Change(Sender: TObject);
begin
  Calc;
end;

procedure TFrmStartStop.LabeledEdit4KeyPress(Sender: TObject; var Key: Char);
begin
if not ( Key in ['0'..'9',Char(8),DecimalSeparator] )  then
 Key:=#0;
end;

procedure TFrmStartStop.LabeledEdit5Change(Sender: TObject);
begin
  Calc2;
end;

procedure TFrmStartStop.LabeledEdit6Change(Sender: TObject);
begin
  Calc2;
end;

procedure TFrmStartStop.LabeledEdit7Change(Sender: TObject);
begin
  Calc2;
end;

procedure TFrmStartStop.LabeledEdit7KeyPress(Sender: TObject; var Key: Char);
begin
if not ( Key in ['0'..'9',Char(8),DecimalSeparator] )  then
 Key:=#0;
end;

procedure TFrmStartStop.LabeledEdit8Change(Sender: TObject);
begin
  Calc2;
end;

procedure TFrmStartStop.LabeledEdit8KeyPress(Sender: TObject; var Key: Char);
begin
if not ( Key in ['0'..'9',Char(8),DecimalSeparator] )  then
 Key:=#0;
end;

procedure TFrmStartStop.LabeledEdit9Change(Sender: TObject);
begin
  Calc2;
end;

procedure TFrmStartStop.LabeledEdit9KeyPress(Sender: TObject; var Key: Char);
begin
if not ( Key in ['0'..'9',Char(8),DecimalSeparator] )  then
 Key:=#0;
end;

procedure TFrmStartStop.PageControl1Change(Sender: TObject);
var MsgSend : String;
    BMsgSend : TBytes;
begin
  try
  //Vamos solicitar aqui o FOSB - Lista de ordens de start
    MsgSend:= '35=FOSB' + #1 + '5017=5' + #1 + '5013=T' + #1 +
                 '5262=1' + #1 + '5209=1' + #1 + '5019='+ FrmMainTreeView.MarketID + #1 + #3;
    BMsgSend:=FrmMainTreeView.StrToBytes(MsgSend);
    FrmMainTreeView.Broker.IOHandler.WriteDirect(BMsgSend);
    FrmMainTreeView.Broker.IOHandler.WriteBufferFlush;

     //Vamos solicitar aqui o FOSS - Lista de ordens de stop
    MsgSend:= '35=FOSS' + #1 + '5017=5' + #1 + '5013=T' + #1 +
                 '5262=1' + #1 + '5209=1' + #1 + '5019='+ FrmMainTreeView.MarketID + #1 + #3;
    BMsgSend:=FrmMainTreeView.StrToBytes(MsgSend);
    FrmMainTreeView.Broker.IOHandler.WriteDirect(BMsgSend);
    FrmMainTreeView.Broker.IOHandler.WriteBufferFlush;
  except
    on E:EIdConnClosedGracefully do
    begin
      FrmMainTreeView.MsgErr:='Não foi possível abrir a lista de ordens.';
      FrmMainTreeView.ShowMsgErr;
    end;
    on E:EAccessViolation do
    begin
      FrmMainTreeView.MsgErr:='Você não está conectado ao broker.';
      FrmMainTreeView.ShowMsgErr;
    end;
  end;
end;

procedure TFrmStartStop.StartStopSheetMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Col, Row: Integer;
begin
//  if Button = mbRight then
//  begin
//	StartStopSheet.MouseToCell(X, Y, Col, Row);
//	StartStopSheet.Col := Col;
//	StartStopSheet.Row := Row;
//  StartStopSheet.SetQuoteByCell;
//  end;
end;

end.
