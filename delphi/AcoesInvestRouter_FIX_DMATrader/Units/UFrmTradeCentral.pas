unit UFrmTradeCentral;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, Sheet, ExtCtrls, IdGlobal, StdCtrls;

type
  TFrmCentral = class(TForm)
    CentralSheet: TSheet;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    Row : Integer;
  public
    { Public declarations }
    procedure AddSymbol( Symbol : String);
    procedure RecallSymbols;
  end;

var
  FrmCentral: TFrmCentral;

implementation

uses UFrmMainTreeView, UThrdDaileonFwRead, UFrmTrade;

{$R *.dfm}

{ TFrmCentral }

procedure TFrmCentral.AddSymbol(Symbol: String);
begin
  CentralSheet.NewLine(Symbol);
  SignalThread.WriteLn('sqt ' + Symbol);
end;



procedure TFrmCentral.RecallSymbols;
var
  I: Integer;
begin
  if CentralSheet.RowCount >= 2 then
  begin
    for I := 1 to CentralSheet.RowCount do
    begin
      if(CentralSheet.Cells[0,I] <> '') then
      begin
        FrmMainTreeView.DaileonFW.IOHandler.WriteLn('sqt ' + CentralSheet.Cells[0,I]);
        FrmMainTreeView.DaileonFW.IOHandler.WriteBufferFlush;
      end;
    end;

  end;

end;

procedure TFrmCentral.Timer1Timer(Sender: TObject);
var Read, Value:String;
    TradeSplit:TStringList;
    Index, I:Integer;
begin
  while SignalThread.Data.Count > Row do
 begin
  Read:=SignalThread.Data.Strings[Row];

//  FrmMainTreeView.AddLogMsg('Lido: ' + Read);
//  Read:=SignalThread.GetData;

  if Read='' then exit;

//  FrmMainTreeView.AddLogMsg('Li:> ' + Read);


  if(Copy(Read,1,2) = 'T:')then
  begin
//    SignalThread.SetDataAsRead;

//    FrmMainTreeView.AddLogMsg('Tentando interpretar mensagem..');

    //Tentamos manipular
    try
      TradeSplit:=TStringList.Create;

      //Faz split dos indices
      SplitColumns(Read,TradeSplit,':');

//      FrmMainTreeView.AddLogMsg('Mensagem separada...');

      // Varre vetor dos dados
      for I := 3 to TradeSplit.Count - 1 do
      begin

//        FrmMainTreeView.AddLogMsg('Loop ( ' + IntToStr(I)+ ' )');

        // O que importa � os indices, que estao nas posicao impares
        if Odd(I) then
        begin
          // Transforma o indice em numero para fazer o case
          Index:=StrToInt(TradeSplit[I]);

//          FrmMainTreeView.AddLogMsg('Indice encontrado: ' +TradeSplit[I] );

          // Recebe o valor do indice( Proximo valor no vetor) removendo
          // o ponto de exclamacao "!" se existir. Evitamos assim
          // de fazer varias vezes isso.
          Value:=TradeSplit[I+1];

          Value:=FrmMainTreeView.ChangeDecimalSeparator(Value,'.',',');

          if Index<>8 then
          Value:= FormatFloat('0.00',StrToFloat(Value));

//          FrmMainTreeView.AddLogMsg('Valor: ' + Value );

          // Fazemos o case dos indices
          case Index of
            2: // Indice Ultimo valor
            begin
              // Atualizamos o form central
              FrmCentral.CentralSheet.SetValue(clLast,TradeSplit[1],Value);

              // Se o form de trade estiver sendo exibido, atualiza valor se existir o ativo
              FrmTrade.TradeSheet.SetValue(clLast,TradeSplit[1],Value);
//              FrmTrade.BlinkCell(clLast,TradeSplit[1],3);

//              FrmMainTreeView.AddLogMsg('Setado na coluna...');
            end; // case 2

            3: // Indice de melhor compra
            begin
              // Atualizamos o form central
              FrmCentral.CentralSheet.SetValue(clBuy,TradeSplit[1],Value);

              // Se o form de trade estiver sendo exibido, atualiza valor se existir o ativo
              FrmTrade.TradeSheet.SetValue(clBuy,TradeSplit[1],Value);
//              FrmTrade.BlinkCell(clBuy,TradeSplit[1],3);
//              FrmMainTreeView.AddLogMsg('Setado na coluna...');
            end;

            4: // Indice de melhor venda
            begin
              // Atualizamos o form central
              FrmCentral.CentralSheet.SetValue(clSell,TradeSplit[1],Value);

              FrmTrade.TradeSheet.SetValue(clSell,TradeSplit[1],Value);
//              FrmTrade.BlinkCell(clSell,TradeSplit[1],3);
//               FrmMainTreeView.AddLogMsg('Setado na coluna...');
            end;

            5: // Indice de hora
            begin
              // Atualizamos o form central
              FrmCentral.CentralSheet.SetValue(clPicture,TradeSplit[1],Value);

              FrmTrade.TradeSheet.SetValue(clVarWeek,TradeSplit[1],SignalThread.FormatTimeTrade(Value));
//             FrmMainTreeView.AddLogMsg('Setado na coluna...');
            end;

            8: // Indice de numero de negocios
            begin
              FrmCentral.CentralSheet.SetValue(clNeg,TradeSplit[1],Value);

              FrmTrade.TradeSheet.SetValue(clNeg,TradeSplit[1],Value);

            end;

            11: // Indice de maxima do dia
            begin
              FrmCentral.CentralSheet.SetValue(clMax,TradeSplit[1],Value);

              FrmTrade.TradeSheet.SetValue(clMax,TradeSplit[1],Value);
//              FrmMainTreeView.AddLogMsg('Setado na coluna...');
            end;

            12: // Indice de minima do dia
            begin
              FrmCentral.CentralSheet.SetValue(clMin,TradeSplit[1],Value);

              FrmTrade.TradeSheet.SetValue(clMin,TradeSplit[1],Value);
//              FrmMainTreeView.AddLogMsg('Setado na coluna...');
            end;

            13: // Indice de fechamento do dia anterior
            begin
              FrmCentral.CentralSheet.SetValue(clClose,TradeSplit[1],Value);

              FrmTrade.TradeSheet.SetValue(clClose,TradeSplit[1],Value);
//              FrmMainTreeView.AddLogMsg('Setado na coluna...');
            end;

            14: // Indice de abertura do dia
            begin

              FrmCentral.CentralSheet.SetValue(clOpen,TradeSplit[1],Value);

              FrmTrade.TradeSheet.SetValue(clOpen,TradeSplit[1],Value);
//               FrmMainTreeView.AddLogMsg('Setado na coluna...');
            end;

            664,700: // Oscilacao do ativo
            begin
              FrmCentral.CentralSheet.SetValue(clVar,TradeSplit[1],Value);

              FrmTrade.TradeSheet.SetValue(clVar,TradeSplit[1],Value);
//              FrmMainTreeView.AddLogMsg('Setado na coluna...');
            end;

//            665,701: // Oscilacao do ativo na semana
//            begin
//              // Atualizamos o form central
//              FrmCentral.CentralSheet.SetValue(clVarWeek,TradeSplit[1],Value);
//            end;
//
//            666,702: // Oscilacao do ativo no mes
//            begin
//              // Atualizamos o form central
//              FrmCentral.CentralSheet.SetValue(clVarMonth,TradeSplit[1],Value);
//            end;
//
//            667,703: // Oscilacao do ativo no ano
//            begin
//              // Atualizamos o form central
//              FrmCentral.CentralSheet.SetValue(clVarYear,TradeSplit[1],Value);
//            end;

          end;
        end; // if mod


      end; // for varredura

      FreeAndNil(TradeSplit);

    except
      on E: Exception do
      FrmMainTreeView.AddLogMsg('Erro ao tratar trade: ' + E.Message);
    end; // except
  end;
       {*************** FIM TRADE **********************}

    Row:=Row+1;
 end;
end;

end.
