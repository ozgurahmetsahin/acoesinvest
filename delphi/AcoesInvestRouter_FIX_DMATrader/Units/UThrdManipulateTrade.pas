unit UThrdManipulateTrade;

interface

uses
  Classes,SysUtils,IdGlobal,Sheet,Graphics,Types;

type
  TThrdManipulateTrade = class(TThread)
  private
    { Private declarations }
    Col, Row, BlinkType:integer;
    function RemoveChar(Text : String;Char : Char):String;
    function CompareValues(Value1 : String; Value2: String):Integer;
    procedure Trade(Text:String);
    procedure BlinkCell;
    function FormatTimeTrade(Time: String): String;
  protected
    procedure Execute; override;
  public
    TradeLine : String;
  end;

implementation
  uses UFrmTrade,UFrmTradeCentral,
  UFrmMainTreeView;
{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TThrdManipulateTrade.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TThrdManipulateTrade }

function TThrdManipulateTrade.FormatTimeTrade(Time: String): String;
var r: String;
begin
 try
   r:=Copy(Time,1,2);
   r:=r+':';
   r:= r + Copy(Time,3,2);
   Result:=r;
 except
   Result:='00:00';
 end;
end;

procedure TThrdManipulateTrade.BlinkCell;
var Rect:TRect;
    X:Integer;
begin

// Tentamos piscar
 try
   //Pegamos Rect da celula
   Rect:=FrmTrade.TradeSheet.CellRect(Col,Row);

   // Com o canvas, fazemos o pisca
   with FrmTrade.TradeSheet.Canvas do
   begin
      case BlinkType of
        1: // Pisca em alta
        Brush.Color:=clLime;

        2: // Pisca em baixa
        Brush.Color:=clRed;

        else Brush.Color:= clBlue; // Outro tipo (normalmente eh o 3)
      end;
      // Desenhamos o Rect na celula
      FillRect(Rect);

      // Pegamos a fonte
      Font:=FrmTrade.TradeSheet.Font;

      // Pegamos a cor da font
      if(Brush.Color <> clBlue)then
      Font.Color:=clBlack
      else
      Font.Color:=clWhite;

      // Pegamos o estilo da fonte
      Font.Style:=Font.Style + [fsBold];

      // Desenhamos à direita os valores
      X:= Rect.Left + ( ( Rect.Right - Rect.Left) - TextWidth(FrmTrade.TradeSheet.Cells[Col,Row]) - 3);
      TextRect(Rect,X ,Rect.Top + 3,FrmTrade.TradeSheet.Cells[Col,Row]);
   end; // with canvas

 except on E: Exception do
   FrmMainTreeView.Memo1.Lines.Add('Erro ao fazer blink:' + E.Message);
 end;

end;

procedure TThrdManipulateTrade.Trade(Text:String);
var TradeSplit:TStringList;
    I: Integer;
    Index:Integer;
    IsOnTradeSheet:Boolean;
    IsOnTradeCentral:Boolean;
    Value:String;
    OldValue:String;
begin
  // Analisamos se é linha de Trade
  if(Copy(Text,1,2) = 'T:')then
  begin
    //Tentamos manipular
    try
      TradeSplit:=TStringList.Create;

      //Faz split dos indices
      SplitColumns(Text,TradeSplit,':');

      // Antes de iniciar a varredura, setamos a variavel bandeira
      // para false. Ela nos ajudara a saber se existe ou nao o ativo
      // na planilha de Trade. Isso evita de fazer FindQuote toda hora.
      IsOnTradeSheet:=False;

      // Fazemos a mesma coisa para o form central
      IsOnTradeCentral := False;

      // Agora procuramos o ativo na planilha Trade
      IsOnTradeSheet:=FrmTrade.TradeSheet.FindQuote(TradeSplit[1]);

      // Mesma coisa para form central
      IsOnTradeCentral:=FrmCentral.CentralSheet.FindQuote(TradeSplit[1]);

      // Varre vetor dos dados
      for I := 3 to TradeSplit.Count - 1 do
      begin

        // O que importa é os indices, que estao nas posicao impares
        if( I mod 2 <> 0 ) then
        begin
          // Transforma o indice em numero para fazer o case
          Index:=StrToInt(TradeSplit[I]);

          // Recebe o valor do indice( Proximo valor no vetor) removendo
          // o ponto de exclamacao "!" se existir. Evitamos assim
          // de fazer varias vezes isso.
          Value:=RemoveChar(TradeSplit[I+1],'!');

          // Fazemos o case dos indices
          case Index of
            2: // Indice Ultimo valor
            begin
              // Atualizamos o form central
              if(IsOnTradeCentral)then
              FrmCentral.CentralSheet.SetValue(clLast,TradeSplit[1],Value);

              // Se o form de trade estiver sendo exibido, atualiza valor se existir o ativo
              if(IsOnTradeSheet)then
              begin
                // Pegamos o valor atual antes de atualizar para fazer a analise
                // de "pisca"
                OldValue:=FrmTrade.TradeSheet.GetValue(clLast,TradeSplit[1]);
                FrmTrade.TradeSheet.SetValue(clLast,TradeSplit[1],Value);
              end;

              // Comparamos os valores e vemos que tipo de "pisca" é.
              BlinkType:=CompareValues(Value, OldValue);

              // Pegamos a coluna e a linha da celula
              Col:=FrmTrade.TradeSheet.GetColumInteger(clLast);
              Row:=FrmTrade.TradeSheet.GetLine(TradeSplit[1]);

              // Piscamos
              Synchronize( BlinkCell );

            end; // case 2

            3: // Indice de melhor compra
            begin
              // Atualizamos o form central
              if(IsOnTradeCentral)then
              FrmCentral.CentralSheet.SetValue(clBuy,TradeSplit[1],Value);

              // Se o form de trade estiver sendo exibido, atualiza valor se existir o ativo
              if(IsOnTradeSheet)then
              begin
                // Pegamos o valor atual antes de atualizar para fazer a analise
                // de "pisca"
                OldValue:=FrmTrade.TradeSheet.GetValue(clBuy,TradeSplit[1]);
                FrmTrade.TradeSheet.SetValue(clBuy,TradeSplit[1],Value);
              end;

              // Comparamos os valores e vemos que tipo de "pisca" é.
              BlinkType:=CompareValues(Value, OldValue);

              // Pegamos a coluna e a linha da celula
              Col:=FrmTrade.TradeSheet.GetColumInteger(clBuy);
              Row:=FrmTrade.TradeSheet.GetLine(TradeSplit[1]);

              // Piscamos
              Synchronize( BlinkCell );
            end;

            4: // Indice de melhor venda
            begin
              // Atualizamos o form central
              if(IsOnTradeCentral)then
              FrmCentral.CentralSheet.SetValue(clSell,TradeSplit[1],Value);

              // Se o form de trade estiver sendo exibido, atualiza valor se existir o ativo
              if(IsOnTradeSheet)then
              begin
                // Pegamos o valor atual antes de atualizar para fazer a analise
                // de "pisca"
                OldValue:=FrmTrade.TradeSheet.GetValue(clSell,TradeSplit[1]);
                FrmTrade.TradeSheet.SetValue(clSell,TradeSplit[1],Value);
              end;

              // Comparamos os valores e vemos que tipo de "pisca" é.
              BlinkType:=CompareValues(Value, OldValue);

              // Pegamos a coluna e a linha da celula
              Col:=FrmTrade.TradeSheet.GetColumInteger(clSell);
              Row:=FrmTrade.TradeSheet.GetLine(TradeSplit[1]);

              // Piscamos
              Synchronize( BlinkCell );

            end;

            5: // Indice de hora
            begin
              // Atualizamos o form central
              if(IsOnTradeCentral)then
              FrmCentral.CentralSheet.SetValue(clPicture,TradeSplit[1],Value);

              // Se o form de trade estiver sendo exibido, atualiza valor se existir o ativo
              if(IsOnTradeSheet)then
              FrmTrade.TradeSheet.SetValue(clVarWeek,TradeSplit[1],FormatTimeTrade(Value));

            end;

            8: // Indice de numero de negocios
            begin
              // Atualizamos o form central
              if(IsOnTradeCentral)then
              FrmCentral.CentralSheet.SetValue(clNeg,TradeSplit[1],Value);

              // Se o form de trade estiver sendo exibido, atualiza valor se existir o ativo
              if(IsOnTradeSheet)then
              FrmTrade.TradeSheet.SetValue(clNeg,TradeSplit[1],Value);

              BlinkType:=3;

              // Pegamos a coluna e a linha da celula
              Col:=FrmTrade.TradeSheet.GetColumInteger(clNeg);
              Row:=FrmTrade.TradeSheet.GetLine(TradeSplit[1]);

              // Piscamos
              Synchronize( BlinkCell );

            end;

            11: // Indice de maxima do dia
            begin
              // Atualizamos o form central
              if(IsOnTradeCentral)then
              FrmCentral.CentralSheet.SetValue(clMax,TradeSplit[1],Value);

              // Se o form de trade estiver sendo exibido, atualiza valor se existir o ativo
              if(IsOnTradeSheet)then
              FrmTrade.TradeSheet.SetValue(clMax,TradeSplit[1],Value);

            end;

            12: // Indice de minima do dia
            begin
              // Atualizamos o form central
              if(IsOnTradeCentral)then
              FrmCentral.CentralSheet.SetValue(clMin,TradeSplit[1],Value);

              // Se o form de trade estiver sendo exibido, atualiza valor se existir o ativo
              if(IsOnTradeSheet)then
              FrmTrade.TradeSheet.SetValue(clMin,TradeSplit[1],Value);

            end;

            13: // Indice de fechamento do dia anterior
            begin
              // Atualizamos o form central
              if(IsOnTradeCentral)then
              FrmCentral.CentralSheet.SetValue(clClose,TradeSplit[1],Value);

              // Se o form de trade estiver sendo exibido, atualiza valor se existir o ativo
              if(IsOnTradeSheet)then
              FrmTrade.TradeSheet.SetValue(clClose,TradeSplit[1],Value);

            end;

            14: // Indice de abertura do dia
            begin
              // Atualizamos o form central
              if(IsOnTradeCentral)then
              FrmCentral.CentralSheet.SetValue(clOpen,TradeSplit[1],Value);

              // Se o form de trade estiver sendo exibido, atualiza valor se existir o ativo
              if(IsOnTradeSheet)then
              FrmTrade.TradeSheet.SetValue(clOpen,TradeSplit[1],Value);

            end;

            664,700: // Oscilacao do ativo
            begin
              // Atualizamos o form central
              if(IsOnTradeCentral)then
              FrmCentral.CentralSheet.SetValue(clVar,TradeSplit[1],Value);

              // Se o form de trade estiver sendo exibido, atualiza valor se existir o ativo
              if(IsOnTradeSheet)then
              FrmTrade.TradeSheet.SetValue(clVar,TradeSplit[1],Value);
            end;

            665,701: // Oscilacao do ativo na semana
            begin
              // Atualizamos o form central
              if(IsOnTradeCentral)then
              FrmCentral.CentralSheet.SetValue(clVarWeek,TradeSplit[1],Value);
            end;

            666,702: // Oscilacao do ativo no mes
            begin
              // Atualizamos o form central
              if(IsOnTradeCentral)then
              FrmCentral.CentralSheet.SetValue(clVarMonth,TradeSplit[1],Value);
            end;

            667,703: // Oscilacao do ativo no ano
            begin
              // Atualizamos o form central
              if(IsOnTradeCentral)then
              FrmCentral.CentralSheet.SetValue(clVarYear,TradeSplit[1],Value);
            end;

          end;
        end; // if mod


      end; // for varredura

      FreeAndNil(TradeSplit);

    except
      on E: Exception do
      FrmMainTreeView.Memo1.Lines.Add('Erro ao tratar trade: ' + E.Message);
    end; // except
  end; // if copy
end;

procedure TThrdManipulateTrade.Execute;
var TradeSplit : TStringList;
  I: Integer;
  Rect:TRect;
  Blink:Boolean;
  V:String;
begin
   Trade(TradeLine);
end;

function TThrdManipulateTrade.RemoveChar(Text : String;Char: Char):String;
var
  I: Integer;
  R : String;
begin
  R:='';
  for I := 1 to Length(Text)  do
  begin
    if(Copy(Text,I,1) <> Char) then
    begin
      R:=R + Copy(Text,I,1);
    end;
  end;

  Result:=R;
end;

function TThrdManipulateTrade.CompareValues(Value1 : String; Value2: String):Integer;
var
  I: Integer;
  R1 : String;
  R2 : String;
  v1, v2 : Double;
begin

  // Removemos os pontos
  if(Value1<>'')then
  begin
    R1:='';
    for I := 1 to Length(Value1)  do
    begin
      if(Copy(Value1,I,1) <> '.') then
      begin
        R1:=R1 + Copy(Value1,I,1);
      end else R1:= R1 + ',';
    end; // for
  end else // if value
  R1:='0,00';
  // Removemos os pontos
  if(Value2<>'')then
  begin
    R2:='';
    for I := 1 to Length(Value2)  do
    begin
      if(Copy(Value2,I,1) <> '.') then
      begin
        R2:=R2 + Copy(Value2,I,1);
      end else R2:= R2 + ',';
    end; // for
  end else // if value
  R2:='0,00';

  // Tentamos converter para float
  try
    v1:= StrToFloat(R1);
    v2:= StrToFloat(R2);

    // Comparamos
    if(v1 > v2) then Result:=1
    else if(v1 < v2) then Result:=2
    else Result:=3;

  except on E: Exception do
    Result:=3;
  end;
end;

end.
