unit UFrmBrokerBuy;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls,Sheet,DateUtils,
  IdException,IdExceptionCore;

type
  TFrmBrokerBuy = class(TForm)
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    ComboBox1: TComboBox;
    Label1: TLabel;
    DateTimePicker1: TDateTimePicker;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Shape1: TShape;
    Label13: TLabel;
    Label14: TLabel;
    Timer1: TTimer;
    GroupBox2: TGroupBox;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    LabeledEdit4: TLabeledEdit;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    CheckBox1: TCheckBox;
    GroupBox4: TGroupBox;
    CheckBox2: TCheckBox;
    Edit1: TEdit;
    CheckBox3: TCheckBox;
    Edit2: TEdit;
    Label26: TLabel;
    Label27: TLabel;
    Label18: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label19: TLabel;
    Label28: TLabel;
    procedure LabeledEdit2Change(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure DateTimePicker1Change(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure LabeledEdit3KeyPress(Sender: TObject; var Key: Char);
    procedure Label14MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure GroupBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label14Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Label21MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure GroupBox3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label21Click(Sender: TObject);
    procedure Label19MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label19Click(Sender: TObject);
    procedure LabeledEdit1Exit(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  protected
    procedure CreateParams(var Params:TCreateParams);override;
  public
    { Public declarations }
    Edit : Boolean;
    SecurityID : String;
    procedure CalcTotal;
    function ChangeDecimalSeparator(Value : String;Decimal : String;DecimalChange : String) : String;
  end;

var
  FrmBrokerBuy: TFrmBrokerBuy;

implementation

uses UFrmTradeCentral,UFrmMainTreeView,URouterLibrary;

{$R *.dfm}

{ TFrmBrokerBuy }

procedure TFrmBrokerBuy.BitBtn1Click(Sender: TObject);
var MsgOrderBuy : String;
    MsgOrderBuyBytes : TBytes;
    TypeValidity : String;
    MsgAnswer : String;
    StringValues : TStringlist;
    WaitTime : Integer;
    MsgSend:String;
    BMsg:TBytes;
    Unique:Integer;
    Value, Price,Dif, Range1, Range2 : Double;
    MsgStart : String;
    BMsgStart : TBytes;
    MsgStop : String;
    BMsgStop : TBytes;
begin


if ( Label25.Caption = 'BOVESPA') Or ( Label25.Caption = 'BM&&F') then
begin

   try

   // Verifica se for Venda e não esta fora do padrão de 5%
   if Self.Caption = 'Venda' then
   begin
     // Valor atual da cotação
     Value:=StrToFloat(ChangeDecimalSeparator(FrmCentral.CentralSheet.GetValue(clLast,LabeledEdit1.Text),'.',','));

     // Calcula diferencia porcentagem
     Dif:= Value * 0.10;

     // Calcula os Ranges
     //Range1:= Value + Dif;
     Range2:= Value - Dif;

     // Verifica se o preco da ordem esta entre os Ranges
     Price:=StrToFloat(LabeledEdit3.Text);

     if( Price < Range2 ) then
     begin
       Label15.Caption:='Sua ordem está fora do padrão de mercado.';
       exit;
     end;

   end;

    TypeValidity:=IntToStr(ComboBox1.ItemIndex);

    MsgOrderBuy:=
         '35=OR' + // Identificacao do Comando
         #1 +
         '5017=0' + // Tipo do comando
         #1 ;

         if Self.Caption= 'Compra' then
         MsgOrderBuy:=MsgOrderBuy + '54=1' // Direcao da Ordem : 1 - Compra, 2 - Venda
         else
         MsgOrderBuy:=MsgOrderBuy + '54=2';
         MsgOrderBuy:=MsgOrderBuy +
         #1 +
         '117=' + LabeledEdit1.Text + //  Codigo do Ativo
         #1 +
         '53=' +  LabeledEdit2.Text + // Quantidade a ser comprada ou vendida
         #1 +
         '44=' + ChangeDecimalSeparator( LabeledEdit3.Text,',','.' )  +  //  Preço Limite
         #1 +
         '5018='+ TypeValidity + // Tipo Validade: 0 - Hoje, 1 - Ate Cancelar, 2 - Dta Espec., 3 - Tudo ou Nada, 4 - Executa ou Cancela
         #1 +
         '5019='+ FrmMainTreeView.MarketID + // Codigo da conta
         #1 +
         '5020=0' + // Tipo de preço: 0 - Preço Limite
         #1;

    if TypeValidity = '2' then
    MsgOrderBuy := MsgOrderBuy + '432=' +FormatDateTime('YYYYMMDD',DateTimePicker1.Date) + #1;

    MsgOrderBuy:=MsgOrderBuy + #3;

//    MessageDlg(MsgOrderBuy,mtConfirmation,[mbOk],0);

    MsgOrderBuyBytes:=FrmMainTreeView.StrToBytes(MsgOrderBuy);

    FrmMainTreeView.LabelReturn:=Label15;

    if MessageDlg('Confirma o envio desta ordem?',mtConfirmation,[mbYes,mbNo],0) = mrYes then
    begin
      if Label23.Visible then
      begin

        MsgSend:='35=OC' + #1 +
              '5017=0' + #1 +
              '37='+Label23.Caption + #1 +
              '5162=' + FrmMainTreeView.ShadownCode + #1 + #3;

        BMsg:=FrmMainTreeView.StrToBytes(MsgSend);
        FrmMainTreeView.Broker.IOHandler.WriteDirect(BMsg);

        Label23.Caption:='';
        Label22.Visible:=False;
        Label23.Visible:=False;

        Sleep(1000);
      end;

      FrmMainTreeView.Memo1.Lines.Add(MsgOrderBuy);

//      FrmMainTreeView.Broker.IOHandler.WriteBufferClear;
//      FrmMainTreeView.Broker.IOHandler.WriteDirect(MsgOrderBuyBytes);
//      FrmMainTreeView.Broker.IOHandler.WriteBufferFlush;

     // Compra
     if(Self.Caption = 'Compra') then
     begin
      // Stop Gain
      if(CheckBox2.Checked)then
      begin
        //Monta a Msg
        MsgStop := '35=OSS' + #1 +
             '5017=0' + #1 +
             '117='  + LabeledEdit1.Text + #1 +
             '53=' + LabeledEdit2.Text + #1 +
             '5031=' + FrmMainTreeView.ChangeDecimalSeparator(Edit1.Text,',','.') + #1 +  // Gain
             '5032=' + FrmMainTreeView.ChangeDecimalSeparator(Edit1.Text,',','.') + #1 +
             '5033=' + FrmMainTreeView.ChangeDecimalSeparator(Edit2.Text,',','.') + #1 +  // Loss
             '5034=' + FrmMainTreeView.ChangeDecimalSeparator(Edit2.Text,',','.')+ #1 +
             '5018=2' + #1 + '5013=C' + #1 +
             '432=' + FormatDateTime('YYYYMMDD',Today) + #1 +
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

      // Stop Loss
      if CheckBox3.Checked then
      begin

      end;
     end;


      LabeledEdit1.Clear;
      LabeledEdit2.Clear;
      LabeledEdit3.Clear;

    end;
   except
     on E:EIdConnClosedGracefully do
     begin
       FrmMainTreeView.MsgErr:='Você não está conectado ao broker.';
       FrmMainTreeView.ShowMsgErr;
     end;
     on E:EAccessViolation do begin
       FrmMainTreeView.MsgErr:='Você não está conectado ao broker.';
       FrmMainTreeView.ShowMsgErr;
     end;
   end;

end {IF BOVESPA}
else
begin
   MessageDlg('Sua boleta não está preenchida corretamente.', mtWarning, [mbOk], 0);

   exit;

   if LabeledEdit4.Text = '' then
   begin
     MessageDlg('Digite seu número de conta',mtWarning,[mbOK],0);
     LabeledEdit4.SetFocus;
     exit;
   end;

   Randomize;

   Unique:= Random(9000);

   if not Edit then
   begin

   MsgOrderBuy:='35=D' + #01 +
         '49=' + FrmMainTreeView.RouterLibrary1.FixSession.Username + #01 +
         '56=' + FrmMainTreeView.RouterLibrary1.FixSession.TargetCompId+ #01 +
         '34=' + FrmMainTreeView.RouterLibrary1.FixSession.IncrementOutMsgSeq + #01 +
         '52=' + FormatDateTime('yyyymmdd-hh:nn:ss',Now) + #01 +
         '11=' +IntToStr(Unique) + #01;

         if Self.Caption = 'Compra' then
         MsgOrderBuy:=MsgOrderBuy + '54=1' + #01
         else
         MsgOrderBuy:=MsgOrderBuy + '54=2' + #01;

         MsgOrderBuy:=MsgOrderBuy + '38=' + LabeledEdit2.Text + #01 +
         '40=2' + #01 +
         '44=' + ChangeDecimalSeparator( LabeledEdit3.Text,',','.' ) + #01;

         case ComboBox1.ItemIndex of
           0: MsgOrderBuy:=MsgOrderBuy + '59=0' + #01;
           1: MsgOrderBuy:=MsgOrderBuy + '59=3' + #01;
           2: MsgOrderBuy:=MsgOrderBuy + '59=4' + #01;
         end;


         MsgOrderBuy:=MsgOrderBuy + '78=1' + #01 +
         '79=' + LabeledEdit4.Text + #01 +
         '661=99' + #01 +
         '453=1' + #01 +
         '448=' + FrmMainTreeView.RouterLibrary1.FixSession.Username + #01 +
         '447=D' + #01 +
         '452=36' + #01 +
         '60=' + FormatDateTime('yyyymmdd-hh:nn:ss',Now) + #01 +
         '55=' + LabeledEdit1.Text + #01 +
         '48=' + SecurityID + #01 +
         '22=8' + #01 +
         '207=' + FrmMainTreeView.RouterLibrary1.FixSession.SecurityExchange + #01;

         MsgOrderBuy:= '8=FIX.4.4' + #01 +
               '9=' + IntToStr(Length(MsgOrderBuy)) + #01 + MsgOrderBuy;

   FrmMainTreeView.LabelReturn:=Label15;


   MsgOrderBuy:=MsgOrderBuy + FrmMainTreeView.RouterLibrary1.GenerateCheckSum(MsgOrderBuy);

   FrmMainTreeView.Memo1.Lines.Add(MsgOrderBuy);

   if MessageDlg('Confirma o envio desta ordem?',mtConfirmation,[mbYes,mbNo],0) = mrYes then
   begin
     FrmMainTreeView.Fix.IOHandler.WriteLn(MsgOrderBuy);
     LabeledEdit1.Clear;
     LabeledEdit2.Clear;
     LabeledEdit3.Clear;
   end;
   end
   else
   begin
     MsgOrderBuy:='35=G' + #01 +
         '49=' + FrmMainTreeView.RouterLibrary1.FixSession.Username + #01 +
         '56=' + FrmMainTreeView.RouterLibrary1.FixSession.TargetCompId+ #01 +
         '34=' + FrmMainTreeView.RouterLibrary1.FixSession.IncrementOutMsgSeq + #01 +
         '52=' + FormatDateTime('yyyymmdd-hh:nn:ss',Now) + #01 +
         '11=' +IntToStr(Unique) + #01;

         if Self.Caption = 'Compra' then
         MsgOrderBuy:=MsgOrderBuy + '54=1' + #01
         else
         MsgOrderBuy:=MsgOrderBuy + '54=2' + #01;

         MsgOrderBuy:=MsgOrderBuy + '38=' + LabeledEdit2.Text + #01 +
         '37=' + Label23.Caption + #01 +
         '40=2' + #01 +
         '44=' + ChangeDecimalSeparator( LabeledEdit3.Text,',','.' ) + #01;

         case ComboBox1.ItemIndex of
           0: MsgOrderBuy:=MsgOrderBuy + '59=0' + #01;
           1: MsgOrderBuy:=MsgOrderBuy + '59=3' + #01;
           2: MsgOrderBuy:=MsgOrderBuy + '59=4' + #01;
         end;


         MsgOrderBuy:=MsgOrderBuy + '78=1' + #01 +
         '79=' + LabeledEdit4.Text + #01 +
         '661=99' + #01 +
         '453=1' + #01 +
         '448=' + FrmMainTreeView.RouterLibrary1.FixSession.Username + #01 +
         '447=D' + #01 +
         '452=36' + #01 +
         '60=' + FormatDateTime('yyyymmdd-hh:nn:ss',Now) + #01 +
         '55=' + LabeledEdit1.Text + #01 +
         '48=' + SecurityID + #01 +
         '22=8' + #01 +
         '207=' + FrmMainTreeView.RouterLibrary1.FixSession.SecurityExchange + #01 +
         '41=' + FrmMainTreeView.RouterLibrary1.FixSession.Username + #01;

         MsgOrderBuy:= '8=FIX.4.4' + #01 +
               '9=' + IntToStr(Length(MsgOrderBuy)) + #01 + MsgOrderBuy;

   FrmMainTreeView.LabelReturn:=Label15;


   MsgOrderBuy:=MsgOrderBuy + FrmMainTreeView.RouterLibrary1.GenerateCheckSum(MsgOrderBuy);

   FrmMainTreeView.Memo1.Lines.Add(MsgOrderBuy);

   if MessageDlg('Confirma o envio desta ordem?',mtConfirmation,[mbYes,mbNo],0) = mrYes then
   begin
     try
      FrmMainTreeView.Fix.IOHandler.WriteLn(MsgOrderBuy);
     except

       on EIdConnectException do
       begin
        FrmMainTreeView.MsgErr:='Você não está conectado ao broker BMF.';
        FrmMainTreeView.ShowMsgErr;
       end;

       on EIdConnClosedGracefully do
       begin
        FrmMainTreeView.MsgErr:='Você não está conectado ao broker BMF.';
        FrmMainTreeView.ShowMsgErr;
       end;

     end;
     LabeledEdit1.Clear;
     LabeledEdit2.Clear;
     LabeledEdit3.Clear;
     Label23.Caption:='';
     Label23.Visible:=False;
     Label22.Visible:=False;
     Edit:=False;
   end;


   end;

end;

end;

procedure TFrmBrokerBuy.BitBtn2Click(Sender: TObject);
begin
  Self.Close;
end;

procedure TFrmBrokerBuy.CalcTotal;
var qtde : Integer;
    price : Double;
    r : Double;
begin
 Label15.Font.Color:=$000F0FFF;

 if ( LabeledEdit2.Text = '' )or ( LabeledEdit3.Text = '' ) then
 begin
   Label8.Caption:='0.00';
   Label15.Caption:='';
 end
 else
 begin
   try
     qtde:= StrToInt(LabeledEdit2.Text);
     price:=StrToFloat(LabeledEdit3.Text);
     r:= price * qtde;
     Label8.Caption:=FormatFloat('0.00',r);

     //Recomendações -- Lote padrão, e qtde fracionaria
     if ( Copy(LabeledEdit1.Text,Length(LabeledEdit1.Text),1) <> 'F' ) then
     begin
       if ( Copy(LabeledEdit1.Text,1,3) <> 'WIN' ) AND ( Copy(LabeledEdit1.Text,1,3) <> 'DOL') AND ( Copy(LabeledEdit1.Text,1,3) <> 'IND') then
       begin
         if qtde mod 100 <> 0 then
         Label15.Caption:='O ativo escolhido é um lote padrão e a quantidade é fracionária.'
         else
         Label15.Caption:='';
       end
       else
       Label15.Caption:='';
     end
     else
     begin
       // Lote Fracionario e qtde padrao
       if qtde div 100 >= 1 then
       Label15.Caption:='O ativo possui uma quantidade padrão.'
       else
       Label15.Caption:='';
     end;

     if price = 0 then
     Label15.Caption:='O preço está nulo.';

   except
    on E: Exception do
    begin
     Label8.Caption:='0.00';
    end;

   end;

   if (Copy(LabeledEdit1.Text,1,3) = 'WIN') OR (Copy(LabeledEdit1.Text,1,3) = 'IND') OR  (Copy(LabeledEdit1.Text,1,3) = 'DOL')  then
   begin
     Label25.Caption:='BM&&F';
//     LabeledEdit4.Visible:=True;
     ComboBox1.Items.Clear;
     ComboBox1.Items.Add('Hoje');
     ComboBox1.Items.Add('Exec./Parc. ou Canc.');
     ComboBox1.Items.Add('Exec. ou Canc.');
     ComboBox1.ItemIndex:=0;
   end
   else
   begin
    if (Copy(LabeledEdit1.Text,1,3) = 'WIN') then
    begin
     Label25.Caption:='BM&&F';
     LabeledEdit4.Visible:=False;
     ComboBox1.Items.Clear;
     ComboBox1.Items.Add('Hoje');
     ComboBox1.Items.Add('Até cancelar');
     ComboBox1.Items.Add('Data espec.');
     ComboBox1.Items.Add('Tudo ou Nada');
     ComboBox1.Items.Add('Exec. ou Canc.');
     ComboBox1.ItemIndex:=0;
    end else
    begin

     Label25.Caption:='BOVESPA';
     LabeledEdit4.Visible:=False;

     ComboBox1.Items.Clear;
     ComboBox1.Items.Add('Hoje');
     ComboBox1.Items.Add('Até cancelar');
     ComboBox1.Items.Add('Data espec.');
     ComboBox1.Items.Add('Tudo ou Nada');
     ComboBox1.Items.Add('Exec. ou Canc.');
     ComboBox1.ItemIndex:=0;
    end;
   end;


 end;

end;
function TFrmBrokerBuy.ChangeDecimalSeparator(Value : String;Decimal : String;DecimalChange : String): String;
var R:String;
  I: Integer;
begin
  R:='';
  for I := 1 to Length(Value) do
  begin
    if Copy(Value,I,1) <> Decimal then
    R:=R + Copy(Value,I,1)
    else
    R:= R + DecimalChange;
  end;
  Result:=R;
end;

procedure TFrmBrokerBuy.CheckBox1Click(Sender: TObject);
begin
 if CheckBox1.Checked then
 Self.FormStyle:=fsStayOnTop
 else
 Self.FormStyle:=fsNormal;
end;

procedure TFrmBrokerBuy.ComboBox1Change(Sender: TObject);
begin
  Label9.Caption:=ComboBox1.Text;
end;

procedure TFrmBrokerBuy.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle:= Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent:= GetDesktopWindow;
end;

procedure TFrmBrokerBuy.DateTimePicker1Change(Sender: TObject);
begin
  Label12.Caption:=DateToStr(DateTimePicker1.Date);
end;

procedure TFrmBrokerBuy.FormClose(Sender: TObject; var Action: TCloseAction);
begin
      LabeledEdit1.Clear;
      LabeledEdit2.Clear;
      LabeledEdit3.Clear;
end;

procedure TFrmBrokerBuy.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  FrmMainTreeView.FormKeyDown(Sender,Key,Shift);
end;

procedure TFrmBrokerBuy.FormShow(Sender: TObject);
begin
  CheckBox1Click(Self);

  DateTimePicker1.Date:=Today;
  DateTimePicker1Change(Self);
  Label17.Caption:=FrmMainTreeView.ClientName;

  if Label23.Caption = '' then
  begin
    Label22.Visible:=False;
    Label23.Visible:=False;
  end;
end;

procedure TFrmBrokerBuy.GroupBox1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
 Label14.Font.Style:=Font.Style + [fsUnderline];
 Label14.Font.Color:=clBlack;
end;

procedure TFrmBrokerBuy.GroupBox3MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  Label21.Font.Style:=Font.Style - [fsUnderline,fsBold];
  Label21.Font.Color:=clBlack;

  Label19.Font.Style:=Font.Style - [fsUnderline,fsBold];
  Label19.Font.Color:=clBlack;
end;

procedure TFrmBrokerBuy.Label14Click(Sender: TObject);
var R:String;
  I: Integer;
begin
  R:='';
  for I := 1 to Length(Label14.Caption) do
  begin
    if Copy(Label14.Caption,I,1) <> '.' then
    R:=R + Copy(Label14.Caption,I,1)
    else
    R:= R + ',';
  end;
  LabeledEdit3.Text:=R;
end;

procedure TFrmBrokerBuy.Label14MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Label14.Font.Style:=Font.Style + [fsUnderline];
  Label14.Font.Color:=clBlue;
end;

procedure TFrmBrokerBuy.Label19Click(Sender: TObject);
begin
 LabeledEdit3.Text:=FrmMainTreeView.ChangeDecimalSeparator(Label19.Caption,'.',',');
end;

procedure TFrmBrokerBuy.Label19MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Label19.Font.Style:=Font.Style + [fsUnderline];
  Label19.Font.Color:=clBlue;
end;

procedure TFrmBrokerBuy.Label21Click(Sender: TObject);
begin
  LabeledEdit3.Text:=FrmMainTreeView.ChangeDecimalSeparator(Label21.Caption,'.',',');
end;

procedure TFrmBrokerBuy.Label21MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Label21.Font.Style:=Font.Style + [fsUnderline];
  Label21.Font.Color:=clBlue;
end;

procedure TFrmBrokerBuy.LabeledEdit1Change(Sender: TObject);
begin
  Label4.Caption:=UpperCase( LabeledEdit1.Text );

  if ( LabeledEdit2.Text <> '' ) and ( LabeledEdit3.Text <> '' )then
  CalcTotal;

end;

procedure TFrmBrokerBuy.LabeledEdit1Exit(Sender: TObject);
var MsgSecurity : String;
    Unique : Integer;
begin
 if not FrmCentral.CentralSheet.FindQuote(LabeledEdit1.Text) and (LabeledEdit1.Text <> '') then
 FrmCentral.AddSymbol(LabeledEdit1.Text);

 FrmMainTreeView.DaileonFW.IOHandler.WriteLn('sqt ' + LowerCase(LabeledEdit1.Text));
 FrmMainTreeView.DaileonFW.IOHandler.WriteBufferFlush;

  if FrmMainTreeView.Fix.Connected then
  begin

  Randomize;


  MsgSecurity:='35=x' + #01 +
         '49=' + FrmMainTreeView.RouterLibrary1.FixSession.Username + #01 +
         '56=' + FrmMainTreeView.RouterLibrary1.FixSession.TargetCompId+ #01 +
         '34=' + FrmMainTreeView.RouterLibrary1.FixSession.IncrementOutMsgSeq + #01 +
         '52=' + FormatDateTime('yyyymmdd-hh:nn:ss',Now) + #01 +
         '320=' +IntToStr(Unique) + #01 +
         '263=0' + #01 +
         '559=0' + #01 +
         '1301=XBMF' + #01 +
         '55=' + LabeledEdit1.Text + #01;

         MsgSecurity:= '8=FIX.4.4' + #01 +
               '9=' + IntToStr(Length(MsgSecurity)) + #01 + MsgSecurity;

  MsgSecurity:= MsgSecurity + FrmMainTreeView.RouterLibrary1.GenerateCheckSum(MsgSecurity);

  FrmMainTreeView.Fix.IOHandler.WriteLn(MsgSecurity);
  end;

end;

procedure TFrmBrokerBuy.LabeledEdit2Change(Sender: TObject);
begin
  Label6.Caption:=LabeledEdit2.Text;
  CalcTotal;
end;

procedure TFrmBrokerBuy.LabeledEdit3KeyPress(Sender: TObject; var Key: Char);
begin
 if not ( Key in ['0'..'9',Char(8),DecimalSeparator] )  then
 Key:=#0;
end;

procedure TFrmBrokerBuy.Timer1Timer(Sender: TObject);
begin
 try
   Label14.Caption:=FrmCentral.CentralSheet.GetValue(clLast,Label4.Caption);
   Label19.Caption:=FrmCentral.CentralSheet.GetValue(clBuy,Label4.Caption);
   Label21.Caption:=FrmCentral.CentralSheet.GetValue(clSell,Label4.Caption);
 except on E: Exception do
   Label14.Caption:='0.00';
 end;
end;

end.
