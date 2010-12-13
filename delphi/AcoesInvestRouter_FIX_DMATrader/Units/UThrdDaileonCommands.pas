unit UThrdDaileonCommands;

interface

uses
  Classes,IdGlobal,Sheet,SysUtils,Graphics;

type
  TThrdDaileonCommands = class(TThread)
  private
    { Private declarations }
    Msg : String;
    IntraDay : TStringList;
    Open,Close,High,Low : Double;
    DateDay,HourDay:String;
    jDateValue : Double;
    ChartCount : Integer;
    SpecialChar : TStringList;
    procedure ShowMsgErr;
    procedure IntradayCmd;
  protected
    procedure Execute; override;
  public
    Data : String;
  end;

implementation
  uses UFrmMainTreeView,UFrmTradeCentral,
  UFrmCloses, UFrmTrade, UFrmTradingSystem;
{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TThrdDaileonCommands.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TThrdDaileonCommands }

procedure TThrdDaileonCommands.Execute;
var Split : TStringList;
  I: Integer;
begin
  { Place thread code here }
  try
  //Cria instancia de separacao
  Split:=TStringList.Create;

  //Quebra
  SplitColumns(Data,Split,':');

  //Verifica o comando

  FrmMainTreeView.Memo1.Lines.Add(Data);

  //Stop
  if Split[0] = 'PTNSTOP' then
  begin
   FrmCentral.CentralSheet.SetValue(clStop,Split[1],Split[2]);
  end;

  //Compra
  if Split[0] = 'PTNBUY' then
  begin
   FrmCentral.CentralSheet.SetValue(clPtnBuy,Split[1],Split[2]);
   FrmCentral.CentralSheet.SetValue(clObj1B,Split[1],Split[3]);
   FrmCentral.CentralSheet.SetValue(clObj2B,Split[1],Split[4]);
   FrmCentral.CentralSheet.SetValue(clObj3B,Split[1],Split[5]);
   FrmCentral.CentralSheet.SetValue(clObj4B,Split[1],Split[6]);
  end;

  //Venda
  if Split[0] = 'PTNSELL' then
  begin
   FrmCentral.CentralSheet.SetValue(clPtnSell,Split[1],Split[2]);
   FrmCentral.CentralSheet.SetValue(clObj1S,Split[1],Split[3]);
   FrmCentral.CentralSheet.SetValue(clObj2S,Split[1],Split[4]);
   FrmCentral.CentralSheet.SetValue(clObj3S,Split[1],Split[5]);
   FrmCentral.CentralSheet.SetValue(clObj4S,Split[1],Split[6]);
  end;

  //Maximas
  if Split[0] = 'HIGHS' then
  begin
    if FrmTradingSystem.Showing then
    begin
      if FrmTradingSystem.TradeSheet.SelectedQuote = Split[1] then
      begin
        FrmTradingSystem.Label15.Caption:=Split[2];
        FrmTradingSystem.Label16.Caption:=Split[3];
        FrmTradingSystem.Label17.Caption:=Split[4];
      end;
    end;
  end;

  //Minimas
  if Split[0] = 'LOWS' then
  begin
    if FrmTradingSystem.Showing then
    begin
      if FrmTradingSystem.TradeSheet.SelectedQuote = Split[1] then
      begin
        FrmTradingSystem.Label45.Caption:=Split[2];
        FrmTradingSystem.Label46.Caption:=Split[3];
        FrmTradingSystem.Label49.Caption:=Split[4];
      end;
    end;
  end;

  if Split[0] = 'CLOSES' then
  begin
    if Split[2] <> 'END' then
    begin
       I:=StrToInt(Split[5]);
       FrmCloses.StringGrid1.Cells[0,I]:=Copy(Split[2],7,2)+'/'+Copy(Split[2],5,2);
       FrmCloses.StringGrid1.Cells[1,I]:=FrmMainTreeView.ChangeDecimalSeparator(Split[3],'.',',');
       FrmCloses.StringGrid1.Cells[2,I]:=Split[4];
       FrmCloses.Refresh;
    end
    else
    begin
      Sleep(2500);
      for I := 2 to 30 do
      begin
        try
          FrmTradingSystem.SeriesAdd( StrToFloat(FrmCloses.StringGrid1.Cells[1,I]),FrmCloses.StringGrid1.Cells[0,I], FrmCloses.StringGrid1.Cells[2,I]);
        except
        end;
      end;
      if StrToFloat(FrmMainTreeView.ChangeDecimalSeparator( FrmCentral.CentralSheet.GetValue(clVar,Split[1]), '.',',')) < 0 then
        FrmTradingSystem.SeriesAdd( StrToFloat(FrmMainTreeView.ChangeDecimalSeparator( FrmCentral.CentralSheet.GetValue(clLast,Split[1]), '.',',')) , 'Hoje','L')
      else
        FrmTradingSystem.SeriesAdd( StrToFloat(FrmMainTreeView.ChangeDecimalSeparator( FrmCentral.CentralSheet.GetValue(clLast,Split[1]), '.',',')) , 'Hoje','H');
    end;
  end;

  if Split[0] = 'INTRADAY' then
  begin
     Synchronize(IntradayCmd);
  end;


  except
    //Por eqto nao vamos fazer nada, depois vejo isso
  end;
end;

procedure TThrdDaileonCommands.IntradayCmd;
begin
end;

procedure TThrdDaileonCommands.ShowMsgErr;
begin
  FrmMainTreeView.MsgErr:=Msg;
  FrmMainTreeView.ShowMsgErr;
end;

end.
