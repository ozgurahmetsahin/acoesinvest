unit UThrdSignal;

interface

uses
  Classes,UMain,UMsgs, UTrade;

type
  TThrdSignal = class(TThread)
  private
    { Private declarations }
    procedure SynchShowBar;
  protected
    procedure Execute; override;
  end;

implementation
  uses UFrmConnection, UFrmTradeCentral, UFrmSheet;
{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TThrdSignal.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TThrdSignal }

{ TODO : Ver questão de usar os forms sheet, verificar se estao assigned }

procedure TThrdSignal.Execute;
var Run:Boolean;
    LogSignal : TLog;
    ReadBuffer:String;
    ReadBufferSplit:TStringList;
    Trades : TTrade;
    CommandString : String;
begin
  {A Variavel Run será uma bandeira de controle de execução desta Thread }
  {Recebe True como padrão para iniciar o Loop}
  Run:=True;

  {Criamos uma instancia nova do Log, para armazenar somente o log desta Thread}
  LogSignal:=TLog.Create;
  {Mudamos o nome do arquivo do log}
  LogSignal.ChangeFileLog(AppPath+'signal.log');

  {Marcamos inicio da Thread}
  LogSignal.AddMsg(Signal_INFO_ThrdStarted);

  {Enviamos dados do usuario}
  FrmConnection.StatusBar1.SimpleText:=Login_INFO_SendLoginMsg;
  CommandString:=MountCommand(Command_Signal_Login,[FrmConnection.EdtUserTrade.Text, FrmConnection.EdtPassTrade.Text]);
  {Se o comando retornar vazio, deu erro ao montar}
  if(CommandString='')then
  begin
    {Desativa flag de execução}
    Run:=False;
    {Marca no log}
    LogSignal.AddMsg(Error_Command_Send);
    LogSignal.WriteLog;

    FrmConnection.StatusBar1.SimpleText:=Error_Command_Send;
  end
  else
  Signal.SendMsg(CommandString);

  {Cria Variavel para analise de dados}
  ReadBufferSplit:=TStringList.Create;

  {Loop de leitura dos dados}
  while Run do
  begin
     {Le dados do buffer do sinal}
     ReadBuffer:=Signal.ReadLine;

     if(ReadBuffer<>'')then
     begin
       LogSignal.AddMsg(ReadBuffer);

       {Separa os dados para analisar}
       SplitData(ReadBuffer,ReadBufferSplit);

       {Mensagem de Login}
       if(ReadBufferSplit[0]=Header_Signal_Login)then
       begin
         {Analisa retorno do login}
         if(ReadBufferSplit[2]=Return_Signal_Login_UserInvalid)then
         begin
           FrmConnection.StatusBar1.SimpleText:=Login_INFO_Signal_UserInvalid;
           {Finaliza a Thread}
           Run:=False;
         end else if(ReadBufferSplit[2]=Return_Signal_Login_OK)then
         begin
           FrmConnection.StatusBar1.SimpleText:=Login_INFO_Signal_UserOK;
           {Exibe a Barra Principal}
           Synchronize(SynchShowBar);
         end else
         begin
           FrmConnection.StatusBar1.SimpleText:=Login_INFO_Signal_UnknownReturn;
           {Finaliza Thread}
           Run:=False;
         end;
       end; // if mensagem login


       if(ReadBufferSplit[0]=Header_Signal_Trade)then
       begin
         {Cria nova instancia do Trade -- Planilha Central}
         Trades:=TTrade.Create(ReadBufferSplit);
         {Realiza Atualizacao -- Planilha Central}
         Trades.UpdateSheetCell(FrmCentral.CentralSheet);

         {Cria nova instancia do Trade -- Planilha Cotações}
         Trades:=TTrade.Create(ReadBufferSplit);
         {Realiza Atualizacao -- Planilha Cotações}
         Trades.UpdateSheetCell(FrmSheet.Sheet);
       end; // if header_trade

     end; // while Run

     {Se tiver vazio escreve o erro que deu}
     if(Signal.LastError<>'') then
     begin
      LogSignal.AddMsg(Signal.LastError);
      // Se o erro for diferente de ReadTimeOut finaliza a Thread
      if(Signal.LastError<>Signal_ERR_ReadTimeOut)And(Signal.LastError<>'')then
      Run:=False;
     end;

     {Limpa dados do buffer e do split}
     ReadBuffer:='';
     ReadBufferSplit.Clear;

     LogSignal.WriteLog;
  end; // while Run

  {Por padrão ao ser finalizada a Thread, finaliza o componente também}
  DestroySignal;

  {Se o DestroySignal causou algum erro na hora de dar o destroy, forçamos nil no componente
  e escrevemos o erro.}
  { TODO : Ver se isso realmente está certo. }
  if(Assigned(Signal))then
  begin
    LogSignal.AddMsg(Signal.LastError);
    Signal:=nil;
  end;


  {Marcamos fim da thread}
  LogSignal.AddMsg(Signal_INFO_ThrdEnded);
  LogSignal.WriteLog;

end;

procedure TThrdSignal.SynchShowBar;
begin
 //FrmConnection.ShowBar;
end;

end.
