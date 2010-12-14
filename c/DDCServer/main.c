/* -*- Mode: C; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- */

/*
 * main.c
 * Copyright (C) Anderson Donda 2010 <donda@acoesinvest.com.br>
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <string.h>
#include <signal.h>
#include <unistd.h>
#include <time.h>
#include <ctype.h>
#include <sys/wait.h>
#include <fcntl.h>

/*Biblioteca Acoes Invest*/
#include "ailib.h"

#define SVR_PORT 8185
#define SVR_HOST "0"
#define MAX_CONN_LISTEN 5
#define MAX_BUF_RECV sizeof(char)*5000
#define MAX_BUF_SIZE sizeof(char) * 1000
#define MAX_SYN_WAIT 2000
#define MAX_SYNCH_TRY 1000
#define BUFFER_PATH "/home/donda/ddc/buffer/"
#define HEADER_LOG "********* Start DDCServer*************"
#define FOOTER_LOG "********* End DDCServer  *************"
#define DEFAULT_PATH "/home/donda/ddc/"
#ifdef BUFFER_PATH
#define BUFFER_PATHSIZE strlen(BUFFER_PATH)
#endif
#define SNAP_PATH "/home/donda/ddc/snapshot/trades/"
#define SNAPBK_PATH "/home/donda/ddc/snapshot/books/"
#define SQT_TEMP "/home/donda/ddc/tmp/"
#define GPN_BOVESPA "/home/donda/ddc/gpn_bovespa.dat"
#define GPN_BMF "/home/donda/ddc/gpn_bmf.dat"
#define FIFO_ARQ "/home/donda/ddc/buffer/fifo"
#define MBQ_BUYER 1
#define MBQ_SELLER 2
#define TERMINAL_LOG "/home/donda/ddc/ddcserver.log"
#define NOT_LOGIN_ADDR1 "187.84.226.2"
#define NOT_LOGIN_ADDR2 "187.84.226.3"
#define NOT_LOGIN_ADDR3 "187.84.226.4"
#define NOT_LOGIN_ADDR4 "187.84.226.5"
#define NOT_LOGIN_ADDR5 "187.84.226.6"
#define NOT_LOGIN_ADDR6 "187.84.226.10"

#define MSG_ERR_SOCK "Error on create socket for server."
#define MSG_ERR_BIND "Error on bind."
#define MSG_ERR_CONN "Error on accept connection."
#define MSG_ERR_WCME "Error on welcome client."
#define MSG_ERR_GRDSON "Error on create grandson."
#define MSG_SVR_START "Server is online."
#define MSG_SVR_WCME "Welcome to DDC Server v1.8.\r\nYou are connected\r\n"
#define MSG_SVR_NOTLOG "W:T:Sorry. You do not have permission for this command.\r\n"
#define MSG_SVR_GRNDEXIT "W:T:Connection with market was closed.\r\n"
#define MSG_SVR_BYE "W:T:bye bye.\r\n"
#define MSG_SVR_SYN "W:T:SYN\r\n"

#define EXIT_ERR_SOCK 1
#define EXIT_ERR_BIND 2
#define EXIT_ERR_WCME 3
#define EXIT_ERR_GRNDSON 4

/***** Declaração de metodos publicos *****/
void sonps(int _fd, pid_t _gson);
void grandsonps(int __fd);
char *id_cli();
char *mntsnapshot(char *symbol);
void *mntsnapshotbk(char *symbol, int __fd);
void gpn_bmf(int __fd);
void gpn_bovespa(int __fd);
void blast(char *_blast);
int blog(char *text, char *_modes);
void sonexit(int _sig);
void getsymbol(char *_b, char *_s);
void mounttrade(char *symbol, char *__t);
void sqt(int _fd, char *_symbol);
void mbq(int _fd, char *_symbol, int _fifo);
void bqt(int _fd, char *_symbol, int _fifo);
int checkuser(int _fd, char *_user, char *_pass);
void version_app(int _fd, char *_app);
int get_client(struct sockaddr *clientInformation, char *_add);
void mbq_snapshoot(int __f, char *__s);
void bqt_snapshoot(int __f, char *__s);
void chart(int _fd, char *cmd);
void readchart(int __fd);

/****** Variaveis Globais Usadas por filhos e netos *****/

// Diretorio temporario com informações do cliente
char *dir;

// Flag de controle de loop para
// o servidor. Valor inicial = 1
// para validar inicio.
int svrrun = 1;

// Variavel de controle de retornos
// Sera utilizada sempre que precisar
// verificar o retorno de alguma funcao
int func_return = 0;

// Descritor do socket para servidor
int socksvr;

// Descritor do socket para o cliente
int sockcli;

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

// PID para processo filho
pid_t son;

// PID para processo neto
pid_t grandson;
pid_t grandchart = -2;

// Solicitacao de quit
int quit = 0;


/** Especificações :
 *  Filho : processo responsavel por receber comandos do cliente
 *  Neto: processo responsavel por tratar as cotações e enviar para cliente
 */

/* Metodo principal */
int main() {

    /* Descritores do PID e SID*/
    pid_t pid, sid;

    /* Cria processo */
    pid = fork();

    /* Verifica se não foi criado o PID*/
    if (pid < 0) {
        /*Erro na criacao do PID*/
        writeln(TERMINAL_LOG, HEADER_LOG, "a+");
        writeln(TERMINAL_LOG, "Erro ao criar PID.", "a+");
        writeln(TERMINAL_LOG, FOOTER_LOG, "a+");
        exit(EXIT_FAILURE);
    }

    /* Verifica se foi criado o PID.
     *
     *  Obs: Nao pode ser ELSE para o IF acima pq o PID pode ser  > 0 ( processo atual)
     * e não iremos tratar isso, pois como o processo ja foi criado,
     * esse ( o processo atual ) pode ser finalizado.
     */
    if (pid > 0) {
        /*Finaliza processo principal*/
        exit(EXIT_SUCCESS);
    }

    /* A partir daqui já é (e tem que ser) o processo daemon criado*/

    /* Mudamos o umask para os arquivos deste daemon*/
    umask(0);

    /* Criamos um novo SID para este processo daemon, ja que foi criado
     * com um fork e depois finalizado o principal, o linux interpreta como orfao, isso entao
     * faz com que ele nao seja orfao.
     */
    sid = setsid();

    /* Claro que verificamos se foi criado com sucesso*/
    if (sid < 0) {
        /*Erro na criacao do SID*/
        writeln(TERMINAL_LOG, HEADER_LOG, "a+");
        writeln(TERMINAL_LOG, "Erro ao criar SID.", "a+");
        writeln(TERMINAL_LOG, FOOTER_LOG, "a+");
        exit(EXIT_FAILURE);
    }

    /* Seta o caminho de trabalho.
     *  Sei que tem é melhor colocar no /, mas como nosso daemon vai sempre
     * estar no caminho padrao dele, vou setar entao o caminho padrao mesmo.
     */
    int cdir = chdir(DEFAULT_PATH);

    /*Verifica se conseguiu mudar o caminho*/
    if (cdir < 0) {
        /*Erro na troca do caminho*/
        writeln(TERMINAL_LOG, HEADER_LOG, "a+");
        writeln(TERMINAL_LOG, "Erro ao setar chdir.", "a+");
        writeln(TERMINAL_LOG, FOOTER_LOG, "a+");
        exit(EXIT_FAILURE);
    }

    /*A partir daqui já é o processo Dameon.*/
    writeln(TERMINAL_LOG, HEADER_LOG, "a+");
    writeln(TERMINAL_LOG, "Daemon criado com sucesso.", "a+");
    writeln(TERMINAL_LOG, FOOTER_LOG, "a+");

    // Aloca variavel global de caminho de temporarios
    dir = malloc(24);

    // Cria descritor do socket do servidor
    socksvr = socket(PF_INET, SOCK_STREAM, 0);

    // Verifica se criou o descritor corretamente
    if (socksvr < 0) {
        // Emite mensagem no terminal sobre o erro
        writeln(TERMINAL_LOG, HEADER_LOG, "a+");
        writeln(TERMINAL_LOG, "Erro ao criar socket.", "a+");
        writeln(TERMINAL_LOG, FOOTER_LOG, "a+");

        // Finaliza aplicativo, ja que nao ha mais nada
        // que se fazer.
        exit(EXIT_ERR_SOCK);
    }

    // Continua sistema caso criado socket para servidor

    // Aloca variavel que ira receber o ip do cliente
    _ipadd = malloc(sizeof (char) *500);

    // Cria estrutura de endereço para o socket do servidor criado
    svr_addr.sin_family = PF_INET;
    svr_addr.sin_port = htons(SVR_PORT);
    svr_addr.sin_addr.s_addr = inet_addr(SVR_HOST);

    // Realiza bind para a estrutura criada e o socket
    func_return = bind(socksvr, (struct sockaddr *) & svr_addr, sizeof (svr_addr));

    // Verifica o retorno do bind
    if (func_return < 0) {
        // Houve um erro ao executar o bind.
        writeln(TERMINAL_LOG, HEADER_LOG, "a+");
        writeln(TERMINAL_LOG, "Erro ao fazer bind.", "a+");
        writeln(TERMINAL_LOG, FOOTER_LOG, "a+");

        // Finaliza aplicativo
        exit(EXIT_ERR_BIND);
    }

    // Continua sistema caso conseguiu realizar o bind

    // Seta "fila de espera" de conexoes
    // Vale resaltar que não é o numero maximo de conexoes
    // aceitas, e sim o numero maximo de conexoes simultaneas aceitas.
    // Ou seja, MAX_CONN_LISTEN de clientes se conectando ao mesmo tempo.
    listen(socksvr, MAX_CONN_LISTEN);

    // Registra sinal IPC para termino de filhos
    signal(SIGCHLD, sonexit);

    // Emite no log mensagem de inicio de recepcao
    writeln(TERMINAL_LOG, HEADER_LOG, "a+");
    writeln(TERMINAL_LOG, MSG_SVR_START, "a+");
    writeln(TERMINAL_LOG, FOOTER_LOG, "a+");

    // Inicia loop de escuta de conexoes
    while (svrrun) {

        cli_addr_len = sizeof (cli_addr);

        // Aguarda uma conexao
        sockcli = accept(socksvr, (struct sockaddr *) & cli_addr, &cli_addr_len);

        get_client((struct sockaddr *) & cli_addr, _ipadd);

        // Passando para cá, recebeu uma conexao,
        // verifica se foi bem sucedida
        if (sockcli < 0) {
            writeln(TERMINAL_LOG, HEADER_LOG, "a+");
            writeln(TERMINAL_LOG, "Erro ao aceitar conexao.", "a+");
            writeln(TERMINAL_LOG, FOOTER_LOG, "a+");
            // Forca ao reinicio do loop
            continue;
        }

        // Conexao foi bem sucedida, cria processo
        // filho para controlar nova conexao
        son = fork();

        // Inicio de Filho e continuacao de pai.

        // Verifica qual é o processo
        if (son > 0) {
            // Processo pai

            // Fecha descritor do cliente recebido ja que o filho
            // esta cuidando dele
            close(sockcli);

            // Volta ao inicio do loop
            continue;
        } else if (son == 0) {
            // Processo filho criado

            // Obtem a pasta temp para este cliente
            dir = id_cli();

            // Cria pasta temp para este cliente
            mkdir(dir, S_IRWXU);

            // A flag de controle de servidor é zerada
            // para que ele nao entre em loop
            svrrun = 0;

            // Cria neto para envio de buffer
            grandson = fork();

            // Verifica se criou neto
            if (grandson < 0) {
                // Emite mensagem de erro
                writeln(TERMINAL_LOG, HEADER_LOG, "a+");
                writeln(TERMINAL_LOG, "Erro ao criar grandson.", "a+");
                writeln(TERMINAL_LOG, FOOTER_LOG, "a+");
                // Força saida
                exit(EXIT_ERR_GRNDSON);
            }


            // Verifica se é filho ou neto
            if (grandson > 0) {
                // Processo filho

                // Executa funcao do filho
                sonps(sockcli, grandson);
            } else {
                // Processo neto


               grandchart = fork();

               if (grandchart > 0) {
                    // Executa funcao do neto

                    grandsonps(sockcli);


                } else {
                    readchart(sockcli);
               }



            }
        } else {
            writeln(TERMINAL_LOG, HEADER_LOG, "a+");
            writeln(TERMINAL_LOG, "Erro ao criar son.", "a+");
            writeln(TERMINAL_LOG, FOOTER_LOG, "a+");
        }

    }

    // Chegando aqui, algo ira ser finalizdo

    // Verifica se é um filho
    if (son == 0) {
        exit(0);
    }


    return (0);

}


// Funcao de sinal IPC para aviso
// de finalização de filhos

void sonexit(int _sig) {

    // Registra o sinal novamente
    signal(SIGCHLD, sonexit);

    // Pid do filho
    pid_t son_pid;
    // Status do filho
    int status;

    // Se for o sinal de finalizacao de filho
    if (_sig == SIGCHLD) {

        // Faz leitura de todos os filhos até não encontrar mais
        do {
            son_pid = waitpid(-1, &status, WNOHANG);

            // Se for um filho que recebeu aviso de neto,
            // finaliza filho
            if (grandson == son_pid && quit == 0 && son == getpid()) {

                printf("%d\n", (int) getpid());

                // Envia mensagem de finalizacao
                send(sockcli, MSG_SVR_GRNDEXIT, strlen(MSG_SVR_GRNDEXIT), 0);

                kill(son, SIGKILL);

            }


            // Com mais de um filho, o son_pid ficara sendo retornado 0
            // assim, se retornar 0 finaliza esse processo
            if (son_pid == 0) {
                break;
            }
        } while (son_pid != -1);

    }

}

// Funcao para tratamento do filho

void sonps(int _fd, pid_t _gson) {

    // Flag de controle de loop
    // para o filho. Valor inicial = 1
    // para validar inicio.
    int sonrun = 1;

    // Obtem o proprio PID
    son = getpid();

    // Buffer de recebimento de dados
    char *bf_son_recv;

    // Auxiliares para analise de parametros
    char *aux1, *aux2, *aux3;

    // Comando enviado pelo cliente
    char *cmd_cli;

    // Retorno padrao de comandos
    int func_return2;

    // Flag de login
    int login = 0;

    // Mensagem de boas vindas
    func_return2 = send(_fd, MSG_SVR_WCME, strlen(MSG_SVR_WCME), 0);

    // Verifica o envio de boas vindas ao cliente
    if (func_return2 < 0) {
        // Emite erro de boas vindas
        writeln(TERMINAL_LOG, HEADER_LOG, "a+");
        writeln(TERMINAL_LOG, "Erro ao enviar boas vindas.", "a+");
        writeln(TERMINAL_LOG, FOOTER_LOG, "a+");
        // Forca saida deste loop
        exit(EXIT_ERR_WCME);
    }

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


    // Verifica se o ip conectado é um ip cadastrado
    if (!strcmp(_ipadd, NOT_LOGIN_ADDR1) || !strcmp(_ipadd, NOT_LOGIN_ADDR2) || !strcmp(_ipadd, NOT_LOGIN_ADDR3) || !strcmp(_ipadd, NOT_LOGIN_ADDR4) ||
            !strcmp(_ipadd, NOT_LOGIN_ADDR5) || !strcmp(_ipadd, NOT_LOGIN_ADDR6) || SVR_PORT != 81) {
        login = 1;
    } else {
        login = 0;
    }

    // Cria descritor para arquivo fifo
    int fpipe;
    mknod(FIFO_ARQ, S_IFIFO | 0666, 0);

    // Abre o arquivo de fifo
    // ATENCAO: O processo pode ficar travado aqui caso DDCEnfoque nao esteja
    // em execucao.
    fpipe = open(FIFO_ARQ, O_WRONLY);

    // Inicia loop de escuta do filho
    while (sonrun) {

        // Limpa buffer antes de receber dados
        bzero(bf_son_recv, MAX_BUF_RECV);

        // Recebe dados do cliente
        //func_return2 = recv(_fd, bf_son_recv, MAX_BUF_RECV, 0);
        func_return2 = readline(_fd, bf_son_recv, 0);

        // Analiza retorno do recebimento
        if (func_return2 > 0) {

            // Há dados recebidos

            // Escreve no log do cliente os dados exatamentes enviados
            // junto com o codigo decimal de cada char.
            strcpy(aux1, dir);
            strcat(aux1, "logs.log");
            writeln(aux1, bf_son_recv, "a+");

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
                send(_fd, MSG_SVR_BYE, strlen(MSG_SVR_BYE), 0);

                // Altera flag de loop de escuta
                sonrun = 0;

                // Ativa flag de quit para nao recriar o neto na funcao signal
                quit = 1;

                // Manda sinal de kill para processo neto
                kill(_gson, SIGKILL);

                // Força reinicio do loop
                continue;
            } else if (!strcmp(aux1, "SQT")) {
                // Cliente solicitou ativo
                // Converte ativo para maiuscula
                uppercase(aux2);

                // Se esta logado autoriza comando
                if (login == 1) {
                    sqt(_fd, aux2);
                } else {
                    send(_fd, MSG_SVR_NOTLOG, strlen(MSG_SVR_NOTLOG), 0);
                }
            } /*else if (!strcmp(aux1, "MBQ")) {
                // Cliente solicitou book
                // Converte ativo para maiuscula
                uppercase(aux2);

                // Se esta logado autoriza comando
                if (login == 1) {
                    mbq(_fd, aux2, fpipe);
                } else {
                    send(_fd, MSG_SVR_NOTLOG, strlen(MSG_SVR_NOTLOG), 0);
                }
            } */else if (!strcmp(aux1, "BQT")) {
                // Cliente solicitou book
                // Converte ativo para maiuscula
                uppercase(aux2);

                // Se esta logado autoriza comando
                if (login == 1) {
                    bqt(_fd, aux2, fpipe);
                } else {
                    send(_fd, MSG_SVR_NOTLOG, strlen(MSG_SVR_NOTLOG), 0);
                }
            } else if (!strcmp(aux1, "GPN")) {

                // Cliente solicitou nomes de corrtoras
                // Converte segundo parametro ( mercado ) para maiuscula
                uppercase(aux2);
                // Se esta logado autoriza comando
                if (login == 1) {
                    // Verifica se foi mercado Bovespa
                    if (!strcmp(aux2, "BOVESPA")) {
                        gpn_bovespa(_fd);
                    } else if (!strcmp(aux2, "BMF")) {
                        // Verifica se foi mercado BMF
                        gpn_bmf(_fd);
                    }
                } else {
                    send(_fd, MSG_SVR_NOTLOG, strlen(MSG_SVR_NOTLOG), 0);
                }
            } else if (!strcmp(aux1, "LOGIN")) {

                // Cliente solicitou login
                // A flag de login recebe o retorno do
                // sucesso em checkuser, assim se for
                // um login valido retorna 1, caso contrario
                // retorna 0 e mantem usuario bloqueado
                // ao uso.
                login = checkuser(_fd, aux2, aux3);
            } else if (!strcmp(aux1, "VERSION")) {

                // Cliente solicitou versao do sistema
                // Converte segundo parametro em maiuscula
                uppercase(aux2);

                // Envia versao atual do sistema para o cliente
                version_app(_fd, aux2);
            } else if (!strcmp(aux1, "CHART")) {
                chart(_fd, bf_son_recv);
            } else if (!strcmp(aux1, "SESSION")) {
                // Cliente solicitou ativo
                // Converte ativo para maiuscula
                sprintf(dir,"%s%s/",SQT_TEMP,aux2);
                send(_fd,dir,strlen(dir),0);
            }

            // Limpa variaveis auxiliares
            bzero(aux1, MAX_BUF_RECV);
            bzero(aux2, MAX_BUF_RECV);
            bzero(aux3, MAX_BUF_RECV);

        } else {

            // Não foi possivel ler mais dados

            // Altera flag de loop de escuta
            sonrun = 0;

            // Manda sinal de kill para processo neto
            kill(_gson, SIGKILL);

            // Força reinicio do loop
            continue;

        }

    }

}

// Metodo responsavel por ler
// os dados armazenados no buffer e
// analisar se foi solicitado pelo cliente e
// enviar caso tenha sido.

void grandsonps(int __fd) {

    // Flag de execucao de neto
    // Valor inicial - 1 para validar
    // inicio de loop
    int grandrun = 1;

    // Buffer de leitura de linha
    char *bfline;

    // Auxilizares de split do buffer
    char *bfline_aux1, *bfline_aux2;

    // Desccritor do arquivo de Buffer
    FILE *bf_file;

    // Descritor de arquivos solicitados
    FILE *aux_file;

    // Aloca buffer e seus auxiliares
    bfline = malloc(MAX_BUF_SIZE);
    bfline_aux1 = malloc(10);
    bfline_aux2 = malloc(40);

    // Arquivo atual de buffer
    char *_file_buffer;
    _file_buffer = malloc(strlen(BUFFER_PATH) + 100);

    // Contador para SYN
    int syn = 0;

    // Contador para leitura de buffer
    int synch_buf = 0;

    // Inicia loop de leitura
    while (grandrun) {

        // Recebe arquivo atual de buffer
        blog("************** Start *****************", "a+");
        blog("Obtendo novo buffer", "a+");
        bzero(_file_buffer, strlen(BUFFER_PATH) + 100);
        blast(_file_buffer);
        //strcpy(_file_buffer,"/home/donda/ddc/all_data.buf");
        blog(_file_buffer, "a+");
        blog("************** End *****************", "a+");


        // blast retorna NULL caso não consiga ler os
        // dados do arquivo last.buf
        if (_file_buffer == NULL || strlen(_file_buffer) < 5) {
            // Altera flag de execucao de neto            
            blog("************** Start *****************", "a+");
            blog("Erro ao obter novo buffer", "a+");
            blog(_file_buffer, "a+");
            blog("para o cliente.", "a+");
            blog(dir, "a+");
            blog("************** End *****************", "a+");

            // Aguarda 5 segundos
            sleep(5);

            // Contabiliza tentativa
            synch_buf++;

            // Analisa se ja tentou o numero maximo
            if (synch_buf > MAX_SYNCH_TRY) {

                blog("************** Start *****************", "a+");
                blog("Numero de tentativas excedeu o limite", "a+");
                blog("Quebrando fluxo do cliente", "a+");
                blog("************** End *******************", "a+");

                // Quebra fluxo
                break;
            } else {
                blog("************** Start *****************", "a+");
                blog("Iniciando uma nova tentativa", "a+");
                blog("************** End *******************", "a+");

                // Envia um SYN para manter conexoes ativas
                send(__fd, MSG_SVR_SYN, strlen(MSG_SVR_SYN), 0);

                char *servertime;
                servertime = malloc(14);
                gettime("W:H:%H:%M:%S", servertime);
                strcat(servertime, "\r\n");
                send(__fd, servertime, strlen(servertime), 0);
                free(servertime);

                // Retorna fluxo ao seu inicio
                continue;
            }


        }

        //  Vindo aqui, foi possivel abrir o arquivo
        // atual de buffer


        // Abre arquivo do buffer
        bf_file = fopen(_file_buffer, "r");

        if (bf_file == NULL) {
            blog("************** Start *****************", "a+");
            blog("Erro ao acessar novo buffer", "a+");
            blog(_file_buffer, "a+");
            blog("para o cliente.", "a+");
            blog(dir, "a+");
            blog("************** End *****************", "a+");

            // Aguarda 5 segundo
            sleep(5);

            // Contabiliza tentativa
            synch_buf++;

            // Analisa se ja tentou o numero maximo
            if (synch_buf > MAX_SYNCH_TRY) {

                blog("************** Start *****************", "a+");
                blog("Numero de tentativas excedeu o limite", "a+");
                blog("Quebrando fluxo do cliente", "a+");
                blog("************** End *******************", "a+");

                // Quebra fluxo
                break;
            } else {
                blog("************** Start *****************", "a+");
                blog("Iniciando uma nova tentativa", "a+");
                blog("************** End *******************", "a+");

                // Envia SYN para manter conexoes ativas
                send(__fd, MSG_SVR_SYN, strlen(MSG_SVR_SYN), 0);

                char *servertime;
                servertime = malloc(14);
                gettime("W:H:%H:%M:%S", servertime);
                strcat(servertime, "\r\n");
                send(__fd, servertime, strlen(servertime), 0);
                free(servertime);

                // Retorna fluxo ao seu inicio
                continue;
            }
        }

        // Chegando aqui, foi possivel abrir o arquivo de buffer
        // Zera as tentativas de leitura
        blog("************** Start *****************", "a+");
        blog("Zerando numero de tentativas de fluxo", "a+");
        blog("************** End *******************", "a+");
        synch_buf = 0;

        int bookc = 0;
        int bookm = 0;


        // Lemos buffer até que seja trocado
        // o arquivo
        while (1) {

            // Lê dados do arquivo, NULL representa fim do arquivo
            // Aguardando entao 1/10 de segundo
            if (fgets(bfline, MAX_BUF_SIZE, bf_file) != NULL) {


                // Remove os caracteres \r e \n da linha
                removechars(bfline, bfline);

                if (bfline[0] == 'S' && bfline[1] == 'Y' && bfline[2] == 'N') {

                    char *_mnt_b;
                    _mnt_b = malloc(MAX_BUF_SIZE);
                    bzero(_mnt_b, MAX_BUF_SIZE);
                    // Envia ao cliente a linha
                    int ka = 0;
                    for (ka = 0; ka <= strlen(bfline); ka++) {
                        //send(__fd, &bfline[ka], sizeof (char), 0);
                        _mnt_b[ka] = bfline[ka];
                    }
                    sprintf(_mnt_b, "%s\r\n", _mnt_b);
                    send(__fd, _mnt_b, strlen(_mnt_b), 0);
                    free(_mnt_b);

                    // Limpa o buffer
                    bzero(bfline, MAX_BUF_SIZE);
                    bzero(bfline_aux1, 5);
                    bzero(bfline_aux2, 40);

                } else {

                    // Quebra linha para analise
                    //sscanf(bfline, "%[^':']:%[^':']:", bfline_aux1, bfline_aux2);

                    // Analises para Trade ( T: )
                    if (bfline[0] == 'T' && bfline[strlen(bfline) - 1] == '!') {

                        // Obtem o ativo
                        getsymbol(bfline, bfline_aux2);

                        // Move o ativo para outra variavel
                        strcpy(bfline_aux1, bfline_aux2);

                        // Concatenas as variaveis dir e ativo
                        sprintf(bfline_aux2, "%s%s", dir, bfline_aux1);

                        // Concatena a extensao .sqt
                        strcat(bfline_aux2, ".sqt");

                        // Zera varivel SYN
                        syn = 0;

                        // Verifica existencia de arquivo de solicitacao
                        aux_file = fopen(bfline_aux2, "r");

                        // Verifica se conseguiu abrir o arquivo
                        if (aux_file != NULL) {

                            // Arquivo aberto, então existe e foi solicitado

                            // Concatena \r\n e \0
                            //sprintf(bfline, "%s\n", bfline);
                            char *_mnt_b;

                            _mnt_b = malloc(MAX_BUF_SIZE);
                            bzero(_mnt_b, MAX_BUF_SIZE);
                            /*
                                                        mounttrade(bfline_aux1, _mnt_b);
                                                        send(__fd, _mnt_b, strlen(_mnt_b), 0);
                                                        free(_mnt_b);
                             */

                            // Envia ao cliente a linha
                            int ka = 0;
                            for (ka = 0; ka <= strlen(bfline); ka++) {
                                //send(__fd, &bfline[ka], sizeof (char), 0);
                                _mnt_b[ka] = bfline[ka];
                            }
                            sprintf(_mnt_b, "%s\r\n", _mnt_b);
                            send(__fd, _mnt_b, strlen(_mnt_b), 0);
                            free(_mnt_b);

                            // Fecha o descritor
                            fclose(aux_file);

                            bookm++;


                        }

                        /* Aqui Acontece o seguinte: Já que agora temos o book completo
                         * enviamos o mini-book a cada alteracao, pois pode ter havido mudancas
                         * nas posicoes do book completo.
                         */
                        // Analise para Book ( M: )

                        getsymbol(bfline, bfline_aux2);

                        // Concatena a extensao .mbq
                        strcpy(bfline_aux1, bfline_aux2);
                        sprintf(bfline_aux2, "%s%s", dir, bfline_aux1);
                        strcat(bfline_aux2, ".mbq");

                        // Verifica existencia de arquivo de solicitacao
                        aux_file = fopen(bfline_aux2, "r");

                        // Verifica se conseguiu abrir o arquivo
                        if (aux_file != NULL) {                           

                            // Arquivo aberto, então existe e foi solicitado

                            // Envia snapshot do mini book
                            if (bookm >= 10) {
                                mbq_snapshoot(__fd, bfline_aux1);
                                // Fecha o descritor
                                fclose(aux_file);
                                bookm = 0;
                            }

                        }



                    } else if (bfline[0] == 'M' && bfline[strlen(bfline) - 1] == '5') {
                        // Analise para Book ( M: )

                        getsymbol(bfline, bfline_aux2);

                        // Concatena a extensao .mbq
                        strcpy(bfline_aux1, bfline_aux2);
                        sprintf(bfline_aux2, "%s%s", dir, bfline_aux1);
                        strcat(bfline_aux2, ".mbq");

                        // Verifica existencia de arquivo de solicitacao
                        aux_file = fopen(bfline_aux2, "r");

                        // Verifica se conseguiu abrir o arquivo
                        if (aux_file != NULL) {

                            // Arquivo aberto, então existe e foi solicitado

                            // Concatena \r\n e \0
                            //sprintf(bfline, "%s\n\r", bfline);

                            // Envia ao cliente a linha
                            char *_mnt_b;
                            _mnt_b = malloc(MAX_BUF_SIZE);
                            bzero(_mnt_b, MAX_BUF_SIZE);
                            // Envia ao cliente a linha
                            int ka = 0;
                            for (ka = 0; ka <= strlen(bfline); ka++) {
                                //send(__fd, &bfline[ka], sizeof (char), 0);
                                _mnt_b[ka] = bfline[ka];
                            }
                            sprintf(_mnt_b, "%s\r\n", _mnt_b);
                            send(__fd, _mnt_b, strlen(_mnt_b), 0);
                            free(_mnt_b);
                            // Fecha o descritor
                            fclose(aux_file);

                        }

                    } else if (bfline[0] == 'K' && bfline[strlen(bfline) - 1] == '5') {
                        // Analise para Book ( B: )

                        int getbook = 0;

                        bfline[0] = 'B';

                        getsymbol(bfline, bfline_aux2);

                        // Concatena a extensao .mbq
                        strcpy(bfline_aux1, bfline_aux2);
                        sprintf(bfline_aux2, "%s%s", dir, bfline_aux1);
                        strcat(bfline_aux2, ".bqt");

                        // Verifica existencia de arquivo de solicitacao
                        aux_file = fopen(bfline_aux2, "r");

                        // Verifica se conseguiu abrir o arquivo
                        if (aux_file != NULL) {

                            // Arquivo aberto, então existe e foi solicitado

                            // Concatena \r\n e \0
                            //sprintf(bfline, "%s\n\r", bfline);

                            // Envia ao cliente a linha
                            char *_mnt_b;
                            _mnt_b = malloc(MAX_BUF_SIZE);
                            bzero(_mnt_b, MAX_BUF_SIZE);
                            // Envia ao cliente a linha
                            int ka = 0;
                            for (ka = 0; ka <= strlen(bfline); ka++) {
                                //send(__fd, &bfline[ka], sizeof (char), 0);
                                _mnt_b[ka] = bfline[ka];
                            }
                            sprintf(_mnt_b, "%s\r\n", _mnt_b);
                            send(__fd, _mnt_b, strlen(_mnt_b), 0);
                            //bqt_snapshoot(__fd, bfline_aux1);
                            free(_mnt_b);
                            // Fecha o descritor
                            fclose(aux_file);

                            getbook = 1;

/*
                            bookc++;

                            if (bookc >= 70) {
                                //bqt_snapshoot(__fd, bfline_aux1);
                                bookc = 0;
                            }
*/
                            //usleep(5);


                        }
                        

                    }

                    // Limpa o buffer e seus auxiliares
                    bzero(bfline, MAX_BUF_SIZE);
                    bzero(bfline_aux1, 5);
                    bzero(bfline_aux2, 10);

                }

            } else {

                //break;

                // Aqui significa que o arquivo esta em seu final,
                // analizamos se não foi trocado o buffer

                // Le dado atual no arquivo de ultimo buffer
                char *_check;
                _check = malloc(strlen(BUFFER_PATH) + 60);
                blast(_check);

                // Ultimo buffer pode retornar NULL caso esteja sendo escrito
                // no arquivo ( via ddccrystal ) na hora em que for ler,
                // caso isso ocorra, é tratado como final de arquivo
                if (_check == NULL) {
                    // É o mesmo ainda, então aguarda 1/10 de segundo
                    // Lembrando que deu NULL então é tratado
                    // como final de arquivo
                    free(_check);
                    usleep(10);
                    // Conta tempo para envio de SYN
                    syn++;

                    // se o contador chegar a 10 ( um segundo de espera )
                    // envia SYN para não fechar conexoes
                    if (syn >= MAX_SYN_WAIT) {
                        // Manda uma mensagem syn
                        send(__fd, MSG_SVR_SYN, strlen(MSG_SVR_SYN), 0);

                        // Zera o contador
                        syn = 0;
                    }
                } else if (strcmp(_file_buffer, _check)) {
                    // Opa trocou, quebramos o loop de leitura
                    // para iniciar no nova arquivo e fechamos descritor atual
                    blog("************** Start *****************", "a+");
                    blog("Verificado buffer do cliente", "a+");
                    blog(dir, "a+");
                    blog("Buffer Atual", "a+");
                    blog(_file_buffer, "a+");
                    blog("Buffer Check", "a+");
                    blog(_check, "a+");
                    blog("Alterando buffer...", "a+");
                    blog("************** End *****************", "a+");
                    fclose(bf_file);
                    free(_check);
                    // Manda uma mensagem syn
                    send(__fd, MSG_SVR_SYN, strlen(MSG_SVR_SYN), 0);
                    break;
                } else {
                    // É o mesmo ainda, então aguarda 1/10 de segundo
                    free(_check);
                    usleep(1000);
                    // Conta tempo para envio de SYN
                    syn++;

                    // se o contador chegar a 100 ( um segundo de espera )
                    // envia SYN para não fechar conexoes
                    if (syn >= MAX_SYN_WAIT) {
                        // Manda uma mensagem syn
                        send(__fd, MSG_SVR_SYN, strlen(MSG_SVR_SYN), 0);

                        char *servertime;
                        servertime = malloc(14);
                        gettime("W:H:%H:%M:%S", servertime);
                        strcat(servertime, "\r\n");
                        send(__fd, servertime, strlen(servertime), 0);
                        free(servertime);

                        // Zera o contador
                        syn = 0;
                    }
                }



            }
            
        }

    }

    // Vindo aqui, significa que o neto ira morrer
    blog("************** Start *****************", "a+");
    blog("Processo neto do cliente", "a+");
    blog(dir, "a+");
    blog("foi finalizado.", "a+");
    blog("************** End *****************", "a+");

}

void blast(char *_blast) {

    char *_lastpath;
    _lastpath = malloc(strlen(BUFFER_PATH) + strlen("last.buf"));

    sprintf(_lastpath, "%s%s", BUFFER_PATH, "last.buf");

    FILE *_flast;

    _flast = fopen(_lastpath, "r");

    if (_flast != NULL) {
        char *_linelast;
        _linelast = malloc(strlen(BUFFER_PATH) + 100);
        if (fgets(_linelast, (strlen(BUFFER_PATH) + 100), _flast) != NULL) {
            removechars(_linelast, _linelast);
            strcpy(_blast, _linelast);
            free(_linelast);
        }


    } else {
        strcpy(_blast, NULL);
    }


    fclose(_flast);

    free(_lastpath);


}

char *id_cli() {
    char *__id;

    char *_ftime;

    _ftime = malloc(14);

    __id = malloc(strlen(SQT_TEMP) + 14);

    strcpy(__id, SQT_TEMP);

    time_t t = time(NULL);

    struct tm *lt;

    lt = localtime(&t);

    strftime(_ftime, 14, "%m%d%H%M%S", lt);

    strcat(__id, _ftime);

    strcat(__id, "/");

    return __id;

}

char *mntsnapshot(char *symbol) {

    char *snap;
    snap = malloc(MAX_BUF_SIZE);
    bzero(snap, MAX_BUF_SIZE);

    char *symbolext;
    char *_read;

    symbolext = malloc(250);

    _read = malloc(15);

    strcpy(snap, "T:");
    strcat(snap, symbol);


    FILE *_fsnap;

    //strcpy(symbolext, symbol);
    sprintf(symbolext, "%s%s", SNAP_PATH, symbol);
    strcat(symbolext, ".5");
    _fsnap = fopen(symbolext, "r");
    if (_fsnap != NULL) {
        fgets(_read, 15, _fsnap);
        fclose(_fsnap);
        sprintf(snap, "%s:%s", snap, _read);
    } else {
        sprintf(snap, "%s:%s", snap, "100000");
    }

    //strcpy(symbolext, symbol);
    sprintf(symbolext, "%s%s", SNAP_PATH, symbol);
    strcat(symbolext, ".1");
    _fsnap = fopen(symbolext, "r");
    if (_fsnap != NULL) {
        fgets(_read, 15, _fsnap);
        fclose(_fsnap);
        sprintf(snap, "%s:1:%s", snap, _read);
    } else {
        sprintf(snap, "%s:1:%s", snap, "000000");
    }

    //strcpy(symbolext, symbol);
    sprintf(symbolext, "%s%s", SNAP_PATH, symbol);
    strcat(symbolext, ".2");
    _fsnap = fopen(symbolext, "r");
    if (_fsnap != NULL) {
        fgets(_read, 15, _fsnap);
        fclose(_fsnap);
        sprintf(snap, "%s:2:%s", snap, _read);
    } else {
        sprintf(snap, "%s:2:%s", snap, "0.00");
    }

    //strcpy(symbolext, symbol);
    sprintf(symbolext, "%s%s", SNAP_PATH, symbol);
    strcat(symbolext, ".3");
    _fsnap = fopen(symbolext, "r");
    if (_fsnap != NULL) {
        fgets(_read, 15, _fsnap);
        fclose(_fsnap);
        sprintf(snap, "%s:3:%s", snap, _read);
    } else {
        sprintf(snap, "%s:3:%s", snap, "0.00");
    }

    //strcpy(symbolext, symbol);
    sprintf(symbolext, "%s%s", SNAP_PATH, symbol);
    strcat(symbolext, ".4");
    _fsnap = fopen(symbolext, "r");
    if (_fsnap != NULL) {
        fgets(_read, 15, _fsnap);
        fclose(_fsnap);
        sprintf(snap, "%s:4:%s", snap, _read);
    } else {
        sprintf(snap, "%s:4:%s", snap, "0.00");
    }

    //strcpy(symbolext, symbol);
    sprintf(symbolext, "%s%s", SNAP_PATH, symbol);
    strcat(symbolext, ".5");
    _fsnap = fopen(symbolext, "r");
    if (_fsnap != NULL) {
        fgets(_read, 15, _fsnap);
        fclose(_fsnap);
        sprintf(snap, "%s:5:%s", snap, _read);
    } else {
        sprintf(snap, "%s:5:%s", snap, "000000");
    }

    //strcpy(symbolext, symbol);
    sprintf(symbolext, "%s%s", SNAP_PATH, symbol);
    strcat(symbolext, ".8");
    _fsnap = fopen(symbolext, "r");
    if (_fsnap != NULL) {
        fgets(_read, 15, _fsnap);
        fclose(_fsnap);
        sprintf(snap, "%s:8:%s", snap, _read);
    } else {
        sprintf(snap, "%s:8:%s", snap, "0");
    }

    //strcpy(symbolext, symbol);
    sprintf(symbolext, "%s%s", SNAP_PATH, symbol);
    strcat(symbolext, ".9");
    _fsnap = fopen(symbolext, "r");
    if (_fsnap != NULL) {
        fgets(_read, 15, _fsnap);
        fclose(_fsnap);
        sprintf(snap, "%s:9:%s", snap, _read);
    } else {
        sprintf(snap, "%s:9:%s", snap, "0");

    }

    //strcpy(symbolext, symbol);
    sprintf(symbolext, "%s%s", SNAP_PATH, symbol);
    strcat(symbolext, ".11");
    _fsnap = fopen(symbolext, "r");
    if (_fsnap != NULL) {
        fgets(_read, 15, _fsnap);
        fclose(_fsnap);
        sprintf(snap, "%s:11:%s", snap, _read);
    } else {
        sprintf(snap, "%s:11:%s", snap, "0.00");
    }

    //strcpy(symbolext, symbol);
    sprintf(symbolext, "%s%s", SNAP_PATH, symbol);
    strcat(symbolext, ".12");
    _fsnap = fopen(symbolext, "r");
    if (_fsnap != NULL) {
        fgets(_read, 15, _fsnap);
        fclose(_fsnap);
        sprintf(snap, "%s:12:%s", snap, _read);
    } else {
        sprintf(snap, "%s:12:%s", snap, "0.00");
    }

    //strcpy(symbolext, symbol);
    sprintf(symbolext, "%s%s", SNAP_PATH, symbol);
    strcat(symbolext, ".13");
    _fsnap = fopen(symbolext, "r");
    if (_fsnap != NULL) {
        fgets(_read, 15, _fsnap);
        fclose(_fsnap);
        sprintf(snap, "%s:13:%s", snap, _read);
    } else {
        sprintf(snap, "%s:13:%s", snap, "0.00");
    }

    //strcpy(symbolext, symbol);
    sprintf(symbolext, "%s%s", SNAP_PATH, symbol);
    strcat(symbolext, ".14");
    _fsnap = fopen(symbolext, "r");
    if (_fsnap != NULL) {
        fgets(_read, 15, _fsnap);
        fclose(_fsnap);
        sprintf(snap, "%s:14:%s", snap, _read);
    } else {
        sprintf(snap, "%s:14:%s", snap, "0.00");
    }

    //strcpy(symbolext, symbol);
    sprintf(symbolext, "%s%s", SNAP_PATH, symbol);
    strcat(symbolext, ".664");
    _fsnap = fopen(symbolext, "r");
    if (_fsnap != NULL) {
        fgets(_read, 15, _fsnap);
        fclose(_fsnap);
        sprintf(snap, "%s:664:%s", snap, _read);
    } else {
        sprintf(snap, "%s:664:%s", snap, "0.00");
    }

    sprintf(snap, "%s!\r\n", snap);

    return snap;

}

void *mntsnapshotbk(char *symbol, int __fd) {

    char *_spath;
    _spath = malloc(strlen(SNAPBK_PATH) + strlen(symbol) + 5);

    char *_line;
    _line = malloc(60);

    FILE *fbook;

    char *sline;
    sline = malloc(60);
    int cline = 0;

    // Compradores
    strcpy(_spath, SNAPBK_PATH);
    sprintf(_spath, "%s%s.bkb", _spath, symbol);
    bzero(sline, 60);
    fbook = fopen(_spath, "r");

    if (fbook != NULL) {

        cline = 0;

        while ((fgets(_line, 60, fbook)) != NULL) {

            removechars(_line, _line);

            sprintf(sline, "%s%s:A:%d:%s", "M:", symbol, cline, _line);

            // Concatena \r\n e \0
            //sprintf(bfline, "%s\n", bfline);
            char *_mnt_b;
            _mnt_b = malloc(MAX_BUF_SIZE);
            bzero(_mnt_b, MAX_BUF_SIZE);
            // Envia ao cliente a linha
            int ka = 0;
            for (ka = 0; ka <= strlen(sline); ka++) {
                //send(__fd, &bfline[ka], sizeof (char), 0);
                _mnt_b[ka] = sline[ka];
            }
            sprintf(_mnt_b, "%s\r\n", _mnt_b);
            send(__fd, _mnt_b, strlen(_mnt_b), 0);
            free(_mnt_b);


            cline++;

            bzero(sline, 60);

            if (cline >= 5) {
                break;
            }

        }

        fclose(fbook);
        cline = 0;
    }


    // Vendedores
    strcpy(_spath, SNAPBK_PATH);
    sprintf(_spath, "%s%s.bks", _spath, symbol);
    bzero(sline, 60);
    fbook = fopen(_spath, "r");

    if (fbook != NULL) {

        cline = 0;

        while ((fgets(_line, 60, fbook)) != NULL) {

            removechars(_line, _line);

            sprintf(sline, "%s%s:A:%d:%s", "M:", symbol, cline, _line);

            // Concatena \r\n e \0
            //sprintf(bfline, "%s\n", bfline);
            char *_mnt_b;
            _mnt_b = malloc(MAX_BUF_SIZE);
            bzero(_mnt_b, MAX_BUF_SIZE);
            // Envia ao cliente a linha
            int ka = 0;
            for (ka = 0; ka <= strlen(sline); ka++) {
                //send(__fd, &bfline[ka], sizeof (char), 0);
                _mnt_b[ka] = sline[ka];
            }
            sprintf(_mnt_b, "%s\r\n", _mnt_b);
            send(__fd, _mnt_b, strlen(_mnt_b), 0);
            free(_mnt_b);

            cline++;

            bzero(sline, 60);

            if (cline >= 5) {
                break;
            }

        }

        fclose(fbook);
        cline = 0;
    }


}

int blog(char *text, char *_modes) {

    char *logpath;
    logpath = malloc(strlen(dir) + 8);

    strcpy(logpath, dir);
    strcat(logpath, "log.log");

    int fw = 0;

    //Descritor do arquivo
    FILE *fl;

    //Abre o arquivo em modo de escrita no final do arquivo
    fl = fopen(logpath, _modes);

    fw = fprintf(fl, "%s\n", text);

    //Fecha descritor salvando alterações
    fclose(fl);

    free(logpath);

    return fw;
}

void gpn_bovespa(int __fd) {

    char *_line;
    _line = malloc(60);

    FILE *fbook;

    fbook = fopen(GPN_BOVESPA, "r");

    if (fbook != NULL) {

        while ((fgets(_line, 60, fbook)) != NULL) {

            removechars(_line, _line);

            char *_mnt_b;
            _mnt_b = malloc(MAX_BUF_SIZE);
            bzero(_mnt_b, MAX_BUF_SIZE);
            // Envia ao cliente a linha
            int ka = 0;
            for (ka = 0; ka <= strlen(_line); ka++) {
                //send(__fd, &bfline[ka], sizeof (char), 0);
                _mnt_b[ka] = _line[ka];
            }
            sprintf(_mnt_b, "%s\r\n", _mnt_b);
            send(__fd, _mnt_b, strlen(_mnt_b), 0);
            free(_mnt_b);


            bzero(_line, 60);


        }

        fclose(fbook);

    }


}

void gpn_bmf(int __fd) {

    char *_line;
    _line = malloc(60);

    FILE *fbook;

    fbook = fopen(GPN_BMF, "r");

    if (fbook != NULL) {

        while ((fgets(_line, 60, fbook)) != NULL) {

            removechars(_line, _line);

            char *_mnt_b;
            _mnt_b = malloc(MAX_BUF_SIZE);
            bzero(_mnt_b, MAX_BUF_SIZE);
            // Envia ao cliente a linha
            int ka = 0;
            for (ka = 0; ka <= strlen(_line); ka++) {
                //send(__fd, &bfline[ka], sizeof (char), 0);
                _mnt_b[ka] = _line[ka];
            }
            sprintf(_mnt_b, "%s\r\n", _mnt_b);
            send(__fd, _mnt_b, strlen(_mnt_b), 0);
            free(_mnt_b);


            bzero(_line, 60);


        }

        fclose(fbook);

    }



}

void getsymbol(char *_b, char *_s) {

    int start = 0;
    int end = 0;
    int count = 0;
    int i = 0;


    for (i = 0; i <= strlen(_b); i++) {
        //printf("%c\n",_b[i]);
        if (_b[i] == ':') {
            count++;

            if (count == 1) {
                start = (i + 1);
                // printf("%c\n",_b[start]);
            }

            if (count == 2) {
                end = (i - 1);
                //printf("%c\n",_b[end]);
                break;
            }

        }

    }

    count = 0;

    for (i = start; i <= end; i++) {
        _s[count] = _b[i];
        count++;
    }

    _s[count] = '\0';



}

void mounttrade(char *symbol, char *__t) {

    char *snap;
    snap = malloc(MAX_BUF_SIZE);
    bzero(snap, MAX_BUF_SIZE);

    char *symbolext;
    char *_read;

    symbolext = malloc(250);

    _read = malloc(15);

    strcpy(snap, "T:");
    strcat(snap, symbol);


    FILE *_fsnap;

    //strcpy(symbolext, symbol);
    sprintf(symbolext, "%s%s", SNAP_PATH, symbol);
    strcat(symbolext, ".5");
    _fsnap = fopen(symbolext, "r");
    if (_fsnap != NULL) {
        fgets(_read, 15, _fsnap);
        fclose(_fsnap);
        sprintf(snap, "%s:%s", snap, _read);
    } else {
        sprintf(snap, "%s:%s", snap, "000000");
    }

    //strcpy(symbolext, symbol);
    sprintf(symbolext, "%s%s", SNAP_PATH, symbol);
    strcat(symbolext, ".1");
    _fsnap = fopen(symbolext, "r");
    if (_fsnap != NULL) {
        fgets(_read, 15, _fsnap);
        fclose(_fsnap);
        sprintf(snap, "%s:1:%s", snap, _read);
    } else {
        sprintf(snap, "%s:1:%s", snap, "000000");
    }

    //strcpy(symbolext, symbol);
    sprintf(symbolext, "%s%s", SNAP_PATH, symbol);
    strcat(symbolext, ".2");
    _fsnap = fopen(symbolext, "r");
    if (_fsnap != NULL) {
        fgets(_read, 15, _fsnap);
        fclose(_fsnap);
        sprintf(snap, "%s:2:%s", snap, _read);
    } else {
        sprintf(snap, "%s:2:%s", snap, "0.00");
    }

    //strcpy(symbolext, symbol);
    sprintf(symbolext, "%s%s", SNAP_PATH, symbol);
    strcat(symbolext, ".3");
    _fsnap = fopen(symbolext, "r");
    if (_fsnap != NULL) {
        fgets(_read, 15, _fsnap);
        fclose(_fsnap);
        sprintf(snap, "%s:3:%s", snap, _read);
    } else {
        sprintf(snap, "%s:3:%s", snap, "0.00");
    }

    //strcpy(symbolext, symbol);
    sprintf(symbolext, "%s%s", SNAP_PATH, symbol);
    strcat(symbolext, ".4");
    _fsnap = fopen(symbolext, "r");
    if (_fsnap != NULL) {
        fgets(_read, 15, _fsnap);
        fclose(_fsnap);
        sprintf(snap, "%s:4:%s", snap, _read);
    } else {
        sprintf(snap, "%s:4:%s", snap, "0.00");
    }

    //strcpy(symbolext, symbol);
    sprintf(symbolext, "%s%s", SNAP_PATH, symbol);
    strcat(symbolext, ".5");
    _fsnap = fopen(symbolext, "r");
    if (_fsnap != NULL) {
        fgets(_read, 15, _fsnap);
        fclose(_fsnap);
        sprintf(snap, "%s:5:%s", snap, _read);
    } else {
        sprintf(snap, "%s:5:%s", snap, "000000");
    }

    //strcpy(symbolext, symbol);
    sprintf(symbolext, "%s%s", SNAP_PATH, symbol);
    strcat(symbolext, ".8");
    _fsnap = fopen(symbolext, "r");
    if (_fsnap != NULL) {
        fgets(_read, 15, _fsnap);
        fclose(_fsnap);
        sprintf(snap, "%s:8:%s", snap, _read);
    } else {
        sprintf(snap, "%s:8:%s", snap, "0");
    }

    //strcpy(symbolext, symbol);
    sprintf(symbolext, "%s%s", SNAP_PATH, symbol);
    strcat(symbolext, ".9");
    _fsnap = fopen(symbolext, "r");
    if (_fsnap != NULL) {
        fgets(_read, 15, _fsnap);
        fclose(_fsnap);
        sprintf(snap, "%s:9:%s", snap, _read);
    } else {
        sprintf(snap, "%s:9:%s", snap, "0");

    }

    //strcpy(symbolext, symbol);
    sprintf(symbolext, "%s%s", SNAP_PATH, symbol);
    strcat(symbolext, ".11");
    _fsnap = fopen(symbolext, "r");
    if (_fsnap != NULL) {
        fgets(_read, 15, _fsnap);
        fclose(_fsnap);
        sprintf(snap, "%s:11:%s", snap, _read);
    } else {
        sprintf(snap, "%s:11:%s", snap, "0.00");
    }

    //strcpy(symbolext, symbol);
    sprintf(symbolext, "%s%s", SNAP_PATH, symbol);
    strcat(symbolext, ".12");
    _fsnap = fopen(symbolext, "r");
    if (_fsnap != NULL) {
        fgets(_read, 15, _fsnap);
        fclose(_fsnap);
        sprintf(snap, "%s:12:%s", snap, _read);
    } else {
        sprintf(snap, "%s:12:%s", snap, "0.00");
    }

    //strcpy(symbolext, symbol);
    sprintf(symbolext, "%s%s", SNAP_PATH, symbol);
    strcat(symbolext, ".13");
    _fsnap = fopen(symbolext, "r");
    if (_fsnap != NULL) {
        fgets(_read, 15, _fsnap);
        fclose(_fsnap);
        sprintf(snap, "%s:13:%s", snap, _read);
    } else {
        sprintf(snap, "%s:13:%s", snap, "0.00");
    }

    //strcpy(symbolext, symbol);
    sprintf(symbolext, "%s%s", SNAP_PATH, symbol);
    strcat(symbolext, ".14");
    _fsnap = fopen(symbolext, "r");
    if (_fsnap != NULL) {
        fgets(_read, 15, _fsnap);
        fclose(_fsnap);
        sprintf(snap, "%s:14:%s", snap, _read);
    } else {
        sprintf(snap, "%s:14:%s", snap, "0.00");
    }

    //strcpy(symbolext, symbol);
    sprintf(symbolext, "%s%s", SNAP_PATH, symbol);
    strcat(symbolext, ".664");
    _fsnap = fopen(symbolext, "r");
    if (_fsnap != NULL) {
        fgets(_read, 15, _fsnap);
        fclose(_fsnap);
        sprintf(snap, "%s:664:%s", snap, _read);
    } else {
        sprintf(snap, "%s:664:%s", snap, "0.00");
    }

    sprintf(snap, "%s!\r\n", snap);

    strcpy(__t, snap);

    free(snap);
    free(symbolext);
    free(_read);

}

// SQT

void sqt(int _fd, char *_symbol) {
    // Cliente solicitou ativo

    // Cria nome do arquivo de solicitacao
    char *f_name;
    f_name = malloc(40);

    // Copia o nome do ativo para a string do nome
    // do arquivo
    strcpy(f_name, dir);
    strcat(f_name, _symbol);

    // Concatena a extensao
    strcat(f_name, ".sqt");

    // Cria arquivo de solicitação
    FILE *fsqt;
    fsqt = fopen(f_name, "w+");

    // Verifica se foi possivel criar arquivo
    if (fsqt != NULL) {

        // Foi possivel

        // Escreve algo apenas por seguranca
        fprintf(fsqt, "%s\n", "called");

        // Fecha arquivo
        fclose(fsqt);

        // Envia snapshot
        send(_fd, mntsnapshot(_symbol), strlen(mntsnapshot(_symbol)), 0);

    } else {

        // Não foi possivel

        // Emite mensagem de erro
        perror("Error on add sqt file");
    }

    // Libera da memoria a variavel do nome
    free(f_name);
}

void mbq(int _fd, char *_symbol, int _fifo) {
    // Cliente solicitou book

    // Cria nome do arquivo de solicitacao
    char *f_name;
    f_name = malloc(40);

    // Copia o nome do ativo para a string do nome
    // do arquivo
    strcpy(f_name, dir);
    strcat(f_name, _symbol);

    // Concatena a extensao
    strcat(f_name, ".mbq");

    // Cria arquivo de solicitação
    FILE *fmnt;
    fmnt = fopen(f_name, "w+");

    // Verifica se foi possivel criar arquivo
    if (fmnt != NULL) {

        // Foi possivel

        // Escreve algo apenas por seguranca
        fprintf(fmnt, "%s\n", "called");

        // Fecha arquivo
        fclose(fmnt);

        // Envia snapshot
        mbq_snapshoot(_fd, _symbol);

    } else {

        // Não foi possivel

        // Emite mensagem de erro
        perror("Error on add mnt file");
    }

    bzero(f_name, 40);

    // Cria comando
    //sprintf(f_name, "D:%s\r\n", _symbol);

    // Envia para o fifo
    //write(_fifo, f_name, strlen(f_name));

    // Libera da memoria a variavel do nome
    free(f_name);
}

void bqt(int _fd, char *_symbol, int _fifo) {
    // Cliente solicitou book

    // Cria nome do arquivo de solicitacao
    char *f_name;
    f_name = malloc(40);

    // Copia o nome do ativo para a string do nome
    // do arquivo
    strcpy(f_name, dir);
    strcat(f_name, _symbol);

    // Concatena a extensao
    strcat(f_name, ".bqt");

    // Cria arquivo de solicitação
    FILE *fmnt;
    fmnt = fopen(f_name, "w+");

    // Verifica se foi possivel criar arquivo
    if (fmnt != NULL) {

        // Foi possivel

        // Escreve algo apenas por seguranca
        fprintf(fmnt, "%s\n", "called");

        // Fecha arquivo
        fclose(fmnt);

        // Envia snapshot
        //bqt_snapshoot(_fd, _symbol);

    } else {

        // Não foi possivel

        // Emite mensagem de erro
        perror("Error on add bqt file");
    }

    bzero(f_name, 40);

    // Cria comando
    sprintf(f_name, "D:%s\r\n", _symbol);

    // Envia para o fifo
    write(_fifo, f_name, strlen(f_name));

    // Libera da memoria a variavel do nome
    free(f_name);
}

// Verifica login do usuario

int checkuser(int _fd, char *_user, char *_pass) {

    char *_rcheck;
    _rcheck = malloc(MAX_BUF_RECV);

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



}

void version_app(int _fd, char *_app) {

    if (!strcmp(_app, "ROUTER")) {
        send(_fd, "VERSION:ROUTER:1.3.1:www.acoesinvest.com.br/downloads/router/acoesrouter.exe\r\n", strlen("VERSION:ROUTER:1.3.1:www.acoesinvest.com.br/downloads/router/acoesrouter.exe\r\n"), 0);
    } else if (!strcmp(_app, "DIFROUTER")) {
        send(_fd, "VERSION:DIFROUTER:1.8:www.acoesinvest.com.br/downloads/router/diferencial/dmatrader.exe\r\n", strlen("VERSION:DIFROUTER:1.8:www.acoesinvest.com.br/downloads/router/diferencial/dmatrader.exe\r\n"), 0);
    }

}

int get_client(struct sockaddr *clientInformation, char *_add) {

    struct sockaddr_in *ipv4 = (struct sockaddr_in *) clientInformation;
    strcpy(_add, inet_ntoa(ipv4->sin_addr));

    return 1;
}

void mbq_snapshoot(int __f, char *__s) {

    char *__fpmbq;
    __fpmbq = malloc(strlen(SNAPBK_PATH) + 50);

    char *__data;
    __data = malloc(80);

    char *__line;
    __line = malloc(80);

    FILE *__fmbq;

    int pos = 0;
    int cont = 0;

    do {

        bzero(__data, 80);
        bzero(__line, 80);
        bzero(__fpmbq, strlen(SNAPBK_PATH) + 50);
        sprintf(__fpmbq, "%s%s.A.%d", SNAPBK_PATH, __s, pos);
        __fmbq = fopen(__fpmbq, "r");
        if (__fmbq != NULL) {
            fgets(__data, 80, __fmbq);
            if (__data[0] != '-') {
                sprintf(__line, "M:%s:U:%d:%d:A:%s\r\n", __s, cont, cont, __data);
                send(__f, __line, strlen(__line), 0);
                cont++;
                pos++;
            } else {
                pos++;
            }
            fclose(__fmbq);
        } else {
            pos++;
            cont++;
        }

    } while (cont <= 4);


    pos = 0;
    cont = 0;

    do {

        bzero(__data, 80);
        bzero(__line, 80);
        bzero(__fpmbq, strlen(SNAPBK_PATH) + 50);
        sprintf(__fpmbq, "%s%s.V.%d", SNAPBK_PATH, __s, pos);
        __fmbq = fopen(__fpmbq, "r");
        if (__fmbq != NULL) {
            fgets(__data, 80, __fmbq);
            if (__data[0] != '-') {
                sprintf(__line, "M:%s:U:%d:%d:V:%s\r\n", __s, cont, cont, __data);
                send(__f, __line, strlen(__line), 0);
                cont++;
                pos++;
            } else {
                pos++;
            }
            fclose(__fmbq);
        } else {
            pos++;
            cont++;
        }

    } while (cont <= 4);

    /*
        bzero(__data, 80);
        bzero(__fpmbq, strlen(SNAPBK_PATH) + 50);
        sprintf(__fpmbq, "%s%s.A.0", SNAPBK_PATH, __s);
        __fmbq = fopen(__fpmbq, "r");
        if (__fmbq != NULL) {
            fgets(__data, 80, __fmbq);
            sprintf(__data, "%s\r\n", __data);
            send(__f, __data, strlen(__data), 0);
            fclose(__fmbq);
        }

        bzero(__data, 80);
        bzero(__fpmbq, strlen(SNAPBK_PATH) + 50);
        sprintf(__fpmbq, "%s%s.A.1", SNAPBK_PATH, __s);
        __fmbq = fopen(__fpmbq, "r");
        if (__fmbq != NULL) {
            fgets(__data, 80, __fmbq);
            sprintf(__data, "%s\r\n", __data);
            send(__f, __data, strlen(__data), 0);
            fclose(__fmbq);
        }

        bzero(__data, 80);
        bzero(__fpmbq, strlen(SNAPBK_PATH) + 50);
        sprintf(__fpmbq, "%s%s.A.2", SNAPBK_PATH, __s);
        __fmbq = fopen(__fpmbq, "r");
        if (__fmbq != NULL) {
            fgets(__data, 80, __fmbq);
            sprintf(__data, "%s\r\n", __data);
            send(__f, __data, strlen(__data), 0);
            fclose(__fmbq);
        }

        bzero(__data, 80);
        bzero(__fpmbq, strlen(SNAPBK_PATH) + 50);
        sprintf(__fpmbq, "%s%s.A.3", SNAPBK_PATH, __s);
        __fmbq = fopen(__fpmbq, "r");
        if (__fmbq != NULL) {
            fgets(__data, 80, __fmbq);
            sprintf(__data, "%s\r\n", __data);
            send(__f, __data, strlen(__data), 0);
            fclose(__fmbq);
        }

        bzero(__data, 80);
        bzero(__fpmbq, strlen(SNAPBK_PATH) + 50);
        sprintf(__fpmbq, "%s%s.A.4", SNAPBK_PATH, __s);
        __fmbq = fopen(__fpmbq, "r");
        if (__fmbq != NULL) {
            fgets(__data, 80, __fmbq);
            sprintf(__data, "%s\r\n", __data);
            send(__f, __data, strlen(__data), 0);
            fclose(__fmbq);
        }

        bzero(__data, 80);
        bzero(__fpmbq, strlen(SNAPBK_PATH) + 50);
        sprintf(__fpmbq, "%s%s.V.0", SNAPBK_PATH, __s);
        __fmbq = fopen(__fpmbq, "r");
        if (__fmbq != NULL) {
            fgets(__data, 80, __fmbq);
            sprintf(__data, "%s\r\n", __data);
            send(__f, __data, strlen(__data), 0);
            fclose(__fmbq);
        }

        bzero(__data, 80);
        bzero(__fpmbq, strlen(SNAPBK_PATH) + 50);
        sprintf(__fpmbq, "%s%s.V.1", SNAPBK_PATH, __s);
        __fmbq = fopen(__fpmbq, "r");
        if (__fmbq != NULL) {
            fgets(__data, 80, __fmbq);
            sprintf(__data, "%s\r\n", __data);
            send(__f, __data, strlen(__data), 0);
            fclose(__fmbq);
        }

        bzero(__data, 80);
        bzero(__fpmbq, strlen(SNAPBK_PATH) + 50);
        sprintf(__fpmbq, "%s%s.V.2", SNAPBK_PATH, __s);
        __fmbq = fopen(__fpmbq, "r");
        if (__fmbq != NULL) {
            fgets(__data, 80, __fmbq);
            sprintf(__data, "%s\r\n", __data);
            send(__f, __data, strlen(__data), 0);
            fclose(__fmbq);
        }

        bzero(__data, 80);
        bzero(__fpmbq, strlen(SNAPBK_PATH) + 50);
        sprintf(__fpmbq, "%s%s.V.3", SNAPBK_PATH, __s);
        __fmbq = fopen(__fpmbq, "r");
        if (__fmbq != NULL) {
            fgets(__data, 80, __fmbq);
            sprintf(__data, "%s\r\n", __data);
            send(__f, __data, strlen(__data), 0);
            fclose(__fmbq);
        }

        bzero(__data, 80);
        bzero(__fpmbq, strlen(SNAPBK_PATH) + 50);
        sprintf(__fpmbq, "%s%s.V.4", SNAPBK_PATH, __s);
        __fmbq = fopen(__fpmbq, "r");
        if (__fmbq != NULL) {
            fgets(__data, 80, __fmbq);
            sprintf(__data, "%s\r\n", __data);
            send(__f, __data, strlen(__data), 0);
            fclose(__fmbq);
        }
     */


    free(__data);
    free(__fpmbq);

}

void bqt_snapshoot(int __f, char *__s) {

    mbq_snapshoot(__f, __s);

    char *__fpmbq;
    __fpmbq = malloc(strlen(SNAPBK_PATH) + 50);

    char *__data;
    __data = malloc(80);

    char *__line;
    __line = malloc(80);

    FILE *__fmbq;

    int pos = 0;
    int cont = 0;

    do {

        bzero(__data, 80);
        bzero(__line, 80);
        bzero(__fpmbq, strlen(SNAPBK_PATH) + 50);
        sprintf(__fpmbq, "%s%s.A.%d", SNAPBK_PATH, __s, pos);
        __fmbq = fopen(__fpmbq, "r");
        if (__fmbq != NULL) {
            fgets(__data, 80, __fmbq);
            if (__data[0] != '-') {
                sprintf(__line, "B:%s:U:%d:%d:A:%s\r\n", __s, cont, cont, __data);
                send(__f, __line, strlen(__line), 0);
                cont++;
                pos++;
            } else {
                pos++;
            }
            fclose(__fmbq);
        } else {
            cont = -1;
        }

    } while (cont != -1);


    pos = 0;
    cont = 0;

    do {

        bzero(__data, 80);
        bzero(__line, 80);
        bzero(__fpmbq, strlen(SNAPBK_PATH) + 50);
        sprintf(__fpmbq, "%s%s.V.%d", SNAPBK_PATH, __s, pos);
        __fmbq = fopen(__fpmbq, "r");
        if (__fmbq != NULL) {
            fgets(__data, 80, __fmbq);
            if (__data[0] != '-') {
                sprintf(__line, "B:%s:U:%d:%d:V:%s\r\n", __s, cont, cont, __data);
                send(__f, __line, strlen(__line), 0);
                cont++;
                pos++;
            } else {
                pos++;
            }
            fclose(__fmbq);
        } else {
            cont = -1;
        }

    } while (cont != -1);

    /*
        bzero(__data, 80);
        bzero(__fpmbq, strlen(SNAPBK_PATH) + 50);
        sprintf(__fpmbq, "%s%s.A.0", SNAPBK_PATH, __s);
        __fmbq = fopen(__fpmbq, "r");
        if (__fmbq != NULL) {
            fgets(__data, 80, __fmbq);
            sprintf(__data, "%s\r\n", __data);
            send(__f, __data, strlen(__data), 0);
            fclose(__fmbq);
        }

        bzero(__data, 80);
        bzero(__fpmbq, strlen(SNAPBK_PATH) + 50);
        sprintf(__fpmbq, "%s%s.A.1", SNAPBK_PATH, __s);
        __fmbq = fopen(__fpmbq, "r");
        if (__fmbq != NULL) {
            fgets(__data, 80, __fmbq);
            sprintf(__data, "%s\r\n", __data);
            send(__f, __data, strlen(__data), 0);
            fclose(__fmbq);
        }

        bzero(__data, 80);
        bzero(__fpmbq, strlen(SNAPBK_PATH) + 50);
        sprintf(__fpmbq, "%s%s.A.2", SNAPBK_PATH, __s);
        __fmbq = fopen(__fpmbq, "r");
        if (__fmbq != NULL) {
            fgets(__data, 80, __fmbq);
            sprintf(__data, "%s\r\n", __data);
            send(__f, __data, strlen(__data), 0);
            fclose(__fmbq);
        }

        bzero(__data, 80);
        bzero(__fpmbq, strlen(SNAPBK_PATH) + 50);
        sprintf(__fpmbq, "%s%s.A.3", SNAPBK_PATH, __s);
        __fmbq = fopen(__fpmbq, "r");
        if (__fmbq != NULL) {
            fgets(__data, 80, __fmbq);
            sprintf(__data, "%s\r\n", __data);
            send(__f, __data, strlen(__data), 0);
            fclose(__fmbq);
        }

        bzero(__data, 80);
        bzero(__fpmbq, strlen(SNAPBK_PATH) + 50);
        sprintf(__fpmbq, "%s%s.A.4", SNAPBK_PATH, __s);
        __fmbq = fopen(__fpmbq, "r");
        if (__fmbq != NULL) {
            fgets(__data, 80, __fmbq);
            sprintf(__data, "%s\r\n", __data);
            send(__f, __data, strlen(__data), 0);
            fclose(__fmbq);
        }

        bzero(__data, 80);
        bzero(__fpmbq, strlen(SNAPBK_PATH) + 50);
        sprintf(__fpmbq, "%s%s.V.0", SNAPBK_PATH, __s);
        __fmbq = fopen(__fpmbq, "r");
        if (__fmbq != NULL) {
            fgets(__data, 80, __fmbq);
            sprintf(__data, "%s\r\n", __data);
            send(__f, __data, strlen(__data), 0);
            fclose(__fmbq);
        }

        bzero(__data, 80);
        bzero(__fpmbq, strlen(SNAPBK_PATH) + 50);
        sprintf(__fpmbq, "%s%s.V.1", SNAPBK_PATH, __s);
        __fmbq = fopen(__fpmbq, "r");
        if (__fmbq != NULL) {
            fgets(__data, 80, __fmbq);
            sprintf(__data, "%s\r\n", __data);
            send(__f, __data, strlen(__data), 0);
            fclose(__fmbq);
        }

        bzero(__data, 80);
        bzero(__fpmbq, strlen(SNAPBK_PATH) + 50);
        sprintf(__fpmbq, "%s%s.V.2", SNAPBK_PATH, __s);
        __fmbq = fopen(__fpmbq, "r");
        if (__fmbq != NULL) {
            fgets(__data, 80, __fmbq);
            sprintf(__data, "%s\r\n", __data);
            send(__f, __data, strlen(__data), 0);
            fclose(__fmbq);
        }

        bzero(__data, 80);
        bzero(__fpmbq, strlen(SNAPBK_PATH) + 50);
        sprintf(__fpmbq, "%s%s.V.3", SNAPBK_PATH, __s);
        __fmbq = fopen(__fpmbq, "r");
        if (__fmbq != NULL) {
            fgets(__data, 80, __fmbq);
            sprintf(__data, "%s\r\n", __data);
            send(__f, __data, strlen(__data), 0);
            fclose(__fmbq);
        }

        bzero(__data, 80);
        bzero(__fpmbq, strlen(SNAPBK_PATH) + 50);
        sprintf(__fpmbq, "%s%s.V.4", SNAPBK_PATH, __s);
        __fmbq = fopen(__fpmbq, "r");
        if (__fmbq != NULL) {
            fgets(__data, 80, __fmbq);
            sprintf(__data, "%s\r\n", __data);
            send(__f, __data, strlen(__data), 0);
            fclose(__fmbq);
        }
     */


    free(__data);
    free(__fpmbq);

}

void chart(int _fd, char *cmd) {

    // Parametros
    char *param1;
    char *param2;
    char *param3;
    char *param4;
    char *param5;
    char *param6;
    char *param7;
    char *param8;

    // Aloca Parametros
    param1 = malloc(sizeof (char) *30);
    param2 = malloc(sizeof (char) *30);
    param3 = malloc(sizeof (char) *30);
    param4 = malloc(sizeof (char) *30);
    param5 = malloc(sizeof (char) *30);
    param6 = malloc(sizeof (char) *30);
    param7 = malloc(sizeof (char) *30);
    param8 = malloc(sizeof (char) *30);

    char mounth[3];
    char day[3];

    char *pathfile;
    pathfile = malloc(MAX_BUF_SIZE);


    char *linedata;
    linedata = malloc(MAX_BUF_SIZE);

    char *chartid;
    chartid = malloc(MAX_BUF_SIZE);

    char *chartheader;
    chartheader = malloc(MAX_BUF_SIZE);

    char *charttime;
    charttime = malloc(MAX_BUF_SIZE);

    // Separa os parametros
    sscanf(cmd, "%s %s %s %s %s %s %s %s", param1, param2, param3, param4, param5, param6, param7, param8);

    // Compara se o primeiro parametro é um request
    if (!strcmp(param2, "request")) {


        // Verifica se o proximo é since
        if (!strcmp(param4, "since")) {

            uppercase(param3);

            // Como é since, assume que o proximo parametro é a data e hora

            // Pega o mes e o dia
            mounth[0] = param5[4];
            mounth[1] = param5[5];
            mounth[2] = '\0';
            day[0] = param5[6];
            day[1] = param5[7];
            day[2] = '\0';

            int monthrange = atoi(mounth);
            int dayrange = atoi(day);

            int mr = monthrange;
            int dr = dayrange;

            // Gera ID do grafico
            gettime("%M%H%S", chartid);

            if (!strcmp(param6, "daily")) {
                strcpy(pathfile, "/home/donda/ddc/buffer/chart");
                sprintf(pathfile, "%s/daily/%s.data", pathfile, param3);

                FILE *fdatas = fopen(pathfile, "r");

                sprintf(pathfile,"%s\r\n",pathfile);
                send(_fd, pathfile, strlen(pathfile), 0);

                if (fdatas != NULL) {

                    while (fgets(linedata, MAX_BUF_SIZE, fdatas) != NULL) {
                        // Pega o header
                        sprintf(chartheader, "C:%s:%s:D:A:", chartid, param3);

                        sscanf(linedata, "%[^':']:%s", charttime, linedata);

                        sprintf(chartheader, "%s%s:%s\r\n", chartheader, charttime, linedata);

                        send(_fd, chartheader, strlen(chartheader), 0);

                        // limpa header
                        bzero(chartheader, MAX_BUF_SIZE);
                    }

                } else {
                    strcpy(linedata, "E:CHART:2\r\n");
                    send(_fd, linedata, strlen(linedata), 0);
                }

            } else {

                for (mr = monthrange; mr <= 12; mr++) {
                    if (mr > monthrange) {
                        dr = 1;
                    } else {
                        dr = dayrange;
                    }
                    for (dr = dr; dr <= 31; dr++) {
                        strcpy(pathfile, "/home/donda/ddc/buffer/chart");
                        if (mr < 10) {
                            if (dr < 10) {
                                sprintf(pathfile, "%s/0%d0%d", pathfile, mr, dr);
                            } else {
                                sprintf(pathfile, "%s/0%d%d", pathfile, mr, dr);
                            }
                        } else {
                            if (dr < 10) {
                                sprintf(pathfile, "%s/%d0%d", pathfile, mr, dr);
                            } else {
                                sprintf(pathfile, "%s/%d%d", pathfile, mr, dr);
                            }
                        }

                        // Verifica o periodo
                        if (!strcmp(param6, "intraday")) {

                            sprintf(pathfile, "%s/%s/%s.data", pathfile, param7, param3);

                            FILE *fdatas = fopen(pathfile, "r");

                            if (fdatas != NULL) {


                                while (fgets(linedata, MAX_BUF_SIZE, fdatas) != NULL) {
                                    // Pega o header
                                    if (dr < 10) {
                                        if (mr<10){
                                            sprintf(chartheader, "C:%s:%s:%s:A:20100%d0%d:", chartid, param3, param7, mr, dr);
                                        }else{
                                            sprintf(chartheader, "C:%s:%s:%s:A:2010%d0%d:", chartid, param3, param7, mr, dr);
                                        }
                                    } else {
                                        if(mr<10){
                                            sprintf(chartheader, "C:%s:%s:%s:A:20100%d%d:", chartid, param3, param7, mr, dr);
                                        }else{
                                            sprintf(chartheader, "C:%s:%s:%s:A:2010%d%d:", chartid, param3, param7, mr, dr);
                                        }
                                    }

                                    sscanf(linedata, "%[^':']:%s", charttime, linedata);

                                    sprintf(chartheader, "%s%s00:%s\r\n", chartheader, charttime, linedata);

                                    send(_fd, chartheader, strlen(chartheader), 0);

                                    // limpa header
                                    bzero(chartheader, MAX_BUF_SIZE);
                                }

                            } else {
                                //strcpy(linedata, "E:CHART:2\r\n");
                                //send(_fd, linedata, strlen(linedata), 0);
                            }


                        }

                    }
                }

                // Pega o candle atual
                strcpy(pathfile, "/home/donda/ddc/buffer/chart/");
                char *dataatual;
                dataatual = malloc(MAX_BUF_SIZE);
                gettime("%m%d", dataatual);
                sprintf(pathfile, "%s%s", pathfile, dataatual);
                sprintf(pathfile, "%s/%s/%s.candle", pathfile, param7, param3);
                FILE *fcandle;
                fcandle = fopen(pathfile, "r");
                if (fcandle != NULL) {
                    fgets(linedata, MAX_BUF_SIZE, fcandle);
                    sprintf(chartheader, "C:%s:%s:%s:A:2010%s:", chartid, param3, param7, dataatual);
                    sscanf(linedata, "%[^':']:%s", charttime, linedata);
                    sprintf(chartheader, "%s%s00:%s\r\n", chartheader, charttime, linedata);
                    send(_fd, chartheader, strlen(chartheader), 0);
                    fclose(fcandle);
                }
                // Fim candle atual
                free(dataatual);
            }


            // Pega o header
            sprintf(chartheader, "C:%s:%s:END\r\n", chartid, param3);
            send(_fd, chartheader, strlen(chartheader), 0);

            // limpa header
            bzero(chartheader, MAX_BUF_SIZE);

            // Escreve arquivo de solicitacao
            sprintf(chartheader, "%s%s.cht", dir, param7);

            FILE *fsol = fopen(chartheader, "a+");

            if (fsol != NULL) {
                fprintf(fsol, "ChartID : %s\n", chartid);
                fprintf(fsol, "ChartSymbol : %s\n", param3);
                fclose(fsol);
            }


        }

    }

    free(param1);
    free(param2);
    free(param3);
    free(param4);
    free(param5);
    free(param6);
    free(param7);
    free(param8);
    free(pathfile);
    free(linedata);
    free(chartid);
    free(chartheader);
    free(charttime);

}

void readchart(int __fd) {

    // Ponteiro para o arquivo
    FILE *fchart = fopen("/home/donda/ddc/buffer/ddcchart.data", "r");

    char *linechart;
    linechart = malloc(MAX_BUF_SIZE);
    char *linechartr;
    linechartr = malloc(MAX_BUF_SIZE);

    char *chartsymbol;
    char *charttime;
    char *chartid;
    char *chartheader;
    char *charttype;
    char *charthour;
    char *chartdata;
    char *chartpath;

    chartid = malloc(MAX_BUF_SIZE);
    chartsymbol = malloc(MAX_BUF_SIZE);
    charttime = malloc(MAX_BUF_SIZE);
    chartheader = malloc(MAX_BUF_SIZE);
    charttype = malloc(MAX_BUF_SIZE);
    charthour = malloc(MAX_BUF_SIZE);
    chartdata = malloc(MAX_BUF_SIZE);
    chartpath = malloc(MAX_BUF_SIZE);

    char *linef = NULL;
    linef = malloc(MAX_BUF_SIZE);

    char *m1, *m2, *m3;
    m1 = malloc(MAX_BUF_SIZE);
    m2 = malloc(MAX_BUF_SIZE);
    m3 = malloc(MAX_BUF_SIZE);

    char *snap;
    snap = malloc(MAX_BUF_SIZE);
    bzero(snap, MAX_BUF_SIZE);

    char *chartdate = NULL;
    chartdate = malloc(MAX_BUF_SIZE);

    // Se abriu lÊ
    if (fchart != NULL) {

        // Vai até o fim do arquivo
        fseek(fchart, 1, SEEK_END);

        while (1) {

            while (fgets(linechart, MAX_BUF_SIZE, fchart) != NULL) {

                if (linechart[0] == 'C') {

                    //send(__fd,bfline,strlen(bfline),0);

                    sscanf(linechart, "%[^':']:%[^':']:%[^':']:%[^':']:%[^':']:%s", chartheader, chartsymbol, charttime, charthour, charttype, chartdata);

                    sprintf(chartpath, "%s%s.cht", dir, charttime);

                    //send(__fd,chartpath,strlen(chartpath),0);

                    FILE *fsolchart = fopen(chartpath, "r");

                    if (fsolchart != NULL) {
                        while (fgets(linef, MAX_BUF_SIZE, fsolchart) != NULL) {
                            sscanf(linef, "%s %s %s", m1, m2, m3);

                            if (!strcmp(m1, "ChartID")) {
                                strcpy(chartid, m3);
                            }

                            if (!strcmp(m1, "ChartSymbol")) {

                                if (!strcmp(m3, chartsymbol)) {

                                    bzero(chartheader, MAX_BUF_SIZE);

                                    strcat(charthour, "00");

                                    gettime("%Y%m%d", chartdate);

                                    sprintf(chartheader, "C:%s:%s:%s:%s:%s:%s:%s\r\n", chartid, chartsymbol, charttime, charttype, chartdate, charthour, chartdata);

                                    send(__fd, chartheader, strlen(chartheader), 0);
                                }

                            }

                            bzero(m1, MAX_BUF_SIZE);
                            bzero(m2, MAX_BUF_SIZE);
                            bzero(m3, MAX_BUF_SIZE);
                        }

                        fclose(fsolchart);
                    }

                }

                bzero(linechart, MAX_BUF_SIZE);

            }

            usleep(1000);

        }
    }

    free(chartid);
    free(chartsymbol);
    free(charttime);
    free(charttype);
    free(chartheader);
    free(charthour);
    free(chartdata);


}
