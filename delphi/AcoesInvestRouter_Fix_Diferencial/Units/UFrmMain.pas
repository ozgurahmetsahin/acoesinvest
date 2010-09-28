unit UFrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, ComCtrls,ShellApi, WinSkinData;

type
  TFrmMain = class(TForm)
    ScrollBox1: TScrollBox;
    PStock: TPanel;
    GStock: TCategoryPanelGroup;
    Stock: TCategoryPanel;
    PChart: TPanel;
    GChart: TCategoryPanelGroup;
    Chart: TCategoryPanel;
    PTrade: TPanel;
    GTrade: TCategoryPanelGroup;
    Trade: TCategoryPanel;
    Label1: TLabel;
    POthers: TPanel;
    GOthers: TCategoryPanelGroup;
    Others: TCategoryPanel;
    Label2: TLabel;
    DaileonFW: TIdTCPClient;
    StatusBar1: TStatusBar;
    Label3: TLabel;
    Label4: TLabel;
    PTradingSystem: TPanel;
    GTradingSystem: TCategoryPanelGroup;
    TradingSystem: TCategoryPanel;
    Label5: TLabel;
    Label6: TLabel;
    SkinData1: TSkinData;
    DaileonData: TIdTCPClient;
    procedure StockCollapse(Sender: TObject);
    procedure StockExpand(Sender: TObject);
    procedure ChartCollapse(Sender: TObject);
    procedure ChartExpand(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure TradeCollapse(Sender: TObject);
    procedure TradeExpand(Sender: TObject);
    procedure OthersExpand(Sender: TObject);
    procedure OthersCollapse(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Label6Click(Sender: TObject);
    procedure TradingSystemCollapse(Sender: TObject);
    procedure TradingSystemExpand(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    MsgErr: String;
    procedure ShowMsgErr;
  end;

var
  FrmMain: TFrmMain;

implementation

uses UFrmConnection, UFrmTrade, UFrmAbstractSymbol, UFrmTradeCentral,
  UFrmTradingSystem;

{$R *.dfm}

procedure TFrmMain.ChartCollapse(Sender: TObject);
begin
  PChart.Height:=34;
end;

procedure TFrmMain.ChartExpand(Sender: TObject);
begin
  PChart.Height:=161;
end;

procedure TFrmMain.FormActivate(Sender: TObject);
begin
  FrmMain.BringToFront;
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
  FrmMain.BringToFront;
end;

procedure TFrmMain.Label1Click(Sender: TObject);
begin
  FrmTrade.Show;
end;

procedure TFrmMain.Label2Click(Sender: TObject);
begin
  FrmConnection.Show;
end;

procedure TFrmMain.Label4Click(Sender: TObject);
var s :string;
begin
  if InputQuery('Resumo do Ativo','Digite o ativo:',s) then
  begin
    //Se não existir na lista geral, adiciona
    try
      if(not FrmCentral.CentralSheet.FindQuote(s)) then
      FrmCentral.AddSymbol(s);

      FrmAbstractSymbol:= TFrmAbstractSymbol.Create(Self);
      FrmAbstractSymbol.Symbol:=s;
      FrmAbstractSymbol.Caption:='Resumo do Ativo - ' + UpperCase(s);
      FrmAbstractSymbol.Label1.Caption:=UpperCase(s);
      FrmAbstractSymbol.Show;
    except
      on E:EAccessViolation do
      begin
        MsgErr:='Não foi possível enviar a solicitação ao servidor.';
        ShowMsgErr;
      end;
    end;
  end;
end;

procedure TFrmMain.Label5Click(Sender: TObject);
begin
  FrmTradingSystem.Show;
end;

procedure TFrmMain.Label6Click(Sender: TObject);
begin
  ShellExecute(Handle,'open','http://200.152.246.206:8080/gbmf/login.do?enviar=1&user=TS4.0&senha=ts','','',SW_SHOWNORMAL);
end;

procedure TFrmMain.OthersCollapse(Sender: TObject);
begin
  POthers.Height:=34;
end;

procedure TFrmMain.OthersExpand(Sender: TObject);
begin
  POthers.Height:=161;
end;

procedure TFrmMain.ShowMsgErr;
begin
  MessageDlg(MsgErr,mtError,[mbOk],0);
end;

procedure TFrmMain.StockCollapse(Sender: TObject);
begin
  PStock.Height:=34;
end;

procedure TFrmMain.StockExpand(Sender: TObject);
begin
  PStock.Height:=161;
end;

procedure TFrmMain.TradeCollapse(Sender: TObject);
begin
  PTrade.Height:=34;
end;

procedure TFrmMain.TradeExpand(Sender: TObject);
begin
  PTrade.Height:=161;
end;

procedure TFrmMain.TradingSystemCollapse(Sender: TObject);
begin
  PTradingSystem.Height:=34;
end;

procedure TFrmMain.TradingSystemExpand(Sender: TObject);
begin
  PTradingSystem.Height:=161;
end;

end.
