unit UFrmConnection;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls,ShellAPI,IniFiles, jpeg, IdGlobal;

type
  TFrmConnection = class(TForm)
    BtnLogin: TBitBtn;
    BtnClear: TBitBtn;
    CheckBox1: TCheckBox;
    BtnClose: TBitBtn;
    StatusBar1: TStatusBar;
    BtnLogout: TBitBtn;
    EdtUserTrade: TEdit;
    EdtPassTrade: TEdit;
    EdtUserBroker: TEdit;
    EdtPassBroker: TEdit;
    Image1: TImage;
    BitBtn1: TBitBtn;
    Timer1: TTimer;
    procedure BtnCloseClick(Sender: TObject);
    procedure BtnLoginClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnLogoutClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CheckBox2Click(Sender: TObject);
    procedure EdtUserBrokerChange(Sender: TObject);
    procedure EdtPassBrokerChange(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    RowRead:Integer;
  public
    { Public declarations }
    procedure SaveInformations;
    procedure LoadInformations;
  end;

var
  FrmConnection: TFrmConnection;

implementation

uses UFrmMainTreeView,UThrdDaileonFwConnection,UThrdBrokerConnection,UThrdFixConnection,
  UFrmMainLine, UFrmConfig, UFrmConnConfig, UMain, UMsgs, UThrdDaileonFwRead;

{$R *.dfm}

procedure TFrmConnection.BtnLoginClick(Sender: TObject);
var DaileonConn : TDaileonFwConnection;
    BrokerConn  : TBrokerConnection;
    FixConn : TFixConnection;
    IniSettings : TIniFile;
begin
  StatusBar1.SimpleText:='Iniciando conexão com servidor...';

  {Cria Instancia da Thread de Conexao}
  if not Assigned(SignalThread) then
  begin
    SignalThread:=TThrdDaileonFwRead.Create;
  end;

  SignalThread.Connection.Host:='server3.acoesinvest.com.br';
  SignalThread.Connection.Port:=8189;
  SignalThread.Connection.ReadTimeout:=500;
  SignalThread.Connection.ConnectTimeout:=2500;

  if SignalThread.Connect then
  begin
    SignalThread.Start;
    RowRead:=0;
    Timer1.Enabled:=True;
    StatusBar1.SimpleText:='Conectado, enviando dados de autenticação...';
    SignalThread.WriteLn('login ' + EdtUserTrade.Text + ' ' + EdtPassTrade.Text);
  end
  else
  StatusBar1.SimpleText:='Não foi possível efetuar a conexão com o servidor.';


//  DaileonConn:= TDaileonFwConnection.Create(True);
//  DaileonConn.Resume;
//
  if EdtUserBroker.Text <> '' then
  begin
    //FrmMainTreeView.TerminateProcesso(AppPath + 'broker.exe');
    Sleep(1000);
    ShellExecute(Handle,'open','brokerRun.bat','',PChar(ExtractFilePath(ParamStr(0))),SW_HIDE);
    BrokerConn := TBrokerConnection.Create(True);
    BrokerConn.Resume;
  end;
//  if Edit1.Text <> '' then
//  begin
//    FixConn:= TFixConnection.Create(True);
//    FixConn.Resume;
//  end;

  SaveInformations;
end;

procedure TFrmConnection.BtnLogoutClick(Sender: TObject);
begin
  try
    FrmMainTreeView.DaileonFW.Disconnect;

    FrmMainTreeView.Broker.Disconnect;

    FrmMainTreeView.Fix.Disconnect;

    FrmMainTreeView.ClientName:='';
    FrmMainTreeView.MarketID:='';
    FrmMainTreeView.ShadownCode:='';

    EdtUserTrade.Enabled:=True;
    EdtPassTrade.Enabled:=True;
    EdtUserBroker.Enabled:=True;
    EdtPassBroker.Enabled:=True;

    BtnLogin.Visible:=True;
    BtnLogout.Visible:=False;
    BtnClear.Enabled:=True;
  except on E: Exception do
  end;
end;

procedure TFrmConnection.CheckBox2Click(Sender: TObject);
begin
// if CheckBox2.Checked then
// begin
//   GroupBox4.Visible:=False;
//   GroupBox3.Caption:='Bovespa / BMF:';
//   Edit1.Text:=EdtUserBroker.Text;
//   Edit2.Text:=EdtPassBroker.Text;

//   MessageDlg('Atenção:' + #13 + #13 +
//   'As configurações atuais para este sistema apresentam servidores diferentes ' +
//   'para ambos os mercados, tenha certeza que os dados de conexão para esses servidores ' +
//   'são os mesmos.',mtWarning,[mbOk],0);
// end
// else
// begin
////   GroupBox4.Visible:=True;
////   Edit1.Clear;
////   Edit2.Clear;
////   GroupBox3.Caption:='Bovespa:';
// end;
end;

procedure TFrmConnection.EdtPassBrokerChange(Sender: TObject);
begin
// if CheckBox2.Checked then
// begin
////   Edit2.Text:=EdtPassBroker.Text;
// end;
end;

procedure TFrmConnection.EdtUserBrokerChange(Sender: TObject);
begin
// if CheckBox2.Checked then
// begin
////   Edit1.Text:=EdtUserBroker.Text;
// end;
end;

procedure TFrmConnection.BitBtn1Click(Sender: TObject);
begin
 FrmConnConfig.Show;
end;

procedure TFrmConnection.BtnCloseClick(Sender: TObject);
begin
  if Assigned(SignalThread) then
  SignalThread.Terminate;
  Self.Close;
end;


procedure TFrmConnection.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  FrmMainTreeView.Show;
//  FrmMainTreeView.BringToFront;
//  FrmMainLine.Show;
//  FrmMainLine.BringToFront;
end;

procedure TFrmConnection.FormShow(Sender: TObject);
//var IniData : TIniFile;
begin
//  CheckBox2.Visible:=False;
//  CheckBox2.Checked:=True;
//  CheckBox2Click(Self);

  //Caso esteja conectado desabilita botoes
//  if FrmMainTreeView.DaileonFW.Connected then
//  begin
//    EdtUserTrade.Enabled:=False;
//    EdtPassTrade.Enabled:=False;
//    EdtUserBroker.Enabled:=False;
//    EdtPassBroker.Enabled:=False;
//
//    BtnLogin.Visible:=False;
//    BtnLogout.Visible:=True;
//    BtnClear.Enabled:=False;
//  end
//  else
//  begin
  //Como não está, habilita os botoes por segurança

//   FrmMainTreeView.TerminateProcesso(ExtractFilePath(ParamStr(0)) + 'broker.exe');

//   LoadInformations;
//
//   FrmConnConfig.FormShow(Self);
//
//   EdtUserTrade.Enabled:=True;
//   EdtPassTrade.Enabled:=True;
//   EdtUserBroker.Enabled:=True;
//   EdtPassBroker.Enabled:=True;
//
//   BtnLogin.Visible:=True;
//   BtnLogout.Visible:=False;
//   BtnClear.Enabled:=True;
//
//  end;
//
//
//  StatusBar1.SimpleText:='';
end;

procedure TFrmConnection.LoadInformations;
var IniData : TIniFile;
begin
    IniData:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'settings.ini');
    EdtUserTrade.Text:= IniData.ReadString('USERINFO','UserTrade','');
    EdtPassTrade.Text:= IniData.ReadString('USERINFO','PassTrade','');
    EdtUserBroker.Text:= IniData.ReadString('USERINFO','UserBoker','');
//    Edit1.Text:=IniData.ReadString('USERINFO','UserBokerBMF','');
    CheckBox1.Checked:=IniData.ReadBool('USERINFO','SaveSettings',False);

    //Host
    FrmMainTreeView.DaileonFW.Host:=IniData.ReadString('SERVERS','TradeServer',FrmMainTreeView.DefaultTradeHost);

    IniData.Free;
end;

procedure TFrmConnection.SaveInformations;
var UserTrade,
    UserBroker,
    UserBrokerBMF,
    PassTrade : String;
    IniData : TIniFile;
begin
  if CheckBox1.Checked then
  begin
    UserTrade:= EdtUserTrade.Text;
    PassTrade:= EdtPassTrade.Text;
    UserBroker:= EdtUserBroker.Text;
//    UserBrokerBMF:=Edit1.Text;

    IniData:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'settings.ini');

    IniData.WriteString('USERINFO','UserTrade',UserTrade);
    IniData.WriteString('USERINFO','PassTrade',PassTrade);
    IniData.WriteString('USERINFO','UserBoker',UserBroker);
    IniData.WriteString('USERINFO','UserBokerBMF',UserBrokerBMF);
    IniData.WriteBool('USERINFO','SaveSettings',True);
    IniData.Free;
  end
  else
  begin
    UserTrade:= '';
    PassTrade:= '';
    UserBroker:= '';
    UserBrokerBMF:='';

    IniData:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'settings.ini');

    IniData.WriteString('USERINFO','UserTrade',UserTrade);
    IniData.WriteString('USERINFO','PassTrade',PassTrade);
    IniData.WriteString('USERINFO','UserBoker',UserBroker);
    IniData.WriteString('USERINFO','UserBokerBMF',UserBrokerBMF);
    IniData.WriteBool('USERINFO','SaveSettings',False);

    IniData.Free;

  end;
end;

procedure TFrmConnection.Timer1Timer(Sender: TObject);
var Line:String;
    DataSplit:TStringList;
begin
  if SignalThread.Data.Count > RowRead then
  begin
    Line:=SignalThread.Data.Strings[RowRead];

    DataSplit:=TStringList.Create;
    SplitColumns(Line,DataSplit,':');

    if DataSplit[0] = 'LOGIN' then
      if DataSplit[2] = '0' then
      StatusBar1.SimpleText:='Usuário/Senha inválido(s).'
      else if DataSplit[2] = '1' then
           begin
             StatusBar1.SimpleText:='Autenticação efetuada com sucesso, abrindo aplicação...';
             if not Assigned(FrmMainLine) then
             begin
               FrmMainLine:=TFrmMainLine.Create(Application);
               FrmMainLine.Show;
               FrmConnection.Hide;
             end;
             Timer1.Enabled:=False;
           end
           else StatusBar1.SimpleText:='Não foi possível efetuar sua autenticação.';

    FreeAndNil(DataSplit);

    RowRead:=RowRead+1;
  end;
end;

end.
