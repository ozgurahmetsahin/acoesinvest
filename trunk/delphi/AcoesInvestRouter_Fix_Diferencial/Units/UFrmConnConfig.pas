unit UFrmConnConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, IniFiles;

type
  TFrmConnConfig = class(TForm)
    lblEditSvrSignal: TLabeledEdit;
    lblEditPortSignal: TLabeledEdit;
    lblEditConnTimeOutSignal: TLabeledEdit;
    lblEditReadTimeOutSignal: TLabeledEdit;
    lblEdtSvrBroker: TLabeledEdit;
    lblEdtPortBroker: TLabeledEdit;
    lbLEdtReadTimeOutBroker: TLabeledEdit;
    lblEdtConnTimeOutBroker: TLabeledEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    procedure CategoryPanel2Collapse(Sender: TObject);
    procedure CategoryPanel1Collapse(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
  private
    { Private declarations }
    const ConfigFileName:String = 'settings.ini';
    procedure ShowHintConnectTimeOut;
    procedure ShowHintReadTimeOut;
    procedure SaveSignal;
    procedure SaveBroker;
    procedure RestoreSignal;
    procedure RestoreBroker;
  public
    { Public declarations }
    procedure LoadAllConfigs;
  end;

var
  FrmConnConfig: TFrmConnConfig;

implementation
  uses UMain, UMsgs, UFrmMainTreeView;
{$R *.dfm}

procedure TFrmConnConfig.BitBtn1Click(Sender: TObject);
begin
  SaveSignal;
end;

procedure TFrmConnConfig.BitBtn2Click(Sender: TObject);
begin
  RestoreSignal;
end;

procedure TFrmConnConfig.BitBtn3Click(Sender: TObject);
begin
 SaveBroker;
end;

procedure TFrmConnConfig.BitBtn4Click(Sender: TObject);
begin
 RestoreBroker;
end;

procedure TFrmConnConfig.CategoryPanel1Collapse(Sender: TObject);
begin
 {Aborta o Collapse}
 Abort;
end;

procedure TFrmConnConfig.CategoryPanel2Collapse(Sender: TObject);
begin
 {Aborta o Collapse}
 Abort;
end;

procedure TFrmConnConfig.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 //Action:=caFree;
end;

procedure TFrmConnConfig.FormShow(Sender: TObject);
begin
  LoadAllConfigs;
end;

procedure TFrmConnConfig.LoadAllConfigs;
var Config:TIniFile;
begin
 {Tenta ler as configurações}
 try
   // Se arquivo não existir, seta valores padrão
   if(not FileExists(AppPath+ConfigFileName))then
   begin
     RestoreSignal;
     SaveSignal;
     RestoreBroker;
     SaveBroker;
   end;
   Config:=TIniFile.Create(AppPath+ConfigFileName);

   // Coloca os dados no formulario
   lblEditSvrSignal.Text:= Config.ReadString('SIGNAL','Server','dmatrader.diferencial.com.br');
   lblEditPortSignal.Text:= Config.ReadString('SIGNAL','Port','8184');
   lblEditConnTimeOutSignal.Text:= Config.ReadString('SIGNAL','ConnectTimeOut','2');
   lblEditReadTimeOutSignal.Text:= Config.ReadString('SIGNAL','ReadTimeOut','250');
   lblEdtSvrBroker.Text:= Config.ReadString('BROKER','Server','brokerdiferencial.cedrofinances.com.br');
   lblEdtPortBroker.Text:= Config.ReadString('BROKER','Port','8185');
   lblEdtConnTimeOutBroker.Text:= Config.ReadString('BROKER','ConnectTimeOut','2');
   lblEdtReadTimeOutBroker.Text:= Config.ReadString('BROKER','ReadTimeOut','250');

   // Se o componente estiver sido criado
   if(Assigned(FrmMainTreeView.DaileonFW))then
   begin
     with FrmMainTreeView.DaileonFW do
     begin
       Host:= Config.ReadString('SIGNAL','Server','dmatrader.diferencial.com.br');
       Port:= Config.ReadInteger('SIGNAL', 'Port', 81);
       ConnectTimeout:= Config.ReadInteger('SIGNAL','ConnectTimeOut', 2)*1000;
       ReadTimeout:= Config.ReadInteger('SIGNAL','ReadTimeOut', 250);
     end; // with signal
   end; // assigned signal

//   // Se o componente estiver sido criado
//   if(Assigned(FrmMainTreeView.Broker))then
//   begin
//     with FrmMainTreeView.Broker do
//     begin
//       Host:= Config.ReadString('BROKER','Server','broker.acoesinvest.com.br');
//       Port:= Config.ReadInteger('BROKER', 'Port', 8185);
//       ConnectTimeout:= Config.ReadInteger('BROKER','ConnectTimeOut', 2)*1000;
//       ReadTimeout:= Config.ReadInteger('BROKER','ReadTimeOut', 250);
//     end; // with broker
//   end; // assigned broker

   Config.Free;
 except
  { TODO : Raises não testados. }
  {Exceção FileNotFound}
  on E:EIniFileException do
  raise EIniFileException.Create(ConnConfig_ERR_IniFileException);
  {Exceção Geral}
  on E: Exception do
  raise Exception.Create(ConnConfig_ERR_Exception);
 end;
end;

procedure TFrmConnConfig.RestoreBroker;
begin
 {Restaura padrão}
 lblEdtSvrBroker.Text:='brokerdiferencial.cedrofinances.com.br';
 lblEdtPortBroker.Text:='8185';
 lblEdtConnTimeOutBroker.Text:='2';
 lblEdtReadTimeOutBroker.Text:='250';
end;

procedure TFrmConnConfig.RestoreSignal;
begin
 {Restaura padrão}
 lblEditSvrSignal.Text:='dmatrader.diferencial.com.br';
 lblEditPortSignal.Text:='8184';
 lblEditConnTimeOutSignal.Text:='2';
 lblEditReadTimeOutSignal.Text:='250';
end;

procedure TFrmConnConfig.SaveBroker;
var Config:TIniFile;
    ZebedeeConfig:TStringList;
begin
  {Tentamos escrever}
  try
//    FrmMainTreeView.TerminateProcesso(AppPath + 'broker.exe');

    Config:=TIniFile.Create(AppPath+ConfigFileName);

    with Config do
    begin
      WriteString('BROKER','Server', lblEdtSvrBroker.Text);
      WriteInteger('BROKER','Port', StrToInt(lblEdtPortBroker.Text));
      WriteInteger('BROKER','ConnectTimeOut', StrToInt(lblEdtConnTimeOutBroker.Text));
      WriteInteger('BROKER','ReadTimeOut', StrToInt(lblEdtReadTimeOutBroker.Text));
    end; // with config

    // Se o componente estiver sido criado
   if(Assigned(FrmMainTreeView.DaileonFW))then
   begin
     with FrmMainTreeView.DaileonFW do
     begin
       Host:= lblEdtSvrBroker.Text;
       Port:= StrToInt(lblEdtPortBroker.Text);
       ConnectTimeout:= StrToInt(lblEdtConnTimeOutBroker.Text)*1000;
       ReadTimeout:= StrToInt(lblEdtReadTimeOutBroker.Text);
     end; // with signal
   end; // assigned signal

    // Configura arquivo zbd
    ZebedeeConfig:=TStringList.Create;
    ZebedeeConfig.Clear;
    ZebedeeConfig.Add('broker -f broker.zbd 9709:'+ lblEdtSvrBroker.Text + ':8185');
    ZebedeeConfig.SaveToFile(AppPath+'brokerRun.bat');

    Config.Free;

//   MessageDlg('Configurações aplicadas com sucesso. Reinicie sua aplicação para que serem ativadas.', mtInformation,[mbOk],0);

  except
    { TODO : Raises não testados. }
    {Exceção FileNotFound}
    on E:EIniFileException do
    raise EIniFileException.Create(ConnConfig_ERR_IniFileException);
    {Exceção Geral}
    on E: Exception do
    raise Exception.Create(ConnConfig_ERR_Exception);
  end;
end;

procedure TFrmConnConfig.SaveSignal;
var Config:TIniFile;
begin
  {Tentamos escrever}
  try
    Config:=TIniFile.Create(AppPath+ConfigFileName);

    with Config do
    begin
      WriteString('SIGNAL','Server', lblEditSvrSignal.Text);
      WriteInteger('SIGNAL','Port', StrToInt(lblEditPortSignal.Text));
      WriteInteger('SIGNAL','ConnectTimeOut', StrToInt(lblEditConnTimeOutSignal.Text));
      WriteInteger('SIGNAL','ReadTimeOut', StrToInt(lblEditReadTimeOutSignal.Text));
    end; // with config

    Config.Free;


//    MessageDlg('Configurações aplicadas com sucesso. Reinicie sua aplicação para que serem ativadas.', mtInformation,[mbOk],0);

  except
    { TODO : Raises não testados. }
    {Exceção FileNotFound}
    on E:EIniFileException do
    raise EIniFileException.Create(ConnConfig_ERR_IniFileException);
    {Exceção Geral}
    on E: Exception do
    raise Exception.Create(ConnConfig_ERR_Exception);
  end;
end;

procedure TFrmConnConfig.ShowHintConnectTimeOut;
begin
  {Exibe explicação sobre o ConnectTimeOut}
  ShowMessage(Hint_ConnectTimeOut);
end;

procedure TFrmConnConfig.ShowHintReadTimeOut;
begin
  {Exibe explicação sobre o ReadTimeOut}
  ShowMessage(Hint_ReadTimeOut);
end;

procedure TFrmConnConfig.SpeedButton1Click(Sender: TObject);
begin
  ShowHintConnectTimeOut;
end;

procedure TFrmConnConfig.SpeedButton2Click(Sender: TObject);
begin
 ShowHintReadTimeOut;
end;

procedure TFrmConnConfig.SpeedButton3Click(Sender: TObject);
begin
 ShowHintReadTimeOut;
end;

procedure TFrmConnConfig.SpeedButton4Click(Sender: TObject);
begin
 ShowHintConnectTimeOut;
end;

end.
