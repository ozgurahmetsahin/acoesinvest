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
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>

/*Biblioteca Acoes Invest*/
#include "ailib.h"

#define BUF_PATH "/home/donda/ddc/buffer/"
#define SYMBOL_PATH "/home/donda/ddc/symbols_crystal.cal"
#define SNAP_PATH "/home/donda/ddc/snapshot/trades/"
#define SNAP_BK_PATH "/home/donda/ddc/snapshot/books/"
#define TERMINAL_LOG "/home/donda/ddc/ddccrystal.log"
#define SYNCH_BUFF_FILE "/home/donda/ddc/buffer/last.buf"
#define FIFO_ARQ "/home/donda/ddc/buffer/fifo"
#define MAX_BUF_SIZE sizeof(char) * 1000
#define SYMBOL_SIZE sizeof(char) * 20
#define USER_CEDRO "ets012\r\n"
#define PASS_CEDRO "123456\r\n"

#define SVR_CRYSTAL_1 "crystal509.cedrofinances.com.br"
#define SVR_CRYSTAL_2 "crystal507.cedrofinances.com.br"
#define SVR_CRYSTAL_3 "crystal505.cedrofinances.com.br"
#define SVR_CRYSTAL_4 "crystal515.cedrofinances.com.br"

#define SVR_CRYSTAL_5 "crystal201.cedrofinances.com.br"
#define SVR_CRYSTAL_6 "crystal501.cedrofinances.com.br"

#define MAX_CRYSTAL 6
#define TIME_OUT 35

#define MSG_ERR_CONN "Error on connect to server."


/* Declaração das funcoes globais*/
int callsymbols(int _fd);
int snapwrite(char *_fname, char *text);
void snapshot(char *_b);
int createfile(char *_fname, int _p);
int file_exist(char *fname);
int updateline(char *line, int _p, int _max, char *__f);
int cancelline(int _p, int _max, char *__f);
int addline(char *line, int _p, int _max, char *__f);
void snapshotbk(char *__b);
int islogin(char *_m);
void changecrystal(int _sig);
int checktrade(char *_t);
void filepiper(int _fd);

// Id inicial de qual crystal usar
int crystal_id = 1;

// Flag para alteracao
int crystal_flag = 0;

// Arquivos de buffer
char *bfile, *bflast, *bfiletmp;

int main(int argc, char** argv) {

    // Descritor com conexao ao servidor
    int s = -1;

    // Buffer de dados
    char *buffer;
    //Aloca na memoria buffer de dados
    buffer = malloc(MAX_BUF_SIZE);

    int login = 0;

    // Aloca arquivos de buffers
    bfile = malloc(strlen(BUF_PATH) + 26);
    bflast = malloc(strlen(BUF_PATH) + 26);
    bfiletmp = malloc(strlen(BUF_PATH) + 26);

    // Limpa conteudo da variavel temp
    bzero(bfiletmp, strlen(BUF_PATH) + 26);

    // Registra sinal de troca de crystais
    signal(SIGUSR1, changecrystal);

    int istrade = 0;

    // Loop de conexao
    // sempre true, ja que tenta infinitamente
    while (1) {

        // Gera uma conexao
        writeln(TERMINAL_LOG, "********* Start *************", "a+");
        writeln(TERMINAL_LOG, "Conectando-se ao crystal", "a+");

        switch (crystal_id) {

            case 1: writeln(TERMINAL_LOG, SVR_CRYSTAL_1, "a+");
                s = connecttoserver(SVR_CRYSTAL_1, 81);
                break;
            case 2: writeln(TERMINAL_LOG, SVR_CRYSTAL_2, "a+");
                s = connecttoserver(SVR_CRYSTAL_2, 81);
                break;
            case 3: writeln(TERMINAL_LOG, SVR_CRYSTAL_3, "a+");
                s = connecttoserver(SVR_CRYSTAL_3, 81);
                break;
            case 4: writeln(TERMINAL_LOG, SVR_CRYSTAL_4, "a+");
                s = connecttoserver(SVR_CRYSTAL_4, 81);
                break;
            case 5: writeln(TERMINAL_LOG, SVR_CRYSTAL_5, "a+");
                s = connecttoserver(SVR_CRYSTAL_5, 81);
                break;
            case 6: writeln(TERMINAL_LOG, SVR_CRYSTAL_6, "a+");
                s = connecttoserver(SVR_CRYSTAL_6, 81);
                break;

        }

        writeln(TERMINAL_LOG, "********* End ***************", "a+");



        // Verifica a conexao
        if (s < 0) {
            // Emite mensagem de erro
            writeln(TERMINAL_LOG, "********* Start *************", "a+");
            writeln(TERMINAL_LOG, "Erro ao se conectar ao crystal", "a+");

            switch (crystal_id) {

                case 1: writeln(TERMINAL_LOG, SVR_CRYSTAL_1, "a+");
                    break;
                case 2: writeln(TERMINAL_LOG, SVR_CRYSTAL_2, "a+");
                    break;
                case 3: writeln(TERMINAL_LOG, SVR_CRYSTAL_3, "a+");
                    break;
                case 4: writeln(TERMINAL_LOG, SVR_CRYSTAL_4, "a+");
                    break;
                case 5: writeln(TERMINAL_LOG, SVR_CRYSTAL_5, "a+");
                    break;
                case 6: writeln(TERMINAL_LOG, SVR_CRYSTAL_6, "a+");
                    break;

            }

            writeln(TERMINAL_LOG, "********* End ***************", "a+");

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

        writeln(TERMINAL_LOG, "********* Start *************", "a+");
        writeln(TERMINAL_LOG, "Conectado", "a+");
        writeln(TERMINAL_LOG, "********* End ***************", "a+");


        /*Cria o processo filho que lera o FIFO com as entradas de comando*/
        pid_t fifo;

        fifo = fork();

        // Verifica se criou o processo fifo
        if (fifo < 0) {
            //Erro na criacao do fifo

            writeln(TERMINAL_LOG, "********* Start *************", "a+");
            writeln(TERMINAL_LOG, "Erro ao criar fifo.", "a+");
            writeln(TERMINAL_LOG, "********* End ***************", "a+");
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

        // Lê dados do socket até
        // retornar -1
        while (readline(s, buffer, TIME_OUT) > 0) {

            // Verifica se não foi solicitado para se alterar de crystal
            if (crystal_flag == 1) {

                // Foi, quebramos o loop para iniciar o proximo
                writeln(TERMINAL_LOG, "********* Start *************", "a+");
                writeln(TERMINAL_LOG, "Alterando crystal", "a+");
                writeln(TERMINAL_LOG, "********* End **************", "a+");

                // Desativa flag antes de quebrar loop
                crystal_flag = 0;

                break;
            }

            // Analisa se é tela de login
            if (islogin(buffer) == 1 && login == 0) {
                send(s, USER_CEDRO, strlen(USER_CEDRO), 0);
            }
            if (islogin(buffer) == 2 && login == 0) {
                send(s, PASS_CEDRO, strlen(PASS_CEDRO), 0);
            }
            if (islogin(buffer) == 3 && login == 0) {
                send(s, "cedro_crystal\r\n", strlen("cedro_crystal\r\n"), 0);
            }



            // Recebe o nome do arquivo atual do buffer
            gettbf(bfiletmp);
            sprintf(bfile, "%s%s", BUF_PATH, bfiletmp);

            // Limpa conteudo da variavel temp
            bzero(bfiletmp, strlen(BUF_PATH) + 26);

            // Antes de escrever no buffer o dado da cotação,
            // já é gerado seu snapshot, para não haver erros
            // de leitura por parte do ddcserver

            // Gera snapshot, caso seja trade ( T )
            snapshot(buffer);

            // Gera snapshot, caso seja book ( B ou M )
            //snapshotbk(buffer);

            // Verifica se contem indices que realmente sao importantes.
            istrade = checktrade(buffer);

            // Escreve então no buffer o dado lido
            // o modo a+ significa para abrir o arquivo e
            // adicionar o dado apos o ultimo dado do arquivo
            // e tambem se não existir, deve-se cria-lo
            if (istrade == 1) {
                writeln(bfile, buffer, "a+");
            }

            istrade = 0;

            // Verifica se é a frase You are connected
            // Chama ativos caso seja.
            if (buffer[0] == 'Y') {
                callsymbols(s);
                login = 1;
            }


            // Verifica se mudou arquivo de buffer
            // para atualizar arquivo de ultimo buffer
            if (strcmp(bflast, bfile)) {

                writeln(TERMINAL_LOG, "********* Start *************", "a+");
                writeln(TERMINAL_LOG, "Fim de arquivo de buffer", "a+");
                writeln(TERMINAL_LOG, bflast, "a+");
                writeln(TERMINAL_LOG, "Novo buffer", "a+");
                writeln(TERMINAL_LOG, bfile, "a+");
                writeln(TERMINAL_LOG, "********* End ***************", "a+");

                // Escreve no arquivo de localização de buffer
                // o arquivo atual de escrita
                // o modo w+ significa para escrever, limpando
                // tudo q estiver escrito e se nao existir o arquivo
                // deve-se cria-lo
                //writeln(SYNCH_BUFF_FILE, bfile, "w+");

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
        writeln(TERMINAL_LOG, "********* Start *************", "a+");
        writeln(TERMINAL_LOG, "Fim da conexao com o crystal", "a+");
        switch (crystal_id) {

            case 1: writeln(TERMINAL_LOG, SVR_CRYSTAL_1, "a+");
                break;
            case 2: writeln(TERMINAL_LOG, SVR_CRYSTAL_2, "a+");
                break;
            case 3: writeln(TERMINAL_LOG, SVR_CRYSTAL_3, "a+");
                break;
            case 4: writeln(TERMINAL_LOG, SVR_CRYSTAL_4, "a+");
                break;
            case 5: writeln(TERMINAL_LOG, SVR_CRYSTAL_5, "a+");
                break;
            case 6: writeln(TERMINAL_LOG, SVR_CRYSTAL_6, "a+");
                break;


        }
        writeln(TERMINAL_LOG, "********* End ***************", "a+");

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

/**
 * Realiza leitura do arquivo que contem os ativos
 * que deverão ser chamados ao servidor da cedro.
 * Retorna -1 caso haja erro de leitura do arquivo, ou
 * 1 para leitura bem sucedida.
 * */
int callsymbols(int _fd) {

    // Descritor do arquivo de ativos
    FILE *fsymbols;

    // Abre o arquivo
    fsymbols = fopen(SYMBOL_PATH, "r");

    // Verifica se foi possivel abrir
    if (fsymbols == NULL) {

        // Retorna -1
        return -1;

    } else {

        // Variavel para leitura da linha
        char *line;
        line = malloc(SYMBOL_SIZE);

        // Montagem do comando
        char *cmd;
        cmd = malloc(SYMBOL_SIZE + 4);


        // Lê dados
        while ((fgets(line, SYMBOL_SIZE, fsymbols)) != NULL) {


            //Monta comando - SQT
            sprintf(cmd, "%s%s\r\n", "sqt ", line);

            // Realiza chamada
            send(_fd, cmd, strlen(cmd), 0);

            // Limpa cmd
            bzero(cmd, SYMBOL_SIZE + 4);

            //Monta comando - MBQ

            sprintf(cmd, "%s%s\r\n", "mbq ", line);

            // Realiza chamada
            send(_fd, cmd, strlen(cmd), 0);

            // Limpa cmd
            bzero(cmd, SYMBOL_SIZE + 4);

        }

        // Limpa variaveis da memoria
        free(line);
        free(cmd);

        // Fecha arquivo de ativos
        fclose(fsymbols);

        return 1;

    }


}

/**
 * Gera arquivos para montagem
 * do snapshot do ativo
 * */
void snapshot(char *_b) {

    int j = 0;
    int k = 0;
    char *b;
    b = malloc(MAX_BUF_SIZE);

    while (j <= strlen(_b)) {

        if (_b[j] != '!' && (unsigned int) _b[j] != 13) {

            if ((unsigned int) _b[j] > 13) {
                b[k] = _b[j];
                k++;
            }

        } else {

            b[k] = '\0';

            //printf("%s\n", b);

            int l = 0;
            int m = 0;
            int v = 0;
            char data[100];
            char *symbol;
            symbol = malloc(strlen(SNAP_PATH) + 12);
            char *ext;
            ext = malloc(strlen(SNAP_PATH) + 24);
            char *ssymbol;
            ssymbol = malloc(100);

            if (b[0] == 'T') {

                int islastprice = 0;

                for (l = 0; l <= k; l++) {

                    if (b[l] != ':' && b[l] != '!' && b[l] != '\0') {
                        data[m] = b[l];
                        m++;
                    } else {
                        data[m] = '\0';
                        m = 0;
                        // printf("%s\n", data);
                        if (v == 1) {
                            strcpy(symbol, SNAP_PATH);
                            strcat(symbol, data);
                            strcpy(ssymbol, data);
                        }

                        if (v >= 3) {
                            if (v % 2 > 0) {
                                strcpy(ext, symbol);
                                sprintf(ext, "%s.%s", ext, data);
                                if (!strcmp(data, "2")) {
                                    islastprice = 1;
                                }
                                //printf("[%s]Index: %s\n", ext, data);
                            } else {
                                //printf("[%s]Value: %s\n", symbol, data);
                                if (islastprice == 1) {
                                    //strcpy(symbolext, symbol);                                    
                                    char *symbolext;
                                    char *_read;
                                    symbolext = malloc(250);
                                    _read = malloc(15);
                                    FILE *_fsnap;
                                    sprintf(symbolext, "%s", symbol);
                                    strcat(symbolext, ".13");
                                    _fsnap = fopen(symbolext, "r");
                                    if (_fsnap != NULL) {
                                        fgets(_read, 15, _fsnap);
                                        fclose(_fsnap);
                                        double cl = atof(_read);
                                        double las = atof(data);
                                        double perc = ((las - cl) / cl) * 100;
                                        bzero(symbolext, 250);
                                        sprintf(symbolext, "T:%s:000000:664:%4.2f:700:%4.2f!", ssymbol, perc, perc);

                                        writeln(bfile, symbolext, "a+");

                                    }

                                    free(symbolext);
                                    free(_read);
                                    islastprice = 0;
                                }

                                snapwrite(ext, data);

                            }
                        }
                        bzero(data, 100);
                        v++;
                    }

                }

            }

            bzero(b, MAX_BUF_SIZE);
            k = 0;

            free(symbol);
            free(ext);
            free(ssymbol);

        }

        j++;

    }

    free(b);


}

int snapwrite(char *_fname, char *text) {

    int fw;

    //Descritor do arquivo
    FILE *fl;

    //Abre o arquivo em modo de escrita no final do arquivo
    fl = fopen(_fname, "w+");

    strcat(text, "\0");

    //Escreve
    fw = fprintf(fl, "%s", text);

    //Fecha descritor salvando alterações
    fclose(fl);

    return fw;
}

void snapshotbk(char *__b) {
    char *v1, *v2, *v3,
            *v4, *v5, *v6,
            *v7, *v8, *v9;

    v1 = malloc(5);
    v2 = malloc(10);
    v3 = malloc(10);
    v4 = malloc(10);
    v5 = malloc(10);
    v6 = malloc(10);
    v7 = malloc(10);
    v8 = malloc(10);
    v9 = malloc(10);

    char *vdata;
    char *vfile;

    vdata = malloc(60);
    vfile = malloc(20);

    sscanf(__b, "%[^':']:%[^':']:%[^':']:%[^':']:%[^':']:%[^':']:%[^':']:%[^':']:%[^':']:", v1, v2, v3, v4, v5, v6, v7, v8, v9);

    if (!strcmp(v1, "M")) {

        // Add
        if (!strcmp(v3, "A")) {

            // Compra
            if (!strcmp(v5, "A")) {

                sprintf(vdata, "%s:%s:%s:%s", v5, v6, v7, v8);

                sprintf(vfile, "%s.bkb", v2);

                int vp = 0;

                vp = atoi(v4);

                if (!file_exist(vfile)) {
                    createfile(vfile, 20);
                }

                addline(vdata, vp, 20, vfile);

                free(v1);
                free(v2);
                free(v3);
                free(v4);
                free(v5);
                free(v6);
                free(v7);
                free(v8);
                free(v9);
                free(vdata);
                free(vfile);

            } else if (!strcmp(v5, "V")) {
                // Venda

                sprintf(vdata, "%s:%s:%s:%s", v5, v6, v7, v8);

                sprintf(vfile, "%s.bks", v2);

                int vp = 0;

                vp = atoi(v4);

                if (!file_exist(vfile)) {
                    createfile(vfile, 20);
                }

                addline(vdata, vp, 20, vfile);

                free(v1);
                free(v2);
                free(v3);
                free(v4);
                free(v5);
                free(v6);
                free(v7);
                free(v8);
                free(v9);
                free(vdata);
                free(vfile);

            }


        } /*else if (!strcmp(v3, "U")) {

            // Compra
            if (!strcmp(v6, "A")) {

                sprintf(vdata, "%s:%s:%s:%s", v6, v7, v8, v9);

                sprintf(vfile, "%s.bkb", v2);

                int vp = 0;

                vp = atoi(v4);

                if (!file_exist(vfile)) {
                    createfile(vfile, 20);
                }

                updateline(vdata, vp, 20, vfile);
               

            } else if (!strcmp(v6, "V")) {
                // Venda

                sprintf(vdata, "%s:%s:%s:%s", v6, v7, v8, v9);

                sprintf(vfile, "%s.bks", v2);

                int vp = 0;

                vp = atoi(v4);

                if (!file_exist(vfile)) {
                    createfile(vfile, 20);
                }

                updateline(vdata, vp, 20, vfile);
            
            }
        } else if (!strcmp(v3, "D")) {
            // Compra
            if (!strcmp(v5, "A")) {


                sprintf(vfile, "%s.bkb", v2);

                int vp = 0;

                vp = atoi(v4);

                if (!file_exist(vfile)) {
                    createfile(vfile, 20);
                }

                cancelline(vp, 20, vfile);
    
            } else if (!strcmp(v5, "V")) {
                // Venda

                sprintf(vfile, "%s.bks", v2);

                int vp = 0;

                vp = atoi(v4);

                if (!file_exist(vfile)) {
                    createfile(vfile, 20);
                } else if (!strcmp(v3, "U")) {

                    // Compra
                    if (!strcmp(v6, "A")) {

                        sprintf(vdata, "%s:%s:%s:%s", v6, v7, v8, v9);

                        sprintf(vfile, "%s.bkb", v2);

                        int vp = 0;

                        vp = atoi(v4);

                        if (!file_exist(vfile)) {
                            createfile(vfile, 20);
                        }

                        updateline(vdata, vp, 20, vfile);
                

                    } else if (!strcmp(v6, "V")) {
                        // Venda

                        sprintf(vdata, "%s:%s:%s:%s", v6, v7, v8, v9);

                        sprintf(vfile, "%s.bks", v2);

                        int vp = 0;

                        vp = atoi(v4);

                        if (!file_exist(vfile)) {
                            createfile(vfile, 20);
                        }

                        updateline(vdata, vp, 20, vfile);

                  
                    }
                } else if (!strcmp(v3, "D")) {
                    // Compra
                    if (!strcmp(v5, "A")) {


                        sprintf(vfile, "%s.bkb", v2);

                        int vp = 0;

                        vp = atoi(v4);

                        if (!file_exist(vfile)) {
                            createfile(vfile, 20);
                        }

                        cancelline(vp, 20, vfile);

                    } else if (!strcmp(v5, "V")) {
                        // Venda

                        sprintf(vfile, "%s.bks", v2);

                        int vp = 0;

                        vp = atoi(v4);

                        if (!file_exist(vfile)) {
                            createfile(vfile, 20);
                        }

                        cancelline(vp, 20, vfile);
          
                    }
                }

                cancelline(vp, 20, vfile);
    
            }
        }*/

    } // Se M


}

int createfile(char *_fname, int _p) {

    char *__fpath;
    __fpath = malloc(strlen(SNAP_BK_PATH) + strlen(_fname) + 5);


    sprintf(__fpath, "%s%s", SNAP_BK_PATH, _fname);


    FILE *fcreate;

    fcreate = fopen(__fpath, "w+");

    if (fcreate != NULL) {

        int j;

        for (j = 0; j < _p; j++) {
            fprintf(fcreate, "%d%s\n", j, ":NULL:NULL:NULL");
        }

        fclose(fcreate);

        free(__fpath);

        return 1;

    } else {
        free(__fpath);
        return 0;
    }

}

int addline(char *line, int _p, int _max, char *__f) {

    char *__fpath;
    __fpath = malloc(strlen(SNAP_BK_PATH) + strlen(__f) + 5);

    char *__ftmp;
    __ftmp = malloc(strlen(SNAP_BK_PATH) + strlen(__f) + 5);

    sprintf(__fpath, "%s%s", SNAP_BK_PATH, __f);

    sprintf(__ftmp, "%s%s~", SNAP_BK_PATH, __f);

    char *read;
    read = malloc(50);

    FILE *fadd;

    int iline = 0;

    fadd = fopen(__fpath, "r");

    if (fadd != NULL) {

        FILE *ftemp;

        ftemp = fopen(__ftmp, "w+");

        while ((fgets(read, 50, fadd)) != NULL) {

            if (iline == _p) {
                fprintf(ftemp, "%s\n", line);
                fprintf(ftemp, "%s", read);
            } else {
                fprintf(ftemp, "%s", read);
            }

            iline++;

        }

        fclose(ftemp);
        fclose(fadd);


        fadd = fopen(__fpath, "w+");

        if (fadd != NULL) {

            FILE *ftemp;

            ftemp = fopen(__ftmp, "r");

            while ((fgets(read, 50, ftemp)) != NULL) {

                fprintf(fadd, "%s", read);

            }

            fclose(ftemp);
            fclose(fadd);

            remove(__ftmp);

            //cancelline(19,20,__f);

            free(__fpath);
            free(__ftmp);
            free(read);

            return 1;
        }


        return 0;


    }


    return 0;

}

int cancelline(int _p, int _max, char *__f) {

    char *__fpath;
    __fpath = malloc(strlen(SNAP_BK_PATH) + strlen(__f) + 5);

    char *__ftmp;
    __ftmp = malloc(strlen(SNAP_BK_PATH) + strlen(__f) + 5);

    sprintf(__fpath, "%s%s", SNAP_BK_PATH, __f);

    sprintf(__ftmp, "%s%s~", SNAP_BK_PATH, __f);

    char *read;
    read = malloc(50);

    FILE *fadd;

    int iline = 0;

    fadd = fopen(__fpath, "r");

    if (fadd != NULL) {

        FILE *ftemp;

        ftemp = fopen(__ftmp, "w+");

        while ((fgets(read, 50, fadd)) != NULL) {

            if (iline == _p) {
                iline++;
                continue;
            } else {
                fprintf(ftemp, "%s", read);
            }

            iline++;

            if (iline >= _max) {
                break;
            }

        }

        fclose(ftemp);
        fclose(fadd);


        fadd = fopen(__fpath, "w+");

        if (fadd != NULL) {

            FILE *ftemp;

            ftemp = fopen(__ftmp, "r");

            while ((fgets(read, 50, ftemp)) != NULL) {

                fprintf(fadd, "%s", read);

            }

            fclose(ftemp);
            fclose(fadd);

            remove(__ftmp);

            free(__fpath);
            free(__ftmp);

            return 1;
        }


        return 0;


    }


    return 0;

}

int updateline(char *line, int _p, int _max, char *__f) {

    char *__fpath;
    __fpath = malloc(strlen(SNAP_BK_PATH) + strlen(__f) + 5);

    char *__ftmp;
    __ftmp = malloc(strlen(SNAP_BK_PATH) + strlen(__f) + 5);

    sprintf(__fpath, "%s%s", SNAP_BK_PATH, __f);

    sprintf(__ftmp, "%s%s~", SNAP_BK_PATH, __f);

    char *read;
    read = malloc(50);

    FILE *fadd;

    int iline = 0;

    fadd = fopen(__fpath, "r");

    if (fadd != NULL) {

        FILE *ftemp;

        ftemp = fopen(__ftmp, "w+");

        while ((fgets(read, 50, fadd)) != NULL) {

            if (iline == _p) {

                strcpy(read, line);
                fprintf(ftemp, "%s\n", read);
            } else {

                fprintf(ftemp, "%s", read);
            }

            iline++;

        }

        fclose(ftemp);
        fclose(fadd);


        fadd = fopen(__fpath, "w+");

        if (fadd != NULL) {

            FILE *ftemp;

            ftemp = fopen(__ftmp, "r");

            while ((fgets(read, 50, ftemp)) != NULL) {

                fprintf(fadd, "%s", read);

            }

            fclose(ftemp);
            fclose(fadd);

            remove(__ftmp);

            free(__fpath);
            free(__ftmp);

            return 1;
        }

        return 0;

    }

    return 0;

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

/* Analiza a mensagem verificando se é
 * processo de login na cedro.
 * O retorno são:
 * 1 : Mensagem solicitando o usuario
 * 2 : Mensagem solicitando a senha
 * -1 : não é mensagem de login
 */
int islogin(char *_m) {

    int j;

    for (j = 0; j <= strlen(_m); j++) {

        if (_m[j] == 'U') {

            if (_m[j + 7] == 'e') {

                return 1;

            }

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

    }

    return -1;

}

void changecrystal(int _sig) {

    // Registra sinal de troca de crystais
    signal(SIGUSR1, changecrystal);

    if (_sig == SIGUSR1) {

        writeln(TERMINAL_LOG, "********* Start *************", "a+");
        writeln(TERMINAL_LOG, "Solicitado troca de crystal", "a+");
        writeln(TERMINAL_LOG, "********* End ***************", "a+");

        // Ativa flag de troca
        crystal_flag = 1;
    }


}

int checktrade(char *_t) {
     int j = 0;
    int k = 0;
    char *b;
    b = malloc(MAX_BUF_SIZE);
    int islastprice = 0;

    while (j <= strlen(_t)) {

        if (_t[j] != '!' && (unsigned int) _t[j] != 13) {

            if ((unsigned int) _t[j] > 13) {
                b[k] = _t[j];
                k++;
            }

        } else {

            b[k] = '\0';

            //printf("%s\n", b);

            int l = 0;
            int m = 0;
            int v = 0;
            char data[100];
            char *symbol;
            symbol = malloc(strlen(SNAP_PATH) + 12);
            char *ext;
            ext = malloc(strlen(SNAP_PATH) + 24);
            char *ssymbol;
            ssymbol = malloc(100);

            if (b[0] == 'T') {

                

                for (l = 0; l <= k; l++) {

                    if (b[l] != ':' && b[l] != '!' && b[l] != '\0') {
                        data[m] = b[l];
                        m++;
                    } else {
                        data[m] = '\0';
                        m = 0;
                        // printf("%s\n", data);
                        if (v == 1) {
                            strcpy(symbol, SNAP_PATH);
                            strcat(symbol, data);
                            strcpy(ssymbol, data);
                        }

                        if (v >= 3) {
                            if (v % 2 > 0) {
                                strcpy(ext, symbol);
                                sprintf(ext, "%s.%s", ext, data);
                                if (!strcmp(data, "2")) {
                                    islastprice = 1;
                                } else if (!strcmp(data, "3")) {
                                    islastprice = 1;
                                } else if (!strcmp(data, "4")) {
                                    islastprice = 1;
                                } else if (!strcmp(data, "5")) {
                                    islastprice = 1;
                                } else if (!strcmp(data, "6")) {
                                    islastprice = 1;
                                } else if (!strcmp(data, "7")) {
                                    islastprice = 1;
                                } else if (!strcmp(data, "8")) {
                                    islastprice = 1;
                                } else if (!strcmp(data, "9")) {
                                    islastprice = 1;
                                } else if (!strcmp(data, "11")) {
                                    islastprice = 1;
                                } else if (!strcmp(data, "12")) {
                                    islastprice = 1;
                                } else if (!strcmp(data, "13")) {
                                    islastprice = 1;
                                } else if (!strcmp(data, "14")) {
                                    islastprice = 1;
                                }
                                //printf("[%s]Index: %s\n", ext, data);
                            } 
                        }
                        bzero(data, 100);
                        v++;
                    }

                }

            }

            bzero(b, MAX_BUF_SIZE);
            k = 0;

            free(symbol);
            free(ext);
            free(ssymbol);

        }

        j++;

    }

    free(b);

    return islastprice;

}

void filepiper(int _fd) {

    int n, fpipe;

    char txt[100];

    mknod(FIFO_ARQ, S_IFIFO | 0666, 0);

    fpipe = open(FIFO_ARQ, O_RDONLY);
    int v = 0;
    while (1) {

        n = read(fpipe, txt, 100);

        if (n > 5) {

            char *cmdbf = malloc(n+10);

            strcpy(cmdbf,"bqt ");

            for(v=2;v<=n;v++){
                sprintf(cmdbf,"%s%c",cmdbf,txt[v]);
            }

            //cmdbf[v]='\0';
            cmdbf[v]='\r';
            cmdbf[v+1]='\n';
            
            send(_fd, cmdbf, strlen(cmdbf), 0);

            writeln(TERMINAL_LOG, "********* Start ***************", "a+");
            writeln(TERMINAL_LOG, "Enviado linha:", "a+");
            writeln(TERMINAL_LOG, cmdbf, "a+");
            writeln(TERMINAL_LOG, "********* End ***************", "a+");

            free(cmdbf);
        }

    }


}