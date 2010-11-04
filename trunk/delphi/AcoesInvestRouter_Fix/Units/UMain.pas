{*******************************************************}
{                                                       }
{              Ações Invest Libray Main                 }
{                                                       }
{      Biblioteca que contêm as funções e componentes   }
{         que serão utilizados por todo o projeto       }
{                                                       }
{*******************************************************}

{*******************************************************}
{               Unidade Principal do Projeto            }
{*******************************************************}
unit UMain;

interface

  {Uses da biblioteca}
  uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
       IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdException, IdExceptionCore,
       IdStack, IdGlobal;


  {Exceção persnalisada para finalizacao da Thread Signal}
  type EThrdSignalEnded = class(Exception);

  {Componente TSignal: Utilizado para receber e enviar dados.}
  { TODO : Ver se tem algum lugar fazendo a chamada direta à variavel Signal
    sem fazer a verificação de Assigned. }
  { TODO : Ver se tem alguma varivel sem fazer o Free. }
  type TSignal = class(TIdTCPClient)
    private
    FRequestShutDown:Boolean;
    {Métodos públicos}
    public
      {Variavel Global do componente}
      {Contém o Ultimo a mensagem do ultimo erro}
      LastError:String;
      {Contém a ultima informacao de uma acao}
      LastInfo:String;
      {Função de leitura de linha do buffer}
      function ReadLine():String;
      {Limpa LastError}
      procedure ClearLastError;
      {Limpa LastInfo}
      procedure ClearLastInfo;
      {EXPERIMENTAL:Solicita que seja encerrada a conexao}
      procedure RequestShutDown;
      {Envia dados ao servidor}
      procedure SendMsg(Msg:String);
  end;

  {Componente TLog: Utilizado para controlar os logs do sistema.}
  type TLog = class(TStringList)
    private
     const LogFileName:String = 'systemlog.log';
    public
     LogFile:String;
     constructor Create;
     procedure AddMsg(Msg:String);
     procedure WriteLog;
     procedure ChangeFileLog(FileName:String);
  end;

{*******************************************************}
{                    Métodos Globais                    }
{*******************************************************}
  procedure CreateSignal();
  procedure DestroySignal();
  procedure ConnectSignal();
  procedure SplitData(Data:String; SData:TStringList); overload;
  procedure SplitData(Data:String; SData:TStringList; Delimiter:String); overload;

  function AppPath:String;

  procedure CreateLog();

  function MountCommand(Command:String; const Args: array of const):String;
{*******************************************************}
{                  Variaveis Globais                    }
{*******************************************************}
  var Signal : TSignal;
      Log : TLog;

implementation
   uses UMsgs;
  {Cria Instancial do componente Signal}
  procedure CreateSignal();
  begin
    Signal:=TSignal.Create(nil);
    Signal.Host:='localhost';
    Signal.Port:=81;
    Signal.ConnectTimeout:=5000;
    Signal.ReadTimeout:=300;
  end;

  {Limpa Instancia do componente Signal}
  procedure DestroySignal();
  begin

    try
      if(Assigned(Signal))then
      begin
      {Limpamos o LastError para nao haver confusao}
       Signal.ClearLastError;
       if Signal.Connected then
       Signal.Disconnect;
      end;
    except
     on E:EIdException do
     Signal.LastError:=Signal_ERR_Exception;
    end;
    FreeAndNil(Signal);
  end;

  {Realiza conexao com o servidor do componente Signal}
  procedure ConnectSignal();
  begin
    {Limpa ultimo erro para nao haver confusao}
    Signal.ClearLastError;
    Signal.ClearLastInfo;
    {Tentamos conectar}
    try
      Signal.Connect;
      {Chegando aqui, conectou}
      Signal.LastInfo:=Signal_INFO_Connected;
      {Limpa LastError}
      Signal.LastError:=Signal_ERR_Clear;
    except
      {Exceção de ConnectTimeOut}
      on E:EIdConnectTimeout do
       Signal.LastError:=Signal_ERR_ConnectTimeOut;
      {Exceção de AlreadyConnected}
      on E:EIdAlreadyConnected do
       Signal.LastError:=Signal_ERR_AlredyConnected;
      {Exceção de Connect}
      on E:EIdConnectException do
       Signal.LastError:=Signal_ERR_ConnectException;
      {Exceção SocketError}
      on E:EIdSocketError do
       Signal.LastError:= Signal_ERR_SocketError;
      {Exceção geral}
      on E: Exception do
       Signal.LastError:=Signal_ERR_Exception;
    end;
  end;

  {Retorna o caminho onde o aplicativo esta instalado}
  function AppPath:String;
  begin
    Result:=ExtractFilePath(ParamStr(0));
  end;

  {Cria Instancia do Log}
  procedure CreateLog();
  begin
    Log:=TLog.Create;
  end;

  {Destroi instanica do Log}
  procedure DestroyLog();
  begin
    FreeAndNil(Log);
  end;

  {Monta um comando}
  function MountCommand(Command:String; const Args: array of const):String;
  begin
    try
      { TODO : Resolver Bug de array }
      Result:=Format(Command,Args);
    except
      on E: EStringListError do
      begin
        Log.AddMsg(Error_MountCommand_StringList);
        Log.WriteLog;
        Result:='';
      end;
      on E:Exception do
      begin
        Log.AddMsg(Error_MountCommand_Exception);
        Log.WriteLog;
        Result:='';
      end;
    end;
  end;

  procedure SplitData(Data:String; SData:TStringList); overload;
  begin
    {Remove a ! se existir}
    if(Copy(Data,Length(Data),1)='!')then
    Data:=Copy(Data,1,Length(Data)-1);
    SplitColumns(Data,SData,':');
  end;
  procedure SplitData(Data:String; SData:TStringList; Delimiter:String); overload;
  begin
    SplitColumns(Data,SData,Delimiter);
  end;

{ TSignal }

procedure TSignal.ClearLastError;
begin
 {Limpa LastError}
 LastError:=Signal_ERR_Clear;
end;

procedure TSignal.ClearLastInfo;
begin
  {Limpa LastInfo}
  LastInfo:=Signal_ERR_Clear;
end;

function TSignal.ReadLine: String;
var ReadData:String;
begin
  {Limpa o ultimo erro, para nao haver confusao}
  ClearLastError;
  {Tenta ler dados}
  try
    if(Assigned(Signal))then
    begin
      {Se não for feito RequestShutDown}
      if(not FRequestShutDown)then
      begin
        ReadData:=IOHandler.ReadLn(#10);
        Result:=ReadData;
      end
      else
      begin
        LastError:=Signal_ERR_RequestShutDown;
        Result:='';
      end;
    end
    else
    Result:='';
  except
   on E:EIdReadTimeout do
   LastError:=Signal_ERR_ReadTimeOut;
   on E:EIdClosedSocket do
   LastError:=Signal_ERR_ClosedSocket;
   on E:Exception do
   LastError:=Signal_ERR_Exception;
  end;
end;

procedure TSignal.RequestShutDown;
begin
 FRequestShutDown:=True;
end;

procedure TSignal.SendMsg(Msg: String);
begin
 { TODO : Ver se esse assigned esta certo. }
 if Assigned(Self) then
 begin
  IOHandler.WriteLn(Msg);
  IOHandler.WriteBufferFlush;
 end;
end;

{ TLog }

procedure TLog.addMsg(Msg: String);
var TimeLog:TTime;
begin
 TimeLog:=Now;
 Add(FormatDateTime('dd/mm-HH:MM',TimeLog) + ':'+ Msg);
end;

procedure TLog.ChangeFileLog(FileName: String);
begin
 LogFile:=FileName;
end;

constructor TLog.Create;
begin
  inherited Create;
  Add('Log Iniciado.');
  LogFile:=AppPath+LogFileName;
end;

procedure TLog.WriteLog;
var DataTemp:TStringList;
begin
  {Salva o Log em um arquivo de Texto}
  DataTemp:=TStringList.Create;
  if(FileExists(LogFile))then
  DataTemp.LoadFromFile(LogFile);
  DataTemp.AddStrings(Self);
  DataTemp.SaveToFile(LogFile);
  DataTemp.Free;
  Clear;
end;

end.
