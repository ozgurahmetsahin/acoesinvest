{ TODO -oDonda -cEstrutura :
Ver como fica o caso dos acesso aos formularios FrmMain e FrmLogin
pelo componente FixLibrary seguindo a OO. }
unit UConnectionCenter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, ExtCtrls, URouterLibrary, DMAConnection, StdCtrls;

type
  TConnectionCenter = class(TForm)
    FixLibrary: TRouterLibrary;
    tmrCheckConnFixStatus: TTimer;
    procedure FixLibraryLogout(Sender: TObject; MsgType: TMsgType; Msg: string);
    procedure FixLibraryLogon(Sender: TObject; MsgType: TMsgType; Msg: string);
    procedure tmrCheckConnFixStatusTimer(Sender: TObject);
    procedure FixLibraryTestRequest(Sender: TObject; Msg: string);
    procedure FixLibraryHeartBeat(Sender: TObject; Msg: string);
    procedure FixLibraryUserListReport(Sender: TObject; Msg: string);
  private
    { Private declarations }
    ConnFix: TConnection;
    procedure LogonFix(Msg:String);
    procedure LogoutFix(Msg:String);
    procedure SendMsgTest;
    procedure HeartBeat;
    procedure WarningConnFixStatus(Status: Boolean);
  public
    { Public declarations }
    ConsultClientName: TEdit;
    function ConnectFix(Host:String; Port:Integer): Boolean;
    procedure StartFix(Username, Password:String);
    procedure DisconnectFix;
    function  IsConnectedFix:Boolean;
    procedure SendCmdFix(Cmd: String);
  end;


implementation

uses UFrmMainBar, UFrmLogin, UThrdFixRead;


{$R *.dfm}

{ TConnectionCenter }


function TConnectionCenter.ConnectFix(Host:String; Port:Integer) : Boolean;
begin

    // Se existir uma instancia, limpa da memoria
    if Assigned(ConnFix) then
    ConnFix.Free;

    // Cria uma nova instancia
    ConnFix:=TConnection.Create;

    // Configura a conexao apenas pra exibir
    // logs de erros
    ConnFix.LogLevel:=lgOnlyErrors;

    // Configura o tipo de leitura
    ConnFix.ReadType:=rtFix;

    // Tenta se conectar
    ConnFix.Connect(Host,Port);

    // Retorna o resultado da conexao
    Result:= ConnFix.Connected;
    if not ConnFix.Connected then
    raise Exception.Create('Erro ao iniciar conexão com o servidor de negociação.' + #13 +
    'Motivo:' + ConnFix.Log.GetLastLog);

end;


procedure TConnectionCenter.DisconnectFix;
begin
  if Assigned(ConnFix) then
    if ConnFix.Connected then
    ConnFix.Disconnect;
end;

procedure TConnectionCenter.FixLibraryHeartBeat(Sender: TObject; Msg: string);
begin
  HeartBeat;
end;

procedure TConnectionCenter.FixLibraryLogon(Sender: TObject; MsgType: TMsgType;
  Msg: string);
begin
  LogonFix(Msg);
end;

procedure TConnectionCenter.FixLibraryLogout(Sender: TObject; MsgType: TMsgType;
  Msg: string);
begin
  LogoutFix(Msg);
end;

procedure TConnectionCenter.FixLibraryTestRequest(Sender: TObject; Msg: string);
begin
  SendMsgTest;
end;

procedure TConnectionCenter.FixLibraryUserListReport(Sender: TObject; Msg: string);
var MsgSplit:TStringList;
begin
  MsgSplit:=TStringList.Create;
 try
  SplitColumns(Msg,MsgSplit,#1);
  ConsultClientName.Text:= MsgSplit.Values['10053'];
 finally
  MsgSplit.Free;
 end;
end;

procedure TConnectionCenter.HeartBeat;
var MsgHeartBeat:String;
begin
  // Gera mensagem de heatbeat
  MsgHeartBeat:=FixLibrary.HeartBeat;
  MsgHeartBeat:=MsgHeartBeat + FixLibrary.GenerateCheckSum(MsgHeartBeat);

  // Envia para o servidor
  SendCmdFix(MsgHeartBeat);
end;

function TConnectionCenter.IsConnectedFix: Boolean;
begin
  // Retorna o status da conexao
  if not Assigned(ConnFix) then Result:=False
  else Result:= ConnFix.Connected;
end;

procedure TConnectionCenter.LogonFix(Msg: String);
begin

  // Cria a barra principal
  frmMainBar:=TfrmMainBar.Create(Self);
  frmMainBar.ledFix.Status:=True;

  // Seta a instancia do centro de conexoes
  frmMainBar.ConnCenter:= Self;

  // Exibe
  frmMainBar.Show;

  // Ativa o timer de verificacao de conexao
  tmrCheckConnFixStatus.Enabled:=True;

  // Esconde tela de login
  frmLogin.Hide;
end;

procedure TConnectionCenter.LogoutFix(Msg: String);
var SplitData:TStringList;
begin
  // Cria Instancia para separar os dados
  SplitData:=TStringList.Create;
  // Separa os dados da mensagem
  SplitColumns(Msg,SplitData,#1);
  // Exibe motivo do logout
  raise Exception.Create('Você foi desconectado do servidor de negociação.' + #13 +
             'Motivo: ' + SplitData.Values['58']);
  // Limpa instancia da memoria
  SplitData.Free;

  // Se esta sendo exibido a barra com os botoes
  // troca a led para vermelho
  if Assigned(frmMainBar) then
  frmMainBar.ledFix.Status:=False;

end;


procedure TConnectionCenter.SendCmdFix(Cmd: String);
begin
  // Envia apenas se estiver conectado
  if Assigned(ConnFix) then
    if ConnFix.Connected then
    ConnFix.WriteCmd(Cmd);
end;

procedure TConnectionCenter.SendMsgTest;
var MsgTest:String;
begin
  // Gera a mensagem de teste
  MsgTest:=FixLibrary.TestRequest('TEST');
  MsgTest:=MsgTest + FixLibrary.GenerateCheckSum(MsgTest);

  // Envia para o servidor
  SendCmdFix(MsgTest);
end;

procedure TConnectionCenter.StartFix(Username, Password:String);
var MsgLogon:String;
    FixRead:TThrdFixReader;
begin

  // Configura os dados na bibliteca do Fix
  with FixLibrary do
  begin
    FixSession.Username:= Username;
    FixSession.Password:= Password;
    FixSession.SenderCompId:= Username;
  end;

  // Inicia a Thread de leitura dos dados
  FixRead:= TThrdFixReader.Create(ConnFix);
  FixRead.ConnCenter:= Self;
  FixRead.Start;

  // Configura a mensagem de Logon
  MsgLogon:=FixLibrary.Logon(FIXProtocol);
  MsgLogon:=MsgLogon + FixLibrary.GenerateCheckSum(MsgLogon);

  // Envia para o servidor
  SendCmdFix(MsgLogon);
end;

procedure TConnectionCenter.tmrCheckConnFixStatusTimer(Sender: TObject);
begin
  // A cada xx segundos ( definidos no interval do timer )
  // verifica o status das conexões
  if Assigned(ConnFix) then
  WarningConnFixStatus(ConnFix.Connected);
end;

procedure TConnectionCenter.WarningConnFixStatus(Status: Boolean);
begin
  // Se Fix nao esta conectado
  if not Status then
  begin
     // Troca o led do fix na barra
     if Assigned(frmMainBar) then
     frmMainBar.ledFix.Status:=False;

     // Desativa o Timer
     tmrCheckConnFixStatus.Enabled:=False;

     // Exibe mensagem para o cliente
     raise Exception.Create('Você foi desconectado do servidor de negociação.' + #13 +
     'Motivo: ' + ConnFix.Log.GetLastLog);
  end;
end;

end.
