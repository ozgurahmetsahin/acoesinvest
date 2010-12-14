unit UFrmConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Tabs, ComCtrls, StdCtrls, ExtCtrls, jpeg,IniFiles, Buttons,ShellAPI;

type
  TFrmConfig = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    Button1: TButton;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    Button2: TButton;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmConfig: TFrmConfig;

implementation

uses UFrmMainTreeView, UThrdDaileonFwRead, UFrmConnection,
  UThrdBrokerConnection;

{$R *.dfm}



procedure TFrmConfig.Button1Click(Sender: TObject);
begin
 if Button1.Caption='Desconectar' then
 begin
   SignalThread.Connection.Disconnect;
 end
 else
 begin
   FrmConnection.EdtUserTrade.Text:=LabeledEdit1.Text;
   FrmConnection.EdtPassTrade.Text:=LabeledEdit2.Text;
   FrmConnection.BtnLoginClick(Self);
 end;
end;

procedure TFrmConfig.Button2Click(Sender: TObject);
var BrokerConn:TBrokerConnection;
begin
 if Button2.Caption='Desconectar' then
 begin
   FrmMainTreeView.Broker.Disconnect;
 end
 else
 begin
   FrmConnection.EdtUserBroker.Text:=LabeledEdit3.Text;
   FrmConnection.EdtPassBroker.Text:=LabeledEdit4.Text;
   Sleep(1000);
   ShellExecute(Handle,'open','brokerRun.bat','',PChar(ExtractFilePath(ParamStr(0))),SW_HIDE);
   BrokerConn := TBrokerConnection.Create(True);
   BrokerConn.Resume;
 end;
end;

procedure TFrmConfig.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer1.Enabled:=False;
end;

procedure TFrmConfig.FormShow(Sender: TObject);
begin
  Timer1.Enabled:=True;
end;

procedure TFrmConfig.Timer1Timer(Sender: TObject);
begin
  if SignalThread.Connection.Connected then
  begin
    Label2.Caption:='Conectado';
    LabeledEdit1.Text:=FrmConnection.EdtUserTrade.Text;
    LabeledEdit2.Text:=FrmConnection.EdtPassTrade.Text;
    Button1.Caption:='Desconectar';
  end
  else
  begin
    Label2.Caption:='Desconectado';
    Button1.Caption:='Conectar';
  end;

  if FrmMainTreeView.Broker.Connected then
  begin
    Label4.Caption:='Conectado';
    LabeledEdit3.Text:=FrmConnection.EdtUserBroker.Text;
    LabeledEdit4.Text:=FrmConnection.EdtPassBroker.Text;
    Button2.Caption:='Desconectar';
  end
  else
  begin
    Label4.Caption:='Desconectado';
    Button2.Caption:='Conectar';
  end;
end;

end.
