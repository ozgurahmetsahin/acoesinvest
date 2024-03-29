program DMATrader;

uses
  Forms,
  UFrmConnection in 'Units\UFrmConnection.pas' {FrmConnection},
  UThrdDaileonFwConnection in 'Units\UThrdDaileonFwConnection.pas',
  UThrdDaileonFwRead in 'Units\UThrdDaileonFwRead.pas',
  UFrmTrade in 'Units\UFrmTrade.pas' {FrmTrade},
  UThrdManipulateTrade in 'Units\UThrdManipulateTrade.pas',
  UFrmAbstractSymbol in 'Units\UFrmAbstractSymbol.pas' {FrmAbstractSymbol},
  UFrmTradeCentral in 'Units\UFrmTradeCentral.pas' {FrmCentral},
  UFrmTradingSystem in 'Units\UFrmTradingSystem.pas' {FrmTradingSystem},
  UFrmMainTreeView in 'Units\UFrmMainTreeView.pas' {FrmMainTreeView},
  UFrmBrokerBuy in 'Units\UFrmBrokerBuy.pas' {FrmBrokerBuy},
  UFrmBrokerSell in 'Units\UFrmBrokerSell.pas' {FrmBrokerSell},
  UThrdBrokerConnection in 'Units\UThrdBrokerConnection.pas',
  UThrdBrokerRead in 'Units\UThrdBrokerRead.pas',
  UFrmHistoryOrders in 'Units\UFrmHistoryOrders.pas' {FrmHistoryOrders},
  UFrmStartStop in 'Units\UFrmStartStop.pas' {FrmStartStop},
  UFrmBrokerageNote in 'Units\UFrmBrokerageNote.pas' {FrmBrokerageNote},
  UThrdDaileonCommands in 'Units\UThrdDaileonCommands.pas',
  UFrmCloses in 'Units\UFrmCloses.pas' {FrmCloses},
  UFrmWebBrowser in 'Units\UFrmWebBrowser.pas' {FrmWebBrowser},
  UFrmMiniBook in 'Units\UFrmMiniBook.pas' {FrmMiniBook},
  UThrdMiniBookManipulate in 'Units\UThrdMiniBookManipulate.pas',
  UFrmConfig in 'Units\UFrmConfig.pas' {FrmConfig},
  UThrdFixConnection in 'Units\UThrdFixConnection.pas',
  UThrdFixRead in 'Units\UThrdFixRead.pas',
  UFrmMainLine in 'Units\UFrmMainLine.pas' {FrmMainLine},
  UFrmPortfolio in 'Units\UFrmPortfolio.pas' {FrmPortfolio},
  UFrmConnConfig in 'Units\UFrmConnConfig.pas' {FrmConnConfig},
  UMsgs in 'Units\UMsgs.pas',
  UMain in 'Units\UMain.pas',
  UFrmBrokerSpeed in 'Units\UFrmBrokerSpeed.pas' {FrmBrokerSpeed},
  UFrmOpenChart in 'Units\UFrmOpenChart.pas' {FrmOpenChart},
  UFrmRSS in 'Units\UFrmRSS.pas' {FrmNews};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmConnection, FrmConnection);
  Application.CreateForm(TFrmMainLine, FrmMainLine);
  Application.CreateForm(TFrmMainTreeView, FrmMainTreeView);
  Application.CreateForm(TFrmTradingSystem, FrmTradingSystem);
  Application.CreateForm(TFrmTrade, FrmTrade);
  Application.CreateForm(TFrmCentral, FrmCentral);
  Application.CreateForm(TFrmBrokerBuy, FrmBrokerBuy);
  Application.CreateForm(TFrmBrokerSell, FrmBrokerSell);
  Application.CreateForm(TFrmHistoryOrders, FrmHistoryOrders);
  Application.CreateForm(TFrmStartStop, FrmStartStop);
  Application.CreateForm(TFrmBrokerageNote, FrmBrokerageNote);
  Application.CreateForm(TFrmCloses, FrmCloses);
  Application.CreateForm(TFrmWebBrowser, FrmWebBrowser);
  Application.CreateForm(TFrmConfig, FrmConfig);
  Application.CreateForm(TFrmPortfolio, FrmPortfolio);
  Application.CreateForm(TFrmConnConfig, FrmConnConfig);
  Application.CreateForm(TFrmBrokerSpeed, FrmBrokerSpeed);
  Application.CreateForm(TFrmOpenChart, FrmOpenChart);
  Application.CreateForm(TFrmNews, FrmNews);
  //Application.ShowMainForm:=False;
  //FrmMainTreeView.Show;
  Application.MainFormOnTaskbar := True;
  Application.Run;
end.
