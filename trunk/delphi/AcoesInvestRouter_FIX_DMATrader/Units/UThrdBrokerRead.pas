unit UThrdBrokerRead;

interface

uses
  Classes,SysUtils,IdException,IdExceptionCore,IdGlobal,Graphics, IdStack,
  Sheet;

type
  TBrokerRead = class(TThread)
  private
    { Private declarations }
    MsgS : String;
    MsgE: String;
    D1 : Real;
    D2 : Real;
    D3 : Real;
    DataBroker:TStringList;
    procedure SynchDataClient;
  protected
    procedure Execute; override;
  end;

implementation
  uses UFrmMainTreeView,UFrmBrokerBuy,UFrmBrokerSell,
  UFrmHistoryOrders,UFrmStartStop,UFrmPortfolio;
{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TBrokerRead.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TBrokerRead }

procedure TBrokerRead.Execute;
var ReadBroker: String;
    Data : TStringList;
    MsgSend:String;
    BMsgSend:TBytes;
    ExistID:Boolean;
    LastCodOR:String;
    IdStatus, IdType:Integer;
    K,J:Integer;
    SheetHistory:TSheet;
begin
  { Place thread code here }

  FrmMainTreeView.AddLogMsg('Thread Broker Started.');
  FrmMainTreeView.ThrdBroker:=True;

  // Eqto estiver conectado ao broker, lê dados.
  while True do
  begin
    try
    // Tenta lêr dados do buffer
    try
      ReadBroker:=FrmMainTreeView.Broker.IOHandler.ReadLn(#3);
    except
    on E: EIdException do
     begin
     FrmMainTreeView.AddLogMsg('Erro ao ler dados do broker: ' + E.Message);
     //Retorna loop ao inicio
     ReadBroker:='';
     Break;
     end;
    on E: EIdSocketError do
    begin
      FrmMainTreeView.AddLogMsg('Erro ao ler dados do broker: ' + E.Message);
     //Retorna loop ao inicio
     ReadBroker:='';
     Break;
    end;

    end; // try Read

    // Se leu alguma coisa
    if(ReadBroker<>'')then
    begin
      // Colocamos no log
      FrmMainTreeView.AddLogMsg(ReadBroker);

      //Cria Lista para dados
      Data:=TStringList.Create;

      //Separa os dados
      SplitColumns(ReadBroker,Data,#1);

      //Verifica Login
      if Data.Values['35'] = 'RLOGIN' then
      begin
        if Data.Values['5279'] = '2' then
        begin
           FrmMainTreeView.MsgErr:='Usuário/Senha de Negociação inválidos.';
           Synchronize(FrmMainTreeView.ShowMsgErr);
           FrmMainTreeView.BrokerDisconnected(Self);
        end
        else if Data.Values['5279'] = '4' then
        begin
           FrmMainTreeView.MsgErr:='Você foi bloqueado pelo administrador.';
           Synchronize(FrmMainTreeView.ShowMsgErr);
           FrmMainTreeView.BrokerDisconnected(Self);
        end
        else if Data.Values['5279'] = '1' then
        begin
          MsgSend:='35=ADR' + #1 + '5017=5' + #1 + #3;
          BMsgSend:=FrmMainTreeView.StrToBytes(MsgSend);
          FrmMainTreeView.Broker.IOHandler.WriteDirect(BMsgSend);
        end;
      end; // verifica login

      //Verificacao ADR
      if Data.Values['35'] = 'RADR' then
      begin

        // Seta os dados do cliente
        DataBroker:=Data;
        Synchronize(SynchDataClient);

        //Vamos solicitar aqui o FOV - Lista de Ordens
        if FrmHistoryOrders.HistorySheet.Cells[0,1]='' then
        begin
          MsgSend:= '35=FOV' + #1 + '5017=5' + #1 + '5013=T' + #1 + '5487=0' +#1 +
                   '9999=0' + #1 + '5262=1' + #1 +  '5463=0' + #1 +  '5209=1' + #1 +#3;

          FrmMainTreeView.Memo1.Lines.Add(MsgSend);
          BMsgSend:=FrmMainTreeView.StrToBytes(MsgSend);
          FrmMainTreeView.Broker.IOHandler.WriteDirect(BMsgSend);
          FrmMainTreeView.Broker.IOHandler.WriteBufferFlush;
        end;

        //Vamos solicitar aqui o FFD - Saldo em conta
        MsgSend:= '35=FFD' + #1 + '5017=5' + #1 + '5209=1' + #1 + '5019=' +
               FrmMainTreeView.MarketID + #1 +#3;

        FrmMainTreeView.Memo1.Lines.Add(MsgSend);
        BMsgSend:=FrmMainTreeView.StrToBytes(MsgSend);
        FrmMainTreeView.Broker.IOHandler.WriteDirect(BMsgSend);
        FrmMainTreeView.Broker.IOHandler.WriteBufferFlush;

        //Vamos solicitar aqui o FS - Sumario Financeiro
        MsgSend:= '35=FS' + #1 + '5017=5' + #1 + '5209=1' + #1 + '5019=' +
               FrmMainTreeView.MarketID + #1 +#3;

        FrmMainTreeView.Memo1.Lines.Add(MsgSend);
        BMsgSend:=FrmMainTreeView.StrToBytes(MsgSend);
        FrmMainTreeView.Broker.IOHandler.WriteDirect(BMsgSend);
        FrmMainTreeView.Broker.IOHandler.WriteBufferFlush;

        //Vamos solicitar aqui o CO - Ordens Fechadas
        MsgSend:= '35=CO' + #1 + '5017=5' + #1 + '5209=1' + #1 + '5019=' +
                   FrmMainTreeView.MarketID + #1 + '5262=1' + #1 +#3;

        FrmMainTreeView.Memo1.Lines.Add(MsgSend);
        BMsgSend:=FrmMainTreeView.StrToBytes(MsgSend);
        FrmMainTreeView.Broker.IOHandler.WriteDirect(BMsgSend);
        FrmMainTreeView.Broker.IOHandler.WriteBufferFlush;

        // Se o form da custidia estiver sendo exibido, chama os dados
        if FrmPortfolio.Showing then
        FrmPortfolio.FormShow(Self);

       end; // verifica ADR

       //Verificacao RFOSB - Lista de Ordens de compra
      if Data.Values['35'] = 'RFOSB' then
      begin
        if StrToInt(Data.Values['5042']) > 0 then
        begin
          for K := 0 to Data.Count - 1 do
          begin
            //Verifica Codigo da ordem
            if Copy(Data[K],1,3) = '37=' then
            begin
              if not FrmHistoryOrders.StartStopSheet.FindQuote(Data.ValueFromIndex[K]) then
              FrmHistoryOrders.StartStopSheet.NewLine(Data.ValueFromIndex[K]);
              LastCodOR:=Data.ValueFromIndex[K];
            end;

            //Seta como Start
            FrmHistoryOrders.StartStopSheet.SetValue(clPicture,LastCodOR,'Start');

            //Verifica preco limite
            if Copy(Data[K],1,3) = '44=' then
            begin
              FrmHistoryOrders.StartStopSheet.SetValue(clSell,LastCodOR,Data.ValueFromIndex[K]);
            end;

            //Quantidade
            if Copy(Data[K],1,3) = '53=' then
            begin
              FrmHistoryOrders.StartStopSheet.SetValue(clVar,LastCodOR,Data.ValueFromIndex[K]);
            end;

            //Verifica preco de disparo
            if Copy(Data[K],1,5) = '5022=' then
            begin
              FrmHistoryOrders.StartStopSheet.SetValue(clBuy,LastCodOR,Data.ValueFromIndex[K]);
            end;

            //Ativo
            if Copy(Data[K],1,4) = '117=' then
            begin
              FrmHistoryOrders.StartStopSheet.SetValue(clLast,LastCodOR,Data.ValueFromIndex[K]);
            end;

            //Validade
            if Copy(Data[K],1,4) = '432=' then
            begin
              FrmHistoryOrders.StartStopSheet.SetValue(clObj3,LastCodOR,Data.ValueFromIndex[K]);
            end;

            //Status
            if Copy(Data[K],1,5) = '5073=' then
            begin
              IdStatus := StrToInt(Data.ValueFromIndex[K]);

              case IdStatus of
                0: FrmHistoryOrders.StartStopSheet.SetValue(clObj4,LastCodOR,'Pendente');
                2: FrmHistoryOrders.StartStopSheet.SetValue(clObj4,LastCodOR,'Acionada');
                3: FrmHistoryOrders.StartStopSheet.SetValue(clObj4,LastCodOR,'Expirada');
                4: FrmHistoryOrders.StartStopSheet.SetValue(clObj4,LastCodOR,'Rejeitada');
                5: FrmHistoryOrders.StartStopSheet.SetValue(clObj4,LastCodOR,'Cancelada');
              end;
            end;

          end;
        end;
      end; // verifica RFOSB

      //Verificacao RPV - Lista de Custodia
      if Data.Values['35'] = 'RPV' then
      begin
        if StrToInt(Data.Values['5096']) > 0 then
        begin
          for K := 0 to Data.Count - 1 do
          begin
            //Verifica Codigo do ativo
            if Copy(Data[K],1,4) = '117=' then
            begin
              if not FrmPortfolio.Portfolio.FindQuote(Data.ValueFromIndex[K]) then
              FrmPortfolio.Portfolio.NewLine(Data.ValueFromIndex[K]);
              LastCodOR:=Data.ValueFromIndex[K];
            end;

            //Verifica atde total
            if Copy(Data[K],1,5) = '5100=' then
            begin
              FrmPortfolio.Portfolio.SetValue(clPicture,LastCodOR,Data.ValueFromIndex[K]);
            end;

            //Verifica qtde disponivel
            if Copy(Data[K],1,5) = '5313=' then
            begin
              FrmPortfolio.Portfolio.SetValue(clLast,LastCodOR,Data.ValueFromIndex[K]);
            end;

            //Verifica preco medio
            if Copy(Data[K],1,5) = '5097=' then
            begin
              FrmPortfolio.Portfolio.SetValue(clSell,LastCodOR,Data.ValueFromIndex[K]);
            end;

            //Verifica preco atual
            if Copy(Data[K],1,5) = '5029=' then
            begin
              FrmPortfolio.Portfolio.SetValue(clStatus,LastCodOR,Data.ValueFromIndex[K]);
            end;



          end;
        end;
      end; // verifica RPV

      if Data.Values['35'] = 'SPVU' then
      begin

          for K := 0 to Data.Count - 1 do
          begin
            //Verifica Codigo do ativo
            //Verifica Codigo do ativo
            if Copy(Data[K],1,4) = '117=' then
            begin
              if not FrmPortfolio.Portfolio.FindQuote(Data.ValueFromIndex[K]) then
              FrmPortfolio.Portfolio.NewLine(Data.ValueFromIndex[K]);
              LastCodOR:=Data.ValueFromIndex[K];
            end;

            //Verifica atde total
            if Copy(Data[K],1,5) = '5100=' then
            begin
              FrmPortfolio.Portfolio.SetValue(clPicture,LastCodOR,Data.ValueFromIndex[K]);
            end;

            //Verifica qtde disponivel
            if Copy(Data[K],1,5) = '5313=' then
            begin
              FrmPortfolio.Portfolio.SetValue(clLast,LastCodOR,Data.ValueFromIndex[K]);
            end;

            //Verifica preco medio
            if Copy(Data[K],1,5) = '5097=' then
            begin
              FrmPortfolio.Portfolio.SetValue(clSell,LastCodOR,Data.ValueFromIndex[K]);
            end;

            //Verifica preco atual
            if Copy(Data[K],1,5) = '5029=' then
            begin
              FrmPortfolio.Portfolio.SetValue(clStatus,LastCodOR,Data.ValueFromIndex[K]);
            end;

          end;
      end;


      //Verificacao RFFD - Saldo em conta
      if (Data.Values['35'] = 'RFFD') then
      begin
            //Verifica saldo disponivel
            FrmPortfolio.Label6.Caption:=Data.Values['5060'];

      end;

      //Verificacao RFFD - Saldo em conta
      if (Data.Values['35'] = 'RFS') then
      begin
            //Verifica saldo projetado
            D1 := StrToFloat(FrmMainTreeView.ChangeDecimalSeparator(Data.Values['5049'],'.',','));
            FrmPortfolio.Label12.Caption:=FormatFloat('0.00', D1);
            D2 := StrToFloat(FrmMainTreeView.ChangeDecimalSeparator(Data.Values['5053'],'.',','));
            FrmPortfolio.Label18.Caption:=FormatFloat('0.00', D2);
            D3 := StrToFloat(FrmMainTreeView.ChangeDecimalSeparator(Data.Values['5057'],'.',','));
            FrmPortfolio.Label22.Caption:=FormatFloat('0.00', D3);
    //        FrmPortfolio.Label7.Caption:=FormatFloat('0.00', ( (D1+D2+D3) + StrToFloat(FrmMainTreeView.ChangeDecimalSeparator(FrmPortfolio.Label6.Caption,'.',',')) ));

      end;

      //Verificacao RCO - Ordens Fechadas
      if (Data.Values['35'] = 'RCO') then
      begin
            //Verifica total de compra
            FrmPortfolio.Label26.Caption:=Data.Values['132'];

            //Verifica total de venda
            FrmPortfolio.Label28.Caption:=Data.Values['133'];

            //Verifica total geral
            FrmPortfolio.Label31.Caption:=Data.Values['5041'];

      end;

      //Verificacao RFOSS - Lista de Ordens de venda
      if Data.Values['35'] = 'RFOSS' then
      begin
        if StrToInt(Data.Values['5042']) > 0 then
        begin
          for K := 0 to Data.Count - 1 do
          begin
            //Verifica Codigo da ordem
            if Copy(Data[K],1,3) = '37=' then
            begin
              if not FrmHistoryOrders.StartStopSheet.FindQuote(Data.ValueFromIndex[K]) then
              FrmHistoryOrders.StartStopSheet.NewLine(Data.ValueFromIndex[K]);
              LastCodOR:=Data.ValueFromIndex[K];
            end;

            //Seta como Stop
            FrmHistoryOrders.StartStopSheet.SetValue(clPicture,LastCodOR,'Stop');

            //Verifica preco Stop Loss Disp.
            if Copy(Data[K],1,5) = '5033=' then
            begin
              FrmHistoryOrders.StartStopSheet.SetValue(clObj1,LastCodOR,Data.ValueFromIndex[K]);
            end;

            //Verifica preco Stop Loss Lim.
            if Copy(Data[K],1,5) = '5034=' then
            begin
              FrmHistoryOrders.StartStopSheet.SetValue(clObj2,LastCodOR,Data.ValueFromIndex[K]);
            end;

            //Verifica preco Stop Gain Disp.
            if Copy(Data[K],1,5) = '5031=' then
            begin
              FrmHistoryOrders.StartStopSheet.SetValue(clStatus,LastCodOR,Data.ValueFromIndex[K]);
            end;

            //Verifica preco Stop Gain Lim.
            if Copy(Data[K],1,5) = '5032=' then
            begin
              FrmHistoryOrders.StartStopSheet.SetValue(clBaseIn,LastCodOR,Data.ValueFromIndex[K]);
            end;

            //Quantidade
            if Copy(Data[K],1,3) = '53=' then
            begin
              FrmHistoryOrders.StartStopSheet.SetValue(clVar,LastCodOR,Data.ValueFromIndex[K]);
            end;

            //Ativo
            if Copy(Data[K],1,4) = '117=' then
            begin
              FrmHistoryOrders.StartStopSheet.SetValue(clLast,LastCodOR,Data.ValueFromIndex[K]);
            end;

            //Validade
            if Copy(Data[K],1,4) = '432=' then
            begin
              FrmHistoryOrders.StartStopSheet.SetValue(clObj3,LastCodOR,Data.ValueFromIndex[K]);
            end;

            //Status
            if Copy(Data[K],1,5) = '5073=' then
            begin
              IdStatus := StrToInt(Data.ValueFromIndex[K]);

              case IdStatus of
                0: FrmHistoryOrders.StartStopSheet.SetValue(clObj4,LastCodOR,'Pendente');
                2: FrmHistoryOrders.StartStopSheet.SetValue(clObj4,LastCodOR,'Acionada');
                3: FrmHistoryOrders.StartStopSheet.SetValue(clObj4,LastCodOR,'Expirada');
                4: FrmHistoryOrders.StartStopSheet.SetValue(clObj4,LastCodOR,'Rejeitada');
                5: FrmHistoryOrders.StartStopSheet.SetValue(clObj4,LastCodOR,'Cancelada');
              end;

            end;
          end;
        end;
      end;


      //Verificacap OR
      if Data.Values['35'] = 'ROR' then
      begin
        if Data.Values['5021'] = '0' then
        begin
          FrmMainTreeView.LabelReturn.Font.Color:=$00007500;
          FrmMainTreeView.LabelReturn.Caption:='Ordem Enviada com Sucesso';
        end
        else
        begin
          FrmMainTreeView.LabelReturn.Font.Color:=$008080FF;
          FrmMainTreeView.LabelReturn.Caption:='Sua ordem não pode ser enviada.';
        end;
      end;

      //Verificacao de Start de Compra e Stop de Venda
      if ( Data.Values['35'] = 'ROSB' ) or ( Data.Values['35'] = 'ROSS' ) then
      begin
        if Data.Values['5021'] = '0' then
        begin
         FrmMainTreeView.LabelReturn.Font.Color:=$00007500;
         FrmMainTreeView.LabelReturn.Caption:='Ordem enviada a corretora com sucesso.';
        end;
      end;

     //Atualizacao de ordens
     if Data.Values['35'] = 'SOVU' then
     begin
      ExistID:=False;

      if FrmHistoryOrders.PageControl1.ActivePageIndex=0 then
      SheetHistory:=FrmHistoryOrders.HistorySheet
      else
      SheetHistory:=FrmHistoryOrders.Sheet1;

      for K := 0 to SheetHistory.RowCount - 1 do
      begin
        if SheetHistory.Cells[0,K] = Data.Values['37'] then
        begin
          ExistID:=True;
          break;
        end;

      end;

      if not ExistID then
      begin
        //Nova Linha
        SheetHistory.NewLine('');

        //Move tudo para baixo
        for K := 0 to SheetHistory.ColCount -1 do
        begin
          for J := SheetHistory.RowCount - 1 downto 2 do
          begin
            SheetHistory.Cells[K,J]:=SheetHistory.Cells[K,J-1];
            SheetHistory.Cells[K,J-1]:='';
          end;
        end;

        SheetHistory.Cells[0,1]:=Data.Values['37'];


        //Atualiza numero de ordens
        FrmHistoryOrders.Caption:='Histórico de Ordens (' + IntToStr(SheetHistory.RowCount - 1 ) + ')';
      end;

       for K := 0 to Data.Count - 1 do
       begin
           if (Copy(Data[K],1,3) = '53=') or (Copy(Data[K],1,5) = '5531=')  then
              begin
                SheetHistory.SetValue(clStatus,Data.Values['37'],Data.ValueFromIndex[K]);
              end;
              if Copy(Data[K],1,3) = '54=' then
              begin
                if Data.ValueFromIndex[K] = '1' then
                SheetHistory.SetValue(clVar,Data.Values['37'],'Compra')
                else
                SheetHistory.SetValue(clVar,Data.Values['37'],'Venda');
              end;
              if Copy(Data[K],1,4) = '117=' then
              begin
                SheetHistory.SetValue(clBuy,Data.Values['37'],Data.ValueFromIndex[K]);
              end;
              if Copy(Data[K],1,5) = '5128=' then
              begin
                SheetHistory.SetValue(clObj3,Data.Values['37'],Data.ValueFromIndex[K]);
              end;
              if Copy(Data[K],1,5) = '5071=' then
              begin
                SheetHistory.SetValue(clPicture,Data.Values['37'],Data.ValueFromIndex[K]);
              end;
              if Copy(Data[K],1,3) = '44=' then
              begin
                SheetHistory.SetValue(clSell,Data.Values['37'],Data.ValueFromIndex[K]);
              end;
              if Copy(Data[K],1,5) = '5028=' then
              begin
                SheetHistory.SetValue(clObj2,Data.Values['37'],Data.ValueFromIndex[K]);
              end;
              if Copy(Data[K],1,5) = '5027=' then
              begin
                SheetHistory.SetValue(clObj1,Data.Values['37'],Data.ValueFromIndex[K]);
              end;
              if Copy(Data[K],1,5) = '5018=' then
              begin
                IdType:=StrToInt(Data.ValueFromIndex[K]);

                case IdType of
                  0: SheetHistory.SetValue(clLast,Data.Values['37'],'Hoje');
                  1: SheetHistory.SetValue(clLast,Data.Values['37'],'Até Canc.');
                  2: SheetHistory.SetValue(clLast,Data.Values['37'],'Dt. Espec.');
                  3: SheetHistory.SetValue(clLast,Data.Values['37'],'Tudo/Nada');
                  4: SheetHistory.SetValue(clLast,Data.Values['37'],'Exec ou Canc.');
                end;

              end;
              if Copy(Data[K],1,5) = '5023=' then
              begin
                IdStatus:=StrToInt(Data.ValueFromIndex[K]);

                case IdStatus of
                  0: SheetHistory.SetValue(clObj4,Data.Values['37'],'Pendente');
                  1: SheetHistory.SetValue(clObj4,Data.Values['37'],'Rejeitada');
                  2: SheetHistory.SetValue(clObj4,Data.Values['37'],'Cancelada');
                  3: SheetHistory.SetValue(clObj4,Data.Values['37'],'Executada');
                  4: SheetHistory.SetValue(clObj4,Data.Values['37'],'Parc. Executada');
                  5: SheetHistory.SetValue(clObj4,Data.Values['37'],'Expirada');
                  6: SheetHistory.SetValue(clObj4,Data.Values['37'],'Recebida');
                  8: SheetHistory.SetValue(clObj4,Data.Values['37'],'Esp. Mercado');
                  9: SheetHistory.SetValue(clObj4,Data.Values['37'],'Congelada');
                  10: SheetHistory.SetValue(clObj4,Data.Values['37'],'Canc. Pendente');
                end;

              end;
       end;


     end;

     //Atualização da lista de ordens de compra
     if Data.Values['35'] = 'SOSBU' then
     begin
      ExistID:=False;

      for K := 0 to FrmHistoryOrders.StartStopSheet.RowCount - 1 do
      begin
        if FrmHistoryOrders.StartStopSheet.Cells[0,K] = Data.Values['37'] then
        begin
          ExistID:=True;
          break;
        end;

      end;

      if not ExistID then
      begin
        //Nova Linha
        FrmHistoryOrders.StartStopSheet.NewLine('');

        //Move tudo para baixo
        for K := 0 to FrmHistoryOrders.StartStopSheet.ColCount -1 do
        begin
          for J := FrmHistoryOrders.StartStopSheet.RowCount - 1 downto 2 do
          begin
            FrmHistoryOrders.StartStopSheet.Cells[K,J]:=FrmHistoryOrders.StartStopSheet.Cells[K,J-1];
            FrmHistoryOrders.StartStopSheet.Cells[K,J-1]:='';
          end;
        end;

        FrmHistoryOrders.StartStopSheet.Cells[0,1]:=Data.Values['37'];
        FrmHistoryOrders.StartStopSheet.Cells[1,1]:='Start';
      end;

       for K := 0 to Data.Count - 1 do
       begin
           if Copy(Data[K],1,3) = '53=' then
              begin
                FrmHistoryOrders.StartStopSheet.SetValue(clVar,Data.Values['37'],Data.ValueFromIndex[K]);
              end;

              if Copy(Data[K],1,4) = '117=' then
              begin
                FrmHistoryOrders.StartStopSheet.SetValue(clLast,Data.Values['37'],Data.ValueFromIndex[K]);
              end;

              if Copy(Data[K],1,4) = '432=' then
              begin
                FrmHistoryOrders.StartStopSheet.SetValue(clObj3,Data.Values['37'],Data.ValueFromIndex[K]);
              end;
              if Copy(Data[K],1,3) = '44=' then
              begin
                FrmHistoryOrders.StartStopSheet.SetValue(clSell,Data.Values['37'],Data.ValueFromIndex[K]);
              end;

              if Copy(Data[K],1,5) = '5022=' then
              begin
                FrmHistoryOrders.StartStopSheet.SetValue(clBuy,Data.Values['37'],Data.ValueFromIndex[K]);
              end;

              if Copy(Data[K],1,5) = '5073=' then
              begin
                IdStatus:=StrToInt(Data.ValueFromIndex[K]);

                case IdStatus of
                  0: FrmHistoryOrders.StartStopSheet.SetValue(clObj4,Data.Values['37'],'Pendente');
                  2: FrmHistoryOrders.StartStopSheet.SetValue(clObj4,Data.Values['37'],'Acionada');
                  3: FrmHistoryOrders.StartStopSheet.SetValue(clObj4,Data.Values['37'],'Expirada');
                  4: FrmHistoryOrders.StartStopSheet.SetValue(clObj4,Data.Values['37'],'Rejeitada');
                  5: FrmHistoryOrders.StartStopSheet.SetValue(clObj4,Data.Values['37'],'Cancelada');
                end;

              end;
       end;

     end;

     //Atualização da lista de ordens de venda
     if Data.Values['35'] = 'SOSSU' then
     begin
      ExistID:=False;

      for K := 0 to FrmHistoryOrders.StartStopSheet.RowCount - 1 do
      begin
        if FrmHistoryOrders.StartStopSheet.Cells[0,K] = Data.Values['37'] then
        begin
          ExistID:=True;
          break;
        end;

      end;

      if not ExistID then
      begin
        //Nova Linha
        FrmHistoryOrders.StartStopSheet.NewLine('');

        //Move tudo para baixo
        for K := 0 to FrmHistoryOrders.StartStopSheet.ColCount -1 do
        begin
          for J := FrmHistoryOrders.StartStopSheet.RowCount - 1 downto 2 do
          begin
            FrmHistoryOrders.StartStopSheet.Cells[K,J]:=FrmHistoryOrders.StartStopSheet.Cells[K,J-1];
            FrmHistoryOrders.StartStopSheet.Cells[K,J-1]:='';
          end;
        end;

        FrmHistoryOrders.StartStopSheet.Cells[0,1]:=Data.Values['37'];
        FrmHistoryOrders.StartStopSheet.Cells[1,1]:='Stop';
      end;

       for K := 0 to Data.Count - 1 do
       begin
           if Copy(Data[K],1,3) = '53=' then
              begin
                FrmHistoryOrders.StartStopSheet.SetValue(clVar,Data.Values['37'],Data.ValueFromIndex[K]);
              end;

              if Copy(Data[K],1,4) = '117=' then
              begin
                FrmHistoryOrders.StartStopSheet.SetValue(clLast,Data.Values['37'],Data.ValueFromIndex[K]);
              end;

              if Copy(Data[K],1,4) = '432=' then
              begin
                FrmHistoryOrders.StartStopSheet.SetValue(clObj3,Data.Values['37'],Data.ValueFromIndex[K]);
              end;

              //Verifica preco Stop Loss Disp.
            if Copy(Data[K],1,5) = '5033=' then
            begin
              FrmHistoryOrders.StartStopSheet.SetValue(clObj1,Data.Values['37'],Data.ValueFromIndex[K]);
            end;

            //Verifica preco Stop Loss Lim.
            if Copy(Data[K],1,5) = '5034=' then
            begin
              FrmHistoryOrders.StartStopSheet.SetValue(clObj2,Data.Values['37'],Data.ValueFromIndex[K]);
            end;

            //Verifica preco Stop Gain Disp.
            if Copy(Data[K],1,5) = '5031=' then
            begin
              FrmHistoryOrders.StartStopSheet.SetValue(clStatus,Data.Values['37'],Data.ValueFromIndex[K]);
            end;

            //Verifica preco Stop Gain Lim.
            if Copy(Data[K],1,5) = '5032=' then
            begin
              FrmHistoryOrders.StartStopSheet.SetValue(clBaseIn,Data.Values['37'],Data.ValueFromIndex[K]);
            end;

              if Copy(Data[K],1,5) = '5073=' then
              begin
                IdStatus:=StrToInt(Data.ValueFromIndex[K]);

                case IdStatus of
                  0: FrmHistoryOrders.StartStopSheet.SetValue(clObj4,Data.Values['37'],'Pendente');
                  2: FrmHistoryOrders.StartStopSheet.SetValue(clObj4,Data.Values['37'],'Acionada');
                  3: FrmHistoryOrders.StartStopSheet.SetValue(clObj4,Data.Values['37'],'Expirada');
                  4: FrmHistoryOrders.StartStopSheet.SetValue(clObj4,Data.Values['37'],'Rejeitada');
                  5: FrmHistoryOrders.StartStopSheet.SetValue(clObj4,Data.Values['37'],'Cancelada');
                end;

              end;
       end;

     end;

      //Verificacao FOV
      if  Data.Values['35'] ='RFOV'  then
      begin
        if FrmHistoryOrders.PageControl1.ActivePageIndex=0 then
      SheetHistory:=FrmHistoryOrders.HistorySheet
      else
      SheetHistory:=FrmHistoryOrders.Sheet1;




         if StrToInt( Data.Values['5042'] ) > 0 then
         begin
            FrmHistoryOrders.Caption:='Histórico de Ordens ('+Data.Values['5042']+')';
            for K := 0 to Data.Count - 1 do
            begin
              if Copy(Data[K],1,3) = '37=' then
              begin

                SheetHistory.NewLine(Data.ValueFromIndex[K]);
                LastCodOR:=Data.ValueFromIndex[K];
              end;
              if Copy(Data[K],1,3) = '53=' then
              begin
                SheetHistory.SetValue(clStatus,LastCodOR,Data.ValueFromIndex[K]);
              end;
              if Copy(Data[K],1,3) = '54=' then
              begin
                if Data.ValueFromIndex[K] = '1' then
                SheetHistory.SetValue(clVar,LastCodOR,'Compra')
                else
                SheetHistory.SetValue(clVar,LastCodOR,'Venda');
              end;
              if Copy(Data[K],1,4) = '117=' then
              begin
                SheetHistory.SetValue(clBuy,LastCodOR,Data.ValueFromIndex[K]);
              end;
              if Copy(Data[K],1,5) = '5128=' then
              begin
                SheetHistory.SetValue(clObj3,LastCodOR,Data.ValueFromIndex[K]);
              end;
              if Copy(Data[K],1,5) = '5071=' then
              begin
                SheetHistory.SetValue(clPicture,LastCodOR,Data.ValueFromIndex[K]);
              end;
              if Copy(Data[K],1,3) = '44=' then
              begin
                SheetHistory.SetValue(clSell,LastCodOR,Data.ValueFromIndex[K]);
              end;
              if Copy(Data[K],1,5) = '5028=' then
              begin
                SheetHistory.SetValue(clObj2,LastCodOR,Data.ValueFromIndex[K]);
              end;
              if Copy(Data[K],1,5) = '5027=' then
              begin
                SheetHistory.SetValue(clObj1,LastCodOR,Data.ValueFromIndex[K]);
              end;
              if Copy(Data[K],1,5) = '5018=' then
              begin
                IdType:=StrToInt(Data.ValueFromIndex[K]);

                case IdType of
                  0: SheetHistory.SetValue(clLast,LastCodOR,'Hoje');
                  1: SheetHistory.SetValue(clLast,LastCodOR,'Até Canc.');
                  2: SheetHistory.SetValue(clLast,LastCodOR,'Dt. Espec.');
                  3: SheetHistory.SetValue(clLast,LastCodOR,'Tudo/Nada');
                  4: SheetHistory.SetValue(clLast,LastCodOR,'Exec ou Canc.');
                end;

              end;
              if Copy(Data[K],1,5) = '5023=' then
              begin
                IdStatus:=StrToInt(Data.ValueFromIndex[K]);

                case IdStatus of
                  0: SheetHistory.SetValue(clObj4,LastCodOR,'Pendente');
                  1: SheetHistory.SetValue(clObj4,LastCodOR,'Rejeitada');
                  2: SheetHistory.SetValue(clObj4,LastCodOR,'Cancelada');
                  3: SheetHistory.SetValue(clObj4,LastCodOR,'Executada');
                  4: SheetHistory.SetValue(clObj4,LastCodOR,'Parc. Executada');
                  5: SheetHistory.SetValue(clObj4,LastCodOR,'Expirada');
                  6: SheetHistory.SetValue(clObj4,LastCodOR,'Recebida');
                  8: SheetHistory.SetValue(clObj4,LastCodOR,'Esp. Mercado');
                  9: SheetHistory.SetValue(clObj4,LastCodOR,'Congelada');
                  10: SheetHistory.SetValue(clObj4,LastCodOR,'Canc. Pendente');
                end;

              end;

            end;
         end;
      end;


  end; // if ReadBroker <> ''

    // Limpamos o ReadBroker
    ReadBroker:='';

    // Limpamos a lista
    FreeAndNil(Data);
    except
     on E: EIdSocketError do
     begin
     FrmMainTreeView.AddLogMsg('Erro ao ler dados do broker: ' + E.Message);
     //Retorna loop ao inicio
     ReadBroker:='';
     Break;
     end;
    end;

  end; // while connected

  FrmMainTreeView.AddLogMsg('Thread Broker Ended.');
  FrmMainTreeView.ThrdBroker:=False;
end;

procedure TBrokerRead.SynchDataClient;
begin
  try
    FrmMainTreeView.MarketID:=DataBroker.Values['5019'];
    FrmMainTreeView.ShadownCode:=DataBroker.Values['5162'];
    FrmMainTreeView.ClientName:=DataBroker.Values['5117'];
  except on E: Exception do
    FrmMainTreeView.AddLogMsg('Erro ao setar dados do cliente:' + E.Message);
  end;
end;

end.
