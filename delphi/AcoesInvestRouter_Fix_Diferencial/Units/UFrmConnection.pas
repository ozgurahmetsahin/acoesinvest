unit UFrmConnection;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls,ShellAPI,IniFiles, jpeg;

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
    procedure BtnCloseClick(Sender: TObject);
    procedure BtnLoginClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnLogoutClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CheckBox2Click(Sender: TObject);
    procedure EdtUserBrokerChange(Sender: TObject);
    procedure EdtPassBrokerChange(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SaveInformations;
    procedure LoadInformations;
  end;

var
  FrmConnection: TFrmConnection;

implementation

uses UFrmMainTreeView,UThrdDaileonFwConnection,UThrdBrokerConnection,UThrdFixConnection,
  UFrmMainLine, UFrmConfig, UFrmConnConfig, UMain, UMsgs;

{$R *.dfm}

procedure TFrmConnection.BtnLoginClick(Sender: TObject);
var DaileonConn : TDaileonFwConnection;
    BrokerConn  : TBrokerConnection;
    FixConn : TFixConnection;
    IniSettings : TIniFile;
begin
  StatusBar1.SimpleText:='Iniciando conex�o com servidor.(' + FrmMainTreeView.DaileonFW.Host + ')';
  DaileonConn:= TDaileonFwConnection.Create(True);
  DaileonConn.Resume;

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

//   MessageDlg('Aten��o:' + #13 + #13 +
//   'As configura��es atuais para este sistema apresentam servidores diferentes ' +
//   'para ambos os mercados, tenha certeza que os dados de conex�o para esses servidores ' +
//   's�o os mesmos.',mtWarning,[mbOk],0);
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
  if FrmMainLine.Showing then
  Self.Hide
  else
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
var IniData : TIniFile;
begin
//  CheckBox2.Visible:=False;
//  CheckBox2.Checked:=True;
//  CheckBox2Click(Self);

  //Caso esteja conectado desabilita botoes
  if FrmMainTreeView.DaileonFW.Connected then
  begin
    EdtUserTrade.Enabled:=False;
    EdtPassTrade.Enabled:=False;
    EdtUserBroker.Enabled:=False;
    EdtPassBroker.Enabled:=False;

    BtnLogin.Visible:=False;
    BtnLogout.Visible:=True;
    BtnClear.Enabled:=False;
  end
  else
  begin
  //Como n�o est�, habilita os botoes por seguran�a

//   FrmMainTreeView.TerminateProcesso(ExtractFilePath(ParamStr(0)) + 'broker.exe');

   LoadInformations;

   FrmConnConfig.FormShow(Self);

   EdtUserTrade.Enabled:=True;
   EdtPassTrade.Enabled:=True;
   EdtUserBroker.Enabled:=True;
   EdtPassBroker.Enabled:=True;

   BtnLogin.Visible:=True;
   BtnLogout.Visible:=False;
   BtnClear.Enabled:=True;

  end;


  StatusBar1.SimpleText:='';
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

end.
