unit UFrmMainLine;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ExtCtrls, Buttons, StdCtrls,ShellApi,DateUtils, jpeg;

type
  TFrmMainLine = class(TForm)
    Image1: TImage;
    Label6: TLabel;
    PopupMenuCotacoes: TPopupMenu;
    PlanilhadeCotaes1: TMenuItem;
    ResumodoAtivo1: TMenuItem;
    Livro5Melhores1: TMenuItem;
    PopupMenuNegociacoes: TPopupMenu;
    HistricodeOrdens1: TMenuItem;
    StartStopBovespa1: TMenuItem;
    PopupMenuLinks: TPopupMenu;
    radingSystemWeb1: TMenuItem;
    AggressiveTradingSystem1: TMenuItem;
    HomeBroker1: TMenuItem;
    N1: TMenuItem;
    CalculadoraBovespa1: TMenuItem;
    CalculadoraBMF1: TMenuItem;
    PopupMenuOutros: TPopupMenu;
    Timer1: TTimer;
    Button1: TButton;
    N2: TMenuItem;
    radingSystemWeb2: TMenuItem;
    AggressiveTradingSystem2: TMenuItem;
    HomeBroker2: TMenuItem;
    CalculadoraBovespa2: TMenuItem;
    CalculadoraBMF2: TMenuItem;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    Image8: TImage;
    Image13: TImage;
    Image14: TImage;
    PopMenuConsultas: TPopupMenu;
    AnliseGrfica1: TMenuItem;
    AnliseFunamentalista1: TMenuItem;
    RelatriosdeApoio1: TMenuItem;
    Agenda1: TMenuItem;
    Comentrios1: TMenuItem;
    CarteiraSugerida1: TMenuItem;
    RelatriosDirios1: TMenuItem;
    procedure Label6Click(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Label1Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PlanilhadeCotaes1Click(Sender: TObject);
    procedure ResumodoAtivo1Click(Sender: TObject);
    procedure Livro5Melhores1Click(Sender: TObject);
    procedure Compra1Click(Sender: TObject);
    procedure Venda1Click(Sender: TObject);
    procedure HistricodeOrdens1Click(Sender: TObject);
    procedure StartStopBovespa1Click(Sender: TObject);
    procedure AggressiveTradingSystem1Click(Sender: TObject);
    procedure CalculadoraBovespa1Click(Sender: TObject);
    procedure HomeBroker1Click(Sender: TObject);
    procedure CalculadoraBMF1Click(Sender: TObject);
    procedure radingSystemWeb1Click(Sender: TObject);
    procedure Conexes1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Label11Click(Sender: TObject);
    procedure Label12Click(Sender: TObject);
    procedure Label9Click(Sender: TObject);
    procedure Label10Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Image8Click(Sender: TObject);
    procedure Image13Click(Sender: TObject);
    procedure AnliseGrfica1Click(Sender: TObject);
    procedure AnliseFunamentalista1Click(Sender: TObject);
    procedure RelatriosdeApoio1Click(Sender: TObject);
    procedure Agenda1Click(Sender: TObject);
    procedure Comentrios1Click(Sender: TObject);
    procedure CarteiraSugerida1Click(Sender: TObject);
    procedure RelatriosDirios1Click(Sender: TObject);
    procedure Image14Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    MoveWin:Boolean;
    procedure Moved(var info); message WM_MOVE;
  protected
    procedure CreateParams(var Params:TCreateParams);override;
  end;

var
  FrmMainLine: TFrmMainLine;

implementation

uses UFrmMainTreeView, UFrmConnection, UFrmTrade, UFrmMiniBook,
  UFrmAbstractSymbol, UFrmBrokerBuy, UFrmHistoryOrders, UFrmStartStop,
  UFrmBrokerSell,UFrmWebBrowser, UFrmPortfolio, UFrmBrokerSpeed, UFrmOpenChart,
  UFrmRSS;

{$R *.dfm}

procedure TFrmMainLine.Agenda1Click(Sender: TObject);
begin
ShellExecute(handle,'open','http://www.acoesinvest.com.br/servicos/diferencial/dif_analisegrafica.php?where=agendadiaf','','',SW_SHOWNORMAL);
end;

procedure TFrmMainLine.AggressiveTradingSystem1Click(Sender: TObject);
begin
ShellExecute(handle,'open','http://www.acoesinvest.com.br/servicos/acoes/atsweb.php','','',SW_SHOWNORMAL);
end;

procedure TFrmMainLine.AnliseFunamentalista1Click(Sender: TObject);
begin
ShellExecute(handle,'open','http://www.acoesinvest.com.br/servicos/diferencial/dif_analisegrafica.php?where=analisefundamentalistaf','','',SW_SHOWNORMAL);
end;

procedure TFrmMainLine.AnliseGrfica1Click(Sender: TObject);
begin
 ShellExecute(handle,'open','http://www.acoesinvest.com.br/servicos/diferencial/dif_analisegrafica.php?where=analisegraficaf','','',SW_SHOWNORMAL);
end;

procedure TFrmMainLine.Button1Click(Sender: TObject);
begin
  FrmMainTreeView.Show;
end;

procedure TFrmMainLine.CalculadoraBMF1Click(Sender: TObject);
var FrmWeb:TFrmWebBrowser;
begin
   FrmWeb:=TFrmWebBrowser.Create(Application);
   FrmWeb.Show;
   FrmWeb.WebBrowser1.Navigate('http://www.acoesinvest.com.br/calculadora/calcmini.php');
end;

procedure TFrmMainLine.CalculadoraBovespa1Click(Sender: TObject);
var FrmWeb:TFrmWebBrowser;
begin
FrmWeb:=TFrmWebBrowser.Create(Application);
   FrmWeb.Show;
   FrmWeb.WebBrowser1.Navigate('http://www.acoesinvest.com.br/calculadora/calc.php');
end;

procedure TFrmMainLine.CarteiraSugerida1Click(Sender: TObject);
begin
ShellExecute(handle,'open','http://www.acoesinvest.com.br/servicos/diferencial/dif_analisegrafica.php?where=carteirasugeridaf','','',SW_SHOWNORMAL);
end;

procedure TFrmMainLine.Comentrios1Click(Sender: TObject);
begin
ShellExecute(handle,'open','http://www.acoesinvest.com.br/servicos/diferencial/dif_analisegrafica.php?where=comentariosf','','',SW_SHOWNORMAL);
end;

procedure TFrmMainLine.Compra1Click(Sender: TObject);
begin
if FrmMainTreeView.Broker.Connected then
begin
    FrmBrokerBuy.Label23.Caption:='';
    FrmBrokerBuy.Label22.Visible:=False;
    FrmBrokerBuy.Label23.Visible:=False;
    FrmBrokerBuy.Show;
end
else
begin
  MessageDlg('Você não está conectado ao broker.',mtError,[mbOk],0);
end;
end;

procedure TFrmMainLine.Conexes1Click(Sender: TObject);
begin
FrmConnection.Show;
end;

procedure TFrmMainLine.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle:= Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent:= GetDesktopWindow;
end;

procedure TFrmMainLine.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 try
   Self.Caption:='Aguarde... Finalizando sua aplicação.';
   if FrmMainTreeView.Broker.Connected then
   FrmMainTreeView.Broker.Disconnect;

   if FrmMainTreeView.DaileonFW.Connected then
   FrmMainTreeView.DaileonFW.Disconnect;

   {Eqto as Flags da Thread do Sinal OU a Thread do Broker estiverem como
   True, aguarda finalização}
   while (FrmMainTreeView.ThrdSignal) OR(FrmMainTreeView.ThrdBroker) do
   begin
    Application.ProcessMessages;
   end;
   FrmMainTreeView.TerminateProcesso(ExtractFilePath(ParamStr(0)) + 'broker.exe');
   FrmMainTreeView.SaveLog;
 finally
   Application.Terminate;
 end;
end;

procedure TFrmMainLine.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    MoveWin := True;
    SendMessage(Handle, WM_LButtonUp, 0, 0);
    SendMessage(Handle, WM_NCLButtonDown, HTCAPTION, 0);
  end;
end;

procedure TFrmMainLine.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 if MoveWin then SendMessage(Handle, WM_NCHITTEST, 2, 0);
end;

procedure TFrmMainLine.FormShow(Sender: TObject);
begin

 if not FrmMainTreeView.DaileonFW.Connected then
 FrmConnection.ShowModal;

 Self.FormStyle:=fsStayOnTop;
end;

procedure TFrmMainLine.HistricodeOrdens1Click(Sender: TObject);
begin
if FrmMainTreeView.Broker.Connected then
begin
 FrmHistoryOrders.Show;
end
else
begin
 MessageDlg('Você não está conectado ao broker.',mtError,[mbOk],0);
end;
end;

procedure TFrmMainLine.HomeBroker1Click(Sender: TObject);
begin
ShellExecute(handle,'open','http://hb.acoesinvest.com.br','','',SW_SHOWNORMAL);
end;

procedure TFrmMainLine.Image13Click(Sender: TObject);
var PtnMouse : TPoint;
begin
  GetCursorPos(PtnMouse);
  PopMenuConsultas.Popup(PtnMouse.X,PtnMouse.Y);
end;

procedure TFrmMainLine.Image14Click(Sender: TObject);
begin
 FrmNews.Show;
end;

procedure TFrmMainLine.Image8Click(Sender: TObject);
begin
 if FrmMainTreeView.Broker.Connected then
 FrmBrokerSpeed.Show
 else
 MessageDlg('Você não está conectado ao broker.',mtError,[mbOk],0);
end;

procedure TFrmMainLine.Label10Click(Sender: TObject);
begin
if FrmMainTreeView.Broker.Connected then
begin
 FrmStartStop.Show;
end
else
begin
 MessageDlg('Você não está conectado ao broker.',mtError,[mbOk],0);
end;
end;

procedure TFrmMainLine.Label11Click(Sender: TObject);
begin
  FrmConnection.Show;
end;

procedure TFrmMainLine.Label12Click(Sender: TObject);
begin
 StartStopBovespa1Click(Self);
end;

procedure TFrmMainLine.Label1Click(Sender: TObject);
//var PtnMouse : TPoint;
begin
//  GetCursorPos(PtnMouse);
//  PopupMenuCotacoes.Popup(PtnMouse.X - 10,PtnMouse.Y + 10);
 FrmTrade.Show;
end;

procedure TFrmMainLine.Label2Click(Sender: TObject);
//var PtnMouse : TPoint;
var j:Integer;
    NewFrmMiniBook:TFrmMiniBook;
begin
//  GetCursorPos(PtnMouse);
//  PopupMenuNegociacoes.Popup(PtnMouse.X - 10,PtnMouse.Y + 10);
     for j := 0 to 20 do
      begin
        if not Assigned(FrmMainTreeView.FrmsBooks[j]) then
        begin
          //Application.CreateForm(TFrmMiniBook,FrmMiniBook);
          NewFrmMiniBook:=TFrmMiniBook.Create(Application);
          FrmMainTreeView.FrmsBooks[j]:=NewFrmMiniBook;
          NewFrmMiniBook.Show;
          break;
        end;
      end;
end;

procedure TFrmMainLine.Label3Click(Sender: TObject);
var //PtnMouse : TPoint;
    FrmWeb:TFrmWebBrowser;
begin
// ShellExecute(handle,'open','http://www.acoesinvest.com.br/grafico.html','','',SW_SHOWNORMAL);
// if(FrmMainTreeView.DaileonFW.Connected) then
// begin
//   FrmWeb:=TFrmWebBrowser.Create(Application);
//   FrmWeb.SetSize(610,855);
//   FrmWeb.Show;
//   FrmWeb.WebBrowser1.Navigate('http://quotes2.enfoque.com.br/diferencial/flashchartHB/pt/grafico.aspx');
// end
// else
// begin
//   MessageDlg('Você não está conectado ao servidor.', mtError, [mbOk], 0);
// end;
// FrmOpenChart.Show;
 ShellExecute(Handle,'open','chartRun.bat','',PChar(ExtractFilePath(ParamStr(0))),SW_HIDE);
end;

procedure TFrmMainLine.Label4Click(Sender: TObject);
var PtnMouse : TPoint;
begin
//  GetCursorPos(PtnMouse);
//  PopupMenuOutros.Popup(PtnMouse.X - 10,PtnMouse.Y + 10);
ShellExecute(handle,'open','https://hb.diferencial.com.br/','','',SW_SHOWNORMAL);
end;

procedure TFrmMainLine.Label6Click(Sender: TObject);
begin
  Self.Close;
end;

procedure TFrmMainLine.Label9Click(Sender: TObject);
//var PtnMouse : TPoint;
begin
HistricodeOrdens1Click(Self);
end;

procedure TFrmMainLine.Livro5Melhores1Click(Sender: TObject);
var j:Integer;
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

procedure TFrmMainLine.Moved(var info);
begin
 MoveWin:=False;
end;

procedure TFrmMainLine.PlanilhadeCotaes1Click(Sender: TObject);
begin
 FrmTrade.Show;
end;

procedure TFrmMainLine.radingSystemWeb1Click(Sender: TObject);
begin
ShellExecute(handle,'open','http://www.acoesinvest.com.br/servicos/acoes/tsweb.php','','',SW_SHOWNORMAL);
end;

procedure TFrmMainLine.RelatriosdeApoio1Click(Sender: TObject);
begin
ShellExecute(handle,'open','http://www.acoesinvest.com.br/servicos/diferencial/dif_analisegrafica.php?where=relatorioapoiof','','',SW_SHOWNORMAL);
end;

procedure TFrmMainLine.RelatriosDirios1Click(Sender: TObject);
begin
ShellExecute(handle,'open','http://www.acoesinvest.com.br/servicos/diferencial/dif_analisegrafica.php?where=relatoriodiariosf','','',SW_SHOWNORMAL);
end;

procedure TFrmMainLine.ResumodoAtivo1Click(Sender: TObject);
begin
  FrmAbstractSymbol:=TFrmAbstractSymbol.Create(Application);
  FrmAbstractSymbol.Show;
end;

procedure TFrmMainLine.StartStopBovespa1Click(Sender: TObject);
begin
if FrmMainTreeView.Broker.Connected then
begin
 FrmPortfolio.Show;
end
else
begin
 MessageDlg('Você não está conectado ao broker.',mtError,[mbOk],0);
end;
end;

procedure TFrmMainLine.Timer1Timer(Sender: TObject);
begin
 //Label5.Caption:=FormatDateTime('hh:nn',Now);
end;

procedure TFrmMainLine.Venda1Click(Sender: TObject);
begin
if FrmMainTreeView.Broker.Connected then
begin
    FrmBrokerSell.Label23.Caption:='';
    FrmBrokerSell.Label22.Visible:=False;
    FrmBrokerSell.Label23.Visible:=False;
    FrmBrokerSell.Show;
end
else
begin
  MessageDlg('Você não está conectado ao broker.',mtError,[mbOk],0);
end;
end;

end.
