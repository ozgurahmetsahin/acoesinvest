unit UThrdDaileonFwRead;

interface

uses
  Windows,Classes,SysUtils,IdException,IdExceptionCore,IdGlobal, Graphics,Sheet,
  Types, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient;

type
  TThrdDaileonFwRead = class(TThread)
  private
    FData: TStrings;
    FConnection: TIdTCPClient;
    FWaitForDatas: Boolean;
    FReadTimeOut:Integer;
    FCriticalSection : TRTLCriticalSection;
    FLastError: String;
    procedure SetWaitForDatas(const Value: Boolean);
    { Private declarations }
  protected
    procedure Execute; override;
    procedure OnConn(Sender: TObject);
    procedure OnDisConn(Sender:TObject);
  public
    constructor Create; reintroduce;
    destructor Destroy; reintroduce;
    function Connect:Boolean;
    procedure WriteLn(AMsg:String);
    function RemoveChar(Text : String;Char: Char):String;
    function FormatTimeTrade(Time: String): String;
    function GetData:String;
    procedure SetDataAsRead;
    procedure SetAllDataAsRead;
  published
    property Data:TStrings read FData;
    property Connection:TIdTCPClient read FConnection;
    property WaitForDatas:Boolean read FWaitForDatas write SetWaitForDatas; // Se True, ativa o ReadTimeOut do socket.
    property LastError:String read FLastError;
  end;

  var SignalThread:TThrdDaileonFwRead;

implementation

uses UFrmMainLine;

{ TThrdDaileonFwRead }

{Fun��o que executa a conex�o com o servidor.
 Essa fun��o executa a fun��o Connection.Connect, por�m,
 � feito o tratamento de erro de conex�o, retornando True para
 conex�o bem-sucedida, ou False para qualquer tipo de erro retornado.}
function TThrdDaileonFwRead.Connect: Boolean;
var R:Boolean;
begin
  {Retorno padr�o de conexao}
  R:=False;

  {Tentativa de conex�o}
  try
    FConnection.Connect;
  finally
    {Resultado da tentiva}
    R:=FConnection.Connected;
  end;

  {Retorna resultado}
  Result:=R;
end;

constructor TThrdDaileonFwRead.Create;
begin
  {Cria instancia para os dados recebidos}
  FData:=TStringList.Create;

  {Cria instancia do socket para conexao}
  FConnection:=TIdTCPClient.Create(nil);

  {Seta valor padr�o para WaitForData}
  SetWaitForDatas(False);

  {Cria controle de se��o critica}
  InitializeCriticalSection(FCriticalSection);

  FConnection.OnConnected:=OnConn;
  FConnection.OnDisconnected:=OnDisConn;

  {Cria thread em modo suspendido.}
  inherited Create(True);
end;

destructor TThrdDaileonFwRead.Destroy;
begin
  DeleteCriticalSection(FCriticalSection);
end;

procedure TThrdDaileonFwRead.Execute;
var Read:String;
begin
  {Loop de leitura at� Thread ser Terminada}
  while not Terminated do
  begin

    {Limpa qualquer dado que esteja em Read}
    Read:='';

    {Efetua tentativa de leitura}
    try
      Read:=RemoveChar(FConnection.IOHandler.ReadLn(),'!');
      {Se Read n�o esta vazio, insere na lista de dados recebidos}
      if Read<>'' then
      begin
        {Inicia uma Se��o Critica}
        EnterCriticalSection(FCriticalSection);
        {Adiciona o dado}
        FData.Add(Read);
        {Deixa a se��o critica}
        LeaveCriticalSection(FCriticalSection);
      end;
    except
      {Tempo de leitura excedido}
      on E: EIdReadTimeout do
      begin
        {Apenas seta o erro}
        FLastError:=E.Message;
      end;
      {Conex�o finalizada inesperadamente, ou finalizada incorretamente}
      on E: EIdConnClosedGracefully do
      begin
        {Seta o Erro}
        FLastError:=E.Message;
      end;
      {Outra exce��o}
      on E: EIdException do
      begin
        {seta o Erro}
        FLastError:=E.Message;
      end;
    end;

    {Se foi mandado terminar, sai do loop}
    if Terminated then
    break;
  end;

  {Tenta desconectar o socket}
  try
    FConnection.Disconnect;
  except on E: EIdException do
    FLastError:=E.Message;
  end;
end;

procedure TThrdDaileonFwRead.SetAllDataAsRead;
begin
  EnterCriticalSection(FCriticalSection);
  Data.Clear;
  LeaveCriticalSection(FCriticalSection);
end;

procedure TThrdDaileonFwRead.SetDataAsRead;
begin
  EnterCriticalSection(FCriticalSection);
  Data.Delete(0);
  LeaveCriticalSection(FCriticalSection);
end;

procedure TThrdDaileonFwRead.SetWaitForDatas(const Value: Boolean);
begin
  {Se valor False, ativa o ReadTimeOut do socket}
  if not Value then
  begin
    {Ativa o ReadTimeOut}
    FConnection.ReadTimeout:=FReadTimeOut;
  end
  else
  begin
    {Pega o valor atual do timeout caso volte a ser solicitado}
    FReadTimeOut:=FConnection.ReadTimeout;
    {Desativa o TimeOut}
    FConnection.ReadTimeout:=-1;
  end;
  {Seta valor da propriedade}
  FWaitForDatas := Value;
end;

procedure TThrdDaileonFwRead.WriteLn(AMsg: String);
begin
  if FConnection.Connected then
  FConnection.IOHandler.WriteLn(AMsg);
end;

function TThrdDaileonFwRead.RemoveChar(Text : String;Char: Char):String;
var
  I: Integer;
  R : String;
begin
  R:='';
  for I := 1 to Length(Text)  do
  begin
    if(Copy(Text,I,1) <> Char) then
    begin
      R:=R + Copy(Text,I,1);
    end;
  end;

  Result:=R;
end;

function TThrdDaileonFwRead.FormatTimeTrade(Time: String): String;
var r: String;
begin
 try
   r:=Copy(Time,1,2);
   r:=r+':';
   r:= r + Copy(Time,3,2);
   Result:=r;
 except
   Result:='00:00';
 end;
end;

function TThrdDaileonFwRead.GetData: String;
begin
//  EnterCriticalSection(FCriticalSection);
  Result:=Data.Strings[0];
//  LeaveCriticalSection(FCriticalSection);
end;

procedure TThrdDaileonFwRead.OnConn(Sender: TObject);
begin
  FrmMainLine.Image16.Visible:=False;
  FrmMainLine.Image17.Visible:=True;
end;

procedure TThrdDaileonFwRead.OnDisConn(Sender: TObject);
begin
  FrmMainLine.Image17.Visible:=False;
  FrmMainLine.Image16.Visible:=True;
end;

end.
