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
  public
    constructor Create; reintroduce;
    destructor Destroy; reintroduce;
    function Connect:Boolean;
    procedure WriteLn(AMsg:String);
    function RemoveChar(Text : String;Char: Char):String;
    function FormatTimeTrade(Time: String): String;
  published
    property Data:TStrings read FData;
    property Connection:TIdTCPClient read FConnection;
    property WaitForDatas:Boolean read FWaitForDatas write SetWaitForDatas; // Se True, ativa o ReadTimeOut do socket.
    property LastError:String read FLastError;
  end;

  var SignalThread:TThrdDaileonFwRead;

implementation

{ TThrdDaileonFwRead }

{Função que executa a conexão com o servidor.
 Essa função executa a função Connection.Connect, porém,
 é feito o tratamento de erro de conexão, retornando True para
 conexão bem-sucedida, ou False para qualquer tipo de erro retornado.}
function TThrdDaileonFwRead.Connect: Boolean;
var R:Boolean;
begin
  {Retorno padrão de conexao}
  R:=False;

  {Tentativa de conexão}
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

  {Seta valor padrão para WaitForData}
  SetWaitForDatas(False);

  {Cria controle de seção critica}
  InitializeCriticalSection(FCriticalSection);

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
  {Loop de leitura até Thread ser Terminada}
  while not Terminated do
  begin

    {Limpa qualquer dado que esteja em Read}
    Read:='';

    {Efetua tentativa de leitura}
    try
      Read:=RemoveChar(FConnection.IOHandler.ReadLn(),'!');
      {Se Read não esta vazio, insere na lista de dados recebidos}
      if Read<>'' then
      begin
        {Inicia uma Seção Critica}
        EnterCriticalSection(FCriticalSection);
        {Adiciona o dado}
        FData.Add(Read);
        {Deixa a seção critica}
        LeaveCriticalSection(FCriticalSection);
      end;
    except
      {Tempo de leitura excedido}
      on E: EIdReadTimeout do
      begin
        {Apenas seta o erro}
        FLastError:=E.Message;
      end;
      {Conexão finalizada inesperadamente, ou finalizada incorretamente}
      on E: EIdConnClosedGracefully do
      begin
        {Seta o Erro}
        FLastError:=E.Message;
      end;
      {Outra exceção}
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

end.
