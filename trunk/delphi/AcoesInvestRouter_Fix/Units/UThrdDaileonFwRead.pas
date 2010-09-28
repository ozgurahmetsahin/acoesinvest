unit UThrdDaileonFwRead;

interface

uses
  Classes,SysUtils,IdException,IdExceptionCore,IdGlobal, Graphics,Sheet,
  Types;

type
  TThrdDaileonFwRead = class(TThread)
  private
    { Private declarations }
    Msg : String;
    Tib: String;
    Res: String;
    Sup : String;
    Data : String;
    DataBook : String;
    Url:String;
    Col, Row, BlinkType:integer;
    procedure ShowErr;
    procedure ShowMsg;
    procedure SynchTib;
    procedure SynchRes;
    procedure SynchSup;
    procedure SynchChart;
    procedure SynchBook;
    procedure NewVersion;
    procedure CheckLogin(Text: String);
    procedure CheckVersion(Text:String);
    procedure MiniBook(Text:String);
    function RemoveChar(Text : String;Char: Char):String;
    function CompareValues(Value1 : String; Value2: String):Integer;
    function FormatTimeTrade(Time: String): String;
    procedure BlinkCell;
    procedure SynchTrade;
  protected
    procedure Execute; override;
  public
  end;

implementation
   uses UFrmMainTreeView,UThrdManipulateTrade,
   UThrdDaileonCommands,UFrmTradingSystem,UFrmMiniBook,UThrdMiniBookManipulate, UFrmTrade,
   UFrmConnection, UFrmTradeCentral, UFrmBrokerSpeed;
{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TThrdDaileonFwRead.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TThrdDaileonFwRead }

procedure TThrdDaileonFwRead.Execute;
var Read : String;
    ManipulateTrade: TThrdManipulateTrade;
    DaileonCommand : TThrdDaileonCommands;
    ManipulateBook: TThrdMiniBookManipulate;
    Blink:Boolean;
    TradeSplit:TStringList;
    I: Integer;
    Index:Integer;
    IsOnTradeSheet:Boolean;
    IsOnTradeCentral:Boolean;
    Value:String;
    OldValue:String;
    SplitBook:TStringList;
    Line : Integer;
    K: Integer;
    Form : TFrmMiniBook;
begin
  { Place thread code here }

  FrmMainTreeView.AddLogMsg('Thread Signal Started.');
  FrmMainTreeView.ThrdSignal:=True;

  Self.Priority:=tpHighest;

  //Enquanto estiver conectado, tentar ler dados
  while FrmMainTreeView.DaileonFW.Connected do
  begin

     // Tenta ler dados do buffer
     try
       Read:= FrmMainTreeView.DaileonFW.IOHandler.ReadLn(#10);
     except
       on E: Exception do
       begin
         FrmMainTreeView.AddLogMsg('Erro ao ler dados do sinal: ' + E.Message);
         Continue; // Retorna loop ao inicio
       end;
     end; // Try read

     // Se leu alguma coisa, trata leitura
     if(Read <> '')then
     begin

       // Analisamos se a mensagem é a mensagem de LOGIN
       CheckLogin(Read);

       // Verificamos se é mensagem de verificacao de Versão.
       CheckVersion(Read);

       // Manipulamos se for Trade
//       ManipulateTrade:=TThrdManipulateTrade.Create(True);
//       ManipulateTrade.TradeLine:=Read;
//       ManipulateTrade.Resume;

       {*************** INICIO TRADE **********************}

  // Analisamos se é linha de Trade
  if(Copy(Read,1,2) = 'T:')then
  begin
    //Tentamos manipular
    try
      TradeSplit:=TStringList.Create;

      //Faz split dos indices
      SplitColumns(Read,TradeSplit,':');

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
              begin
                FrmCentral.CentralSheet.SetValue(clLast,TradeSplit[1],Value);
              end;

              // Se o form de trade estiver sendo exibido, atualiza valor se existir o ativo
              if(IsOnTradeSheet)then
              begin
                // Pegamos o valor atual antes de atualizar para fazer a analise
                // de "pisca"
                OldValue:=FrmTrade.TradeSheet.GetValue(clLast,TradeSplit[1]);
                FrmTrade.TradeSheet.SetValue(clLast,TradeSplit[1],Value);

                // Comparamos os valores e vemos que tipo de "pisca" é.
                BlinkType:=CompareValues(Value, OldValue);

                // Pegamos a coluna e a linha da celula
                Col:=FrmTrade.TradeSheet.GetColumInteger(clLast);
                Row:=FrmTrade.TradeSheet.GetLine(TradeSplit[1]);

                // Piscamos
                Synchronize( BlinkCell );
              end;

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

                // Comparamos os valores e vemos que tipo de "pisca" é.
                BlinkType:=CompareValues(Value, OldValue);

                // Pegamos a coluna e a linha da celula
                Col:=FrmTrade.TradeSheet.GetColumInteger(clBuy);
                Row:=FrmTrade.TradeSheet.GetLine(TradeSplit[1]);

                // Piscamos
                Synchronize( BlinkCell );
              end;

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

                // Comparamos os valores e vemos que tipo de "pisca" é.
                BlinkType:=CompareValues(Value, OldValue);

                // Pegamos a coluna e a linha da celula
                Col:=FrmTrade.TradeSheet.GetColumInteger(clSell);
                Row:=FrmTrade.TradeSheet.GetLine(TradeSplit[1]);

                // Piscamos
                Synchronize( BlinkCell );
              end;


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
              begin
                FrmTrade.TradeSheet.SetValue(clNeg,TradeSplit[1],Value);

                BlinkType:=3;

                // Pegamos a coluna e a linha da celula
                Col:=FrmTrade.TradeSheet.GetColumInteger(clNeg);
                Row:=FrmTrade.TradeSheet.GetLine(TradeSplit[1]);

                // Piscamos
                Synchronize( BlinkCell );
              end;

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
      FrmMainTreeView.AddLogMsg('Erro ao tratar trade: ' + E.Message);
    end; // except
  end; // if copy

       {*************** FIM TRADE **********************}

       // Manipulamos mini-book
       // Diferente do Trade, que é apenas uma planilha, o mini-book
       // pode estar em varios forms, por isso ele esta nesta thread
       // e não em uma separada.
       {**************** INICIO BOOK *******************}
       Msg:=Read;
       Synchronize(SynchBook);
//  FreeAndNil(Form);
//       // Separamos os dados
//  if(Copy(Read,1,2) = 'M:')then
//  begin
//  try
//  SplitBook:=TStringList.Create;
//  SplitColumns(Read,SplitBook,':');
//
//  FrmMainTreeView.AddLogMsg(Read);
//
//  // Varre o array que contem os forms abertos
//  for K := 1 to 20 do
//  begin
//    // Pegamos o Form para fazer manipulacao
//    Form:=FrmMainTreeView.FrmsBooks[K];
//
//    // Verificamos se há algum form na posicao do array
//    if(Form <> nil) and (Assigned(Form))then
//    begin
//
//      // Verificamos se esse form é do mesmo ativo que os dados
//      if(Form.Symbol=SplitBook[1])then
//      begin
//        // Setamos que estamos Editando o form
//        // Ver se isso ainda é necessário
//        Form.Editing:=True;
//
//        // Analisamos se é tipo A ( Adiciona )
//        if(SplitBook[2]='A')then
//        Form.AddLine(SplitBook[3], SplitBook[4], SplitBook[5], SplitBook[6], SplitBook[7]);
//
//        // Analisamos se é tipo U ( Atualiza )
//        if(SplitBook[2]='U')then
//        Form.UpdateLine(SplitBook[3], SplitBook[5], SplitBook[6], SplitBook[7], SplitBook[8]);
//
//        // Analisamos se é tipo D ( Deleta )
//        if(SplitBook[2]='D')then
//         if(SplitBook[3] <> '3')then
//         Form.DelLine(SplitBook[5], SplitBook[4], SplitBook[3]);
//
//         Form.StringGrid1.Refresh;
//
//      end; // if Form.symbol
//
//    end; // if Assigned FrmBoook[K]
//  end; // for array

  // Book Speed
//  if(FrmBrokerSpeed.Symbol = SplitBook[1])then
//  begin
//    // Analisamos se é tipo A ( Adiciona )
//        if(SplitBook[2]='A')then
//        FrmBrokerSpeed.AddLine(SplitBook[3], SplitBook[4], SplitBook[5], SplitBook[6], SplitBook[7]);
//
//        // Analisamos se é tipo U ( Atualiza )
//        if(SplitBook[2]='U')then
//        FrmBrokerSpeed.UpdateLine(SplitBook[3], SplitBook[5], SplitBook[6], SplitBook[7], SplitBook[8]);
//
//        // Analisamos se é tipo D ( Deleta )
//        if(SplitBook[2]='D')then
//        FrmBrokerSpeed.DelLine(SplitBook[5], SplitBook[4], SplitBook[3]);
//  end;

//  except
//    on E:Exception do
//    FrmMainTreeView.AddLogMsg('Erro ao manipular book: '+E.Message);
//  end;
//  end;

       {**************** FIM BOOK **********************}
       //MiniBook(Read);

//       //Caso seja ponto de stop
//       if(Copy(Read,1,8) = 'PTNSTOP:') then
//       begin
//         DaileonCommand:=TThrdDaileonCommands.Create(True);
//         DaileonCommand.Data:=Read;
//         DaileonCommand.Resume;
//       end;
//
//       //Caso seja ponto de compra
//       if(Copy(Read,1,7) = 'PTNBUY:') then
//       begin
//         DaileonCommand:=TThrdDaileonCommands.Create(True);
//         DaileonCommand.Data:=Read;
//         DaileonCommand.Resume;
//      end;
//
//      //Caso seja ponto de venda
//      if(Copy(Read,1,8) = 'PTNSELL:') then
//      begin
//        DaileonCommand:=TThrdDaileonCommands.Create(True);
//        DaileonCommand.Data:=Read;
//        DaileonCommand.Resume;
//      end;
//
//      //Caso seja maximas
//      if(Copy(Read,1,6) = 'HIGHS:') then
//      begin
//        DaileonCommand:=TThrdDaileonCommands.Create(True);
//        DaileonCommand.Data:=Read;
//        DaileonCommand.Resume;
//      end;
//
//      //Caso seja minimas
//      if(Copy(Read,1,5) = 'LOWS:') then
//      begin
//        DaileonCommand:=TThrdDaileonCommands.Create(True);
//        DaileonCommand.Data:=Read;
//        DaileonCommand.Resume;
//      end;

      //Erro de SQT
      if ( Copy(Read,1,7) = 'E:2:SQT' ) then
      begin
         FrmMainTreeView.MsgErr:='O ativo ' + Copy(Read,9,Length(Read)) + ' não existe.';
         Synchronize(FrmMainTreeView.ShowMsgErr);
         FrmMainTreeView.DelUnknowSymbol(Trim(Copy(Read,9,Length(Read))));
      end;

//         //Closes
//         if ( Copy(Read,1,7) = 'CLOSES:' ) then
//         begin
//           DaileonCommand:=TThrdDaileonCommands.Create(True);
//           DaileonCommand.Data:=Read;
//           DaileonCommand.Resume;
//         end;
//
//         //Termometro
//         if( Copy(Read,1,2) = 'I:' ) then
//         begin
//           Tib:=Read;
//           Synchronize(SynchTib);
//         end;
//
//         //Resistencia
//         if( Copy(Read,1,4) = 'RES:' ) then
//         begin
//           Res:=Read;
//           Synchronize(SynchRes);
//         end;
//
//         //Suporte
//         if( Copy(Read,1,4) = 'SUP:' ) then
//         begin
//           Sup:=Read;
//           Synchronize(SynchSup);
//         end;
//
//         //Intraday
//         if( Copy(Read,1,9) = 'INTRADAY:' ) then
//         begin
//           Data:=Read;
//           Synchronize(SynchChart);
//         end;

         // Limpamos o Log depois de um tempo
         if(FrmMainTreeView.Memo1.Lines.Count > 100)then
         begin
           FrmMainTreeView.SaveLog;
           FrmMainTreeView.Memo1.Lines.Clear;
         end;

     end; // if Read


     // Limpamos o Read
     Read:='';

  end; // while connected

  FrmMainTreeView.AddLogMsg('Thread Signal Ended.');
  FrmMainTreeView.ThrdSignal:=False;
end;

procedure TThrdDaileonFwRead.MiniBook(Text: String);
begin
  if(Copy(Text,1,2) = 'M:') then
  begin
    DataBook:=Text;
    Synchronize(SynchBook);
  end;
end;

procedure TThrdDaileonFwRead.NewVersion;
begin
  FrmMainTreeView.NewVersion(Url);
end;

procedure TThrdDaileonFwRead.ShowErr;
begin
  FrmMainTreeView.MsgErr:= Msg;
  FrmMainTreeView.ShowMsgErr;
end;

procedure TThrdDaileonFwRead.ShowMsg;
begin
//  FrmMainTreeView.StatusBar1.SimpleText:=Msg;
end;

procedure TThrdDaileonFwRead.SynchBook;
var SplitBook:TStringList;
    Line : Integer;
    K: Integer;
    Form : TFrmMiniBook;
    MsgBook:String;
begin

     // Manipulamos mini-book
       // Diferente do Trade, que é apenas uma planilha, o mini-book
       // pode estar em varios forms, por isso ele esta nesta thread
       // e não em uma separada.
       {**************** INICIO BOOK *******************}

  MsgBook:=Msg;

  FreeAndNil(Form);

       // Separamos os dados
  if(Copy(MsgBook,1,2) = 'M:') or (Copy(MsgBook,1,2) = 'B:')then
  begin
  try
  SplitBook:=TStringList.Create;
  SplitColumns(MsgBook,SplitBook,':');

  //FrmMainTreeView.AddLogMsg(MsgBook);

    // Book Speed
  if(FrmBrokerSpeed.Symbol = SplitBook[1]) and (Copy(MsgBook,1,2) = 'M:')then
  begin
    // Analisamos se é tipo A ( Adiciona )
        if(SplitBook[2]='A')then
        FrmBrokerSpeed.AddLine(SplitBook[3], SplitBook[4], SplitBook[5], SplitBook[6], SplitBook[7]);

        // Analisamos se é tipo U ( Atualiza )
        if(SplitBook[2]='U')then
        FrmBrokerSpeed.UpdateLine(SplitBook[3], SplitBook[5], SplitBook[6], SplitBook[7], SplitBook[8]);

        // Analisamos se é tipo D ( Deleta )
        if(SplitBook[2]='D')then
        FrmBrokerSpeed.DelLine(SplitBook[5], SplitBook[4], SplitBook[3]);
  end;

  // Varre o array que contem os forms abertos
  for K := 1 to 20 do
  begin
    // Pegamos o Form para fazer manipulacao
    Form:=FrmMainTreeView.FrmsBooks[K];

    // Verificamos se há algum form na posicao do array
    if(Form <> nil) and (Assigned(Form))then
    begin

      // Verificamos se esse form é do mesmo ativo que os dados
      if(Form.Symbol=SplitBook[1])then
      begin
        // Setamos que estamos Editando o form
        // Ver se isso ainda é necessário
        Form.Editing:=True;

        // Analisamos se é tipo A ( Adiciona )
        if(SplitBook[2]='A')then
         Form.AddLine(SplitBook[3], SplitBook[4], SplitBook[5], SplitBook[6], SplitBook[7]);

        // Analisamos se é tipo U ( Atualiza )
        if(SplitBook[2]='U')then
        Form.UpdateLine(SplitBook[3], SplitBook[5], SplitBook[6], SplitBook[7], SplitBook[8]);

        // Analisamos se é tipo D ( Deleta )
        if(SplitBook[2]='D')then
         if(SplitBook[3] <> '3')then
         Form.DelLine(SplitBook[5], SplitBook[4], SplitBook[3]);

      end; // if Form.symbol

    end; // if Assigned FrmBoook[K]
  end; // for array


  except
    on E:Exception do
    FrmMainTreeView.AddLogMsg('Erro ao manipular book: '+E.Message);
  end;
  end;

       {**************** FIM BOOK **********************}
end;

procedure TThrdDaileonFwRead.SynchChart;
var IntradaySplit:TStringList;
  I: Integer;
  Open,High,Low,CloseStock,DateStock,TimeStock : String;
  jDateValue:Double;
  ScaleSpace:Double;
begin
   IntradaySplit:=TStringList.Create;
   SplitColumns(Data,IntradaySplit,':');
   FrmMainTreeView.AddLogMsg(Data);
   for I := 0 to IntradaySplit.Count - 1 do
   begin
     if not Odd(I) then
     begin
       if IntradaySplit[I] = '2' then
       DateStock:=IntradaySplit[I+1];
       if IntradaySplit[I] = '3' then
       TimeStock:=IntradaySplit[I+1];
       if IntradaySplit[I] = '4' then
       Open:=IntradaySplit[I+1];
       if IntradaySplit[I] = '5' then
       High:=IntradaySplit[I+1];
       if IntradaySplit[I] = '6' then
       Low:=IntradaySplit[I+1];
       if IntradaySplit[I] = '7' then
       CloseStock:=IntradaySplit[I+1];
     end;
   end;
//
//   with FrmMainTreeView.GetFrmChart do
//   begin
//     try
//
//      if IntradaySplit[2] <> 'END' then
//      begin
//        jDateValue:=StockChartX1.ToJulianDate(StrToInt(Copy(DateStock,1,4)),StrToInt(Copy(DateStock,5,2)),StrToInt(Copy(DateStock,7,2)),StrToInt(Copy(TimeStock,1,2)),StrToInt(Copy(TimeStock,3,2)),00);
//        StockChartX1.AppendValue(IntradaySplit[1]+'.open',jDateValue, StrToFloat( FrmMainTreeView.ChangeDecimalSeparator(Open,'.',',')) );
//        StockChartX1.AppendValue(IntradaySplit[1]+'.close',jDateValue,StrToFloat( FrmMainTreeView.ChangeDecimalSeparator(CloseStock,'.',',')));
//        StockChartX1.AppendValue(IntradaySplit[1]+'.high',jDateValue,StrToFloat( FrmMainTreeView.ChangeDecimalSeparator(High,'.',',')));
//        StockChartX1.AppendValue(IntradaySplit[1]+'.low',jDateValue,StrToFloat( FrmMainTreeView.ChangeDecimalSeparator(Low,'.',',')));
//      end
//      else
//      begin
//        StockChartX1.Update;
//        ScaleMax:=StockChartX1.GetMaxValue(IntradaySplit[1]+'.close');
//        ScaleMin:=StockChartX1.GetMinValue(IntradaySplit[1]+'.close');
//        {ScaleSpace:= (ScaleMax + ScaleMin) / 100;
//        ScaleMax:= ScaleMax+ScaleSpace;
//        ScaleMin:= ScaleMin+ScaleSpace;}
//        //StockChartX1.SetYScale(0,ScaleMax,ScaleMin);
//      end;
//
//     except
//       on E:Exception do
//       FrmMainTreeView.AddLogMsg(E.Message);
//     end;
//   end;


end;

procedure TThrdDaileonFwRead.SynchRes;
var SRes: TStringList;
begin
   if FrmTradingSystem.Showing then
   begin
     FrmMainTreeView.AddLogMsg(Res);
     SRes:=TStringList.Create;
     SplitColumns(Res,SRes,':');
     //if ( FrmTradingSystem.GroupBox1.Caption = SRes[1] ) then
     //begin
       if SRes[2] <> 'NULL' then
       FrmTradingSystem.Label53.Caption:=SRes[2]
       else
       FrmTradingSystem.Label53.Caption:='--';
     //end;

   end;
end;

procedure TThrdDaileonFwRead.SynchSup;
var SSup: TStringList;
begin
   if FrmTradingSystem.Showing then
   begin
     SSup:=TStringList.Create;
     SplitColumns(Sup,SSup,':');
     //if ( FrmTradingSystem.GroupBox1.Caption = SRes[1] ) then
     //begin
       if SSup[2] <> 'NULL' then
       FrmTradingSystem.Label48.Caption:=SSup[2]
       else
       FrmTradingSystem.Label48.Caption:='--';
     //end;

   end;
end;

procedure TThrdDaileonFwRead.SynchTib;
var STib:TStringList;
begin
  if FrmTradingSystem.Showing then
  begin
    STib:=TStringList.Create;
    SplitColumns(Tib,STib,':');
    FrmTradingSystem.Label54.Caption:=STib[2];
    FrmTradingSystem.Label57.Caption:=STib[4];
    FrmTradingSystem.Label59.Caption:=STib[6];
    FrmTradingSystem.Gauge1.Progress:=StrToInt(STib[2]);
    FrmTradingSystem.Gauge2.Progress:=StrToInt(STib[4]);
    FrmTradingSystem.Gauge3.Progress:=StrToInt(STib[6]);
  end;
end;

procedure TThrdDaileonFwRead.SynchTrade;
begin

end;

procedure TThrdDaileonFwRead.CheckLogin(Text: String);
var LoginCheck :TStringList;
begin
try
if (Copy(Text,1,6) = 'LOGIN:') then
begin
  LoginCheck:=TStringList.Create;
  SplitColumns(Text,LoginCheck,':');
  if ( LoginCheck[2] = '0' ) then
  begin
    FrmConnection.BtnLogoutClick(Self);
    Msg:='Usuário ou Senha inválidos.';
    Synchronize(ShowErr);
    FrmConnection.Show;
  end
  else
  begin
    // Envia solicitacao de versao
    FrmMainTreeView.DaileonFW.IOHandler.WriteLn('version difrouter');
    FrmMainTreeView.DaileonFW.IOHandler.WriteBufferFlush;

    // Carrega ativos salvos
    FrmTrade.Load;
//    FrmMainTreeView.RecallBooks;
  end;

  FreeAndNil(LoginCheck);
 end;
except
  on E:Exception do
  begin
     FrmMainTreeView.AddLogMsg('Erro ao tratar login: ' + E.Message);
  end;
end;
end;

procedure TThrdDaileonFwRead.CheckVersion(Text: String);
var VersionCheck:TStringList;
begin
if (Copy(Text,1,8) = 'VERSION:') then
begin
  VersionCheck:=TStringList.Create;
  SplitColumns(Text,VersionCheck,':');
  if ( VersionCheck[2] <> FrmMainTreeView.VersionID ) then
  begin
    Url:=VersionCheck[3];
    NewVersion;
  end;
  FreeAndNil(VersionCheck);
end;
end;

function TThrdDaileonFwRead.RemoveChar(Text : String;Char: Char):String;
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

function TThrdDaileonFwRead.CompareValues(Value1 : String; Value2: String):Integer;
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

function TThrdDaileonFwRead.FormatTimeTrade(Time: String): String;
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

procedure TThrdDaileonFwRead.BlinkCell;
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
   FrmMainTreeView.AddLogMsg('Erro ao fazer blink:' + E.Message);
 end;

end;

end.
