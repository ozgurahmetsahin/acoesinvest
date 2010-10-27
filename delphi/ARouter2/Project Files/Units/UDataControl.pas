{*******************************************************}
{                                                       }
{                Controlador de Conexão                 }
{                e Manipulador de Dados                 }
{*******************************************************}

unit UDataControl;

interface

uses Windows, SysUtils, IdTCPClient, IdBaseComponent, IdException, IdExceptionCore, IdTelnet,
Classes;
{$M+}
type

  TConnection = class;

  TConnectionThread = class(TThread)
    protected
      FConn : TConnection;
      procedure Execute;override;
    public
      constructor Create(AConn : TConnection); reintroduce;
      property Connection:TConnection read FConn;
  end;

  TConnection = class(TObject)
  private
    FConnection: TIdTCPClient;{Socket de Conexão}
    FDataRecv: TStrings; {Lista para armazenamento do buffer de dados recebidos}
    FConnectTimeout: Integer; {Timeout para conexão}
    FReadTimeOut: Integer; {Timeout para leitura}
    FHost: String;
    FPort: Integer;
    FThreadConnection: TConnectionThread;
    procedure SetConnectTimeout(const Value: Integer);
    procedure SetReadTimeout(const Value: Integer);
  protected
    procedure ReadDataBuffer;
  public
    constructor Create;
    function Connect : Boolean; overload;
    function Connect(Host:String; Port:Integer):Boolean;overload;
    procedure Disconnect;
    function GetAllDataRecv:TStrings;
    function Connected:Boolean;
    procedure SendMsg(Msg:String);
  published
    property ConnectTimeOut:Integer read FConnectTimeout write SetConnectTimeout;
    property ReadTimeOut:Integer read FReadTimeOut write SetReadTimeout;
    property Host:String read FHost write FHost;
    property Port:Integer read FPort write FPort;
    property ThreadConnection: TConnectionThread read FThreadConnection write FThreadConnection;
end;
{$M-}

implementation

  uses UConsts;

{ TConnection }

{Inicia uma nova conexão}
function TConnection.Connect: Boolean;
begin
  {Configura os valores no socket}
  with FConnection do
  begin
    Host:=FHost;
    Port:=FPort;
    ConnectTimeout:=FConnectTimeout;
    ReadTimeout:=FReadTimeOut;
  end;

  {Tenta conectar retornando resultado}
  try
    FConnection.Connect;

    {Inicia Thread de leitura de dados}
    FThreadConnection:=TConnectionThread.Create(Self);
  finally
    Result:=FConnection.Connected;
  end;

end;

{Inicia uma nova conexão}
function TConnection.Connect(Host: String; Port: Integer): Boolean;
begin
  {Pré-configura os valores}
  FHost:=Host;
  FPort:=Port;
  {Inicia a conexao}
  Result:=Connect;
end;

{Retorna Status da conexão}
function TConnection.Connected: Boolean;
begin
  if Assigned(FConnection) then
  Result:=FConnection.Connected
  else Result:=False;
end;

constructor TConnection.Create;
begin
  inherited Create;
  {Cria instancia do Socket}
  FConnection:=TIdTCPClient.Create(nil);

  {Cria instancia da lista de dados}
  FDataRecv:=TStringList.Create;

  {Configura valores padrões}
  SetConnectTimeout(0);
  SetReadTimeout(0);
  FHost:='';
  FPort:=0;
end;

{Desconecta socket}
procedure TConnection.Disconnect;
begin
  {Força finalização da Thread}
  if Assigned(FThreadConnection) then
  FThreadConnection.Terminate;

  if Assigned(FConnection) then
  FConnection.Disconnect;
end;

{Obtêm todos os dados recebidos pelo buffer}
function TConnection.GetAllDataRecv: TStrings;
begin
 Result:=FDataRecv;
end;

{Lê os dados do socket}
procedure TConnection.ReadDataBuffer;
var Recv:String;
begin
  {Lê dados do buffer e adiciona na lista}
  Recv:=FConnection.IOHandler.ReadLn;
  if Recv<>'' then
  FDataRecv.Add(Recv);
end;

{Envia uma mensagem ao servidor}
procedure TConnection.SendMsg(Msg: String);
begin
  if Connected then
  FConnection.IOHandler.WriteLn(Msg);
end;

procedure TConnection.SetConnectTimeout(const Value: Integer);
begin
  FConnectTimeout := Value;
end;

procedure TConnection.SetReadTimeout(const Value: Integer);
begin
  FReadTimeOut := Value;
end;

{ TConnectionThread }

constructor TConnectionThread.Create(AConn: TConnection);
begin
 FConn:=AConn;
 inherited Create(False);
end;

procedure TConnectionThread.Execute;
begin
  {Lê dados do socket}
  while FConn.FConnection.Connected do
  begin
    with FConn do
    begin
      if not FConnection.IOHandler.InputBufferIsEmpty then
      Synchronize(FConn.ReadDataBuffer);
    end;

    {Se solicitado, finaliza thread}
    if Terminated then
    Break;
  end;
end;

end.
