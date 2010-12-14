unit UFrmMainTreeView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ImgList, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, StdCtrls, ExtCtrls,UFrmMiniBook,TlHelp32,PsAPI,ShellApi,
  URouterLibrary,IdGlobal,Sheet, AppEvnts,IdStack;

type
  TFrmMainTreeView = class(TForm)
    TreeView1: TTreeView;
    DaileonFW: TIdTCPClient;
    Broker: TIdTCPClient;
    Panel1: TPanel;
    Image1: TImage;
    Fix: TIdTCPClient;
    ApplicationEvents1: TApplicationEvents;
    RouterLibrary1: TRouterLibrary;
    Memo1: TMemo;
    procedure TreeView1DblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure BrokerConnected(Sender: TObject);
    procedure RouterLibrary1TestRequest(Sender: TObject; Msg: string);
    procedure RouterLibrary1ExecutionReport(Sender: TObject; MsgType: TMsgType;
      Msg: string);
    procedure RouterLibrary1CancelEditReject(Sender: TObject; MsgType: TMsgType;
      Msg: string);
    procedure RouterLibrary1Logout(Sender: TObject; MsgType: TMsgType;
      Msg: string);
    procedure RouterLibrary1SecurityListReport(Sender: TObject; Msg: string);
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
    procedure BrokerDisconnected(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    MsgErr:String;

    //Codigo de Mercado para o Broker
    MarketID:String;
    //Codigo Shadown dentro do broker ( tipo id dentro do banco )
    ShadownCode : String;

    //Label do form q envio a ordem
    LabelReturn : TLabel;

    //Nome do cliente
    ClientName: String;

    // Flag das Threads
    ThrdSignal, ThrdBroker:Boolean;

    //Formulario que solicitou o intraday
    //GetFrmChart : TFrmChart;

    FrmsBooks: array[1..20] of TFrmMiniBook;

    //Host padrão de cotacao
    const DefaultTradeHost : String = 'dmatrader.diferencial.com.br';
    //Host padrão de negociacao
    const DefaultRouterHost : String = 'broker.acoesinvest.com.br';

    // Versao do sistema
    const VersionID:String = '1.3';

    procedure ShowMsgErr;
    procedure DelUnknowSymbol(Symbol : String);
    function StrToBytes(AString: String): TBytes;
    function ChangeDecimalSeparator(Value : String;Decimal : String;DecimalChange : String): String;
    function TerminateProcesso(sFile: string): Bool;
    procedure RecallBooks;
    procedure NewVersion(Url:String);

    procedure AddLogMsg( Msg : String);
    procedure SaveLog;
  end;

var
  FrmMainTreeView: TFrmMainTreeView;

implementation

uses UFrmTrade, UFrmAbstractSymbol, UFrmConnection,UFrmTradeCentral,
 UFrmBrokerBuy, UFrmBrokerSell, UFrmHistoryOrders,
  UFrmStartStop, UFrmBrokerageNote, UFrmWebBrowser, UFrmConfig, UFrmMainLine,
  UThrdDaileonFwRead, UFrmTradingSystem;

{$R *.dfm}

function TFrmMainTreeView.TerminateProcesso(sFile: string): Bool;
var
  verSystem: TOSVersionInfo;
  hdlSnap,hdlProcess: THandle;
  bPath,bLoop: Bool;
  peEntry: TProcessEntry32;
  arrPid: array [0..1023] of DWord;
  iC: DWord;
  k,iCount: Integer;
  arrModul: array [0..299] of Char;
  hdlModul: HMODULE;
begin
  result:=false;
  if ExtractFileName(sFile)=sFile then
    bPath:=false
  else
  bPath:=true;
  verSystem.dwOSVersionInfoSize:=SizeOf(TOSVersionInfo);
  GetVersionEx(verSystem);
  if verSystem.dwPlatformId=VER_PLATFORM_WIN32_WINDOWS then
  begin
    hdlSnap:=CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0);
    peEntry.dwSize:=Sizeof(peEntry);
    bLoop:=Process32First(hdlSnap,peEntry);
    while integer(bLoop)<>0 do
    begin
      if bPath then
      begin
        if CompareText(peEntry.szExeFile,sFile)=0 then
        begin
          TerminateProcess(OpenProcess(PROCESS_TERMINATE,false,peEntry.th32ProcessID) ,0);
          result:=true;
        end;
      end
      else
      begin
        if CompareText(ExtractFileName(peEntry.szExeFile),sFile)=0 then
        begin
          TerminateProcess(OpenProcess(PROCESS_TERMINATE,false,peEntry.th32ProcessID) ,0);
          result:=true;
        end;
      end;
      bLoop:=Process32Next(hdlSnap,peEntry);
    end;
    CloseHandle(hdlSnap);
  end
  else
    if verSystem.dwPlatformId=VER_PLATFORM_WIN32_NT then
    begin
      EnumProcesses(@arrPid,SizeOf(arrPid),iC);
      iCount:=iC div SizeOf(DWORD);
      for k:=0 to Pred(iCount) do
      begin
        hdlProcess:=OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ,false,arrPid [k]);
        if (hdlProcess<>0) then
        begin
          EnumProcessModules(hdlProcess,@hdlModul,SizeOf(hdlModul),iC);
          GetModuleFilenameEx(hdlProcess,hdlModul,arrModul,SizeOf(arrModul));
          if bPath then
          begin
            if CompareText(arrModul,sFile)=0 then
            begin
              TerminateProcess(OpenProcess(PROCESS_TERMINATE or PROCESS_QUERY_INFORMATION,False,arrPid [k]), 0);
              result:=true;
            end;
          end
          else
          begin
            if CompareText(ExtractFileName(arrModul),sFile)=0 then
            begin
              TerminateProcess(OpenProcess(PROCESS_TERMINATE or PROCESS_QUERY_INFORMATION,False,arrPid [k]), 0);
              result:=true;
            end;
          end;
          CloseHandle(hdlProcess);
        end;
      end;
    end;
end;

procedure TFrmMainTreeView.AddLogMsg(Msg: String);
var DateTimeLog: TDateTime;
begin
  DateTimeLog:=Now;
  Memo1.Lines.Add(FormatDateTime('dd/mm-hhmm: ',DateTimeLog) + Msg);
end;

procedure TFrmMainTreeView.ApplicationEvents1Exception(Sender: TObject;
  E: Exception);
begin
 if E.ClassType = EIdSocketError then
 begin
   FrmMainTreeView.AddLogMsg('Abort on AppEvent:' + E.Message );
   FrmMainTreeView.Broker.Disconnect;
 end;
end;

procedure TFrmMainTreeView.BrokerConnected(Sender: TObject);
begin
  FrmHistoryOrders.HistorySheet.ClearLines;
  FrmMainLine.Image19.Visible:=False;
  FrmMainLine.Image18.Visible:=True;
end;

procedure TFrmMainTreeView.BrokerDisconnected(Sender: TObject);
begin
FrmMainLine.Image18.Visible:=False;
FrmMainLine.Image19.Visible:=True;
end;

function TFrmMainTreeView.ChangeDecimalSeparator(Value : String;Decimal : String;DecimalChange : String): String;
var R:String;
  I: Integer;
begin
  R:='';
  for I := 1 to Length(Value) do
  begin
    if Copy(Value,I,1) <> Decimal then
    R:=R + Copy(Value,I,1)
    else
    R:= R + DecimalChange;
  end;
  Result:=R;
end;


function TFrmMainTreeView.StrToBytes(AString: String): TBytes;
var
   j: integer;
begin
   SetLength( Result, Length(AString)) ;
   for j := 0 to Length(AString) - 1 do
     Result[j] := ord(AString[j + 1]);
end;

procedure TFrmMainTreeView.DelUnknowSymbol(Symbol: String);
begin
 if FrmTrade.TradeSheet.FindQuote(Symbol) then
 FrmTrade.TradeSheet.DelLine(Symbol);

 if FrmTradingSystem.TradeSheet.FindQuote(Symbol) then
 FrmTradingSystem.TradeSheet.DelLine(Symbol);

 if FrmCentral.CentralSheet.FindQuote(Symbol) then
 FrmCentral.CentralSheet.DelLine(Symbol);
end;

procedure TFrmMainTreeView.FormClose(Sender: TObject; var Action: TCloseAction);
begin
// TerminateProcesso(ExtractFilePath(ParamStr(0)) + 'broker.exe');
end;

procedure TFrmMainTreeView.FormCreate(Sender: TObject);
var
  I: Integer;
begin
 ShellExecute(Handle,'open','brokerRun.bat','',PChar(ExtractFilePath(ParamStr(0))),SW_HIDE);

 // Limpa Lista de Books
 for I := 0 to 20 do
 FreeAndNil(FrmsBooks[I]);

end;

procedure TFrmMainTreeView.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 case Key of
   113: FrmConnection.Show;
   114: FrmTrade.Show;
   115: FrmTradingSystem.Show;
   116: FrmBrokerBuy.Show;
   118: FrmHistoryOrders.Show;
   120: FrmBrokerSell.Show;
 end;
end;

procedure TFrmMainTreeView.FormShow(Sender: TObject);
begin

// if not DaileonFW.Connected then
// FrmConnection.ShowModal;

end;

procedure TFrmMainTreeView.NewVersion(Url:String);
begin
if MessageDlg('Há uma nova versão disponível para este sistema. Deseja realizar o download?', mtConfirmation, [mbYes,mbNo], 0) = mrYes then
begin
  MessageDlg('O sistema continuará funcionando enquanto você realiza o download. ' + #13 + 'Após baixar a nova versão,'+
              'finalize seu sistema antes de realizar a instalação.', mtInformation,[mbOk], 0);
  ShellExecute(handle,'open',Pchar(Url),'','',SW_SHOWNORMAL);
end;
end;

procedure TFrmMainTreeView.RecallBooks;
var
  I: Integer;
begin
 for I := 0 to 20 do
 begin
   if Assigned(FrmsBooks[I]) then
   begin
     FrmMainTreeView.DaileonFW.IOHandler.WriteLn('mbq ' + LowerCase(FrmsBooks[I].Edit1.Text));
     FrmMainTreeView.DaileonFW.IOHandler.WriteBufferFlush;
   end;
 end;
end;

procedure TFrmMainTreeView.RouterLibrary1CancelEditReject(Sender: TObject;
  MsgType: TMsgType; Msg: string);
begin
 MessageDlg('Sua solicitação foi rejeitada pelo servidor.',mtError,[mbOK],0);
end;

procedure TFrmMainTreeView.RouterLibrary1ExecutionReport(Sender: TObject;
  MsgType: TMsgType; Msg: string);
var MsgSplit:TStringList;
    K,J:Integer;
begin
  MsgSplit:=TStringList.Create;
  SplitColumns(Msg,MsgSplit,#01);

  with FrmHistoryOrders do
  begin

   if not HistorySheet.FindQuote(MsgSplit.Values['37']) then
   begin

     //Verifica se e havido de recebimento pelo OMS
     if ( MsgSplit.Values['37'] = 'NOT AVAILABLE' ) and ( MsgSplit.Values['39'] = 'R') then
     begin
       LabelReturn.Font.Color:=$00007500;
       LabelReturn.Caption:='Ordem enviada com sucesso.';
     end
     else if (MsgSplit.Values['37'] <> 'NONE') then
          
     begin

       //Nova Linha
       FrmHistoryOrders.HistorySheet.NewLine('');

       //Move tudo para baixo
       for K := 0 to FrmHistoryOrders.HistorySheet.ColCount -1 do
       begin
         for J := FrmHistoryOrders.HistorySheet.RowCount - 1 downto 2 do
         begin
           FrmHistoryOrders.HistorySheet.Cells[K,J]:=FrmHistoryOrders.HistorySheet.Cells[K,J-1];
           FrmHistoryOrders.HistorySheet.Cells[K,J-1]:='';
         end;
       end;
        HistorySheet.Cells[0,1]:=MsgSplit.Values['37'];
        HistorySheet.SetValue(clPicture,MsgSplit.Values['37'],MsgSplit.Values['60']);

        if MsgSplit.Values['54'] = '1' then
        HistorySheet.SetValue(clVar,MsgSplit.Values['37'],'Compra')
        else
        HistorySheet.SetValue(clVar,MsgSplit.Values['37'],'Venda');

        HistorySheet.SetValue(clStatus,MsgSplit.Values['37'],MsgSplit.Values['38']);
        HistorySheet.SetValue(clSell,MsgSplit.Values['37'],MsgSplit.Values['44']);
        HistorySheet.SetValue(clBuy,MsgSplit.Values['37'],MsgSplit.Values['55']);
        HistorySheet.SetValue(clObj3,MsgSplit.Values['37'],MsgSplit.Values['6']);
        HistorySheet.SetValue(clObj2,MsgSplit.Values['37'],MsgSplit.Values['14']);

       if MsgSplit.Values['59'] = '0' then
       HistorySheet.SetValue(clLast,MsgSplit.Values['37'],'Hoje')
       else if MsgSplit.Values['59'] = '3' then
       HistorySheet.SetValue(clLast,MsgSplit.Values['37'],'Exec./Parc. ou Canc.')
       else if MsgSplit.Values['59'] = '4' then
       HistorySheet.SetValue(clLast,MsgSplit.Values['37'],'Exec. ou Canc.');

       HistorySheet.SetValue(clObj2,MsgSplit.Values['37'],MsgSplit.Values['14']);

       if MsgSplit.Values['39'] = '0' then
       HistorySheet.SetValue(clObj4,MsgSplit.Values['37'],'Recebida')
       else if MsgSplit.Values['39'] = '4' then
       HistorySheet.SetValue(clObj4,MsgSplit.Values['37'],'Cancelada')
       else if MsgSplit.Values['39'] = '8' then
       HistorySheet.SetValue(clObj4,MsgSplit.Values['37'],'Rejeitada')
       else if MsgSplit.Values['39'] = '2' then
       HistorySheet.SetValue(clObj4,MsgSplit.Values['37'],'Executada')
       else if MsgSplit.Values['39'] = 'A' then
       HistorySheet.SetValue(clObj4,MsgSplit.Values['37'],'Pendente')
       else if MsgSplit.Values['39'] = 'C' then
       HistorySheet.SetValue(clObj4,MsgSplit.Values['37'],'Expirada')
       else if MsgSplit.Values['39'] = '1' then
       HistorySheet.SetValue(clObj4,MsgSplit.Values['37'],'Parc. Executada')
       else if MsgSplit.Values['39'] = '5' then
       HistorySheet.SetValue(clObj4,MsgSplit.Values['37'],'Editada')
       else if MsgSplit.Values['39'] = '9' then
       HistorySheet.SetValue(clObj4,MsgSplit.Values['37'],'Aguardando Merc.')
       else if MsgSplit.Values['39'] = 'E' then
       HistorySheet.SetValue(clObj4,MsgSplit.Values['37'],'Aguardando Edição')
       else if MsgSplit.Values['39'] = '6' then
       HistorySheet.SetValue(clObj4,MsgSplit.Values['37'],'Canc. Pendente')
       else
       HistorySheet.SetValue(clObj4,MsgSplit.Values['37'],MsgSplit.Values['39']);

       FrmHistoryOrders.Caption:='Histórico de Ordens (' + IntToStr(FrmHistoryOrders.HistorySheet.RowCount - 1 ) + ')';
     end;
   end
   else
   begin
       HistorySheet.SetValue(clPicture,MsgSplit.Values['37'],MsgSplit.Values['60']);

       if MsgSplit.Values['54'] = '1' then
        HistorySheet.SetValue(clVar,MsgSplit.Values['37'],'Compra')
        else
        HistorySheet.SetValue(clVar,MsgSplit.Values['37'],'Venda');

        HistorySheet.SetValue(clStatus,MsgSplit.Values['37'],MsgSplit.Values['38']);
        HistorySheet.SetValue(clSell,MsgSplit.Values['37'],MsgSplit.Values['44']);
        HistorySheet.SetValue(clBuy,MsgSplit.Values['37'],MsgSplit.Values['55']);
        HistorySheet.SetValue(clObj3,MsgSplit.Values['37'],MsgSplit.Values['6']);
        HistorySheet.SetValue(clObj2,MsgSplit.Values['37'],MsgSplit.Values['14']);

       if MsgSplit.Values['59'] = '0' then
       HistorySheet.SetValue(clLast,MsgSplit.Values['37'],'Hoje')
       else if MsgSplit.Values['59'] = '3' then
       HistorySheet.SetValue(clLast,MsgSplit.Values['37'],'Exec./Parc. ou Canc.')
       else if MsgSplit.Values['59'] = '4' then
       HistorySheet.SetValue(clLast,MsgSplit.Values['37'],'Exec. ou Canc.');

       HistorySheet.SetValue(clObj2,MsgSplit.Values['37'],MsgSplit.Values['14']);

       if MsgSplit.Values['39'] = '0' then
       HistorySheet.SetValue(clObj4,MsgSplit.Values['37'],'Recebida')
       else if MsgSplit.Values['39'] = '4' then
       HistorySheet.SetValue(clObj4,MsgSplit.Values['37'],'Cancelada')
       else if MsgSplit.Values['39'] = '8' then
       HistorySheet.SetValue(clObj4,MsgSplit.Values['37'],'Rejeitada')
       else if MsgSplit.Values['39'] = '2' then
       HistorySheet.SetValue(clObj4,MsgSplit.Values['37'],'Executada')
       else if MsgSplit.Values['39'] = 'A' then
       HistorySheet.SetValue(clObj4,MsgSplit.Values['37'],'Pendente')
       else if MsgSplit.Values['39'] = 'C' then
       HistorySheet.SetValue(clObj4,MsgSplit.Values['37'],'Expirada')
       else if MsgSplit.Values['39'] = '1' then
       HistorySheet.SetValue(clObj4,MsgSplit.Values['37'],'Parc. Executada')
       else if MsgSplit.Values['39'] = '5' then
       HistorySheet.SetValue(clObj4,MsgSplit.Values['37'],'Editada')
       else if MsgSplit.Values['39'] = '9' then
       HistorySheet.SetValue(clObj4,MsgSplit.Values['37'],'Aguardando Merc.')
       else if MsgSplit.Values['39'] = 'E' then
       HistorySheet.SetValue(clObj4,MsgSplit.Values['37'],'Aguardando Edição')
       else if MsgSplit.Values['39'] = '6' then
       HistorySheet.SetValue(clObj4,MsgSplit.Values['37'],'Canc. Pendente')
       else
       HistorySheet.SetValue(clObj4,MsgSplit.Values['37'],MsgSplit.Values['39']);

       FrmHistoryOrders.Caption:='Histórico de Ordens (' + IntToStr(FrmHistoryOrders.HistorySheet.RowCount - 1 ) + ')';

   end;

  end;
end;

procedure TFrmMainTreeView.RouterLibrary1Logout(Sender: TObject;
  MsgType: TMsgType; Msg: string);
begin
 MessageDlg('Usuário/Senha inválido BM&F.',mtError,[mbOk],0);
 Fix.Disconnect;
end;

procedure TFrmMainTreeView.RouterLibrary1SecurityListReport(Sender: TObject;
  Msg: string);
var MsgSplit:TStringList;
begin
  MsgSplit:=TStringList.Create;
  SplitColumns(Msg,MsgSplit,#01);

  FrmBrokerBuy.SecurityID:=MsgSplit.Values['48'];
  FrmBrokerSell.SecurityID:=MsgSplit.Values['48'];
end;

procedure TFrmMainTreeView.RouterLibrary1TestRequest(Sender: TObject;
  Msg: string);
var MsgTest:String;
begin
 MsgTest:=RouterLibrary1.TestRequest('TEST');
 MsgTest:=MsgTest + RouterLibrary1.GenerateCheckSum(MsgTest);
 Fix.IOHandler.WriteLn(MsgTest);
end;

procedure TFrmMainTreeView.SaveLog;
var LogTemp:TStringList;
begin
   LogTemp:=TStringList.Create;
   if FileExists(ExtractFilePath(ParamStr(0)) + 'logs.log') then
   LogTemp.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'logs.log');
   LogTemp.AddStrings(Memo1.Lines);
   LogTemp.SaveToFile(ExtractFilePath(ParamStr(0)) + 'logs.log');
end;

procedure TFrmMainTreeView.ShowMsgErr;
begin
  MessageDlg(MsgErr,mtError,[mbOk],0);
end;

procedure TFrmMainTreeView.TreeView1DblClick(Sender: TObject);
var Node : TTreeNode;
    s : String;
    FrmWeb:TFrmWebBrowser;
  j: Integer;
begin
  //Obtem o Item selecionado
  Node:= TreeView1.Selected;

  //Verifica qual foi
  if AnsiSameStr(Node.Text,'Planilha de Cotações') then
  FrmTrade.Show;

  if AnsiSameStr(Node.Text,'Resumo do Ativo') then
  begin
    //Se não existir na lista geral, adiciona
    FrmAbstractSymbol:=TFrmAbstractSymbol.Create(Application);
    FrmAbstractSymbol.Show;
  end;

  if AnsiSameStr(Node.Text,'Conectar') then
  FrmConnection.Show;

  if AnsiSameStr(Node.Text,'Compra (F5)') then
  begin
    FrmBrokerBuy.Label23.Caption:='';
    FrmBrokerBuy.Label22.Visible:=False;
    FrmBrokerBuy.Label23.Visible:=False;
    FrmBrokerBuy.Show;
  end;

  if AnsiSameStr(Node.Text,'Venda (F9)') then
  begin
    FrmBrokerSell.Label23.Caption:='';
    FrmBrokerSell.Label22.Visible:=False;
    FrmBrokerSell.Label23.Visible:=False;
    FrmBrokerSell.Show;
  end;

  if AnsiSameStr(Node.Text,'Histórico de Ordens (F7)') then
  begin
    FrmHistoryOrders.Show;
  end;

  if AnsiSameStr(Node.Text,'Start/Stop') then
  FrmStartStop.Show;

  if AnsiSameStr(Node.Text,'Nota de Corretagem') then
  FrmBrokerageNote.Show;

  if AnsiSameStr(Node.Text,'Aggressive Trading System') then
  ShellExecute(handle,'open','http://www.acoesinvest.com.br/servicos/acoes/atsweb.php','','',SW_SHOWNORMAL);

//  if AnsiSameStr(Node.Text,'Intraday') then
//  FrmOpenChart.Show;

  if AnsiSameStr(Node.Text,'Book 5 Melhores') then
  begin
    for j := 1 to 20 do
      begin
        if not Assigned(FrmMainTreeView.FrmsBooks[j]) then
        begin
          Application.CreateForm(TFrmMiniBook,FrmMiniBook);
          FrmMainTreeView.FrmsBooks[j]:=FrmMiniBook;
          FrmMiniBook.Show;
          break;
        end;
      end;
  end;

  if AnsiSameStr(Node.Text,'Calculadora Bovespa') then
  begin
   FrmWeb:=TFrmWebBrowser.Create(Application);
   FrmWeb.Show;
   FrmWeb.WebBrowser1.Navigate('http://www.acoesinvest.com.br/calculadora/calc.php');
   //ShellExecute(handle,'open','http://www.acoesinvest.com.br/calculadora/calc.php','','',SW_SHOWNORMAL);
  end;

  if AnsiSameStr(Node.Text,'Home Broker') then
  begin
   {FrmWeb:=TFrmWebBrowser.Create(Application);
   FrmWeb.Show;
   FrmWeb.WebBrowser1.Navigate('http://hb.acoesinvest.com.br');}
   ShellExecute(handle,'open','http://hb.acoesinvest.com.br','','',SW_SHOWNORMAL);
  end;

  if AnsiSameStr(Node.Text,'Calculadora BM&F') then
  begin
   FrmWeb:=TFrmWebBrowser.Create(Application);
   FrmWeb.Show;
   FrmWeb.WebBrowser1.Navigate('http://www.acoesinvest.com.br/calculadora/calcmini.php');
   //ShellExecute(handle,'open','http://www.acoesinvest.com.br/calculadora/calcmini.php','','',SW_SHOWNORMAL);
  end;

  if AnsiSameStr(Node.Text,'Invest Trading System') then
  begin
   {FrmWeb:=TFrmWebBrowser.Create(Application);
   FrmWeb.Show;
   FrmWeb.WebBrowser1.Navigate('http://www.acoesinvest.com.br/servicos/acoes/tsweb.php');}
   ShellExecute(handle,'open','http://www.acoesinvest.com.br/servicos/acoes/tsweb.php','','',SW_SHOWNORMAL);
  end;

  if AnsiSameStr(Node.Text,'Configurar') then
  begin
    FrmConfig.Show;
  end;
end;

end.
