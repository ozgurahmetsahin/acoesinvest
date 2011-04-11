/* 
 * File:   main.c
 * Author: donda
 *
 * Created on March 3, 2011, 1:11 PM
 */

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <postgresql/libpq-fe.h>
#include "ailib.h"

//#define USERNAME "difainvest01\r\n"
#define USERNAME "L:71cb0980-ea37-44f0-9615-8919d2eefcfa\n"
#define PASSWORD "5587\r\n"

#define CONN_TIMEOUT 40
#define MAX_BUF_RECV 5000

#define WELCOME_MSG "Welcome to DDC 2.0.\r\n"
#define CONNECTED_MSG "You are connected\r\n"
#define ERR_SERVER_FULL "Server full\r\n"
#define ERR_NEW_THRCLIENT "Dammit, something is wrong. Call someone.\r\n"
#define QUIT_MSG "I will miss you. Bye Bye.\r\n"
#define COMMAND_UNKNOW "This command is not valid. Are you sure of it?\r\n"
#define NOT_AUTH "You are not authorized for this command. Try login first.\r\n"
#define ALREADY_CONN "You already made logon.\r\n"

struct t_ddclist {
    int index;
    char *value;
    struct t_ddclist *next;
};

typedef struct t_ddclist ddclist;


ddclist *createDDCList();
int addDDCList(ddclist *list, char *value);
ddclist *insertDDCList(ddclist *list, int index, char *value);
ddclist *deleteDDCList(ddclist *list, int index);
ddclist *getDDCList(ddclist *list, int index);
void displayDDCList(ddclist *list);
ddclist *_splitcolumns(char *data, unsigned int separator);
void destroyDDCList(ddclist *list);

void *connectMarketSignal();
void *serverListener();
void *clientListener(void *fd);
void *senderData();
int checkuser(int _fd, char *_user, char *_pass);
void setonline(int status, int shadowcode);
void setlog(char *msg);
int islogin(char *_m);
int get_client(struct sockaddr *clientInformation, char *_add);
void clearConnections();
int addNewConnection(int fd);
int removeConnection(int fd);

/* Variaveis Globais */
int sockMarketSignal = -1; // socket do sinal
ddclist *connectedClients[1000];

/* Variavel de troca */
pthread_mutex_t mutexData;
char *exchangeData;
pthread_mutex_t mutexConnections;

/*
 * 
 */
int main(int argc, char** argv) {

    pthread_t marketSignal;
    pthread_attr_t marketAttr;

    pthread_t server;
    pthread_attr_t serverAttr;

    pthread_t sender;
    pthread_attr_t senderAttr;

    int createThread;

    pthread_attr_init(&serverAttr);
    pthread_attr_setdetachstate(&serverAttr, PTHREAD_CREATE_DETACHED);

    setlog("Starting server listener.");

    createThread = pthread_create(&server, NULL, serverListener, NULL);

    if (createThread) {
        setlog("Error on start server listener.");
        exit(-1);
    }

    setlog("Server Listerner started sucefully.");

    pthread_attr_init(&marketAttr);
    pthread_attr_setdetachstate(&marketAttr, PTHREAD_CREATE_JOINABLE);

    setlog("Starting connect market signal.");

    createThread = pthread_create(&marketSignal, &marketAttr, connectMarketSignal, NULL);

    if (createThread) {
        setlog("Error on start connectMarketSignal");
        exit(-1);
    }

    setlog("Connect Market Signal started sucefully.");

    pthread_attr_init(&senderAttr);
    pthread_attr_setdetachstate(&senderAttr, PTHREAD_CREATE_DETACHED);

    setlog("Starting Sender Data.");

    createThread = pthread_create(&sender, &senderAttr, senderData, NULL);

    if (createThread) {
        setlog("Error on create sender data.");
        exit(-1);
    }

    pthread_attr_destroy(&marketAttr);
    pthread_attr_destroy(&serverAttr);
    pthread_attr_destroy(&senderAttr);

    setlog("Waiting for all.");

    pthread_join(marketSignal, NULL);
    pthread_exit(NULL);

    return (EXIT_SUCCESS);
}

void setlog(char *msg) {
    printf("Log:%s\r\n", msg);
    //writeln("ddcglobal.log",msg,"a+");
}

void *connectMarketSignal() {

    char *buffer;
    buffer = malloc(1024);

    int readResult = 0;

    int trySetExchangeData = 0;

    long exchangeCounter = 0;

    setlog("Thread Market Signal Started,");

    int mutexResult = pthread_mutex_init(&mutexData, NULL);

    if (mutexResult < 0) {
        setlog("Error o init mutex data.");
        pthread_exit((void *) - 1);
    }

    exchangeData = malloc(1024);

    while (1) {

        setlog("Connecting to TraderData server.");

        sockMarketSignal = connecttoserver("201.49.223.92", 805);

        if (sockMarketSignal < 0) {
            setlog("Connection Error");
            sleep(5);
            continue;
        }

        setlog("Connected.");

        setlog("Prepared to read datas.");

        for (;;) {

            readResult = readline(sockMarketSignal, buffer, CONN_TIMEOUT);

            if (readResult == 0) {
                setlog("Readtimeout exceeded.");
                break;
            } else if (readResult < 0) {
                setlog("Error on readdata.");
                break;
            }


            if (islogin(buffer) == 1) {
                setlog("Sending GUID.");
                send(sockMarketSignal, USERNAME, strlen(USERNAME), 0);
            }
            if (islogin(buffer) == 2) {
                send(sockMarketSignal, PASSWORD, strlen(PASSWORD), 0);
            }
            if (islogin(buffer) == 3) {
                send(sockMarketSignal, "cedro_crystal\r\n", strlen("cedro_crystal\r\n"), 0);
            }
            if (islogin(buffer) == 4) {
                setlog("Market signal send You are connected");
            }

            for (;;) {
                if (strlen(exchangeData) <= 0) {
                    exchangeCounter++;
                    pthread_mutex_lock(&mutexData);
                    //strcpy(exchangeData,buffer);
                    ddclist *data = _splitcolumns(buffer, (unsigned int) ':');

                    if (data->index == 0) {

                        if (!strcmp(data->value, "T")) {

                            char *tick = malloc(sizeof (char) *256);
                            sprintf(tick, "T:%s:%s00:5:%s:8:%s:11:%s:12:%s:13:%s:14:%s!\r\n", getDDCList(data, 1)->value, getDDCList(data, 3)->value, getDDCList(data, 3)->value,
                                    getDDCList(data, 11)->value, getDDCList(data, 8)->value, getDDCList(data, 9)->value,
                                    getDDCList(data, 5)->value, getDDCList(data, 4)->value);

                            pthread_mutex_lock(&mutexData);
                            strcpy(exchangeData, tick);
                            pthread_mutex_unlock(&mutexData);
                            free(tick);

                        } else if (!strcmp(data->value, "N")) {

                            char *tick = malloc(sizeof (char) *256);

                            sprintf(tick, "T:%s:%s00:2:%s:5:%s00!\r\n", getDDCList(data, 1)->value, getDDCList(data, 3)->value,
                                    getDDCList(data, 4)->value, getDDCList(data, 3)->value);
                            pthread_mutex_lock(&mutexData);
                            strcpy(exchangeData, tick);
                            pthread_mutex_unlock(&mutexData);
                            free(tick);

                        } else if (!strcmp(data->value, "D")) {

                            char *tick = malloc(sizeof (char) *256);


                            if (!strcmp(getDDCList(data, 2)->value, "A")) {
                                /* Ativo
                                 * Conmando
                                 * Linha
                                 * Direcao
                                 * Valor
                                 * Qtde
                                 * Corretora
                                 */
                                sprintf(tick, "B:%s:%s:%s:%s:%s:%s:%s:%s!\r\n",
                                        getDDCList(data, 1)->value, getDDCList(data, 2)->value, getDDCList(data, 4)->value,
                                        getDDCList(data, 3)->value, getDDCList(data, 5)->value, getDDCList(data, 6)->value, getDDCList(data, 7)->value,
                                        getDDCList(data, 8)->value);
                            } else if (!strcmp(getDDCList(data, 2)->value, "U")) {
                                /* Ativo
                                 * Conmando
                                 * Linha
                                 * Direcao
                                 * Valor
                                 * Qtde
                                 * Corretora
                                 */
                                sprintf(tick, "B:%s:%s:%s:%s:%s:%s:%s:%s:%s!\r\n",
                                        getDDCList(data, 1)->value, getDDCList(data, 2)->value, getDDCList(data, 4)->value, getDDCList(data, 4)->value,
                                        getDDCList(data, 3)->value, getDDCList(data, 5)->value, getDDCList(data, 6)->value, getDDCList(data, 7)->value,
                                        getDDCList(data, 8)->value);
                            } else if (!strcmp(getDDCList(data, 2)->value, "D")) {
                                /* Ativo
                                 * Conmando
                                 * Tipo
                                 * Direcao
                                 * Posicao
                                 */
                                sprintf(tick, "B:%s:%s:%s:%s:%s:%s!\r\n",
                                        getDDCList(data, 1)->value, getDDCList(data, 2)->value,
                                        getDDCList(data, 3)->value, getDDCList(data, 4)->value, getDDCList(data, 5)->value,
                                        getDDCList(data, 6)->value);
                            }
                            pthread_mutex_lock(&mutexData);
                            strcpy(exchangeData, tick);
                            pthread_mutex_unlock(&mutexData);
                            free(tick);

                        }

                    }


                    destroyDDCList(data);

//                    pthread_mutex_unlock(&mutexData);
                    trySetExchangeData = 0;
                    break;
                } else {
                    usleep(5);
                    trySetExchangeData++;
                    if (trySetExchangeData >= 200) {
                        setlog("DELAY DETECTED.");
                    }
                    pthread_mutex_lock(&mutexData);
                    memset(exchangeData, (int) '\0', 1024);
                    pthread_mutex_unlock(&mutexData);
                    trySetExchangeData = 0;
                }
            }

            memset(buffer, (int) '\0', 1024);

        }

        close(sockMarketSignal);

        setlog("Disconnected.");

    }

    pthread_exit(NULL);
}

void *serverListener() {

    setlog("Server Listener Started.");

    // Descritor do socket para servidor
    int socksvr;

    // Descritor do socket para cliente
    int sockcli;

    // Variavel de controle de retornos
    // Sera utilizada sempre que precisar
    // verificar o retorno de alguma funcao
    int func_return = 0;

    // Estrutura de endereçamento de conexao
    // utilizada pelo servidor
    struct sockaddr_in svr_addr;

    // Estrutura de endereçamento de conexao
    // utilizada pelo cliente
    struct sockaddr cli_sockaddr;
    struct sockaddr_in cli_addr;

    // Endereço ip do novo cliente
    char *_ipadd;

    // Tamanho do enderecamento do cliente,
    // utilizado para gerar o novo socket
    int cli_addr_len;

    // Cria descritor do socket do servidor
    socksvr = socket(PF_INET, SOCK_STREAM, 0);

    // Verifica se criou o descritor corretamente
    if (socksvr < 0) {
        // Emite mensagem no terminal sobre o erro
        setlog("Error on create socket server listener.");

        // Finaliza aplicativo, ja que nao ha mais nada
        // que se fazer.
        pthread_exit((void *) - 1);
    }

    // Continua sistema caso criado socket para servidor

    // Aloca variavel que ira receber o ip do cliente
    _ipadd = malloc(sizeof (char) *500);

    // Cria estrutura de endereço para o socket do servidor criado
    svr_addr.sin_family = PF_INET;
    svr_addr.sin_port = htons(8189);
    svr_addr.sin_addr.s_addr = inet_addr("0");

    // Realiza bind para a estrutura criada e o socket
    func_return = bind(socksvr, (struct sockaddr *) & svr_addr, sizeof (svr_addr));

    // Verifica o retorno do bind
    if (func_return < 0) {
        // Houve um erro ao executar o bind.
        setlog("Error on bind socket.");

        // Finaliza aplicativo
        pthread_exit((void *) - 2);
    }

    // Continua sistema caso conseguiu realizar o bind

    // Seta "fila de espera" de conexoes
    // Vale resaltar que não é o numero maximo de conexoes
    // aceitas, e sim o numero maximo de conexoes simultaneas aceitas.
    // Ou seja, MAX_CONN_LISTEN de clientes se conectando ao mesmo tempo.
    listen(socksvr, 10);

    setlog("Clearing all connections.");
    clearConnections();

    int mutexRConn = pthread_mutex_init(&mutexConnections, NULL);

    if (mutexRConn < 0) {
        setlog("Error on init mutex connection.");
        pthread_exit((void *) - 1);
    }

    while (1) {
        cli_addr_len = sizeof (cli_addr);

        setlog("Waiting for new clients...");

        // Aguarda uma conexao
        sockcli = accept(socksvr, (struct sockaddr *) & cli_addr, &cli_addr_len);

        // Passando para cá, recebeu uma conexao,
        // verifica se foi bem sucedida
        if (sockcli < 0) {
            setlog("Error on accept new client.");
            close(sockcli);
            // Forca ao reinicio do loop
            continue;
        }

        get_client((struct sockaddr *) & cli_addr, _ipadd);

        if (addNewConnection(sockcli) < 0) {
            setlog("Server full.");
            send(sockcli, ERR_SERVER_FULL, strlen(ERR_SERVER_FULL), 0);
            send(sockcli, QUIT_MSG, strlen(QUIT_MSG), 0);
            close(sockcli);
            continue;
        }

        pthread_t newClient;
        pthread_attr_t newClientAttr;

        pthread_attr_init(&newClientAttr);
        pthread_attr_setdetachstate(&newClientAttr, PTHREAD_CREATE_DETACHED);

        if (pthread_create(&newClient, &newClientAttr, clientListener, (void *) sockcli)) {
            send(sockcli, ERR_NEW_THRCLIENT, sizeof (ERR_NEW_THRCLIENT), 0);
            close(sockcli);
            setlog(ERR_NEW_THRCLIENT);
            continue;
        }

        setlog("New client has been accept sucefully.");

    }

    setlog("Server Listener finished.");
    pthread_exit(NULL);

}

void *clientListener(void *fd) {

    int _fd = (int) fd;

    int login = 0;

    // Buffer de recebimento de dados
    char *bf_son_recv;

    // Auxiliares para analise de parametros
    char *aux1, *aux2, *aux3;

    // Comando enviado pelo cliente
    char *cmd_cli;

    // Retorno padrao de comandos
    int func_return2;

    send(_fd, WELCOME_MSG, strlen(WELCOME_MSG), 0);
    send(_fd, CONNECTED_MSG, strlen(CONNECTED_MSG), 0);

    // Vindo para ca ocorreu tudo bem nas boas vindas

    // Aloca buffer de recebimento na memoria e variavel
    // de comando
    bf_son_recv = malloc(MAX_BUF_RECV);
    cmd_cli = malloc(MAX_BUF_RECV);

    // Indentifcador de escrita na posicao
    // da variavel de comando
    int cmd_id = 0;

    // Aloca variaveis auxiliares
    aux1 = malloc(MAX_BUF_RECV);
    aux2 = malloc(MAX_BUF_RECV);
    aux3 = malloc(MAX_BUF_RECV);

    bzero(cmd_cli, MAX_BUF_RECV);
    bzero(bf_son_recv, MAX_BUF_RECV);

    while (1) {

        // Recebe dados do cliente
        //func_return2 = recv(_fd, bf_son_recv, MAX_BUF_RECV, 0);
        func_return2 = readline(_fd, bf_son_recv, 0);

        if (func_return2 <= 0) {
            if (login > 0)
                setonline(0, login);
            setlog("Connection with client closed gracefully.");
            break;
        }

        // Limpa
        bzero(aux1, MAX_BUF_RECV);

        // Faz split no comando lido para analise
        sscanf(bf_son_recv, "%s %s %s", aux1, aux2, aux3);

        // Converte comando para maiuscula
        uppercase(aux1);

        // Analise os comandos
        if (!strcmp(aux1, "QUIT")) {
            //Cliente solicitou a saida

            // Envia mensagem de saida
            send(_fd, QUIT_MSG, strlen(QUIT_MSG), 0);

            if (login > 0)
                setonline(0, login);

            break;
        } else if (!strcmp(aux1, "SQT")) {
            // Cliente solicitou ativo
            // Converte ativo para maiuscula
            uppercase(aux2);

            /*
                        if (login <= 0) {
                            send(_fd, NOT_AUTH, strlen(NOT_AUTH), 0);
                        } else {
             */
            char *cmd_sqt = malloc(40);
            sprintf(cmd_sqt, "A:T:%s:false\r\n", aux2);
            setlog(cmd_sqt);
            send(sockMarketSignal, cmd_sqt, strlen(cmd_sqt), 0);
            sprintf(cmd_sqt, "A:T:%s:true\r\n", aux2);
            setlog(cmd_sqt);
            send(sockMarketSignal, cmd_sqt, strlen(cmd_sqt), 0);

            sprintf(cmd_sqt, "A:N:%s:false\r\n", aux2);
            setlog(cmd_sqt);
            send(sockMarketSignal, cmd_sqt, strlen(cmd_sqt), 0);
            sprintf(cmd_sqt, "A:N:%s:true\r\n", aux2);
            setlog(cmd_sqt);
            send(sockMarketSignal, cmd_sqt, strlen(cmd_sqt), 0);
            free(cmd_sqt);
            //  }
        } else if (!strcmp(aux1, "BQT")) {
            // Cliente solicitou ativo
            // Converte ativo para maiuscula
            uppercase(aux2);
            if (login <= 0) {
                send(_fd, NOT_AUTH, strlen(NOT_AUTH), 0);
            } else {
                char *cmd_sqt = malloc(40);
                sprintf(cmd_sqt, "A:D:%s:false\r\n", aux2);
                setlog(cmd_sqt);
                send(sockMarketSignal, cmd_sqt, strlen(cmd_sqt), 0);
                sprintf(cmd_sqt, "A:D:%s:true\r\n", aux2);
                setlog(cmd_sqt);
                send(sockMarketSignal, cmd_sqt, strlen(cmd_sqt), 0);
                free(cmd_sqt);
            }

        } else if (!strcmp(aux1, "MBQ")) {
            // Cliente solicitou ativo
            // Converte ativo para maiuscula
            uppercase(aux2);
            if (login <= 0) {
                send(_fd, NOT_AUTH, strlen(NOT_AUTH), 0);
            } else {
                char *cmd_sqt = malloc(40);
                sprintf(cmd_sqt, "mbq %s\r\n", aux2);
                setlog(cmd_sqt);
                send(sockMarketSignal, cmd_sqt, strlen(cmd_sqt), 0);
                free(cmd_sqt);
            }
        } else if (!strcmp(aux1, "CHANGEPASS")) {
            // Cliente solicitou ativo
            // Converte ativo para maiuscula
            //uppercase(aux2);
            if (login <= 0) {
                send(_fd, NOT_AUTH, strlen(NOT_AUTH), 0);
            } else {
                send(_fd, "CHANGEPASS:1\r\n", strlen("CHANGEPASS:1\r\n"), 0);
                char *cmd_sqt = malloc(40);
                sprintf(cmd_sqt, "CHANGEPASS:%s:%s", aux2, aux3);
                setlog(cmd_sqt);
                free(cmd_sqt);
            }
        } else if (!strcmp(aux1, "LOGIN")) {

            // Cliente solicitou login
            // A flag de login recebe o retorno do
            // sucesso em checkuser, assim se for
            // um login valido retorna 1, caso contrario
            // retorna 0 e mantem usuario bloqueado
            // ao uso.
            if (login == 0)
                login = checkuser(_fd, aux2, aux3);
            else
                send(_fd, ALREADY_CONN, strlen(ALREADY_CONN), 0);

        } else {
            send(_fd, COMMAND_UNKNOW, strlen(COMMAND_UNKNOW), 0);
        }

        memset(bf_son_recv, (int) '\0', MAX_BUF_RECV);

    }

    close(_fd);

    if (removeConnection(_fd) < 0) {
        setlog("Cant remove a connection.");
    }

    setlog("A client connection has been closed.");

    pthread_exit(NULL);

}

void *senderData() {

    int c = 0;
    int r = 0;
    setlog("Sender Data started.");

    while (1) {
        usleep(100);
        pthread_mutex_lock(&mutexData);
        if (strlen(exchangeData) > 0) {
            for (c = 0; c <= 999; c++) {
                if (connectedClients[c] != 0) {
                    //r = send(connectedClients[c],exchangeData,strlen(exchangeData),MSG_DONTWAIT);
                    addDDCList(connectedClients[c], exchangeData);
                    if (r < 0) {
                        setlog("Error on sending data.");
                    }
                }
            }
            memset((char *) exchangeData, 0, 1024);
        }
        pthread_mutex_unlock(&mutexData);

    }

    setlog("Sender Data finished.");

    pthread_exit(NULL);

}

int checkuser(int _fd, char *_user, char *_pass) {

    int r = 0;
    char *_rcheck;
    _rcheck = malloc(MAX_BUF_RECV);

    char *_sql;
    _sql = malloc(MAX_BUF_RECV);
    /*
        // Verifica se foi passado os parametros
        if ((strlen(_user) > 0) && (strlen(_pass) > 0)) {
            sprintf(_rcheck, "LOGIN:%s:1\r\n", _user);
        } else {
            // Nada foi passado, recusa login
            sprintf(_rcheck, "LOGIN:%s:0\r\n", _user);
        }

        send(_fd, _rcheck, strlen(_rcheck), 0);

        free(_rcheck);

        return 1;
     */

    PGconn *conn = NULL;
    conn = PQconnectdb("host=187.84.226.2 dbname=intraDb user=postgres password=sabedoria");

    if (PQstatus(conn) == CONNECTION_OK) {
        PGresult *result;

        sprintf(_sql, "SELECT codigo,usuario,senha,tipo,online FROM clientes_login WHERE usuario = '%s' AND senha = '%s'", _user, _pass);

        result = PQexec(conn, _sql);


        if (!result) {
            sprintf(_rcheck, "LOGIN:%s:0:0\r\n", _user);
        } else {
            switch (PQresultStatus(result)) {
                case PGRES_EMPTY_QUERY:
                    sprintf(_rcheck, "LOGIN:%s:0:0\r\n", _user);
                    r = 0;
                    break;
                case PGRES_TUPLES_OK:
                    if (PQntuples(result) == 1) {
                        char *t = PQgetvalue(result, 0, 3);
                        if (!strcmp(t, "A") || !strcmp(t, "D")) {

                            char *on = PQgetvalue(result, 0, 4);

                            if (!strcmp(on, "0")) {
                                sprintf(_rcheck, "LOGIN:%s:1:%s\r\n", _user, PQgetvalue(result, 0, 0));
                                r = atoi(PQgetvalue(result, 0, 0));
                                setonline(1, r);
                            } else {
                                sprintf(_rcheck, "LOGIN:%s:0:3\r\n", _user);
                                r = 0;
                            }


                        } else {
                            sprintf(_rcheck, "LOGIN:%s:0:2\r\n", _user);
                            r = 0;
                        }

                    } else if (PQntuples(result) > 1) {
                        sprintf(_rcheck, "LOGIN:%s:0:4\r\n", _user);
                        r = 0;
                    } else {
                        sprintf(_rcheck, "LOGIN:%s:0:1\r\n", _user);
                        r = 0;
                    }
                    break;
            }

            PQclear(result);

            if (conn != NULL)
                PQfinish(conn);

        }

        send(_fd, _rcheck, strlen(_rcheck), 0);

        free(_rcheck);

        /*
                if(r==0){
                    quit=1;
                    sonrun=0;
                    kill(grandson,SIGKILL);
                }
         */

        return r;
    } else {
        sprintf(_rcheck, "LOGIN:%s:0:0\r\n", _user);
        send(_fd, _rcheck, strlen(_rcheck), 0);
        free(_rcheck);
        PQfinish(conn);
        return 0;
    }


}

void setonline(int status, int shadowcode) {

    PGconn *conn = NULL;
    conn = PQconnectdb("host=server2.acoesinvest.com.br dbname=intraDb user=postgres password=sabedoria");

    if (PQstatus(conn) == CONNECTION_OK) {
        PGresult *result;

        char *sql = malloc(1024);

        sprintf(sql, "UPDATE clientes_login SET online=%d WHERE codigo=%d", status, shadowcode);

        setlog(sql);

        result = PQexec(conn, sql);

        /*
                if(status==1)
                    sprintf(sql,"INSERT INTO logins_log(log_cod, user_cod, log_type, log_time,"
                        "user_ip,user_temp_dir) VALUES(default, %d, 'I', current_timestamp, '192.168.1.1', '%s')",
                        atoi(shadowcode), dir);
                else
                    sprintf(sql,"INSERT INTO logins_log(log_cod, user_cod, log_type, log_time,"
                        "user_ip,user_temp_dir) VALUES(default, %d, 'O', current_timestamp, '192.168.1.1', '%s')",
                        atoi(shadowcode), dir);

                writeln(TERMINAL_LOG,sql,"a+");

                result = PQexec(conn,sql);
         */

        PQclear(result);

        PQfinish(conn);
    } else {
        if (conn != NULL) {
            PQfinish(conn);
        }
    }
}

int get_client(struct sockaddr *clientInformation, char *_add) {

    struct sockaddr_in *ipv4 = (struct sockaddr_in *) clientInformation;
    strcpy(_add, inet_ntoa(ipv4->sin_addr));

    return 1;
}

int islogin(char *_m) {

    int j;

    /*
        for (j = 0; j <= strlen(_m); j++) {
            if (_m[j] == 'U') {

                if (_m[j + 7] == 'e') {

                    return 1;

                }
        

            if (_m[j] == 'P') {

                if (_m[j + 7] == 'd') {

                    return 2;

                }

            }

            if (_m[j] == 'C') {

                if (_m[j + 9] == 'g') {

                    return 3;

                }

            }

            if (_m[j] == 'Y') {

                if (_m[j + 4] == 'a') {

                    return 4;

                }

            }

        }
     */

    j = -1;

    if (_m[0] == 'V' && _m[1] == ':')
        j = 1;

    return j;

}

void clearConnections() {
    int i;
    for (i = 0; i <= 999; i++) {
        if (connectedClients[i] != 0) {
            //close(connectedClients[i]);
        }
        connectedClients[i] = 0;
    }
    PGconn *conn = NULL;
    conn = PQconnectdb("host=server2.acoesinvest.com.br dbname=intraDb user=postgres password=sabedoria");

    if (PQstatus(conn) == CONNECTION_OK) {
        PGresult *result;

        char *sql = malloc(1024);

        sprintf(sql, "UPDATE clientes_login SET online=0");

        setlog(sql);

        result = PQexec(conn, sql);

        PQclear(result);

        PQfinish(conn);
    } else {
        if (conn != NULL) {
            PQfinish(conn);
        }
    }
}

int addNewConnection(int fd) {

    int c;
    int r = -1;
    pthread_mutex_lock(&mutexConnections);
    for (c = 0; c <= 999; c++) {
        if (connectedClients[c] == 0) {
            r = c;
            connectedClients[c] = createDDCList();
            break;
        }
    }
    pthread_mutex_unlock(&mutexConnections);
    return r;
}

int removeConnection(int fd) {
    int c;
    int r = -1;
    pthread_mutex_lock(&mutexConnections);
    /*
        for(c=0;c<=999;c++){
            if(connectedClients[c]==fd){
                r=c;
                connectedClients[c]=0;
                break;
            }
        }
     */
    pthread_mutex_unlock(&mutexConnections);
    return r;
}

ddclist *createDDCList() {

    ddclist *newList = NULL;

    newList = malloc(sizeof (ddclist));

    if (!newList) {
        return NULL;
    }

    newList->index = -1;
    newList->value = malloc(sizeof (char) *256);
    newList->next = NULL;
    if (!newList->value) {
        return NULL;
    }

    return newList;
}

int addDDCList(ddclist *list, char *value) {

    ddclist *addList = NULL;

    addList = createDDCList();

    if (!addList) {
        return -1;
    }

    if (list->index == -1) {
        list->index = 0;
        strcpy(list->value, value);
        return 1;
    }

    ddclist *i, *temp;

    i = list;

    while (i) {
        if (!i->next) {
            temp = i;
        }
        i = i->next;
    }
    addList->index = (temp->index + 1);
    strcpy(addList->value, value);
    temp->next = addList;
    return addList->index;
}

void displayDDCList(ddclist *list) {

    ddclist *l = list;

    while (l) {
        printf("Index:%d\nValue:%s\n\n", l->index, l->value);
        l = l->next;
    }
}

// Separa os valores baseado no caracter de separa��o(separator) e popula
// a lista com os dados separados.
// Utilize a conversao de caracter para obter o separador desejado.
// Ex: (unsigned int)':' Coloca como separador o caracter de dois pontos( : )

ddclist *_splitcolumns(char *data, unsigned int separator) {

    ddclist *list = createDDCList();

    // Variavel temporaria que guardar� os dados entre a colunas
    // 256 = 255 caracteres + 1 caracter de finalizacao de string '\0'
    char tempdata[256];

    // Posicao de inscrita de caracter na tempdata
    int position = 0;

    // Contador de varredura dos caracteres
    int c = 0;

    // Contador das colunas encontradas
    int count = 0;

    // Ultima Estrutura usada
    //struct TDDCData *end;

    // Varre os caracteres at� o fim de todos
    for (c = 0; c < strlen(data); c++) {

        // Verifica se � o separador
        if ((unsigned int) data[c] == separator) {

            // Finaliza a string de temp data
            tempdata[position] = '\0';

            // � o separador, coloca os dados na estrutura
            // Primeiro, se for a primeira coluna encontrada, coloca
            // os dados na estrutura ddcdata. Caso contrario, cria uma
            // nova estrutura e coloca na posicao next.
            if (count == 0) {
                //list->index = count;
                //strcpy(list->value, tempdata);
                //list->next = NULL;
                // Como � a primeira, a ultima usada � ela mesma
                //end = list;
                addDDCList(list, tempdata);
            } else {
                // Como nao � o primeiro, cria uma
                // nova estrutura e popula os dados
                // o malloc aloca a nova estrutura
                // na memoria.
                //struct TDDCData *last;
                //last = malloc(sizeof (struct TDDCData));
                // Popula os dados
                //last->index = count;
                //strcpy(last->value, tempdata);
                //last->next = NULL;

                // Coloca na ultima usada, essa proxima estrutura
                //end->next = last;

                // Atualiza a ultima usada para esta nova criada
                //end = last;
                addDDCList(list, tempdata);
            }

            // Muda contador da coluna
            count++;

            // Zera tempdata
            bzero(tempdata, 256);

            // Reinicializa posicao de caracter para tempdata
            position = 0;

        } else {
            // Não é o separador, adiciona caracter ao tempdata, soh se for caracter valido
            if ((unsigned int) data[c] != 10 && (unsigned int) data[c] != 13) {
                tempdata[position] = data[c];
                position++;
            }
        }

    } // fim do for

    // Acabou o for, ent�o tempos que colocar todos os dados restantes como ultima coluna.
    //struct TDDCData *last;
    //last = malloc(sizeof (struct TDDCData));
    // Popula os dados
    //last->index = count;
    //strcpy(last->value, tempdata);
    //last->next = NULL;

    // Coloca na ultima usada, essa proxima estrutura
    //end->next = last;

    // Atualiza a ultima usada para esta nova criada
    //end = NULL;

    addDDCList(list, tempdata);

    return list;

}

ddclist *insertDDCList(ddclist *list, int index, char *value) {

    ddclist *i, *temp, *t;
    int c = 0;
    ddclist *insertList = createDDCList();
    insertList->index = index;
    strcpy(insertList->value, value);

    i = list;
    t = list;
    temp = NULL;

    while (i) {
        if (i->index == index) {
            if (temp == NULL) {
                insertList->next = i;
                t = insertList;
                while (t) {
                    t->index = c;
                    c++;
                    t = t->next;
                }
                return insertList;
            } else {
                temp->next = insertList;
                insertList->next = i;
                while (t) {
                    t->index = c;
                    c++;
                    t = t->next;
                }
            }
            return list;
        }
        temp = i;
        i = i->next;
    }
}

ddclist *deleteDDCList(ddclist *list, int index) {

    ddclist *i, *temp, *t;
    int c = 0;
    i = list;
    t = list;
    temp = NULL;

    while (i) {
        if (i->index == index) {
            if (temp == NULL) {
                temp = temp->next;
                free(i);
                while (t) {
                    t->index = c;
                    c++;
                    t = t->next;
                }
                return temp;
            } else {
                temp->next = i->next;
                free(i);
                while (t) {
                    t->index = c;
                    c++;
                    t = t->next;
                }
            }
            return list;
        }
        temp = i;
        i = i->next;
    }

}

void destroyDDCList(ddclist *list) {

    ddclist *temp;

    while (list) {
        temp = list;
        free(temp);
        list = list->next;
    }

}

ddclist *getDDCList(ddclist *list, int index) {

    if (index == 0 && list->index == -1) {
        return NULL;
    }

    ddclist *t = list;
    while (t) {
        if (t->index == index) {
            return t;
        }
        t = t->next;
    }

}