unit UFrmConnectionControl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UConsts, UDataControl, StdCtrls, Buttons, ComCtrls, ExtCtrls;

type
  TFrmConnectionControl = class(TForm)
    BtnConnection: TBitBtn;
    Configurar: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    TimerCheckConnection: TTimer;
    CkAutoReconnect: TCheckBox;
    Label5: TLabel;
    Label6: TLabel;
    procedure TimerCheckConnectionTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnConnectionClick(Sender: TObject);
  private
    { Private declarations }
    IsAutoReconnect:Boolean;
  public
    { Public declarations }
  end;

var
  FrmConnectionControl: TFrmConnectionControl;
  SignalConnection : TConnection;

implementation

procedure TFrmConnectionControl.BtnConnectionClick(Sender: TObject);
begin

  if (BtnConnection.Caption = SBtnDisconnect) and (not IsAutoReconnect) then
  begin
    {Finaliza timer de checagem de conexao}
    TimerCheckConnection.Enabled:=False;
    {Desconecta socket}
    SignalConnection.Disconnect;
    {Desabilita auto reconexao}
    CkAutoReconnect.Checked:=False;
    {Muda caption do botao}
    BtnConnection.Caption:=SBtnConnect;
    {Muda Informações}
    Label2.Caption:=SConnOff;
    Label3.Caption:='';
    Exit;
  end;

  {Configura a conexão}
  with SignalConnection do
  begin
    Host:='server3.acoesinvest.com.br';
    Port:=8189;
    ConnectTimeOut:=2000;
    ReadTimeOut:=250;
  end;

  {Inicia a conexao}
  if SignalConnection.Connect then
  begin
    {Habilita auto reconexao}
    CkAutoReconnect.Checked:=True;
    {Muda caption do botao}
    BtnConnection.Caption:=SBtnDisconnect;
    {Desativa Flag de Auto Reconexao}
    IsAutoReconnect:=False;
    {Inicia timer de checagem de conexao}
    TimerCheckConnection.Enabled:=True;
  end
  else
  begin
    {Desabilita auto reconexao}
    CkAutoReconnect.Checked:=False;
    {Muda caption do botao}
    BtnConnection.Caption:=SBtnConnect;
    {Finaliza timer de checagem de conexao}
    TimerCheckConnection.Enabled:=False;
  end;
end;

procedure TFrmConnectionControl.FormCreate(Sender: TObject);
begin
  {Configura Informações}
  Self.Caption:=SFrmConnectionCaption;
  BtnConnection.Caption:=SBtnConnect;
  Label2.Caption:=SConnOff;
  Label3.Caption:='';
end;

procedure TFrmConnectionControl.TimerCheckConnectionTimer(Sender: TObject);
begin
  if SignalConnection.Connected then
  begin
    Label2.Caption:=SConnOn;
    Label3.Caption:=SignalConnection.Host;
  end
  else
  begin
    Label2.Caption:=SConnOff;
    Label3.Caption:='';

    if CkAutoReconnect.Checked then
    begin
      IsAutoReconnect:=True;
      BtnConnectionClick(Self);
    end;

  end;

end;

initialization
  SignalConnection:=TConnection.Create;
{$R *.dfm}

end.
