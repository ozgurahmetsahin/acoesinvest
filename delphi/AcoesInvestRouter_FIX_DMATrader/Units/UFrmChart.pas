unit UFrmChart;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  OleCtrls, STOCKCHARTXLib_TLB, StdCtrls,DateUtils, ComCtrls, ToolWin,
  ExtCtrls, ImgList, Menus, PlatformDefaultStyleActnCtrls, ActnList, ActnMan,
  TeCanvas, Dialogs,IdGlobal,StrUtils, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient;

type
  TFrmChart = class(TForm)
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    ImageList: TImageList;
    Arrow: TToolButton;
    Cross: TToolButton;
    ToolButton3: TToolButton;
    ZoomUser: TToolButton;
    ZoomIn: TToolButton;
    ZoomOut: TToolButton;
    ToolButton7: TToolButton;
    ToolButton11: TToolButton;
    Indicators: TToolButton;
    ActionManager1: TActionManager;
    PopupMenu1: TPopupMenu;
    IFRIndicator: TAction;
    IFR1: TMenuItem;
    StochasticOscIndicator: TAction;
    StochasticOscIndicator1: TMenuItem;
    BollingerBandsIndicator: TAction;
    SimpleMovingAverageIndicator: TAction;
    ExponentialMovingAverageIndicator: TAction;
    ParabolicSARIndicator: TAction;
    TrixIndicator: TAction;
    WilliamsPctIndicator: TAction;
    OnBalanceVolIndicator: TAction;
    MacdIndicator: TAction;
    BandasdeBollinger1: TMenuItem;
    MdiaExponencial1: TMenuItem;
    MdiaAritmtica1: TMenuItem;
    MACD1: TMenuItem;
    OBV1: TMenuItem;
    Parablico1: TMenuItem;
    Estocstico1: TMenuItem;
    WilliansR1: TMenuItem;
    PopupMenu2: TPopupMenu;
    AlterarPeriodo1: TMenuItem;
    N1: TMenuItem;
    Zoom1: TMenuItem;
    Zoon1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Indicadores1: TMenuItem;
    Panel1: TPanel;
    LbDate: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    LbOpen: TLabel;
    LbHigh: TLabel;
    Label4: TLabel;
    LbLow: TLabel;
    Label8: TLabel;
    LbClose: TLabel;
    Label10: TLabel;
    ColorBox1: TColorBox;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    StockChartX1: TStockChartX;
    Panel3: TPanel;
    Panel4: TPanel;
    TrendLine: TAction;
    ToolButton4: TToolButton;
    PopupMenu3: TPopupMenu;
    rendLines1: TMenuItem;
    Elipse: TAction;
    Rectangle: TAction;
    SpeedLines: TAction;
    Gannfan: TAction;
    Elipse1: TMenuItem;
    Rectangle1: TMenuItem;
    SpeedLines1: TMenuItem;
    Gannfan1: TMenuItem;
    FibonacciArcs: TAction;
    FibonacciFan: TAction;
    FibonacciRetracements: TAction;
    FibonacciTimeZones: TAction;
    TironeLevels: TAction;
    QuadrantLines: TAction;
    RaffRegression: TAction;
    ErrorChannels: TAction;
    FibonacciArcs1: TMenuItem;
    FibonacciFan1: TMenuItem;
    FibonacciRetracements1: TMenuItem;
    FibonacciTimeZones1: TMenuItem;
    ironeLevels1: TMenuItem;
    QuadrantLines1: TMenuItem;
    RaffRegression1: TMenuItem;
    ErrorChannels1: TMenuItem;
    BandasdeBollinger2: TMenuItem;
    ResetarZoom1: TMenuItem;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton12: TToolButton;
    Panel5: TPanel;
    Edit1: TEdit;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ComboBox1: TComboBox;
    IdTCPClient1: TIdTCPClient;
    procedure Timer1Timer(Sender: TObject);
    procedure CrossClick(Sender: TObject);
    procedure ZoomUserClick(Sender: TObject);
    procedure ZoomInClick(Sender: TObject);
    procedure ZoomOutClick(Sender: TObject);
    procedure IFRIndicatorExecute(Sender: TObject);
    procedure StochasticOscIndicatorExecute(Sender: TObject);
    procedure BollingerBandsIndicatorExecute(Sender: TObject);
    procedure ExponentialMovingAverageIndicatorExecute(Sender: TObject);
    procedure MacdIndicatorExecute(Sender: TObject);
    procedure OnBalanceVolIndicatorExecute(Sender: TObject);
    procedure WilliamsPctIndicatorExecute(Sender: TObject);
    procedure TrixIndicatorExecute(Sender: TObject);
    procedure ParabolicSARIndicatorExecute(Sender: TObject);
    procedure SimpleMovingAverageIndicatorExecute(Sender: TObject);
    procedure StockChartX1KeyUp(ASender: TObject; nChar, nRepCnt,
      nFlags: SmallInt);
    procedure FormCreate(Sender: TObject);
    procedure ArrowClick(Sender: TObject);
    procedure Zoom1Click(Sender: TObject);
    procedure Zoon1Click(Sender: TObject);
    procedure Indicadores1Click(Sender: TObject);
    procedure StockChartX1MouseMove(ASender: TObject; X, Y, Record_: Integer);
    procedure StockChartX1UserDrawingComplete(ASender: TObject;
      StudyType: TOleEnum; const Name: WideString);
    procedure ColorBox1Change(Sender: TObject);
    procedure StockChartX1Paint(ASender: TObject; Panel: Integer);
    procedure FormResize(Sender: TObject);
    procedure AlterarPeriodo1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TrendLineExecute(Sender: TObject);
    procedure ElipseExecute(Sender: TObject);
    procedure RectangleExecute(Sender: TObject);
    procedure SpeedLinesExecute(Sender: TObject);
    procedure GannfanExecute(Sender: TObject);
    procedure FibonacciArcsExecute(Sender: TObject);
    procedure FibonacciFanExecute(Sender: TObject);
    procedure FibonacciRetracementsExecute(Sender: TObject);
    procedure FibonacciTimeZonesExecute(Sender: TObject);
    procedure TironeLevelsExecute(Sender: TObject);
    procedure QuadrantLinesExecute(Sender: TObject);
    procedure RaffRegressionExecute(Sender: TObject);
    procedure ErrorChannelsExecute(Sender: TObject);
    procedure BandasdeBollinger2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ResetarZoom1Click(Sender: TObject);
    procedure StockChartX1SelectSeries(ASender: TObject;
      const Name: WideString);
    procedure ToolButton13Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    { Private declarations }

    CrossHairStock:Boolean;
    IncLines: Integer;
    IncIndicators : Integer;
    procedure UpdateChartValue;
    procedure ChangePeriodo(const PreValue:String = '15');
  public
    { Public declarations }
    PeriodoChart : Integer;
    DrawingLine: Boolean;
    RangeEnd: Boolean;
    FTime: String;
    FValue: Double;
    FLastTime:String;
    FMax,FMin : Double;
    FName:String;
    procedure UpdateStockChart;
    procedure LoadData(ASymbol:String);
    procedure AddCandle(Date,Hour,Open,High,Low,Close:String);
    procedure UpdateLastCandle(Date, Hour, Index, Value:String);
  end;

var
  FrmChart: TFrmChart;

implementation

uses Unit1, UFrmChangePeriodo, Unit2;

{$R *.dfm}

procedure TFrmChart.ElipseExecute(Sender: TObject);
begin
  Inc(IncLines);
  DrawingLine:=True;
  StockChartX1.DrawLineStudy(lsEllipse, Format('%d',[IncLines]));
end;

procedure TFrmChart.ErrorChannelsExecute(Sender: TObject);
begin
  Inc(IncLines);
  DrawingLine:=True;
  StockChartX1.DrawLineStudy(lsErrorChannel, Format('%d',[IncLines]));
end;

procedure TFrmChart.ExponentialMovingAverageIndicatorExecute(Sender: TObject);
begin
  DrawingLine:=True;
  Inc(IncIndicators);
  StockChartX1.AddIndicatorSeries(indExponentialMovingAverage, 'Media Exp-'+IntToStr(IncIndicators), 0, True);
  StockChartX1.Update;
end;

procedure TFrmChart.FibonacciArcsExecute(Sender: TObject);
begin
  Inc(IncLines);
  DrawingLine:=True;
  StockChartX1.DrawLineStudy(lsFibonacciArcs, Format('%d',[IncLines]));
end;

procedure TFrmChart.FibonacciFanExecute(Sender: TObject);
begin
  Inc(IncLines);
  DrawingLine:=True;
  StockChartX1.DrawLineStudy(lsFibonacciFan, Format('%d',[IncLines]));
end;

procedure TFrmChart.FibonacciRetracementsExecute(Sender: TObject);
begin
  Inc(IncLines);
  DrawingLine:=True;
  StockChartX1.DrawLineStudy(lsFibonacciRetracements, Format('%d',[IncLines]));
end;

procedure TFrmChart.FibonacciTimeZonesExecute(Sender: TObject);
begin
  Inc(IncLines);
  DrawingLine:=True;
  StockChartX1.DrawLineStudy(lsFibonacciTimeZones, Format('%d',[IncLines]));
end;

procedure TFrmChart.FormClose(Sender: TObject; var Action: TCloseAction);
begin
// FrmChartMain.DelChart(Self);
end;

procedure TFrmChart.FormCreate(Sender: TObject);
var Thrd:TReadData;
begin
 FMax:=0;
 FMin:=0;
 IncIndicators:=0;
 try
   IdTCPClient1.Connect;
   if IdTCPClient1.Connected then
   begin
     Thrd:=TReadData.Create(True);
     Thrd.Tcp:=IdTCPClient1;
     Thrd.Frm:=Self;
     Thrd.Start;
   end;
 except on E: Exception do
  ShowMessage('Não foi possível estabelecer uma comunicação com o servidor.');
 end;
end;

procedure TFrmChart.FormResize(Sender: TObject);
begin
 Panel3.Left:= Self.Width - ( Panel3.Width + 15);
 Panel4.Top:= Self.Height - ( StockChartX1.Top + 6 );
end;

procedure TFrmChart.FormShow(Sender: TObject);
begin
// StockChartX1.SetFocus;
end;

procedure TFrmChart.GannfanExecute(Sender: TObject);
begin
  Inc(IncLines);
  DrawingLine:=True;
  StockChartX1.DrawLineStudy(lsGannFan, Format('%d',[IncLines]));
end;

procedure TFrmChart.AddCandle(Date, Hour, Open, High, Low, Close: String);
var  Y,M,D:Integer;
     H,MM,SS:Integer;
     JDate:Double;
      fle: TextFile;
  Line: string;
  filename:string;
begin
  Y:=StrToIntDef(Copy(Date,1,4),0);
//      ShowMessage(Format('Ano: %d',[Y]));
      M:=StrToIntDef(Copy(Date,5,2),0);
//      ShowMessage(Format('Mês: %d',[M]));
      D:=StrToIntDef(Copy(Date,7,2),0);
//      ShowMessage(Format('Dia: %d',[D]));

//      ShowMessage(Data[1]);
      H:=StrToIntDef(Copy(Hour,1,2),0);
//      ShowMessage(Format('Hora: %d',[H]));
      MM:=StrToIntDef(Copy(Hour,3,2),0);
//      ShowMessage(Format('Minuto: %d',[MM]));
      SS:=StrToIntDef(Copy(Hour,5,2),0);
//      ShowMessage(Format('Segundos: %d',[SS]));

      JDate:=Self.StockChartX1.ToJulianDate(Y,M,D,H,MM,SS);

      Open:=AnsiReplaceStr(Open,'.',',');
      High:=AnsiReplaceStr(High,'.',',');
      Low:=AnsiReplaceStr(Low,'.',',');
      Close:=AnsiReplaceStr(Close,'.',',');

      if (Open<>'0,00') and (High<>'0,00') and (Low<>'0,00') and (Close<>'0,00') then
      begin
        Self.StockChartX1.AppendValue( StockChartX1.Symbol + '.open', JDate, StrToFloat(Open) );
        Self.StockChartX1.AppendValue( StockChartX1.Symbol+ '.high', JDate, StrToFloat(High) );
        Self.StockChartX1.AppendValue(StockChartX1.Symbol + '.low', JDate, StrToFloat(Low) );
        Self.StockChartX1.AppendValue( StockChartX1.Symbol + '.close', JDate, StrToFloat(Close) );

        filename:=FName;
        AssignFile( fle, filename );
        if FileExists(FName) then
        Append(fle)
        else
        Rewrite(fle);

        Line:=Date+';'+Hour+';'+Open+';'+High+';'+Low+';'+Close+';0.00';
        Writeln(fle,Line);
        CloseFile(fle);
      end;
end;

procedure TFrmChart.AlterarPeriodo1Click(Sender: TObject);
begin
 ChangePeriodo;
end;

procedure TFrmChart.ArrowClick(Sender: TObject);
begin
  CrossHairStock:=False;
  StockChartX1.CrossHairs:=False;
//  Panel1.Visible:=False;
  Panel3.Visible:=False;
  Panel4.Visible:=False;
end;

procedure TFrmChart.BandasdeBollinger2Click(Sender: TObject);
var Ptns:TPoint;
begin
  GetCursorPos(Ptns);
  PopupMenu3.Popup(Ptns.X,Ptns.Y);
end;

procedure TFrmChart.BollingerBandsIndicatorExecute(Sender: TObject);
begin
  DrawingLine:=True;
  Inc(IncIndicators);
  StockChartX1.AddIndicatorSeries(indBollingerBands, 'Bol-'+IntToStr(IncIndicators), 0, True);
  StockChartX1.Update;
end;

procedure TFrmChart.IFRIndicatorExecute(Sender: TObject);
var PanelAdd:Integer;
begin
  DrawingLine:=True;
  Inc(IncIndicators);
  PanelAdd:=StockChartX1.AddChartPanel;
  StockChartX1.AddIndicatorSeries(indRelativeStrengthIndex, 'IFR-'+IntToStr(IncIndicators), PanelAdd, True);
  StockChartX1.Update;
end;

procedure TFrmChart.Indicadores1Click(Sender: TObject);
var Ptns:TPoint;
begin
  GetCursorPos(Ptns);
  PopupMenu1.Popup(Ptns.X,Ptns.Y);
end;

procedure TFrmChart.LoadData(ASymbol: String);
var
  panel: integer;
  row: integer;
  s: string;
  fle: TextFile;
  Line: string;
  filename:string;
  Data:TStrings;
  Y,M,D:Integer;
  H,MM,SS:Integer;
  JDate:Double;
  LastDate,LastHour:String;
begin
try
  { Save the current FPU state and then disable FPU exceptions }
  Saved8087CW := Default8087CW;
  Set8087CW($133f); { Disable all fpu exceptions }

  StockChartX1.RemoveAllSeries;

  // Configura o ativo a ser solicitado
  Self.StockChartX1.Symbol := ASymbol;

  // Configura o periodo solicitado
  case ComboBox1.ItemIndex of
    0: PeriodoChart:=1;
    1: PeriodoChart:=5;
    2: PeriodoChart:=10;
    3: PeriodoChart:=15;
    4: PeriodoChart:=30;
    5: PeriodoChart:=-1;
  end;

  // First add a panel (chart area) for the OHLC data:
  panel := Self.StockChartX1.AddChartPanel;

  //Now add the open, high, low and close series to that panel:
  Self.StockChartX1.AddSeries( StockChartX1.Symbol + '.open', stCandleChart, panel );
  Self.StockChartX1.AddSeries( StockChartX1.Symbol + '.high', stCandleChart, panel );
  Self.StockChartX1.AddSeries( StockChartX1.Symbol + '.low', stCandleChart, panel );
  Self.StockChartX1.AddSeries( StockChartX1.Symbol + '.close', stCandleChart, panel );

    //Change the color:
    Self.StockChartX1.SeriesColor[ StockChartX1.Symbol + '.close' ] := clGreen;

    //Add the volume chart panel
//    panel := Self.StockChartX1.AddChartPanel;
//    Self.StockChartX1.AddSeries(StockChartX1.Symbol + '.volume', stVolumeChart, panel);

    //Change volume color and weight of the volume panel:
//    Self.StockChartX1.SeriesColor[ StockChartX1.Symbol + '.volumne' ] := clBlue;
//    Self.StockChartX1.SeriesWeight[ StockChartX1.Symbol + '.volumne' ] := 3;

    //Resize the volume panel to make it smaller
    Self.StockChartX1.PanelY1[ 1 ] := Self.StockChartX1.PanelY1[ 1 ] + 100;//like in VC example

    // Monta Caminho para arquivo de dados
    if PeriodoChart<>-1 then
    filename:=ExtractFilePath(ParamStr(0)) + '/data/'+StockChartX1.Symbol+'.'+IntTostr(PeriodoChart)
    else
    filename:=ExtractFilePath(ParamStr(0)) + '/data/'+StockChartX1.Symbol+'.d';

    Form1.Memo1.Lines.Add('Verificando: ' + filename);

    FName:=filename;

    if FileExists(filename) then
    begin
      Data:=TStringList.Create;
      AssignFile( fle, filename );
      Reset( fle );
      while not eof(fle) do
      begin
        ReadLn( fle, Line );
        Data.Clear;
        SplitColumns(Line,Data,';');

        LastDate:=Data[0];
        LastHour:=Data[1];
  //      ShowMessage(Data[0]);
        Y:=StrToIntDef(Copy(Data[0],1,4),0);
  //      ShowMessage(Format('Ano: %d',[Y]));
        M:=StrToIntDef(Copy(Data[0],5,2),0);
  //      ShowMessage(Format('Mês: %d',[M]));
        D:=StrToIntDef(Copy(Data[0],7,2),0);
  //      ShowMessage(Format('Dia: %d',[D]));

  //      ShowMessage(Data[1]);
        H:=StrToIntDef(Copy(Data[1],1,2),0);
  //      ShowMessage(Format('Hora: %d',[H]));
        MM:=StrToIntDef(Copy(Data[1],3,2),0);
  //      ShowMessage(Format('Minuto: %d',[MM]));
        SS:=StrToIntDef(Copy(Data[1],5,2),0);
  //      ShowMessage(Format('Segundos: %d',[SS]));

        JDate:=Self.StockChartX1.ToJulianDate(Y,M,D,H,MM,SS);

        Self.StockChartX1.AppendValue( StockChartX1.Symbol + '.open', JDate, StrToFloat(Data[2]) );
        Self.StockChartX1.AppendValue( StockChartX1.Symbol + '.high', JDate, StrToFloat(Data[3]) );
        Self.StockChartX1.AppendValue( StockChartX1.Symbol + '.low', JDate, StrToFloat(Data[4]) );
        Self.StockChartX1.AppendValue( StockChartX1.Symbol + '.close', JDate, StrToFloat(Data[5]) );
  //      Self.StockChartX1.AppendValue( StockChartX1.Symbol + '.volume',JDate, 0 );
      end;

      CloseFile(fle);

      if IdTCPClient1.Connected then
       if PeriodoChart<>-1 then
        IdTCPClient1.IOHandler.WriteLn('chart request '+StockChartX1.Symbol+' since '+LastDate+':'+LastHour+' intraday '+IntToStr(PeriodoChart))
       else
        IdTCPClient1.IOHandler.WriteLn('chart request '+StockChartX1.Symbol+' since '+LastDate+':'+LastHour+' daily');

    end
    else
    begin
      if IdTCPClient1.Connected then
       if PeriodoChart<>-1 then
        IdTCPClient1.IOHandler.WriteLn('chart request '+StockChartX1.Symbol+' since 20101201 intraday '+IntToStr(PeriodoChart))
       else
        IdTCPClient1.IOHandler.WriteLn('chart request '+StockChartX1.Symbol+' since 20101201 daily');
    end;

    {Candle}
     StockChartX1.SeriesColor[StockChartX1.Symbol+'.close']:= clWhite;
     StockChartX1.UpColor  := clLime;
     StockChartX1.DownColor:= clRed;
     {Volume}
     StockChartX1.SeriesColor[StockChartX1.Symbol+'.volume'] := clWhite;
     StockChartX1.SeriesWeight[StockChartX1.Symbol+'.volume']:= 2;
     {Fundo}
     StockChartX1.ChartBackColor:= clBlack;
     StockChartX1.ChartForeColor:= clWhite;
    //  StockChartX1.Gridcolor     := clLime;
     {Janelas}
     StockChartX1.DisplayTitleBorder:= False;
     {Grid}
     StockChartX1.XGrid:= True;
     StockChartX1.YGrid:= True;
     StockChartX1.ThreeDStyle:= True;

     StockChartX1.DisplayTitles:= True;
     StockChartX1.RightDrawingSpacePixels:= 5;
//     FrmMain.DaileonFW.IOHandler.WriteLn('intraday range ' + LowerCase( FormChange.Caption) + ' ' + FormatDateTime('yyyymmdd',Today) +' ' + FormatDateTime('yyyymmdd',Today) + ' ' + LabeledStockChartX1.Symbol);

     Self.FTime:='';
     Self. FValue:=0;
//     Self.PeriodoChart:=PeriodoChart;
     Self.FMax:=StockChartX1.GetMaxValue(StockChartX1.Symbol + '.close');
     Self.FMin:=StockChartX1.GetMinValue(StockChartX1.Symbol + '.close');


    //Update the chart
    Self.StockChartX1.Update;


    Self.Panel5.Caption:='Atualizando sua base histórica...';
except on E:Exception do Form1.Memo1.Lines.Add(E.Message);

end;
end;

procedure TFrmChart.MacdIndicatorExecute(Sender: TObject);
var PanelAdd:Integer;
begin
  DrawingLine:=True;
  Inc(IncIndicators);
  PanelAdd:=StockChartX1.AddChartPanel;
  StockChartX1.AddIndicatorSeries(indMACD, 'MACD-'+IntToStr(IncIndicators), PanelAdd, True);
  StockChartX1.Update;
end;

procedure TFrmChart.OnBalanceVolIndicatorExecute(Sender: TObject);
var PanelAdd:Integer;
begin
  DrawingLine:=True;
  Inc(IncIndicators);
  PanelAdd:=StockChartX1.AddChartPanel;
  StockChartX1.AddIndicatorSeries(indOnBalanceVolume, 'OBV-'+IntToStr(IncIndicators), PanelAdd, True);
  StockChartX1.Update;
end;

procedure TFrmChart.ParabolicSARIndicatorExecute(Sender: TObject);
begin
  DrawingLine:=True;
  Inc(IncIndicators);
  StockChartX1.AddIndicatorSeries(indParabolicSAR, 'Parabolico-'+IntToStr(IncIndicators), 0, True);
  StockChartX1.Update;
end;

procedure TFrmChart.QuadrantLinesExecute(Sender: TObject);
begin
  Inc(IncLines);
  DrawingLine:=True;
  StockChartX1.DrawLineStudy(lsQuadrantLines, Format('%d',[IncLines]));
end;

procedure TFrmChart.RaffRegressionExecute(Sender: TObject);
begin
  Inc(IncLines);
  DrawingLine:=True;
  StockChartX1.DrawLineStudy(lsRaffRegression, Format('%d',[IncLines]));
end;

procedure TFrmChart.RectangleExecute(Sender: TObject);
begin
  Inc(IncLines);
  DrawingLine:=True;
  StockChartX1.DrawLineStudy(lsRectangle, Format('%d',[IncLines]));
end;

procedure TFrmChart.ResetarZoom1Click(Sender: TObject);
begin
 StockChartX1.ResetZoom;
end;

procedure TFrmChart.SimpleMovingAverageIndicatorExecute(Sender: TObject);
begin
  DrawingLine:=True;
  Inc(IncIndicators);
  StockChartX1.AddIndicatorSeries(indSimpleMovingAverage, 'Media Ari-'+IntToStr(IncIndicators), 0, True);
  StockChartX1.Update;
end;

procedure TFrmChart.SpeedLinesExecute(Sender: TObject);
begin
  Inc(IncLines);
  DrawingLine:=True;
  StockChartX1.DrawLineStudy(lsSpeedLines, Format('%d',[IncLines]));
end;

procedure TFrmChart.StochasticOscIndicatorExecute(Sender: TObject);
var PanelAdd:Integer;
begin
  DrawingLine:=True;
  Inc(IncIndicators);
  PanelAdd:=StockChartX1.AddChartPanel;
  StockChartX1.AddIndicatorSeries(indStochasticOscillator, 'Estocastico-'+IntToStr(IncIndicators), PanelAdd, True);
  StockChartX1.Update;
end;

procedure TFrmChart.StockChartX1KeyUp(ASender: TObject; nChar, nRepCnt,
  nFlags: SmallInt);
begin
// ShowMessage(IntToStr(nChar));
 case nChar of
   33: // PageUp
   begin
     if FMax = 0 then
     FMax:= StockChartX1.GetMaxValue(Self.Caption+'.close')
     else
     FMax:= FMax + ( (FMax + FMin) / 100 );

     if FMin = 0 then
     FMin:=StockChartX1.GetMinValue(Self.Caption+'.close')
     else
    FMin:=Fmin - ( (FMax + FMin) / 100 );

     StockChartX1.SetYScale(0,FMax,FMin);
   end;
   34:  //PgDown
   begin
     if FMax = 0 then
     FMax:= StockChartX1.GetMaxValue(Self.Caption+'.close')
     else
     FMax:= FMax - ( (FMax + FMin) / 100 );

     if FMin = 0 then
     FMin:=StockChartX1.GetMinValue(Self.Caption+'.close')
     else
     FMin:=Fmin + ( (FMax + FMin) / 100 );

     StockChartX1.SetYScale(0,FMax,FMin);
   end;
   35 : // End
   begin
     StockChartX1.ResetZoom;
     FMin:= StockChartX1.GetMinValue(Self.Caption+'.close');
     FMax:= StockChartX1.GetMaxValue(Self.Caption+'.close');
     StockChartX1.SetYScale(0, FMax, FMin);
   end;
   38:  // Seta Cima
   begin
     FMax:= FMax + 3;
     FMin:= FMin + 3;
     StockChartX1.SetYScale(0,FMax,FMin);
     StockChartX1.Update;
   end;
   40:   // Seta Baixo
   begin
     FMax:= FMax - 3;
     FMin:= FMin - 3;
     StockChartX1.SetYScale(0,FMax,FMin);
     StockChartX1.Update;
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
         end;
       DrawingLine:=False;
     end;
   end;
   48..57: // Num 0 - 9 teclado normal
   begin
     ChangePeriodo(Chr(nChar));
   end;
   96..105: // Num 0 - 9 teclado numerico
   begin
     case nChar of
       96: ChangePeriodo('0');
       97: ChangePeriodo('1');
       98: ChangePeriodo('2');
       99: ChangePeriodo('3');
       100: ChangePeriodo('4');
       101: ChangePeriodo('5');
       102: ChangePeriodo('6');
       103: ChangePeriodo('7');
       104: ChangePeriodo('8');
       105: ChangePeriodo('9');
     end;
   end;
   67: // C
   begin
     CrossClick(Self);
   end;
   68: // D
   begin
     ChangePeriodo('D');
   end;
   90: // Z
   begin
     ZoomUserClick(Self);
   end;
   107: // +
   begin
      ZoomInClick(Self);
   end;
   109: // -
   begin
     ZoomOutClick(Self);
   end;

 end;

 StockChartX1.SetFocus;
end;

procedure TFrmChart.StockChartX1MouseMove(ASender: TObject; X, Y,
  Record_: Integer);
begin

 if ( CrossHairStock )and ( not StockChartX1.CrossHairs ) then
 StockChartX1.CrossHairs:=True;

 try
     LbDate.Caption:=FormatDateTime('dd/mm/yyyy',StrToDateTime( StockChartX1.FromJulianDate(StockChartX1.GetJDate(StockChartX1.Symbol+'.close', Record_)))) + ' / ' +
                   FormatDateTime('hh:mm:ss',StrToDateTime( StockChartX1.FromJulianDate(StockChartX1.GetJDate(StockChartX1.Symbol+'.close', Record_))));

     LbOpen.Caption:= FormatFloat('0.00',Self.StockChartX1.GetValue(StockChartX1.Symbol+'.open',Record_));
     LbHigh.Caption:= FormatFloat('0.00',Self.StockChartX1.GetValue(StockChartX1.Symbol+'.high',Record_));
     LbLow.Caption:= FormatFloat('0.00',Self.StockChartX1.GetValue(StockChartX1.Symbol+'.low',Record_));
     LbClose.Caption:= FormatFloat('0.00',Self.StockChartX1.GetValue(StockChartX1.Symbol+'.close',Record_));
 except
   Abort;
 end;

 if CrossHairStock then
 begin
   try
     Panel3.Caption:=FormatFloat('0.00', StockChartX1.GetYValueByPixel(Y) );
     Panel4.Caption:=FormatDateTime('hh:mm:ss',StrToDateTime( StockChartX1.FromJulianDate(StockChartX1.GetJDate(StockChartX1.Symbol+'.close', Record_))));
     Panel3.Top:=Y + StockChartX1.Top;
     Panel4.Left:=X - ( Panel4.Width div 2 );
   except
    Abort;
   end;

 end;

end;

procedure TFrmChart.StockChartX1Paint(ASender: TObject; Panel: Integer);
var
  tick: extended;
  p: integer;
begin
  //See if this Panel is the one with the OHLC bar chart
  p := StockChartX1.GetPanelBySeriesName('PETR4.close');
  if p <> panel then
    exit;

  //Show the real-time tick box
  if StockChartX1.RealTimeXLabels then
  begin
    tick := StockChartX1.GetValue('PETR4.close', StockChartX1.LastVisibleRecord);
    StockChartX1.ShowLastTick ('PETR4.close', tick );
  end;
end;

procedure TFrmChart.StockChartX1SelectSeries(ASender: TObject;
  const Name: WideString);
begin
  DrawingLine:=True;
end;

procedure TFrmChart.StockChartX1UserDrawingComplete(ASender: TObject;
  StudyType: TOleEnum; const Name: WideString);
begin
  DrawingLine:=False;
end;

procedure TFrmChart.Timer1Timer(Sender: TObject);
begin
 if FTime <> '' then
 if not DrawingLine then
 UpdateChartValue;
end;

procedure TFrmChart.TironeLevelsExecute(Sender: TObject);
begin
  Inc(IncLines);
  DrawingLine:=True;
  StockChartX1.DrawLineStudy(lsTironeLevels, Format('%d',[IncLines]));
end;

procedure TFrmChart.ToolButton13Click(Sender: TObject);
begin
  if Edit1.Text='SHOWMELOG' then
  Form1.Show
  else
  LoadData(Edit1.Text);
end;

procedure TFrmChart.ToolButton2Click(Sender: TObject);
begin
// ChangePeriodo;
  Form1.Show;
end;

procedure TFrmChart.ChangePeriodo(const PreValue:String);
begin
  FrmChangePeriodo.FormChange:=Self;
  FrmChangePeriodo.SetPreValue(PreValue);
  FrmChangePeriodo.ShowModal;
end;

procedure TFrmChart.ColorBox1Change(Sender: TObject);
begin
  Self.StockChartX1.LineColor:=ColorBox1.Selected;
end;

procedure TFrmChart.ComboBox1Change(Sender: TObject);
begin
  if StockChartX1.Symbol<>'' then
  LoadData(StockChartX1.Symbol);
end;

procedure TFrmChart.CrossClick(Sender: TObject);
begin
 CrossHairStock:= True;
 StockChartX1.CrossHairs:=True;
// Panel1.Visible:=True;
 Panel3.Visible:=True;
 Panel4.Visible:=True;
end;

procedure TFrmChart.ZoomUserClick(Sender: TObject);
begin
  StockChartX1.ZoomUserDefined;
end;

procedure TFrmChart.Zoon1Click(Sender: TObject);
begin
 ZoomOutClick(Self);
end;

procedure TFrmChart.Zoom1Click(Sender: TObject);
begin
 ZoomInClick(Self);
end;

procedure TFrmChart.ZoomInClick(Sender: TObject);
begin
 StockChartX1.ZoomIn(5);
 StockChartX1.ScrollRight(5);
end;

procedure TFrmChart.ZoomOutClick(Sender: TObject);
begin
 StockChartX1.ZoomOut(5);
 StockChartX1.ScrollLeft(5);
end;

procedure TFrmChart.TrendLineExecute(Sender: TObject);
begin
  Inc(IncLines);
  DrawingLine:=True;
  StockChartX1.DrawLineStudy(lsTrendLine, Format('%d',[IncLines]));
end;

procedure TFrmChart.TrixIndicatorExecute(Sender: TObject);
var PanelAdd:Integer;
begin
  DrawingLine:=True;
  Inc(IncIndicators);
  PanelAdd:=StockChartX1.AddChartPanel;
  StockChartX1.AddIndicatorSeries(indTRIX, 'Trix-'+IntToStr(IncIndicators), PanelAdd, True);
  StockChartX1.Update;
end;

procedure TFrmChart.UpdateChartValue;
var HourT,MinuteT: String;
    HourL,MinuteL: String;
    NewJulianDate:Double;
    HighV,LowV:Double;
    EHT, EHL : TDateTime;
begin
  if (FTime <> '') and (FLastTime<>'') and ( PeriodoChart > 0 ) then
  begin

  HourT:=Copy(FTime,1,2);
  MinuteT:=Copy(FTime,3,2);

  HourL:=Copy(FLastTime,1,2);
  MinuteL:=Copy(FLastTime,3,2);

  EHT:= EncodeTime(StrToInt( HourT ) , StrToInt( MinuteT ),00,00);
  EHL:= EncodeTime(StrToInt( HourL ) , StrToInt( MinuteL ),00,00);

  EHL:= IncMinute(EHL,PeriodoChart);

  if EHT >= EHL then
  begin
    FLastTime:=FTime;
    NewJulianDate:=Self.StockChartX1.ToJulianDate(YearOf(Today),MonthOf(Today),DayOf(Today),StrToInt(HourT),StrToInt(MinuteT),00);
    Self.StockChartX1.AppendValue(StockChartX1.Symbol+'.open',NewJulianDate,FValue);
    Self.StockChartX1.AppendValue(StockChartX1.Symbol+'.close',NewJulianDate,FValue);
    Self.StockChartX1.AppendValue(StockChartX1.Symbol+'.high',NewJulianDate,FValue);
    Self.StockChartX1.AppendValue(StockChartX1.Symbol+'.low',NewJulianDate,FValue);
  end
  else
  begin
    HighV:=Self.StockChartX1.GetValue(StockChartX1.Symbol+'.high',Self.StockChartX1.RecordCount);
    LowV:=Self.StockChartX1.GetValue(StockChartX1.Symbol+'.low',Self.StockChartX1.RecordCount);

    if FValue > HighV then
    Self.StockChartX1.EditValueByRecord(StockChartX1.Symbol+'.high',Self.StockChartX1.RecordCount,FValue);

    if FValue < LowV then
    Self.StockChartX1.EditValueByRecord(StockChartX1.Symbol+'.low',Self.StockChartX1.RecordCount,FValue);

    Self.StockChartX1.EditValueByRecord(StockChartX1.Symbol+'.close',Self.StockChartX1.RecordCount,FValue);
  end;

  UpdateStockChart;

  end;

end;

procedure TFrmChart.UpdateLastCandle(Date, Hour, Index, Value: String);
var  Y,M,D:Integer;
     H,MM,SS:Integer;
     JDate:Double;
     FValue:Double;
begin
     Y:=StrToIntDef(Copy(Date,1,4),0);
//      ShowMessage(Format('Ano: %d',[Y]));
      M:=StrToIntDef(Copy(Date,5,2),0);
//      ShowMessage(Format('Mês: %d',[M]));
      D:=StrToIntDef(Copy(Date,7,2),0);
//      ShowMessage(Format('Dia: %d',[D]));

//      ShowMessage(Data[1]);
      H:=StrToIntDef(Copy(Hour,1,2),0);
//      ShowMessage(Format('Hora: %d',[H]));
      MM:=StrToIntDef(Copy(Hour,3,2),0);
//      ShowMessage(Format('Minuto: %d',[MM]));
      SS:=StrToIntDef(Copy(Hour,5,2),0);
//      ShowMessage(Format('Segundos: %d',[SS]));

      JDate:=Self.StockChartX1.ToJulianDate(Y,M,D,H,MM,SS);

      Value:=AnsiReplaceStr(Value,'.',',');
      FValue:=StrToFloat(Value);

      if Index='1' then
      begin
        Self.StockChartX1.EditValueByRecord(StockChartX1.Symbol+'.open',Self.StockChartX1.RecordCount,FValue);
      end;
      if Index='2' then
      begin
        Self.StockChartX1.EditValueByRecord(StockChartX1.Symbol+'.high',Self.StockChartX1.RecordCount,FValue);
      end;
      if Index='3' then
      begin
        Self.StockChartX1.EditValueByRecord(StockChartX1.Symbol+'.low',Self.StockChartX1.RecordCount,FValue);
      end;
      if Index='4' then
      begin
        Self.StockChartX1.EditValueByRecord(StockChartX1.Symbol+'.close',Self.StockChartX1.RecordCount,FValue);
      end;

      Self.StockChartX1.Update;
end;

procedure TFrmChart.UpdateStockChart;
begin
 if not DrawingLine and RangeEnd then
 Self.StockChartX1.Update;
end;

procedure TFrmChart.WilliamsPctIndicatorExecute(Sender: TObject);
var PanelAdd:Integer;
begin
  DrawingLine:=True;
  Inc(IncIndicators);
  PanelAdd:=StockChartX1.AddChartPanel;
  StockChartX1.AddIndicatorSeries(indWilliamsPctR, 'Willians-'+IntToStr(IncIndicators), PanelAdd, True);
  StockChartX1.Update;
end;

end.
