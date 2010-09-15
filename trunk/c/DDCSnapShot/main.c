/* 
 * File:   main.c
 * Author: donda
 *
 * Created on September 8, 2010, 11:17 AM
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "ailib.h"

#define MAX_BUF_SIZE sizeof(char) * 1000
#define BUFFER_PATH "/home/donda/ddc/buffer/"
#define MAX_SYNCH_TRY 1000
#define LAST 5
#define HIGH 2
#define LOW 3
#define OPEN 1
#define CLOSE 4
#define NEG 6
#define TIMETRD 7
#define BESTBID 8
#define BESTASK 9

void blast(char *_blast);
void updatesnapshot(char *_s, int col, char *_v);

/*
 * 
 */
int main(int argc, char** argv) {

    // Arquivo atual de leitura de dados
    char *fbuffer;
    // Ultimo arquivo usado como leitura
    char *lastbuffer;

    // Linha do arquivo
    char *dataline;

    // Ativo da linha
    char *symbol;

    // Aloca variaveis na memoria
    fbuffer = malloc(MAX_BUF_SIZE);
    lastbuffer = malloc(MAX_BUF_SIZE);
    dataline = malloc(MAX_BUF_SIZE);
    symbol = malloc(MAX_BUF_SIZE);

    // Limpa os dados nas variaveis
    bzero(fbuffer, MAX_BUF_SIZE);
    bzero(lastbuffer, MAX_BUF_SIZE);
    bzero(symbol, MAX_BUF_SIZE);

    // Descritor para o arquivo de buffer
    FILE *fbf = NULL;

    // Estrutura para analisar
    struct TDDCData *data = NULL;
    // Lista temporaria para varredura de dados
    struct TDDCData *t = NULL;


    // Loop de leitura de arquivo
    while (1) {

        // obtem o arquivo atual
        //blast(fbuffer);
        strcpy(fbuffer, "/home/donda/Documents/data_book.txt");

        // blast pode retornar NULL quando ao acessar
        // o arquivo de buffer e ele esta sendo modificado.
        // Verifica se isso ocorreu
        if (fbuffer == NULL || strlen(fbuffer) <= 5) {
            // É NULL ou não tem dados suficiente
            // Aguarda 100 milisegundos e enta novamente
            usleep(100);
            continue;
        }

        // Compara para ver se é o mesmo arquivo
        if (!strcmp(fbuffer, lastbuffer)) {

            // É o mesmo arquivo, lê os dados
            if (fgets(dataline, MAX_BUF_SIZE, fbf) != NULL) {

                printf("%s\r\n", dataline);

                //removechars(dataline, dataline);

                // Destroi a lista
                if (data != NULL) {
                    destroylist(data);
                    data = NULL;
                }
                if (t != NULL) {
                    t = NULL;
                }

                // Cria uma nova lista
                data = createlist();

                // Separa os dados
                splitcolumns(dataline, 58, data);

                // Ve que tipo de dado é
                if (data->value[0] == 'T') {

                    // Tick de cotação                    

                    // Seta lista temporaria
                    t = data;

                    // Varre dados para analise
                    while (t) {

                        // Pega o ativo
                        if (t->index == 1) {
                            strcpy(symbol, t->value);
                        }

                        // Os indentificador dos dados estao nos
                        // indices impares, e os valores nos
                        // indices pares.
                        if (t->index >= 3) {

                            if (t->index % 2 != 0) {

                                // Indice impar, vê qual é o identificador
                                if (!strcmp(t->value, "2")) {
                                    // Ultima cotacao
                                    // Vai para o proximo registro
                                    t = t->next;

                                    // Atualiza arquivo
                                    updatesnapshot(symbol, LAST, t->value);
                                } else if (!strcmp(t->value, "3")) {
                                    // Melhor compra
                                    // Vai para o proximo registro
                                    t = t->next;

                                    // Atualiza arquivo
                                    updatesnapshot(symbol, BESTBID, t->value);
                                } else if (!strcmp(t->value, "4")) {
                                    // Melhor Venda
                                    // Vai para o proximo registro
                                    t = t->next;

                                    // Atualiza arquivo
                                    updatesnapshot(symbol, BESTASK, t->value);
                                } else if (!strcmp(t->value, "5")) {
                                    // Ultima horario
                                    // Vai para o proximo registro
                                    t = t->next;

                                    // Atualiza arquivo
                                    updatesnapshot(symbol, TIMETRD, t->value);
                                } else if (!strcmp(t->value, "8")) {
                                    // N. negocios
                                    // Vai para o proximo registro
                                    t = t->next;

                                    // Atualiza arquivo
                                    updatesnapshot(symbol, NEG, t->value);
                                } else if (!strcmp(t->value, "11")) {
                                    // Maxima
                                    // Vai para o proximo registro
                                    t = t->next;

                                    // Atualiza arquivo
                                    updatesnapshot(symbol, HIGH, t->value);
                                } else if (!strcmp(t->value, "12")) {
                                    // Minima
                                    // Vai para o proximo registro
                                    t = t->next;

                                    // Atualiza arquivo
                                    updatesnapshot(symbol, LOW, t->value);
                                } else if (!strcmp(t->value, "13")) {
                                    // Fechamento
                                    // Vai para o proximo registro
                                    t = t->next;

                                    // Atualiza arquivo
                                    updatesnapshot(symbol, CLOSE, t->value);
                                } else if (!strcmp(t->value, "14")) {
                                    // Abertura
                                    // Vai para o proximo registro
                                    t = t->next;

                                    // Atualiza arquivo
                                    updatesnapshot(symbol, OPEN, t->value);
                                }

                            }

                        }

                        // Proximo dado
                        t = t->next;
                    }


                } else if (data->value[0] == 'B') {

                    // Snapshot do book de ofertas

                    // Seta lista temporaria
                    t = data;

                    // Tipo de mensagem
                    int book_type = 0;

                    // Direcao da mensagem
                    int direction = 0;

                    // Posicao antiga
                    int old_position = 0;

                    // Posicao nova
                    int new_position = 0;

                    // Dados para snap
                    char *snap;
                    snap = malloc(sizeof (char) * 100);

                    // Pega o ativo
                    t = t->next;
                    strcpy(symbol, t->value);

                    //printf("Ativo:%s\r\n",symbol);

                    // Pega o tipo
                    t = t->next;
                    if (t->value[0] == 'A') {
                        book_type = 1;

                        // Pega posicao
                        t = t->next;
                        new_position = atoi(t->value);

                        // Pega a direcao
                        t = t->next;
                        if (t->value[0] == 'A') {
                            direction = 1;
                        } else if (t->value[0] == 'V') {
                            direction = 2;
                        } else {
                            direction = 0;
                        }

                        // Monta msg

                        // Preco
                        t = t->next;
                        strcpy(snap, t->value);

                        // Qtde
                        t = t->next;
                        sprintf(snap, "%s:%s", snap, t->value);

                        // Corretora
                        t = t->next;
                        sprintf(snap, "%s:%s", snap, t->value);

                        // Data
                        t = t->next;
                        sprintf(snap, "%s:%s", snap, t->value);

                        //printf("Snap Add:%s\r\n",snap);


                    } else if (t->value[0] == 'U') {
                        book_type = 2;

                        // Pega posicao nova
                        t = t->next;
                        new_position = atoi(t->value);

                        // Pega posicao antiga
                        t = t->next;
                        old_position = atoi(t->value);

                        // Pega a direcao
                        t = t->next;
                        if (t->value[0] == 'A') {
                            direction = 1;
                        } else if (t->value[0] == 'V') {
                            direction = 2;
                        } else {
                            direction = 0;
                        }

                        // Monta msg

                        // Preco
                        t = t->next;
                        strcpy(snap, t->value);

                        // Qtde
                        t = t->next;
                        sprintf(snap, "%s:%s", snap, t->value);

                        // Corretora
                        t = t->next;
                        sprintf(snap, "%s:%s", snap, t->value);

                        // Data
                        t = t->next;
                        sprintf(snap, "%s:%s", snap, t->value);

                        //printf("Snap Update:%s\r\n",snap);
                    } else if (t->value[0] == 'D') {
                        book_type = 3;

                        // Pega tipo
                        t = t->next;
                        // Retorna carro do processo para dado tipo 3.
                        old_position = atoi(t->value);
                        if (old_position == 3) {
                            continue;
                        }
                        //new_position = atoi(t->value);

                        //printf("Pre Delete:\r\n");

                        // Pega a direcao
                        t = t->next;
                        if (t->value[0] == 'A') {
                            direction = 1;
                        } else if (t->value[0] == 'V') {
                            direction = 2;
                        } else {
                            direction = 0;
                        }

                        //printf("Almost Delete:\r\n");

                        // Pega posicao
                        t = t->next;
                        new_position = atoi(t->value);

                        // Monta msg
                        sprintf(snap, "%s:%s:%s:%s", "--", "--", "--", "--");

                        //printf("Snap Delete:%s\r\n",snap);

                    } else {
                        book_type = 0;
                    }

                    // Se tipo de msg e direcao direfente de 0 entao significa
                    // que analisou a msg direito.
                    if (book_type != 0 && direction != 0) {

                        char snapfile[200];

                        if (direction == 1) {
                            sprintf(snapfile, "%s/%s.%c.%d", "/home/donda/ddc/snapshot/books", symbol, 'A', new_position);
                        } else {
                            sprintf(snapfile, "%s/%s.%c.%d", "/home/donda/ddc/snapshot/books", symbol, 'V', new_position);
                        }

                        FILE *fs;
                        fs = fopen(snapfile, "w+");
                        if (fs != NULL) {
                            fprintf(fs, "%s", snap);
                            fclose(fs);
                        }



                    }


                    if (snap != NULL) {
                        free(snap);
                    }


                } else {
                    destroylist(data);
                    data = NULL;
                }
            } else {
                // Não consegui ler dados, talves esteja no final
                // aguarda 100 milisegundos e tenta novamente
                usleep(100);

                // Inicia loop
                continue;
            }

        } else {
            printf("Antigo: %s Novo: %s\r\n", lastbuffer, fbuffer);

            // Não é o mesmo, fecha o atual e abre o novo
            if (fbf != NULL) {
                fclose(fbf);
            }

            // Abre o novo arquivo
            fbf = fopen(fbuffer, "r");

            // Se conseguiu abrir o arquivo
            if (fbf != NULL) {
                // Atualiza o ultimo arquivo usado
                strcpy(lastbuffer, fbuffer);
            } else {

                // Não abriu, aguarda 100 milisegundos
                usleep(100);

                // Retorna loop
                continue;
            }

        }

    } // loop


    return (EXIT_SUCCESS);
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

void updatesnapshot(char *_s, int col, char *_v) {

    char *__s;
    __s = malloc(MAX_BUF_SIZE);
    strcpy(__s, _s);

    switch (col) {
        case 1:
            strcat(__s, ".14");
            break;
        case 2:
            strcat(__s, ".11");
            break;
        case 3:
            strcat(__s, ".12");
            break;
        case 4:
            strcat(__s, ".13");
            break;
        case 5:
            strcat(__s, ".2");
            break;
        case 6:
            strcat(__s, ".8");
            break;
        case 7:
            strcat(__s, ".5");
            break;
        case 8:
            strcat(__s, ".3");
            break;
        case 9:
            strcat(__s, ".4");
            break;

    }

    char snapfile[100];
    sprintf(snapfile, "%s/%s", "/home/donda/ddc/snapshot/trades", __s);
    FILE *fs;
    fs = fopen(snapfile, "w+");
    if (fs != NULL) {
        fprintf(fs, "%s", _v);
        fclose(fs);
    }
    free(__s);
}