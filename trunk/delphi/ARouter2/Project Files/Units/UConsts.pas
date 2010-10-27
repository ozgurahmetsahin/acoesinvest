{*******************************************************}
{                                                       }
{                Constantes e Mensagens                 }
{                                                       }
{*******************************************************}

unit UConsts;

interface

resourcestring
  SSpace = ' ';
  SAppName = 'Ações Invest Router';
  SAppVersion = '2.0';

  SConnOff = 'Parado';
  SConnOn = 'Conectado';
  SFrmConnectionCaption = 'Conexão';
  SBtnConnect = 'C&onectar';
  SBtnDisconnect = 'Desc&onectar';

  SSheet_Caption_NewSheet = 'Nova Planilha';
  SSheet_Prompt_NewSheet = 'Nome da nova planilha:';
  SSheet_Panel_SheetName = 'Planilha: ';
  SSheet_Panel_SymbolsQty = 'Ativos: ';
  SSheet_AddSymbol_WithSheetNameEmpty = 'Selecione uma planilha ou crie uma nova antes de adicionar os ativos.';
  SSheet_ColumnName_Symbol = 'Ativo';
  SSheet_ColumnName_LastPrice = 'Último';
  SSheet_ColumnName_Percent = 'Osc.';
  SSheet_ColumnName_Bid = 'Melhor Compra';
  SSheet_ColumnName_Ask = 'Melhor Venda';
  SSheet_ColumnName_High = 'Máxima';
  SSheet_ColumnName_Low = 'Mínima';
  SSheet_ColumnName_Open = 'Abertura';
  SSheet_ColumnName_Close = 'Fechamento';
  SSheet_ColumnName_Busines = 'Negócios';
  SSheet_ERROR_ConvertNewValue = 'Erro ao converter novo valor:';
  SSheet_ERROR_ConvertOldValue = 'Erro ao converter antigo valor:';

  SOpenSheet_MsgDlg_CantDeleteSheetOpened = 'Está planilha está atualmente aberta e não pode ser excluida.';

implementation

end.
