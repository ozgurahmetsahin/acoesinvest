unit UFrmChart;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls,ComCtrls, ToolWin, Tabs, ExtCtrls,
  Buttons, StdCtrls, Menus, ImgList,Sheet;

type
  TFrmChart = class(TForm)
    PopupMenu1: TPopupMenu;
    ExibirBarraLateral1: TMenuItem;
    CoolBar2: TCoolBar;
    ToolBar2: TToolBar;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ImageList: TImageList;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    PopupMenu2: TPopupMenu;
    IFR1: TMenuItem;
    StochasticOscIndicator1: TMenuItem;
    BandasdeBollinger1: TMenuItem;
    MdiaExponencial1: TMenuItem;
    MdiaAritmtica1: TMenuItem;
    MACD1: TMenuItem;
    OBV1: TMenuItem;
    Parablico1: TMenuItem;
    Estocstico1: TMenuItem;
    WilliansR1: TMenuItem;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    Timer1: TTimer;
    procedure SpeedButton1Click(Sender: TObject);
    procedure ToolButton9Click(Sender: TObject);
    procedure ToolButton10Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure ToolButton6Click(Sender: TObject);
    procedure ExibirBarraLateral1Click(Sender: TObject);
    procedure IFR1Click(Sender: TObject);
    procedure StochasticOscIndicator1Click(Sender: TObject);
    procedure BandasdeBollinger1Click(Sender: TObject);
    procedure MdiaExponencial1Click(Sender: TObject);
    procedure MACD1Click(Sender: TObject);
    procedure OBV1Click(Sender: TObject);
    procedure Parablico1Click(Sender: TObject);
    procedure WilliansR1Click(Sender: TObject);
    procedure Estocstico1Click(Sender: TObject);
    procedure ToolButton7Click(Sender: TObject);
    procedure ToolButton11Click(Sender: TObject);
    procedure ToolButton12Click(Sender: TObject);
    procedure StockChartX1MouseMove(ASender: TObject; X, Y, Record_: Integer);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    IncLines:Integer;
    IncIndicators:Integer;
    PanelAdd:Integer;
    Arrow:Double;
  protected
    procedure CreateParams(var Params:TCreateParams);override;
  public
    { Public declarations }
    ScaleMax,ScaleMin:Double;
  end;

var
  FrmChart: TFrmChart;

implementation

uses UFrmOpenChart, UFrmTradeCentral, UFrmMainTreeView;

{$R *.dfm}

procedure TFrmChart.BandasdeBollinger1Click(Sender: TObject);
begin
  Inc(IncIndicators);
  StockChartX1.AddIndicatorSeries(indBollingerBands, 'Bol-'+IntToStr(IncIndicators), 0, True);
  StockChartX1.Update;
end;

procedure TFrmChart.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle:= Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent:= GetDesktopWindow;
end;

procedure TFrmChart.Estocstico1Click(Sender: TObject);
begin
  Inc(IncIndicators);
  PanelAdd:=StockChartX1.AddChartPanel;
  StockChartX1.AddIndicatorSeries(indTRIX, 'Trix-'+IntToStr(IncIndicators), PanelAdd, True);
  StockChartX1.Update;
end;

procedure TFrmChart.ExibirBarraLateral1Click(Sender: TObject);
begin
  StockChartX1.ResetZoom;
end;

procedure TFrmChart.FormCreate(Sender: TObject);
begin
 IncLines:=0;
 IncIndicators:=0;
 Arrow:=0;
end;

procedure TFrmChart.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  var Max,Min:Double;
begin
  case Key of
    // end
    35: ExibirBarraLateral1Click(Self);
    //Seta UP
    38:
    begin
      Arrow:=Arrow + 0.03;
      Max:=ScaleMax + Arrow;
      Min:=ScaleMin + Arrow;
      StockChartX1.SetYScale(0,ScaleMax,ScaleMin);
      ScaleMax:=Max;
      ScaleMin:=Min;
    end;
    //Seta Down
    40:
    begin
     if(Arrow >=0) then
     begin
      Arrow:=Arrow - 0.03;
      Max:=ScaleMax - Arrow;
      Min:=ScaleMin - Arrow;
      StockChartX1.SetYScale(0,ScaleMax,ScaleMin);
      ScaleMax:=Max;
      ScaleMin:=Min;
     end
     else
     begin
       Arrow:= Arrow - ( -0.3 );
       Max:=ScaleMax + ( -Arrow );
       Min:=ScaleMin + ( -Arrow );
       StockChartX1.SetYScale(0,ScaleMax,ScaleMin);
       ScaleMax:=Max;
       ScaleMin:=Min;
     end;
    end;
    46 : //Delete
   begin
     if StockChartX1.SelectedType <> 0 then
     begin
     if not((StockChartX1.SelectedType = otStockBarChart)or(StockChartX1.SelectedType = otCandleChart)
         or(StockChartX1.SelectedType = otLineChart)or(StockChartX1.SelectedType = otVolumeChart)) then
         begin
           case StockChartX1.SelectedType of
             497,502 : StockChartX1.RemoveSeries(StockChartX1.SelectedKey);
             else
             StockChartX1.RemoveObject(StockChartX1.SelectedType, StockChartX1.SelectedKey);
           end;
           StockChartX1.Update;
         end;
     end;
   end;
    // C
    67: ToolButton12Click(Self);

    // +
    107: ToolButton1Click(Self);
    // -
    109: ToolButton2Click(Self);
  end;
end;

procedure TFrmChart.IFR1Click(Sender: TObject);
begin
  Inc(IncIndicators);
  PanelAdd:=StockChartX1.AddChartPanel;
  StockChartX1.AddIndicatorSeries(indRelativeStrengthIndex, 'IFR-'+IntToStr(IncIndicators), PanelAdd, True);
  StockChartX1.Update;
end;

procedure TFrmChart.MACD1Click(Sender: TObject);
begin
  Inc(IncIndicators);
  StockChartX1.AddIndicatorSeries(indSimpleMovingAverage, 'Media Ari-'+IntToStr(IncIndicators), 0, True);
  StockChartX1.Update;
end;

procedure TFrmChart.MdiaExponencial1Click(Sender: TObject);
begin
  Inc(IncIndicators);
  StockChartX1.AddIndicatorSeries(indExponentialMovingAverage, 'Media Exp-'+IntToStr(IncIndicators), 0, True);
  StockChartX1.Update;
end;

procedure TFrmChart.OBV1Click(Sender: TObject);
begin
  Inc(IncIndicators);
  PanelAdd:=StockChartX1.AddChartPanel;
  StockChartX1.AddIndicatorSeries(indOnBalanceVolume, 'OBV-'+IntToStr(IncIndicators), PanelAdd, True);
  StockChartX1.Update;
end;

procedure TFrmChart.Parablico1Click(Sender: TObject);
begin
  Inc(IncIndicators);
  StockChartX1.AddIndicatorSeries(indParabolicSAR, 'Parabolico-'+IntToStr(IncIndicators), 0, True);
  StockChartX1.Update;
end;

procedure TFrmChart.SpeedButton1Click(Sender: TObject);
begin
  Inc(IncLines);
  StockChartX1.DrawLineStudy(lsTrendLine, Format('%d',[IncLines]));
end;

procedure TFrmChart.StochasticOscIndicator1Click(Sender: TObject);
begin
  Inc(IncIndicators);
  PanelAdd:=StockChartX1.AddChartPanel;
  StockChartX1.AddIndicatorSeries(indStochasticOscillator, 'Estocastico-'+IntToStr(IncIndicators), PanelAdd, True);
  StockChartX1.Update;
end;

procedure TFrmChart.StockChartX1MouseMove(ASender: TObject; X, Y,
  Record_: Integer);
begin
  {Ao mover o mouse, ativa o Cross caso esteja checado.
  Isso porque se o cara clica some o cross}
  if(ToolButton12.Down) then StockChartX1.CrossHairs:=True;
end;

procedure TFrmChart.Timer1Timer(Sender: TObject);
var Last:Double;
begin
 try
  {Obtem o ultimo valor de cotacao}
  Last:= StrToFloat( FrmMainTreeView.ChangeDecimalSeparator(FrmCentral.CentralSheet.GetValue(clLast,Self.Caption),'.',',') );

  {Seta o Valor no Grafico}
  StockChartX1.ShowLastTick(Self.Caption+'.close',Last);

 except
   {Ignora qualquer erro}
   on E:Exception do
   FrmMainTreeView.Memo1.Lines.Add(E.Message);
 end;
end;

procedure TFrmChart.ToolButton10Click(Sender: TObject);
begin
  Inc(IncLines);
  StockChartX1.DrawLineStudy(lsRectangle, Format('%d',[IncLines]));
end;

procedure TFrmChart.ToolButton11Click(Sender: TObject);
begin
 StockChartX1.CrossHairs:=False;
 ToolButton11.Down:=True;
 ToolButton12.Down:=False;
end;

procedure TFrmChart.ToolButton12Click(Sender: TObject);
begin
 StockChartX1.CrossHairs:=True;
 ToolButton11.Down:=False;
 ToolButton12.Down:=True;
end;

procedure TFrmChart.ToolButton1Click(Sender: TObject);
begin
 StockChartX1.ZoomIn(5);
end;

procedure TFrmChart.ToolButton2Click(Sender: TObject);
begin
 StockChartX1.ZoomOut(5);
end;

procedure TFrmChart.ToolButton3Click(Sender: TObject);
begin
 StockChartX1.ZoomUserDefined;
end;

procedure TFrmChart.ToolButton4Click(Sender: TObject);
begin
 Inc(IncLines);
 StockChartX1.DrawLineStudy(lsFibonacciFan,Format('%d',[IncLines]));
end;

procedure TFrmChart.ToolButton5Click(Sender: TObject);
begin
 Inc(IncLines);
 StockChartX1.DrawLineStudy(lsFibonacciRetracements, Format('%d',[IncLines]));
end;

procedure TFrmChart.ToolButton6Click(Sender: TObject);
begin
 Inc(IncLines);
 StockChartX1.DrawLineStudy(lsFibonacciTimeZones, Format('%d',[IncLines]));
end;

procedure TFrmChart.ToolButton7Click(Sender: TObject);
var MousePtn : TPoint;
begin
  GetCursorPos(MousePtn);
  PopupMenu2.Popup(MousePtn.X+3,MousePtn.Y);
end;

procedure TFrmChart.ToolButton9Click(Sender: TObject);
begin
 Inc(IncLines);
 StockChartX1.DrawLineStudy(lsEllipse, Format('%d',[IncLines]));
end;

procedure TFrmChart.WilliansR1Click(Sender: TObject);
begin
  Inc(IncIndicators);
  PanelAdd:=StockChartX1.AddChartPanel;
  StockChartX1.AddIndicatorSeries(indWilliamsPctR, 'Willians-'+IntToStr(IncIndicators), PanelAdd, True);
  StockChartX1.Update;
end;

end.
