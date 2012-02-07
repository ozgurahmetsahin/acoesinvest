{*************************************************
*                                                *
*         Classe Responsavel por manipular       *
*             as conexões do sistema.            *
*                                                *
**************************************************}
unit DMAConnection;

interface

uses Classes, Windows, SysUtils, IdTcpClient, IdBaseComponent, IdComponent,
IdException,IdExceptionCore, IdGlobal;

procedure SplitColumns(const AData: string; AStrings: TStrings; const ADelim: string = ' ');

type TConnectionData = class(TObject)
private
  // Instancia da lista de dados armazenados
  FStoreData : TStringList;
  // Mutex para insercao e leitura dos dados
  FMutex : TRTLCriticalSection;

  // Controlador de conteudo
  FCount : Integer;

  // Controladores da sessão critica
  procedure LockMutex;
  procedure UnlockMutex;
public
  constructor Create;
  destructor Destroy; override;
  procedure AddData(AData: String);
  function GetData:String;
  function Next: Boolean;
end;

type
TConnectionListener = class;
TLogLevel = (lgOnlyErrors,lgAll);
TReadType = (rtAnsi, rtDirect, rtFix);

TLog = class(TStringList)
public
  function GetLastLog:String;
end;

TConnection = class(TPersistent)
private
  // Socket da conexao
  FSocket : TIdTCPClient;
  // Flag de conexao
  FConnected: Boolean;
  // Dados recebidos
  FData : TConnectionData;
  // Thread de leitura
  FListener : TConnectionListener;
  // Logs
  FLog: TLog;
  // Level de escrito do log
  FLogLevel: TLogLevel;
  // Tipo de leitura
  FReadType: TReadType;
  procedure AddLog(AMessage:String; LogLevel:TLogLevel);
public
  constructor Create;
  destructor Destroy; override;
  function Connect(AHost:String; APort:Integer):Boolean;
  procedure Disconnect;
  function ReadBuffer: Boolean;overload;
  function ReadBuffer(ATerminator:Char):Boolean;overload;
  function ReadBufferFix:Boolean;
  procedure WriteCmd(ACmd:String);
  procedure WriteDirect(ACmd:TBytes);
published
  property Connected:Boolean read FConnected;
  property Data:TConnectionData read FData;
  property Log:TLog read FLog;
  property LogLevel: TLogLevel read FLogLevel write FLogLevel default lgOnlyErrors;
  property ReadType: TReadType read FReadType write FReadType default rtAnsi;
end;

TConnectionListener = class(TThread)
private
  // Conexao a ser escutada
  FConn : TConnection;
  // Flag de execucao
  FRun: Boolean;
protected
  procedure Execute; override;
public
  constructor Create(AConn:TConnection);
  procedure Kill;
end;

TConnectionReader = class(TThread)
protected
  FConn:TConnection;
public
  constructor Create(AConn:TConnection);
end;

implementation

procedure SplitColumns(const AData: string; AStrings: TStrings; const ADelim: string);
var
  i: Integer;
  LData: string;
  LDelim: Integer; //delim len
  LLeft: string;
  LLastPos: Integer;
  LLeadingSpaceCnt: Integer;
Begin
  Assert(Assigned(AStrings));
  AStrings.Clear;
  LDelim := Length(ADelim);
  LLastPos := 1;
  LData := Trim(AData);

  if LData = '' then begin //if WhiteStr
    Exit;
  end;

  LLeadingSpaceCnt := 0;
  while AData[LLeadingSpaceCnt + 1] <= #32 do begin
    Inc(LLeadingSpaceCnt);
  end;

  i := Pos(ADelim, LData);
  while I > 0 do begin
    LLeft := Copy(LData, LLastPos, I - LLastPos); //'abc d' len:=i(=4)-1    {Do not Localize}
    if LLeft > '' then begin    {Do not Localize}
      AStrings.AddObject(Trim(LLeft), TObject(LLastPos + LLeadingSpaceCnt));
    end;
    LLastPos := I + LDelim; //first char after Delim
    i := PosIdx(ADelim, LData, LLastPos);
  end;//while found
  if LLastPos <= Length(LData) then begin
    AStrings.AddObject(Trim(Copy(LData, LLastPos, MaxInt)), TObject(LLastPos + LLeadingSpaceCnt));
  end;
end;

{ TConnection }

procedure TConnection.AddLog(AMessage: String; LogLevel: TLogLevel);
begin
  if(LogLevel = FLogLevel) or (FLogLevel = lgAll) then
  FLog.Add(FormatDateTime('DD/MM - HH:nn:SS - ',Now) + AMessage);
end;

function TConnection.Connect(AHost: String; APort: Integer): Boolean;
begin

  // Configura o Host e a Porta no Socket
  with FSocket do
  begin
    Host:= AHost;
    Port:= APort;
  end;

  // Tenta conectar
  try
    // Log
    AddLog('Trying to connect to ' + AHost + ':' + IntToStr(APort),lgAll);

    try
      FSocket.Connect;
      // Log
      AddLog('Connected to ' + AHost + ':' + IntToStr(APort),lgAll);
    except
      on E: Exception do
      begin
        // Log
        AddLog('Error on connect. Message:' + E.Message, lgOnlyErrors);
      end;
    end;

    // Se conectado, inicia thread de leitura
    FListener:=TConnectionListener.Create(Self);
    FListener.Start;
  finally
    // Coloca o resultado da conexao
    Result:=FSocket.Connected;
    // Seta resultado na flag
    FConnected:=FSocket.Connected;
  end;
end;

constructor TConnection.Create;
begin
  // Limpa qualquer existencia do socket em memoria
  if Assigned(FSocket) then
  FreeAndNil(FSocket);

  // Cria nova instancia do socket
  FSocket:=TIdTCPClient.Create(nil);

  // Seta flag de conexao como false
  FConnected:=False;

  // Cria instancia da lista de dados
  FData:= TConnectionData.Create;

  // Seta meto padrao de leitura
  FReadType:= rtAnsi;

  // Configura propriedades inicias do socket
  with FSocket do
  begin
    ConnectTimeout:= 5000;
    ReadTimeout:= 45000;
  end;

  // Cria e configura instancia do log
  FLog:=TLog.Create;
  FLogLevel:=lgOnlyErrors;


  // Log
  AddLog('Object Connection created.',lgAll);
end;

destructor TConnection.Destroy;
begin
  // Desconecta se estiver conectado
  if FConnected then
  Disconnect;

  // Limpa instancias usadas na memoria
  FData.Free;
  FLog.Free;

  inherited Destroy;
end;

procedure TConnection.Disconnect;
begin
  // Log
  AddLog('Disconnecting.',lgAll);
  // Mata thread de leitura
  if Assigned(FListener) then
  FListener.Kill;

  // Desconecta o Socket
  if Assigned(FSocket) then
  FSocket.Disconnect;
  // Forca a Flag FConnected para False
  // ocorre as vezes de que FSocket.Connected fica como
  // true mesmo quando esta desconectado.
  // Assim forcando a flag ficar False, corrige tal problema.
  FConnected:=False;
end;

function TConnection.ReadBuffer(ATerminator: Char): Boolean;
var Buffer:String;
    ReadChar:String;
    ReadBroker:String;
begin
  Result:= False;
  try
    // Log
    AddLog('Reading Buffer.',lgAll);

    // Ajusta tamanho do buffer
    FSocket.IOHandler.MaxLineLength:=900000;

    ReadChar:='';
    ReadBroker:='';
    while True do
    begin
      ReadChar:=FSocket.IOHandler.ReadChar;
      if (ReadChar <> #03) and (ReadChar<>#0) and (ReadChar<>#10) and (ReadChar<>#13) then
      ReadBroker:=ReadBroker+ReadChar
      else if (ReadChar=#01) then
           break;
    end;
    Buffer:= ReadBroker;
//    Buffer:= FSocket.IOHandler.ReadLn(ATerminator);
    if Buffer <> '' then
    begin
      // Log
      AddLog('Adding data: ' + Buffer,lgAll);
      FData.AddData (Buffer);
      Result:=True;
    end;
  except
    on E: Exception do
    begin
      FConnected:=False;
      Result:=False;
      // Log
      AddLog('Error on ReadBuffer.Message:' + E.Message,lgOnlyErrors);
    end;
  end;
end;

function TConnection.ReadBufferFix: Boolean;
var FixRead:String;
    MsgFix:String;
begin
  Result:=False;

  try
    repeat
      FixRead:= FSocket.IOHandler.ReadLn(#01);
      if FixRead <> '' then
      if MsgFix <> '' then MsgFix:= MsgFix + #01+ FixRead else MsgFix:= FixRead;
    until (Copy(FixRead,1,3) = '10=');

    if MsgFix <> '' then
    begin
      // Log
      AddLog('Adding data: ' + MsgFix,lgAll);
      FData.AddData (MsgFix);
      Result:=True;
    end;

  except
   on E:Exception do
   begin
     FConnected:=False;
     Result:=False;
     // Log
     AddLog('Error on ReadBufferFix.Message:' + E.Message,lgOnlyErrors);
   end;
  end;
end;

function TConnection.ReadBuffer: Boolean;
var Buffer:String;
begin
  Result:= False;
  try
    // Log
    AddLog('Reading Buffer.',lgAll);
    Buffer:= FSocket.IOHandler.ReadLn;
    if Buffer <> '' then
    begin
      // Log
      AddLog('Adding data: ' + Buffer,lgAll);
      FData.AddData (Buffer);
      Result:=True;
    end;
  except
    on E: Exception do
    begin
      FConnected:=False;
      Result:=False;
      // Log
      AddLog('Error on ReadBuffer.Message:' + E.Message,lgOnlyErrors);
    end;
  end;
end;

procedure TConnection.WriteCmd(ACmd: String);
begin
  { TODO : Verificar se esta conectado antes de enviar }
  // Log
  AddLog('Sending Command:' + ACmd,lgAll);
  // Envia comando
  FSocket.IOHandler.WriteLn(ACmd);
end;

procedure TConnection.WriteDirect(ACmd: TBytes);
begin
  // Log
  AddLog('Sending Direct Command.',lgAll);
  // Envia comando
  FSocket.IOHandler.WriteDirect(ACmd);
end;

{ TConnectionListener }

constructor TConnectionListener.Create(AConn: TConnection);
begin
  // Seta a conexao a ser escutada
  FConn:=AConn;

  // Ativa flag de execucao
  FRun:=True;

  // Cria uma thread em modo suspenso
  inherited Create(True);
end;

procedure TConnectionListener.Execute;
begin
  while FRun do
  begin
    case FConn.ReadType of
      rtAnsi:if not FConn.ReadBuffer then
             Kill;
      rtDirect:if not FConn.ReadBuffer(#3) then
             Kill;
      rtFix:if not FConn.ReadBufferFix then
             Kill;
    end;

  end;
end;

procedure TConnectionListener.Kill;
begin
  FRun:=False;
end;

{ TConnectionData }

procedure TConnectionData.AddData(AData: String);
begin
  // Trava uma sessao critica
  LockMutex;
  // Adiciona o dado a lista
  FStoreData.Add(AData);
  // Incrementa conteudo
  Inc(FCount);
  // Libera a sessao critica
  UnlockMutex;
end;

constructor TConnectionData.Create;
begin
  // Cria Instancia do objeto que armazenara a lista de dados
  FStoreData:=TStringList.Create;
  // Inicializa uma sessão critica - Mutex
  InitializeCriticalSection(FMutex);

  // Inicializa contador
  FCount:=0;
end;

destructor TConnectionData.Destroy;
begin
  DeleteCriticalSection(FMutex);
  FStoreData.Free;
end;

function TConnectionData.GetData: String;
begin
  // Retorna o dado
  if (Next) then
  begin
    try
      // Trava uma sessao critica
      LockMutex;
      Result:= FStoreData[0];
      FStoreData.Delete(0);
      //Decrementa conteudo
      Dec(FCount);
      // Libera sessao critica
      UnlockMutex; 
    except 
      on E: Exception do
      begin
        UnlockMutex;
        Result:='';
      end;
    end;
  end
  else
  Result:='';
end;

procedure TConnectionData.LockMutex;
begin
  EnterCriticalSection(FMutex);
end;

function TConnectionData.Next: Boolean;
begin
  // Por padrao retorna false
  Result:=False;

  // Verifica se existe dados
  if FCount>0 then
  Result:=True;
end;

procedure TConnectionData.UnlockMutex;
begin
  LeaveCriticalSection(FMutex);
end;

{ TLog }

function TLog.GetLastLog: String;
begin
  Result:= Strings[Count-1];
end;

{ TConnectionReader }

constructor TConnectionReader.Create(AConn: TConnection);
begin
  FConn:=AConn;
  inherited Create(True);
end;

end.
