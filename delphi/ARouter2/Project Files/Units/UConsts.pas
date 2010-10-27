{*******************************************************}
{                                                       }
{                Constantes e Mensagens                 }
{                                                       }
{*******************************************************}

unit UConsts;

interface

resourcestring
  SSpace = ' ';
  SAppName = 'A��es Invest Router';
  SAppVersion = '2.0';

  SConnOff = 'Parado';
  SConnOn = 'Conectado';
  SFrmConnectionCaption = 'Conex�o';
  SBtnConnect = 'C&onectar';
  SBtnDisconnect = 'Desc&onectar';

  SSheet_Caption_NewSheet = 'Nova Planilha';
  SSheet_Prompt_NewSheet = 'Nome da nova planilha:';
  SSheet_Panel_SheetName = 'Planilha: ';
  SSheet_Panel_SymbolsQty = 'Ativos: ';
  SSheet_AddSymbol_WithSheetNameEmpty = 'Selecione uma planilha ou crie uma nova antes de adicionar os ativos.';
  SSheet_ColumnName_Symbol = 'Ativo';
  SSheet_ColumnName_LastPrice = '�ltimo';
  SSheet_ColumnName_Percent = 'Osc.';
  SSheet_ColumnName_Bid = 'Melhor Compra';
  SSheet_ColumnName_Ask = 'Melhor Venda';
  SSheet_ColumnName_High = 'M�xima';
  SSheet_ColumnName_Low = 'M�nima';
  SSheet_ColumnName_Open = 'Abertura';
  SSheet_ColumnName_Close = 'Fechamento';
  SSheet_ColumnName_Busines = 'Neg�cios';
  SSheet_ERROR_ConvertNewValue = 'Erro ao converter novo valor:';
  SSheet_ERROR_ConvertOldValue = 'Erro ao converter antigo valor:';

  SOpenSheet_MsgDlg_CantDeleteSheetOpened = 'Est� planilha est� atualmente aberta e n�o pode ser excluida.';

implementation

end.
