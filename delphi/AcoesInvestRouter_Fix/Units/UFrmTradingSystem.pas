unit UFrmTradingSystem;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrmTrade, StdCtrls, ExtCtrls, Grids, Sheet, Menus, Buttons,
  TeEngine, Series, TeeProcs, Chart, Gauges,IdException,IdExceptionCore;

type
  TFrmTradingSystem = class(TFrmTrade)
    TimerPanel: TTimer;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label13: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Bevel5: TBevel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    SpeedButton3: TSpeedButton;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label49: TLabel;
    Bevel6: TBevel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Chart1: TChart;
    Series1: TBarSeries;
    ScrollBar1: TScrollBar;
    GroupBox2: TGroupBox;
    Label48: TLabel;
    Label53: TLabel;
    Gauge1: TGauge;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Gauge2: TGauge;
    Label57: TLabel;
    Label58: TLabel;
    Gauge3: TGauge;
    Label59: TLabel;
    Bevel7: TBevel;
    Bevel8: TBevel;
    Bevel9: TBevel;
    procedure TradeSheetDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure TradeSheetClick(Sender: TObject);
    procedure TimerPanelTimer(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SeriesAdd(Value:Double; LabelValue:String;Status : String);
  end;

var
  FrmTradingSystem: TFrmTradingSystem;

implementation

uses UFrmTradeCentral, UFrmCloses, UFrmMainTreeView;

{$R *.dfm}

procedure TFrmTradingSystem.FormShow(Sender: TObject);
begin
  inherited;
  FrmMainTreeView.DaileonFW.IOHandler.WriteLn('tib');
end;

procedure TFrmTradingSystem.ScrollBar1Change(Sender: TObject);
begin
  inherited;
  Chart1.Page:=ScrollBar1.Position;
end;

procedure TFrmTradingSystem.SeriesAdd(Value: Double; LabelValue: String;Status : String);
var co : TColor;
begin
 if Status = 'H' then
 co := clLime
 else if Status = 'L' then
      co:= clRed
      else
      co:=clYellow;

 Series1.Add(Value,LabelValue,co);
 Chart1.Page:=Chart1.Pages.Count;
 ScrollBar1.Max:=Chart1.Pages.Count;
 ScrollBar1.Position:=ScrollBar1.Max;
end;

procedure TFrmTradingSystem.SpeedButton3Click(Sender: TObject);
begin
  inherited;
  GroupBox1.Visible:=False;
end;

procedure TFrmTradingSystem.TimerPanelTimer(Sender: TObject);
begin
  inherited;
  Label3.Caption:= FrmCentral.CentralSheet.GetValue(clVar,TradeSheet.SelectedQuote);
  Label5.Caption:= FrmCentral.CentralSheet.GetValue(clVarWeek,TradeSheet.SelectedQuote);
  Label7.Caption:= FrmCentral.CentralSheet.GetValue(clVarMonth,TradeSheet.SelectedQuote);
  Label9.Caption:= FrmCentral.CentralSheet.GetValue(clVarYear,TradeSheet.SelectedQuote);
  Label19.Caption:= FrmCentral.CentralSheet.GetValue(clStop,TradeSheet.SelectedQuote);
  Label21.Caption:= FrmCentral.CentralSheet.GetValue(clPtnBuy,TradeSheet.SelectedQuote);
  Label22.Caption:= FrmCentral.CentralSheet.GetValue(clObj1B,TradeSheet.SelectedQuote);
  Label25.Caption:= FrmCentral.CentralSheet.GetValue(clObj2B,TradeSheet.SelectedQuote);
  Label26.Caption:= FrmCentral.CentralSheet.GetValue(clObj3B,TradeSheet.SelectedQuote);
  Label31.Caption:= FrmCentral.CentralSheet.GetValue(clObj4B,TradeSheet.SelectedQuote);
  Label33.Caption:= FrmCentral.CentralSheet.GetValue(clPtnSell,TradeSheet.SelectedQuote);
  Label34.Caption:= FrmCentral.CentralSheet.GetValue(clObj1S,TradeSheet.SelectedQuote);
  Label37.Caption:= FrmCentral.CentralSheet.GetValue(clObj2S,TradeSheet.SelectedQuote);
  Label38.Caption:= FrmCentral.CentralSheet.GetValue(clObj3S,TradeSheet.SelectedQuote);
  Label41.Caption:= FrmCentral.CentralSheet.GetValue(clObj4S,TradeSheet.SelectedQuote);
  Label14.Caption:= FrmCentral.CentralSheet.GetValue(clMax,TradeSheet.SelectedQuote);
  Label43.Caption:= FrmCentral.CentralSheet.GetValue(clMin,TradeSheet.SelectedQuote);
end;

procedure TFrmTradingSystem.TradeSheetClick(Sender: TObject);
var
  I: Integer;
begin
   //Mostra no GroupBox qual ativo esta selecionado
  GroupBox1.Caption:=TradeSheet.SelectedQuote + ':';

  Series1.Clear;

  GroupBox1.Visible:=True;

    //Solicita as info basicas do ativo
  try
    FrmMainTreeView.DaileonFW.IOHandler.WriteLn('ptnstop ' + LowerCase( TradeSheet.SelectedQuote));
    FrmMainTreeView.DaileonFW.IOHandler.WriteLn('ptnbuy ' + LowerCase( TradeSheet.SelectedQuote));
    FrmMainTreeView.DaileonFW.IOHandler.WriteLn('ptnsell ' + LowerCase( TradeSheet.SelectedQuote));
    FrmMainTreeView.DaileonFW.IOHandler.WriteLn('highs ' + LowerCase( TradeSheet.SelectedQuote));
    FrmMainTreeView.DaileonFW.IOHandler.WriteLn('lows ' + LowerCase( TradeSheet.SelectedQuote));
    FrmMainTreeView.DaileonFW.IOHandler.WriteLn('closes ' + LowerCase( TradeSheet.SelectedQuote));
    FrmMainTreeView.DaileonFW.IOHandler.WriteLn('res ' + LowerCase( TradeSheet.SelectedQuote) + ' ' +
    FrmCentral.CentralSheet.GetValue(clLast,TradeSheet.SelectedQuote));
    FrmMainTreeView.DaileonFW.IOHandler.WriteLn('sup ' + LowerCase( TradeSheet.SelectedQuote) + ' ' +
    FrmCentral.CentralSheet.GetValue(clLast,TradeSheet.SelectedQuote));
  except
    on E:EIdConnClosedGracefully do
    begin
      FrmMainTreeView.MsgErr:='Os dados não estão disponíveis no momento.';
      FrmMainTreeView.ShowMsgErr;
    end;
  end;
end;

procedure TFrmTradingSystem.TradeSheetDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  inherited;
  if TradeSheet.Cells[ACol,ARow] = 'W' then
  begin
    TradeSheet.Cells[ACol,ARow] := 'Aguarde';
    TradeSheet.SetValue(clBaseIn,TradeSheet.Cells[0,ARow],' --- ');
    TradeSheet.SetValue(clObj1,TradeSheet.Cells[0,ARow],' --- ');
    TradeSheet.SetValue(clObj2,TradeSheet.Cells[0,ARow],' --- ');
    TradeSheet.SetValue(clObj3,TradeSheet.Cells[0,ARow],' --- ');
    TradeSheet.SetValue(clObj4,TradeSheet.Cells[0,ARow],' --- ');
  end
  else if TradeSheet.Cells[ACol,ARow] = 'S' then
  TradeSheet.Cells[ACol,ARow] := 'Vendido'
  else if TradeSheet.Cells[ACol,ARow] = 'B' then
  TradeSheet.Cells[ACol,ARow] := 'Comprado';

  if ( TradeSheet.GetColumInteger(clStatus) = ACol ) And ( ARow >= 1 ) then
  with TradeSheet.Canvas do
  begin
    if TradeSheet.Cells[ACol,ARow] = 'Vendido' then
    begin
      Brush.Color:=clRed;
      FillRect(Rect);
      Font.Color:=clBlack;
      TextRect(Rect,Rect.Left + 3,Rect.Top + 3,TradeSheet.Cells[ACol,ARow]);
    end
    else if TradeSheet.Cells[ACol,ARow] = 'Comprado' then
    begin
      Brush.Color:=clLime;
      FillRect(Rect);
      Font.Color:=clBlack;
      TextRect(Rect,Rect.Left + 3,Rect.Top + 3,TradeSheet.Cells[ACol,ARow]);
    end
    else if TradeSheet.Cells[ACol,ARow] = 'Aguarde' then
    begin
      Brush.Color:=clYellow;
      FillRect(Rect);
      Font.Color:=clBlack;
      TextRect(Rect,Rect.Left + 3,Rect.Top + 3,TradeSheet.Cells[ACol,ARow]);
    end;         


    Font.Color:=TradeSheet.FontColorPaint;
  end;

end;

end.

