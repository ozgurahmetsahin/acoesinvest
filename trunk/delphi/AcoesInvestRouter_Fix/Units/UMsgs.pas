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
  Signal_ERR_ConnectTimeOut = 'O servidor não respondeu no tempo limite.';
  Signal_ERR_ConnectException = 'Não foi possível estabelecer uma conexão.';
  Signal_ERR_ReadTimeOut = 'Tempo limite de leitura excedido.';
  Signal_ERR_ClosedSocket = 'Sua conexão está fechada.';
  Signal_ERR_AlredyConnected = 'Você já está conectado ao servidor.';
  Signal_ERR_SocketError = 'Erro ao tentar se conectar o servidor.';
  Signal_ERR_Exception = 'Erro não tratado.';
  Signal_ERR_Clear = '';
  Signal_ERR_ThrdEnded = 'Sua conexão com o servidor foi finalizada inexperadamente.';
  Signal_ERR_RequestShutDown = 'Solicitada a desconexão.';
  Signal_INFO_Connected = 'Você foi conectado com êxito.';
  Signal_INFO_Clear = '';
  Signal_INFO_ThrdStarted = 'Thread Signal Iniciada.';
  Signal_INFO_ThrdEnded = 'Thread Signal Finalizada.';


  {*******************************************************}
  {                                                       }
  {         Constantes para o form Configurações          }
  {                                                       }
  {*******************************************************}

  ConnConfig_ERR_IniFileException = 'Erro ao ler arquivo de configurações.';
  ConnConfig_ERR_Exception = 'Erro geral ao ler o arquivo.';


  {*******************************************************}
  {                                                       }
  {         Constantes para o form login                  }
  {                                                       }
  {*******************************************************}

  Login_INFO_StartConnSignal = 'Iniciando conexão com o servidor...';
  Login_INFO_SendLoginMsg = 'Enviando usuário e senha...';
  Login_INFO_Signal_UserInvalid = 'Usuário/Senha de Cotação inválidos.';
  Login_INFO_Signal_UserOK = 'Você foi autenticado com sucesso no servidor de cotação.';
  Login_INFO_Signal_UserCanceled = 'Usuário cancelado ou expirado.';
  Login_INFO_Signal_UnknownReturn = 'Seu usuário não pode ser processado.';

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
  Sheet_ColumnName_LastPrice = 'Último';
  Sheet_ColumnName_Percent = 'Osc.';
  Sheet_ColumnName_Bid = 'Melhor Compra';
  Sheet_ColumnName_Ask = 'Melhor Venda';
  Sheet_ColumnName_High = 'Máxima';
  Sheet_ColumnName_Low = 'Mínima';
  Sheet_ColumnName_Open = 'Abertura';
  Sheet_ColumnName_Close = 'Fechamento';
  Sheet_ColumnName_Busines = 'Negócios';


  {*******************************************************}
  {                                                       }
  {         Constantes para o form opensheet              }
  {                                                       }
  {*******************************************************}
  OpenSheet_MsgDlg_CantDeleteSheetOpened = 'Está planilha está atualmente aberta e não pode ser excluida.';


  {*******************************************************}
  {                                                       }
  {               Constantes uso geral                    }
  {                                                       }
  {*******************************************************}
  { TODO : Melhorar Explicação dos Hints }
  Hint_ConnectTimeOut = 'Estabeleçe o tempo limite em que o sistema deverá aguardar ' +
                        'para que uma conexão seja bem-sucedida. Se esse tempo limite exceder, '+
                        'o sistema emitirá um aviso que não foi possível se conectar ao servidor.';

  Hint_ReadTimeOut =    'Estabeleçe o tempo limite em que o sistema deverá aguardar ' +
                        'para que uma leitura de dado seja bem-sucedida. Se esse tempo limite exceder, '+
                        'continuará seu processo e aguardando novamente novos dados. Isso evita que o sistema ' +
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
  Error_Command_Send = 'Não foi possível enviar o comando.';

implementation

end.
