/*
 * File:   main.c
 * Author: donda
 *
 * Created on March 15, 2010, 2:56 PM
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <time.h>
#include <unistd.h>
#include <signal.h>
#include <netdb.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/types.h>

/*Biblioteca Acoes Invest*/
#include "ailib.h"

/*Bibliotecas Locais do projeto*/
#include "enfoque.h"

/********************************************************/
/*            Definicoes de caminhos e Palavras         */
#define BUF_PATH "/home/donda/ddc/buffer/"
#define SYMBOL_PATH "/home/donda/ddc/symbols.cal"
#define SNAP_PATH "/home/donda/ddc/snapshot/trades/"
#define SNAP_BK_PATH "/home/donda/ddc/snapshot/books/"
#define TERMINAL_LOG "/home/donda/ddc/ddcenfoque.log"
#define SYNCH_BUFF_FILE "/home/donda/ddc/buffer/last.buf"
#define FIFO_ARQ "/home/donda/ddc/buffer/fifo"
#define HEADER_LOG "********* Start DDCEnfoque*************"
#define FOOTER_LOG "********* End DDCEnfoque *************"
#define DEFAULT_PATH "/home/donda/ddc/"
#define LOGIN_ENFOQUE "L:DIFERENCIAL_FEED:ROGERIO:NMB+TRD\r\n"
#define MSG_ERR_CONN "Error on connect to server."
/*********************************************************/

/*********************************************************/
/*                 Definicioes de Tamanhos               */
#define MAX_BUF_SIZE sizeof(char) * 1000
#define SYMBOL_SIZE sizeof(char) * 20
#define MAX_CRYSTAL 2
#define DEFAULT_TIMEOUT 35
/*********************************************************/

/*********************************************************/
/*                 Definicioes de Servidores             */
#define SVR_CRYSTAL_1 "socket1.enfoque.com.br"
#define SVR_CRYSTAL_2 "socket2.enfoque.com.br"
#define SVR_PORT 8090
/*********************************************************/


/* Declaração das funcoes globais*/
int file_exist(char *fname);
void changecrystal(int _sig);
void filepiper(int _fd);
void temp_book(char *__s, char *_b);

// Id inicial de qual crystal usar
int crystal_id = 1;

// Flag para alteracao
int crystal_flag = 0;

char *cedrobooks;
int addcountc = 0;
int addcountv = 0;

int main(int argc, char** argv) {

    cedrobooks = malloc(sizeof (char) *1000);

    //Descritores do PID e SID
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
    writeln(TERMINAL_LOG, "Daemon Iniciado com sucesso.", "a+");
    writeln(TERMINAL_LOG, FOOTER_LOG, "a+");

    // Descritor com conexao ao servidor
    int s = -1;

    // Buffer de dados
    char *buffer;
    //Aloca na memoria buffer de dados
    buffer = malloc(MAX_BUF_SIZE);

    // Arquivos de buffer
    char *bfile, *bflast, *bfiletmp;

    int login = 0;

    // Aloca arquivos de buffers
    bfile = malloc(strlen(BUF_PATH) + 26);
    bflast = malloc(strlen(BUF_PATH) + 26);
    bfiletmp = malloc(strlen(BUF_PATH) + 26);

    // Limpa conteudo da variavel temp
    bzero(bfiletmp, strlen(BUF_PATH) + 26);

    // Registra sinal de troca de crystais
    signal(SIGUSR1, changecrystal);

    // Loop de conexao
    // sempre true, ja que tenta infinitamente
    while (1) {

        // Gera uma conexao
        writeln(TERMINAL_LOG, HEADER_LOG, "a+");
        writeln(TERMINAL_LOG, "Conectando-se ao Enfoque", "a+");

        switch (crystal_id) {

            case 1: writeln(TERMINAL_LOG, SVR_CRYSTAL_1, "a+");
                s = connecttoserver(SVR_CRYSTAL_1, SVR_PORT);
                break;
            case 2: writeln(TERMINAL_LOG, SVR_CRYSTAL_2, "a+");
                s = connecttoserver(SVR_CRYSTAL_2, SVR_PORT);
                break;

        }

        writeln(TERMINAL_LOG, FOOTER_LOG, "a+");


        // Verifica a conexao
        if (s < 0) {
            // Emite mensagem de erro
            writeln(TERMINAL_LOG, HEADER_LOG, "a+");
            writeln(TERMINAL_LOG, "Erro ao se conectar ao Enfoque", "a+");

            switch (crystal_id) {

                case 1: writeln(TERMINAL_LOG, SVR_CRYSTAL_1, "a+");
                    break;
                case 2: writeln(TERMINAL_LOG, SVR_CRYSTAL_2, "a+");
                    break;

            }

            writeln(TERMINAL_LOG, FOOTER_LOG, "a+");

            // Altera o crystal
            crystal_id++;

            // Se passou do 5 volta para o 1
            if (crystal_id > MAX_CRYSTAL) {
                crystal_id = 1;
            }

            // Aguarda 1 segundo para reinicio
            sleep(1);

            // Força reinicio ao loop
            continue;
        }

        writeln(TERMINAL_LOG, HEADER_LOG, "a+");
        writeln(TERMINAL_LOG, "Conectado", "a+");
        writeln(TERMINAL_LOG, FOOTER_LOG, "a+");

        /*Cria o processo filho que lera o FIFO com as entradas de comando*/
        pid_t fifo;

        fifo = fork();

        // Verifica se criou o processo fifo
        if (fifo < 0) {
            //Erro na criacao do fifo

            writeln(TERMINAL_LOG, HEADER_LOG, "a+");
            writeln(TERMINAL_LOG, "Erro ao criar fifo.", "a+");
            writeln(TERMINAL_LOG, FOOTER_LOG, "a+");
            exit(EXIT_FAILURE);
        }

        // Se for o processo fifo executa sua funcao
        // e se sair da funcao a um exit
        if (fifo == 0) {
            filepiper(s);
            //exit(0);
        }

        // Aqui é o processo pai ( fifo != 0 )


        // Registra nome do arquivo de buffer
        // nas variaveis auxiliares
        gettbf(bfiletmp);
        sprintf(bfile, "%s%s", BUF_PATH, bfiletmp);
        strcpy(bflast, bfile);

        // Marca inicio de conexao no buffer ( isso garante q o arquivo seja criado se ja mudou de minuto )
        writeln(bfile, "StartConnection", "a+");

        // Atualiza o arquivo de sincronização com o
        // arquivo de buffer atual
        writeln(SYNCH_BUFF_FILE, bfile, "w+");

        // Limpa conteudo da variavel temp
        bzero(bfiletmp, strlen(BUF_PATH) + 26);

        send(s, LOGIN_ENFOQUE, strlen(LOGIN_ENFOQUE), 0);

        // Lê dados do socket até
        // retornar -1
        while (readline(s, buffer, DEFAULT_TIMEOUT) > 0) {

            // Buffer secundario com as msgs recebidas pela enfoque
            writeln("/home/donda/ddc/buffer/enfoque.msg", buffer, "a+");


            // Verifica se não foi solicitado para se alterar de crystal
            if (crystal_flag == 1) {

                // Foi, quebramos o loop para iniciar o proximo
                writeln(TERMINAL_LOG, HEADER_LOG, "a+");
                writeln(TERMINAL_LOG, "Alterando Enfoque", "a+");
                writeln(TERMINAL_LOG, FOOTER_LOG, "a+");

                // Desativa flag antes de quebrar loop
                crystal_flag = 0;

                break;
            }

            // Se for mensagem de login OK chama ativos
            if (buffer[0] == 'M' && buffer[2] == 'H') {
                send(s, "C:\r\n", strlen("C:\r\n"), 0);
                sleep(2);
                subsymbols(s, SYMBOL_PATH, SYMBOL_SIZE);
            }

            // Recebe o nome do arquivo atual do buffer
            gettbf(bfiletmp);
            sprintf(bfile, "%s%s", BUF_PATH, bfiletmp);

            // Limpa conteudo da variavel temp
            bzero(bfiletmp, strlen(BUF_PATH) + 26);

            // Analisa a primeira letra da mensagem.
            // para ver que tipo de mensagem é
            if (buffer[0] == 'T' ) {
                // Mensagens Tick ( T: ) e Negocios ( N: )

                // Variavel que conterá a mensagem convertida para o formato cedro
                char *cedrofmt = malloc(sizeof (char) *1000);

                // Utiliza a funcao da biblioteca Ailib que ja faz as conversoes
                entoce(buffer, cedrofmt);

                // Certo, como o dado foi convertido escrevemos
                // a mensagem no buffer central
                if (cedrofmt != NULL) {
                    writeln(bfile, cedrofmt, "a+");
                }

                // Limpa a variavel da memoria
                free(cedrofmt);

            } else if (buffer[0] == 'N') {
                // Mensagens Tick ( T: ) e Negocios ( N: )

                // Variavel que conterá a mensagem convertida para o formato cedro
                char *cedrofmt = malloc(sizeof (char) *1000);

                // Utiliza a funcao da biblioteca Ailib que ja faz as conversoes
                entoce(buffer, cedrofmt);

                // Certo, como o dado foi convertido escrevemos
                // a mensagem no buffer central
                if (cedrofmt != NULL) {
                    writeln(bfile, cedrofmt, "a+");
                }

                // Limpa a variavel da memoria
                free(cedrofmt);

            } else if (buffer[0] == 'D') {

                // Mensagem de livro dinamico
                // faz um tratamento diferente já que o separador
                // de dados é o : e nao o TAB

                // Estrutura para analise
                struct TDDCData *dbook = createlist();

                // Popula a estrutura ( 58 é o codigo asci para o : )
                splitcolumns(buffer, 58, dbook);

                // Estrutura temporaria varredura dos dados da estrutura
                struct TDDCData *tmp = dbook;

                // Flag que ira manipular o tipo de mensagem
                int book_type = 0;

                // Mensagem montada
                char *bookcedro = malloc(sizeof (char) *1000);

                // Posicao para msgs tipo U
                char *position = malloc(sizeof (char) *1000);

                // Varre a estrutura
                while (tmp) {

                    // Indice 1, onde contem que tipo de mensagem
                    // do livro é. Verifica que tipo é para iniciar
                    // a mudanca
                    if (tmp->index == 1) {

                        // Tipo C, selecao do ativo
                        if (tmp->value[0] == 'C') {

                            // Vai para o proximo dado
                            tmp = tmp->next;

                            // Copia o ativo para a variavel global
                            // que controla o ativo selecionado
                            strcpy(cedrobooks, tmp->value);

                            // Altera flag de tipo de msg para -1,
                            // assim nao sera impresso no buffer essa
                            // linha
                            book_type = -1;

                            // Zera o contador de linhas para tipo A
                            addcountc = 0;
                            addcountv = 0;

                            break;

                        } else if (tmp->value[0] == 'U') {

                            // Mensagem de atualizacao, montamos
                            // o cabecao da mensagem com o ativo
                            // que esta na variavel global.
                            sprintf(bookcedro, "K:%s:U", cedrobooks);

                            // Altera a falg que identifica que tipo de mensagem é
                            book_type = 1;

                        } else if (tmp->value[0] == 'D') {

                            // Mensagem de delecao, montamos
                            // o cabecao da mensagem com o ativo
                            // que esta na variavel global.
                            sprintf(bookcedro, "K:%s:D", cedrobooks);

                            // Altera a flag que identifica que tipo de mensagem é
                            book_type = 2;

                        } else if (tmp->value[0] == 'A') {

                            // Mensagem de adição, vai para o proximo indice
                            // e ve qual é a direcao
                            tmp = tmp->next;

                            if (tmp->value[0] == 'A') {
                                // Direcao compra
                                sprintf(bookcedro, "K:%s:A:%d", cedrobooks, addcountc);
                                addcountc++;
                            } else if (tmp->value[0] == 'V') {
                                // Direcao venda
                                sprintf(bookcedro, "K:%s:A:%d", cedrobooks, addcountv);
                                addcountv++;
                            }


                            // Altera a flag
                            book_type = 3;


                        }

                    }

                    // Indice 2
                    if (tmp->index == 2) {

                        // Se msg do tipo U, entao copia a direcao para
                        // a variavel temporaria, para depois utiliza-la

                        if (book_type == 1) {
                            strcpy(position, tmp->value);
                        } else if (book_type == 2 || book_type == 3) {
                            // Mensagem do tipo delecao ou adicao, apenas concatena
                            sprintf(bookcedro, "%s:%s", bookcedro, tmp->value);
                        }

                    }

                    // Demais indices
                    if (tmp->index >= 3) {

                        // Para msgs do tipo U concatena valores
                        if (book_type == 1) {

                            sprintf(bookcedro, "%s:%s", bookcedro, tmp->value);

                            // Se for o indice 4, então coloca junto a posicao
                            // que esta na variavel
                            if (tmp->index == 4) {
                                sprintf(bookcedro, "%s:%s", bookcedro, position);
                            }

                        } else if (book_type == 2 || book_type == 3) {
                            // Mensagem do tipo delecao ou adicao, apenas concatena
                            sprintf(bookcedro, "%s:%s", bookcedro, tmp->value);
                        }

                    }



                    // Vai para o proximo indice
                    tmp = tmp->next;
                }

                // Finalisa msg
                strcat(bookcedro, ":5");

                // Escreve no buffer
                if (book_type > 0) {
                    writeln(bfile, bookcedro, "a+");                    
                }

                // Limpa variaveis
                free(bookcedro);
                free(position);

                // Destroi a lista
                destroylist(dbook);
                destroylist(tmp);
                tmp = NULL;

                //temp_book(bfile,cedrobooks);


            }
            

            // Verifica se mudou arquivo de buffer
            // para atualizar arquivo de ultimo buffer
            if (strcmp(bflast, bfile)) {

                writeln(TERMINAL_LOG, HEADER_LOG, "a+");
                writeln(TERMINAL_LOG, "Fim de arquivo de buffer", "a+");
                writeln(TERMINAL_LOG, bflast, "a+");
                writeln(TERMINAL_LOG, "Novo buffer", "a+");
                writeln(TERMINAL_LOG, bfile, "a+");
                writeln(TERMINAL_LOG, FOOTER_LOG, "a+");

                // Escreve no arquivo de localização de buffer
                // o arquivo atual de escrita
                // o modo w+ significa para escrever, limpando
                // tudo q estiver escrito e se nao existir o arquivo
                // deve-se cria-lo
                writeln(SYNCH_BUFF_FILE, bfile, "w+");

                writeln(TERMINAL_LOG, HEADER_LOG, "a+");
                writeln(TERMINAL_LOG, "Arquivo de sincronizacao atualizado para", "a+");
                writeln(TERMINAL_LOG, bfile, "a+");
                writeln(TERMINAL_LOG, FOOTER_LOG, "a+");

                // Copia o novo caminho do buffer
                strcpy(bflast, bfile);
            }

            // Limpa buffer
            bzero(buffer, MAX_BUF_SIZE);

        }

        // Escreve no buffer EndOfConnection
        // o modo a+ significa para abrir o arquivo e
        // adicionar o dado apos o ultimo dado do arquivo
        // e tambem se não existir, deve-se cria-lo
        writeln(bfile, "EndOfConnection", "a+");
        writeln(TERMINAL_LOG, HEADER_LOG, "a+");
        writeln(TERMINAL_LOG, "Fim da conexao com o enfoque", "a+");
        switch (crystal_id) {

            case 1: writeln(TERMINAL_LOG, SVR_CRYSTAL_1, "a+");
                break;
            case 2: writeln(TERMINAL_LOG, SVR_CRYSTAL_2, "a+");
                break;


        }
        writeln(TERMINAL_LOG, FOOTER_LOG, "a+");

        // Volta flag de login para 0
        login = 0;

        // Fecha descritor atual
        close(s);

        // Altera id para o proximo crystal
        crystal_id++;

        if (crystal_id > MAX_CRYSTAL) {
            crystal_id = 1;
        }

    } // loop conexao


    return (EXIT_SUCCESS);
}

int file_exist(char *fname) {

    char *__fpath;
    __fpath = malloc(strlen(SNAP_BK_PATH) + strlen(fname) + 5);


    sprintf(__fpath, "%s%s", SNAP_BK_PATH, fname);

    FILE *f;

    f = fopen(__fpath, "r");

    if (f != NULL) {
        fclose(f);
        free(__fpath);
        return 1;
    } else {
        free(__fpath);
        return 0;
    }

}

void changecrystal(int _sig) {

    // Registra sinal de troca de crystais
    signal(SIGUSR1, changecrystal);

    if (_sig == SIGUSR1) {

        writeln(TERMINAL_LOG, HEADER_LOG, "a+");
        writeln(TERMINAL_LOG, "Solicitado troca de enfoque", "a+");
        writeln(TERMINAL_LOG, FOOTER_LOG, "a+");

        // Ativa flag de troca
        crystal_flag = 1;
    }


}

void filepiper(int _fd) {

    int n, fpipe;

    char txt[100];

    mknod(FIFO_ARQ, S_IFIFO | 0666, 0);

    fpipe = open(FIFO_ARQ, O_RDONLY);

    while (1) {

        n = read(fpipe, txt, 100);

        if (n > 5) {
            txt[n] = '\0';

            send(_fd, txt, strlen(txt), 0);

            writeln(TERMINAL_LOG, HEADER_LOG, "a+");
            writeln(TERMINAL_LOG, "Enviado linha:", "a+");
            writeln(TERMINAL_LOG, txt, "a+");
            writeln(TERMINAL_LOG, FOOTER_LOG, "a+");
        }

    }


}

void temp_book(char *__s, char *_b){
    char *__fpmbq;
    __fpmbq = malloc(strlen(SNAP_BK_PATH) + 50);

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
        bzero(__fpmbq, strlen(SNAP_BK_PATH) + 50);
        sprintf(__fpmbq, "%s%s.A.%d", SNAP_BK_PATH, __s, pos);
        __fmbq = fopen(__fpmbq, "r");
        if (__fmbq != NULL) {
            fgets(__data, 80, __fmbq);
            if (__data[0] != '-') {
                sprintf(__line, "M:%s:U:%d:%d:A:%s\r\n", __s, cont, cont, __data);
                writeln(_b,__line,"a+");
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
        bzero(__fpmbq, strlen(SNAP_BK_PATH) + 50);
        sprintf(__fpmbq, "%s%s.V.%d", SNAP_BK_PATH, __s, pos);
        __fmbq = fopen(__fpmbq, "r");
        if (__fmbq != NULL) {
            fgets(__data, 80, __fmbq);
            if (__data[0] != '-') {
                sprintf(__line, "M:%s:U:%d:%d:V:%s\r\n", __s, cont, cont, __data);
                writeln(_b,__line,"a+");
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
}