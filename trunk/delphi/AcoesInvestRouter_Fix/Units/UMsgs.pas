{*******************************************************}
{                                                       }
{           Biblioteca de Mensagens do Sistema          }
{                                                       }
{                                                       }
{                                                       }
{*******************************************************}
unit UMsgs;

interface

resourcestring
  {*******************************************************}
  {                                                       }
  {           Constantes para o componente Signal         }
  {                                                       }
  {*******************************************************}
  Signal_ERR_ConnectTimeOut = 'O servidor n�o respondeu no tempo limite.';
  Signal_ERR_ConnectException = 'N�o foi poss�vel estabelecer uma conex�o.';
  Signal_ERR_ReadTimeOut = 'Tempo limite de leitura excedido.';
  Signal_ERR_ClosedSocket = 'Sua conex�o est� fechada.';
  Signal_ERR_AlredyConnected = 'Voc� j� est� conectado ao servidor.';
  Signal_ERR_SocketError = 'Erro ao tentar se conectar o servidor.';
  Signal_ERR_Exception = 'Erro n�o tratado.';
  Signal_ERR_Clear = '';
  Signal_ERR_ThrdEnded = 'Sua conex�o com o servidor foi finalizada inexperadamente.';
  Signal_ERR_RequestShutDown = 'Solicitada a desconex�o.';
  Signal_INFO_Connected = 'Voc� foi conectado com �xito.';
  Signal_INFO_Clear = '';
  Signal_INFO_ThrdStarted = 'Thread Signal Iniciada.';
  Signal_INFO_ThrdEnded = 'Thread Signal Finalizada.';


  {*******************************************************}
  {                                                       }
  {         Constantes para o form Configura��es          }
  {                                                       }
  {*******************************************************}

  ConnConfig_ERR_IniFileException = 'Erro ao ler arquivo de configura��es.';
  ConnConfig_ERR_Exception = 'Erro geral ao ler o arquivo.';


  {*******************************************************}
  {                                                       }
  {         Constantes para o form login                  }
  {                                                       }
  {*******************************************************}

  Login_INFO_StartConnSignal = 'Iniciando conex�o com o servidor...';
  Login_INFO_SendLoginMsg = 'Enviando usu�rio e senha...';
  Login_INFO_Signal_UserInvalid = 'Usu�rio/Senha de Cota��o inv�lidos.';
  Login_INFO_Signal_UserOK = 'Voc� foi autenticado com sucesso no servidor de cota��o.';
  Login_INFO_Signal_UserCanceled = 'Usu�rio cancelado ou expirado.';
  Login_INFO_Signal_UnknownReturn = 'Seu usu�rio n�o pode ser processado.';

  {*******************************************************}
  {                                                       }
  {         Constantes para o form sheet                  }
  {                                                       }
  {*******************************************************}

  Sheet_Caption_NewSheet = 'Nova Planilha';
  Sheet_Prompt_NewSheet = 'Nome da nova planilha:';
  Sheet_Panel_SheetName = 'Planilha: ';
  Sheet_Panel_SymbolsQty = 'Ativos: ';
  Sheet_AddSymbol_WithSheetNameEmpty = 'Selecione uma planilha ou crie uma nova antes de adicionar os ativos.';
  Sheet_ColumnName_Symbol = 'Ativo';
  Sheet_ColumnName_LastPrice = '�ltimo';
  Sheet_ColumnName_Percent = 'Osc.';
  Sheet_ColumnName_Bid = 'Melhor Compra';
  Sheet_ColumnName_Ask = 'Melhor Venda';
  Sheet_ColumnName_High = 'M�xima';
  Sheet_ColumnName_Low = 'M�nima';
  Sheet_ColumnName_Open = 'Abertura';
  Sheet_ColumnName_Close = 'Fechamento';
  Sheet_ColumnName_Busines = 'Neg�cios';


  {*******************************************************}
  {                                                       }
  {         Constantes para o form opensheet              }
  {                                                       }
  {*******************************************************}
  OpenSheet_MsgDlg_CantDeleteSheetOpened = 'Est� planilha est� atualmente aberta e n�o pode ser excluida.';


  {*******************************************************}
  {                                                       }
  {               Constantes uso geral                    }
  {                                                       }
  {*******************************************************}
  { TODO : Melhorar Explica��o dos Hints }
  Hint_ConnectTimeOut = 'Estabele�e o tempo limite em que o sistema dever� aguardar ' +
                        'para que uma conex�o seja bem-sucedida. Se esse tempo limite exceder, '+
                        'o sistema emitir� um aviso que n�o foi poss�vel se conectar ao servidor.';

  Hint_ReadTimeOut =    'Estabele�e o tempo limite em que o sistema dever� aguardar ' +
                        'para que uma leitura de dado seja bem-sucedida. Se esse tempo limite exceder, '+
                        'continuar� seu processo e aguardando novamente novos dados. Isso evita que o sistema ' +
                        'o sistema pare de responder';

  {*******************************************************}
  {                                                       }
  {         Constantes para o sistema                     }
  {                                                       }
  {*******************************************************}

  System_INFO_Started = 'Sistema Iniciado.';
  System_INFO_Ended = 'Sistema Finalizado.';

  {*******************************************************}
  {                                                       }
  {         Constantes para os comandos                   }
  {                                                       }
  {*******************************************************}

  Command_Signal_Login = 'login %s %s';
  Command_Signal_Version = 'version %s';
  Command_Signal_Sqt = 'sqt %s';
  Header_Signal_Login = 'LOGIN';
  Header_Signal_Trade = 'T';
  Return_Signal_Login_UserInvalid = '0';
  Return_Signal_Login_OK = '1';
  Return_Signal_Login_Canceled = '2';
  Error_MountCommand_StringList = 'Dados insuficientes para montar o comando.';
  Error_MountCommand_Exception = 'Erro geral ao montar comando.';
  Error_Command_Send = 'N�o foi poss�vel enviar o comando.';

implementation

end.
