/*
 * File:   main.c
 * Author: donda
 *
 * Created on August 19, 2010, 8:49 PM
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>
#include "ailib.h"

#define MAX_BUF_SIZE sizeof(char) * 1000
#define BUFFER_PATH "/home/donda/ddc/buffer/"
#define MAX_SYNCH_TRY 1000
#define MAX_SYN_WAIT 2000

#define LAST 5
#define HIGH 2
#define LOW 3
#define OPEN 1
#define CLOSE 4
#define NEG 6
#define TIMETRD 7
#define BESTBID 8
#define BESTASK 9

/******* Declarações das funções ********/
void readalldata(char *dt);
void tradedata(char *_d, int _pe, char *_dt, char *_f);
char *timecmp(char *_t, int _p);
void makedirs(char *_dd);
void readdata(char *dm);
void blast(char *_blast);
void updatesnapshot(char *_s, int col, char *_v);

/*Declaracao da Estrutura de Dados para informacao da linha de Trade*/
struct trade {
    char symbol[10];
    char last[20];
    char time[10];
};

/*
 *
 */
int main(int argc, char** argv) {

    if (argc >= 2) {
        if (!strcmp(argv[1], "-mk")) {
            if (argc == 3) {
                makedirs(argv[2]);
            } else {
                printf("Usage %s -mk <date>: Where date is mmdd, i.e: 0825 ( Month 08 and Day 25 )\r\n", argv[0]);
            }
        } else if (!strcmp(argv[1], "-rall")) {
            if (argc == 3) {
                readalldata(argv[2]);
            } else {
                printf("Usage %s -rall <date>: Where date is mmdd, i.e: 0825 ( Month 08 and Day 25 )\r\n", argv[0]);
            }
        } else if (!strcmp(argv[1], "-r")) {
            if (argc == 3) {
                readdata(argv[2]);
            } else {
                printf("Usage %s -r <date>: Where date is yyyymmdd, i.e: 0825 (Month 08 and Day 25 )\r\n", argv[0]);
            }
        } else {
            printf("Usage %s [ -r (read data) | -rall (read all data) | -mk (make dirs)]", argv[0]);
        }
    } else {
        printf("Usage %s [ -r (read data) | -rall (read all data) | -mk (make dirs)]\r\n", argv[0]);
    }

    printf("Done\r\n");

    return (EXIT_SUCCESS);
}

/* Função readalldata será responsavel por ler
 * todos os arquivos .tbf existentes e gerar os
 * dados intraday destes arquivos.
 */
void readalldata(char *dt) {

    /* Primeiro pegamos a data.
     * Por padrão pega a data atual da maquina.
     */

    /*Agora armazenamos a hora inicial da varredura.*/
    // variavel que armazenara a hora.
    char *t;
    // alocamento da variavel na memoria
    t = malloc(sizeof (char) * 5);
    // Inicia valor da hora como as 09:00 hrs
    strcpy(t, "1000");

    /* Iniciamos aqui entao a varredura*/

    // Variavel que contera o nome completo do arquivo
    // Caminho + nome arquivo
    char *f;
    // Alocamento da variavel
    f = malloc(sizeof (char) *1000);

    // Descritor do arquivo para leitura dos dados
    FILE *fl;

    // Variavel para armazenar o dado lido do arquivo
    char *line;
    // Alocamento da variavel na memoria
    line = malloc(sizeof (char) *1000);

    // Eqto a hora for diferente de 19:00 hrs continua lendo
    while (1) {

        // Montamos o nome do arquivo
        sprintf(f, "/home/donda/ddc/backups/mes_09/%s%s.tbf", dt, t);

        printf("%s\r\n", f);

        // Tentamos abrir o arquivo
        fl = fopen(f, "r");

        // Verificamos a abertura
        if (fl != NULL) {

            // Como abriu, vamos lê-lo.
            int rcount = 0;
            char *rline; // Retorno lido

            while (!feof(fl)) {

                rline = fgets(line, sizeof (char) *1000, fl);

                if (rline == NULL) {
                    rcount++;
                    if (rcount >= 1000) {
                        printf("Fim do arquivo encontrado.\r\n");
                        rcount = 0;
                        break;
                    }
                    continue;
                } else {
                    rcount = 0;
                }

                //printf("ReadData:%s\r\n", rline);

                if (strlen(rline) > 10) {
                    int k = 1;
                    
                    tradedata(rline, 1, dt, NULL);
                    tradedata(rline, 5, dt, NULL);
                    tradedata(rline, 10, dt, NULL);
                    tradedata(rline, 15, dt, NULL);
                    tradedata(rline, 30, dt, NULL);
                    
                }

                // Limpamos o dado lido para não ter má leitura
                bzero(line, sizeof (char) *1000);
                rline = NULL;
            }

            // Fechamos o descritor do arquivo lido
            fclose(fl);
            //close(fl);
            fl = NULL;

        } else {
            // Erro ao abrir arquivo
            perror("Erro ao abrir arquivo de buffer");
            //printf("Erro ao ler arquivo: %s\r\n", f);
        }

        // Vamos mudar a hora para ir para o proximo arquivo
        char *h;
        h = malloc(sizeof (char) *3);
        sprintf(h, "%c%c", t[0], t[1]);
        int ih = atoi(h);

        char *m;
        m = malloc(sizeof (char) *3);
        sprintf(m, "%c%c", t[2], t[3]);
        int im = atoi(m);
        im++;
        if (im > 59) {
            im = 0;
            ih++;
        }


        if (im >= 0 && im < 10) {
            sprintf(t, "%d0%d", ih, im);
        } else {
            sprintf(t, "%d%d", ih, im);
        }

        //printf("%s\r\n", t);

        free(h);
        free(m);

        if (ih == 19) {
            break;
        };
    }


}

/**
 * Função tradedata será responsavel por ler
 * o dado lido e verificar se é linha de trade,
 * e caso for, fazer analise de grafico.
 * @param _d
 */
void tradedata(char *_d, int _pe, char *_dt, char *_f) {
    // Analisa se é Trade
    if (_d[0] == 'T') {

        // String temporaria para valor
        char value[100];
        // Auxiliador do vetor
        int aux = 0;

        // Contador de Separador
        int count = -1;

        // Auxiliador de varredura
        int i = 0;

        // Caminho para os arquivos de analise
        char path[50];

        // Auxiliador de indice
        char index[10];

        // Estrutura para analise de Trade
        struct trade TTrade;

        // Valores iniciais para TTrade.
        strcpy(TTrade.last, "-1");
        strcpy(TTrade.time, "-1");

        //printf("TradeData: %s", _d);

        for (i = 0; i < strlen(_d); i++) {

            if (_d[i] != ':' && _d[i] != '!') {
                value[aux] = _d[i];
                aux++;
            } else {
                count++;
                // Finaliza String
                value[aux] = '\0';

                // Pega o Ativo
                if (count == 1) {
                    strcpy(TTrade.symbol, value);
                }

                // Indices estão nos contadores impares
                if (count >= 3) {
                    if (count % 2 > 0) {
                        strcpy(index, value);
                    } else {

                        // Ações para Indice 2
                        if (!strcmp(index, "2")) {
                            strcpy(TTrade.last, value);
                            //updatesnapshot(TTrade.symbol,LAST,value);
                        }

                        // Ações para o indice 5
                        if (!strcmp(index, "5")) {
                            strcpy(TTrade.time, value);
                            //updatesnapshot(TTrade.symbol,TIMETRD,value);
                        }

/*
                        // Ações para o indice 3
                        if (!strcmp(index, "3")) {
                            updatesnapshot(TTrade.symbol,BESTBID,value);
                        }

                        // Ações para o indice 4
                        if (!strcmp(index, "4")) {
                            updatesnapshot(TTrade.symbol,BESTASK,value);
                        }

                        // Ações para o indice 11
                        if (!strcmp(index, "11")) {
                            updatesnapshot(TTrade.symbol,HIGH,value);
                        }

                        // Ações para o indice 12
                        if (!strcmp(index, "12")) {
                            updatesnapshot(TTrade.symbol,LOW,value);
                        }

                        // Ações para o indice 13
                        if (!strcmp(index, "13")) {
                            updatesnapshot(TTrade.symbol,CLOSE,value);
                        }

                        // Ações para o indice 14
                        if (!strcmp(index, "14")) {
                            updatesnapshot(TTrade.symbol,OPEN,value);
                        }

                        // Ações para o indice 8
                        if (!strcmp(index, "8")) {
                            updatesnapshot(TTrade.symbol,NEG,value);
                        }
*/


                    }
                }
                // Limpa value
                bzero(value, 10);
                aux = 0;
            }


        } // for

        if (strcmp(TTrade.time, "-1")) {

            // Variavel temp que tem o valor da hora armazenada
            // no arquivo
            char tmptime[10];

            // Configura caminho para arquivo time
            sprintf(path, "/home/donda/ddc/buffer/chart/%s/%d/%s.time", _dt, _pe, TTrade.symbol);

            // Abre o arquivo
            FILE *ftime = fopen(path, "r");
            if (ftime != NULL) {
                fgets(tmptime, 10, ftime);
                fclose(ftime);
                //close(ftime);
            } else {
                // Garante que tmptime nao fique fazia
                strcpy(tmptime, "0800");
            }

            // Tira os segundos
            TTrade.time[4] = '\0';
            TTrade.time[5] = '\0';

            // Descobre para qual time esse dado se refere
            strcpy(TTrade.time, timecmp(TTrade.time, _pe));

            // Analisa a hora, se diferentes, cria uma nova
            // linha de grafico e reinicia os valores
            if (strcmp(tmptime, TTrade.time)) {

                // Diferentes, montamos a linha

                // Variavel que contera a linha
                char chartline[100];

                // Variavel para os valores
                char values[10];

                // Descritor para leitura dos arquivos
                FILE *f;

                // Configura caminho para arquivo open
                sprintf(path, "/home/donda/ddc/buffer/chart/%s/%d/%s.open", _dt, _pe, TTrade.symbol);
                // Escrevemos no arquivo
                f = fopen(path, "r");
                if (f != NULL) {
                    fgets(values, 10, f);
                    fclose(f);
                    //close(f);
                } else {
                    strcpy(values, "0");
                }

                // Monta linha
                sprintf(chartline, "%s:1:%s", tmptime, values);

                // Pegamos a maxima
                // Configura caminho para arquivo high
                sprintf(path, "/home/donda/ddc/buffer/chart/%s/%d/%s.high", _dt, _pe, TTrade.symbol);
                // Escrevemos no arquivo
                f = fopen(path, "r");
                if (f != NULL) {
                    fgets(values, 10, f);
                    fclose(f);
                    //close(f);
                } else {
                    strcpy(values, "0");
                }

                sprintf(chartline, "%s:2:%s", chartline, values);

                // Pegamos a minima
                // Configura caminho para arquivo low
                sprintf(path, "/home/donda/ddc/buffer/chart/%s/%d/%s.low", _dt, _pe, TTrade.symbol);
                // Escrevemos no arquivo
                f = fopen(path, "r");
                if (f != NULL) {
                    fgets(values, 10, f);
                    fclose(f);
                    //close(f);
                } else {
                    strcpy(values, "0");
                }

                sprintf(chartline, "%s:3:%s", chartline, values);

                // Pegamos o fechamento
                // Configura caminho para arquivo last
                sprintf(path, "/home/donda/ddc/buffer/chart/%s/%d/%s.close", _dt, _pe, TTrade.symbol);
                // Escrevemos no arquivo
                f = fopen(path, "r");
                if (f != NULL) {
                    fgets(values, 10, f);
                    fclose(f);
                    //close(f);
                } else {
                    strcpy(values, "0");
                }

                sprintf(chartline, "%s:4:%s", chartline, values);

                // Escrevemos o a linha
                // Configura caminho para arquivo
                sprintf(path, "/home/donda/ddc/buffer/chart/%s/%d/%s.data", _dt, _pe, TTrade.symbol);
                //printf("%s %s\r\n", TTrade.symbol, chartline);
                FILE *fchart = fopen(path, "a+");
                if (fchart != NULL) {
                    fprintf(fchart, "%s\n", chartline);
                    fclose(fchart);
                    //close(fchart);
                }

                // Escrevemos o novo tempo
                // Configura caminho para arquivo
                sprintf(path, "/home/donda/ddc/buffer/chart/%s/%d/%s.time", _dt, _pe, TTrade.symbol);
                FILE *ftime = fopen(path, "w+");
                if (ftime != NULL) {
                    fprintf(fchart, "%s", TTrade.time);
                    fclose(ftime);
                    //close(ftime);

                    // Deletamos os arquivos
                    sprintf(path, "/home/donda/ddc/buffer/chart/%s/%d/%s.high", _dt, _pe, TTrade.symbol);
                    remove(path);
                    sprintf(path, "/home/donda/ddc/buffer/chart/%s/%d/%s.low", _dt, _pe, TTrade.symbol);
                    remove(path);
                    sprintf(path, "/home/donda/ddc/buffer/chart/%s/%d/%s.open", _dt, _pe, TTrade.symbol);
                    remove(path);
                }

            }

        } // if TTrade,time


        // Se achou valor de ultimo faz os calculos
        if (strcmp(TTrade.last, "-1")) {

            // Candle Atual
            char candle[100];

            /*
             *   Valor de Abertura
             *
             * Quando ocorre de vir o valor de ultimo, ao mesmo tempo que muda o
             * periodo, ele tem que verificar entao se o arquivo open existe,
             * se existir, nao houve troca de periodo e esse valor de trade nao
             * é a abertura, mas se nao existir, significa que houve uma mudanca de
             * periodo ja verificada nas linhas acima e que foi deletado o arquivo
             * para que aqui saiba dessa troca.
             */

            // Essa variavel contera a linha de atualizacao para os
            // usuarios do DDCServer.
            char *_l;
            _l = malloc(sizeof (char) *1000);

            // Inicializa a variavel de linha com o cabeçalho
            sprintf(_l, "C:%s:%d", TTrade.symbol, _pe);

            // Pega a hora do candle

            // Variavel temp que tem o valor da hora armazenada
            // no arquivo
            char tmptime[10];

            // Configura caminho para arquivo time
            sprintf(path, "/home/donda/ddc/buffer/chart/%s/%d/%s.time", _dt, _pe, TTrade.symbol);

            // Abre o arquivo
            FILE *ftime = fopen(path, "r");
            if (ftime != NULL) {
                fgets(tmptime, 10, ftime);
                fclose(ftime);
                //close(ftime);
            } else {
                // Garante que tmptime nao fique fazia
                strcpy(tmptime, "0800");
            }

            // Tira os segundos
            TTrade.time[4] = '\0';
            TTrade.time[5] = '\0';

            // Coloca a hora na linha
            sprintf(_l, "%s:%s", _l, tmptime);

            // Coloca no candle atual
            strcpy(candle, tmptime);

            // Configura caminho para arquivo abertura
            sprintf(path, "/home/donda/ddc/buffer/chart/%s/%d/%s.open", _dt, _pe, TTrade.symbol);

            char o[10];

            // Tenta abrir o arquivo
            FILE *fo = fopen(path, "r");


            // Verifica abertura
            if (fo == NULL) {
                // Não abriu, então arquivo nao existe.
                // Cria o arquivo
                fo = fopen(path, "w+");
                // Escreve no arquivo os dados
                fprintf(fo, "%s", TTrade.last);
                // Fecha o arquivo salvando os dados
                fclose(fo);
                // Fecha o descritor
                //close(fo);

                // O arquivo de Abertura controla as trocas de horario,
                // portanto como explicado acima, qdo não existir significa
                // que foi trocado o periodo. Entao assim o tipo
                // de dado sera tipo A para o comando CHART do
                // DDCServer.
                sprintf(_l, "%s:A:1:%s", _l, TTrade.last);
            } else {
                // Abriu, entao o arquivo existe, fecha o descritor
                // Coloca dado no candle atual
                fgets(o, 10, fo);
                sprintf(candle, "%s:1:%s", candle, o);
                fclose(fo);
                //close(fo);
                // Como novamente mencionado, não existir significa que é o mesmo
                // candle, então é tipo U para o comando CHART
                strcat(_l, ":U");
            }

            //printf("Passou abertura\r\n");

            /*
             *   Valor de Ultimo
             */

            // Configura caminho para arquivo last
            sprintf(path, "/home/donda/ddc/buffer/chart/%s/%d/%s.close", _dt, _pe, TTrade.symbol);

            // Tenta abrir o arquivo
            FILE *fc = fopen(path, "w+");

            // Verifica a abertura
            if (fc != NULL) {
                // Abriu, então escrevemos o dado
                fprintf(fc, "%s", TTrade.last);
                // Coloca no candle atual
                sprintf(candle, "%s:4:%s", candle, TTrade.last);
                // Fecha o arquivo salvando os dados
                fclose(fc);
                // Fecha o descritor do arquivo
                //close(fc);

                // Adiciona dado na linha de candle
                sprintf(_l, "%s:4:%s", _l, TTrade.last);
            } else {
                // Não abriu, escreve mensagem de erro
                //printf("Erro ao escrever close\r\n");
            }

            //printf("Passou ultimo\r\n");

            /*
             *   Valor de Maxima
             */

            // Configura caminho para arquivo high
            sprintf(path, "/home/donda/ddc/buffer/chart/%s/%d/%s.high", _dt, _pe, TTrade.symbol);

            // Primeiro, temos que pegar o valor atual escrito no arquivo
            // depois comparamos com o valor atual lido.

            // Variavel para comparacao
            double high = 0;
            // Variavel para dado atual no arquivo
            char h[10];

            // Tentamos abrir o arquivo
            FILE *fh = fopen(path, "r");

            // Verifica a abertura
            if (fh != NULL) {
                // Abriu, lemos o dado
                fgets(h, 10, fh);
                // Fechamos o arquivo
                fclose(fh);
                // Fechamos o descritor
                //close(fh);

                // Tentamos realizar a conversao de Str para Double
                high = atof(h);

            } else {
                // Não deu para ler o arquivo, então escreve mensagem de erro
                //printf("Erro ao ler dados de máxima\r\n");

            }

            // Realizamos a comparacao dos dados
            if (atof(TTrade.last) > high) {

                // Como o dado atual é maior que o dado no arquivo, atualizamos
                // o dado no arquivo para o dado atual.

                // Coloca no candle atual
                sprintf(candle, "%s:2:%s", candle, TTrade.last);

                // Abre o arquivo
                fh = fopen(path, "w+");

                // Verifica a tentativa de abertura
                if (fh != NULL) {
                    // Conseguiu abrir, escreve os dados
                    fprintf(fh, "%s", TTrade.last);
                    // Fecha arquivo salvando os dados
                    fclose(fh);
                    // Fecha Descritor de arquivo
                    //close(fh);

                    // Adiciona dado
                    sprintf(_l, "%s:2:%s", _l, TTrade.last);
                } else {
                    // Não conseguiu abrir, escreve mensagem de erro
                    printf("Erro ao atualizar dados de maxima\r\n");
                }
            } else {
                // Coloca no candle atual
                sprintf(candle, "%s:2:%s", candle, h);
            }

            //printf("Passou maximo\r\n");


            /*
             *   Valor de Minima
             */

            // Configura caminho para arquivo low
            sprintf(path, "/home/donda/ddc/buffer/chart/%s/%d/%s.low", _dt, _pe, TTrade.symbol);

            // Primeiro, temos que pegar o valor atual escrito no arquivo
            // depois comparamos com o valor atual lido.

            // Variavel para comparacao - Recebe um valor alto para que a primeira
            // comparacao seja verdadeira.
            double low = 70000;
            // Variavel para dado atual no arquivo
            char l[10];

            // Tentamos abrir o arquivo
            FILE *fl = fopen(path, "r");

            // Verifica a abertura
            if (fl != NULL) {
                // Abriu, lemos o dado
                fgets(l, 10, fl);
                // Fechamos o arquivo
                fclose(fl);
                // Fechamos o descritor
                //close(fl);

                // Tentamos realizar a conversao de Str para Double
                low = atof(l);

            } else {
                // Não deu para ler o arquivo, então escreve mensagem de erro
                //printf("Erro ao ler dados de minima\r\n");

            }

            // Realizamos a comparacao dos dados
            if (atof(TTrade.last) < low) {

                // Coloca no candle atual
                sprintf(candle, "%s:3:%s", candle, TTrade.last);

                // Como o dado atual é menor que o dado no arquivo, atualizamos
                // o dado no arquivo para o dado atual.

                // Abre o arquivo
                fl = fopen(path, "w+");

                // Verifica a tentativa de abertura
                if (fl != NULL) {
                    // Conseguiu abrir, escreve os dados
                    fprintf(fl, "%s", TTrade.last);
                    // Fecha arquivo salvando os dados
                    fclose(fl);
                    // Fecha Descritor de arquivo
                    //close(fl);
                    // Adiciona dado
                    sprintf(_l, "%s:3:%s", _l, TTrade.last);
                } else {
                    // Não conseguiu abrir, escreve mensagem de erro
                    //printf("Erro ao atualizar dados de minima\r\n");
                }
            } else {
                // Coloca no candle atual
                sprintf(candle, "%s:3:%s", candle, l);
            }

            //printf("Passou minima\r\n");

            // Escrevemos no buffer a linha montada
            if (_f != NULL) {
                writeln(_f, _l, "a+");
            }

            // Desalocamos a variavel da memoria
            free(_l);


            // Configura caminho para arquivo high
            sprintf(path, "/home/donda/ddc/buffer/chart/%s/%d/%s.candle", _dt, _pe, TTrade.symbol);
            writeln(path, candle, "w+");

        } // if TTrade.last


    } // if _d[0] = 'T'
}

/**
 * Função timecmp será responsavel por receber
 * o um determinado horario e retornar o horario
 * de candle daquele horario. Ex: Passa-se por parametro
 * o horario 16:03 com periodo 5, ira retornar 16:00 pois
 * o horario 16:03 pertence ao candle das 16:00.
 * @param _t
 * @param _p
 * @return
 */
char *timecmp(char *_t, int _p) {

    // Pega o valor da hora
    char h[3];
    h[0] = _t[0];
    h[1] = _t[1];
    //Finaliza h
    h[2] = '\0';

    // Hora em int
    int ih = atoi(h);

    // Pega o valor do minuto
    char m[3];
    m[0] = _t[2];
    m[1] = _t[3];
    // Finaliza m
    m[2] = '\0';

    // Minuto em int
    int im = atoi(m);


    // Pega o valor do quociente da divisao entre o minuto e o periodo
    int q = (im / _p);

    // Multiplica o valor do quociente pelo periodo para
    // descobrir a qual minuto esta relacionado
    int x = (q * _p);

    // X entao é o minuto que pertence, monta o horario
    register char *r = malloc(10);

    if (x >= 10) {
        sprintf(r, "%s%d", h, x);
    } else {
        sprintf(r, "%s0%d", h, x);
    }

    return r;

}

/**
 * Função responsavel por criar os diretores de armazenamento
 * dos dados.
 */
void makedirs(char *_dd) {

    // Configura caminho para arquivo high
    char path[1000];
    sprintf(path, "/home/donda/ddc/buffer/chart/%s/", _dd);
    mkdir(path, 0777);
    int i = 1;
    for (i = 1; i <= 30; i++) {
        sprintf(path, "/home/donda/ddc/buffer/chart/%s/%d/", _dd, i);
        mkdir(path, 0777);
    }


}

/**
 * Função readdata responsavel por ler o buffer e analisar os dados
 */
void readdata(char *_dm) {

    // Flag de execucao de neto
    // Valor inicial - 1 para validar
    // inicio de loop
    int readrun = 1;

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

    printf("Starting read...\r\n");


    // Inicia loop de leitura
    while (readrun) {

        blast(_file_buffer);

        // blast retorna NULL caso não consiga ler os
        // dados do arquivo last.buf
        if (_file_buffer == NULL || strlen(_file_buffer) < 5) {

            // Aguarda 5 segundos
            sleep(5);

            // Contabiliza tentativa
            synch_buf++;

            // Analisa se ja tentou o numero maximo
            if (synch_buf > MAX_SYNCH_TRY) {
                // Quebra fluxo
                break;
            } else {
                // Retorna fluxo ao seu inicio
                continue;
            }


        }

        //  Vindo aqui, foi possivel abrir o arquivo
        // atual de buffer

        printf("While File:%s\r\n", _file_buffer);


        // Abre arquivo do buffer
        bf_file = fopen(_file_buffer, "r");

        if (bf_file == NULL) {

            // Aguarda 5 segundo
            sleep(5);

            // Contabiliza tentativa
            synch_buf++;

            // Analisa se ja tentou o numero maximo
            if (synch_buf > MAX_SYNCH_TRY) {
                // Quebra fluxo
                break;
            } else {
                // Retorna fluxo ao seu inicio
                continue;
            }
        }

        // Chegando aqui, foi possivel abrir o arquivo de buffer
        // Zera as tentativas de leitura
        synch_buf = 0;

        // Contador para os peridos de grafico
        int charts = 1;

        // Lemos buffer até que seja trocado
        // o arquivo
        while (1) {

            // Lê dados do arquivo, NULL representa fim do arquivo
            // Aguardando entao 1/10 de segundo
            if (fgets(bfline, MAX_BUF_SIZE, bf_file) != NULL) {

                removechars(bfline, bfline);

                // Analises para Trade ( T: )
                if (bfline[0] == 'T' && bfline[strlen(bfline) - 1] == '!') {

                    // Analisa dados
                    for (charts = 1; charts <= 30; charts++) {
                        tradedata(bfline, charts, _dm, "/home/donda/ddc/buffer/ddcchart.data");                        
                    }
/*
                    tradedata(bfline, 1, _dm, "/home/donda/ddc/buffer/ddcchart.data");
                    tradedata(bfline, 5, _dm, "/home/donda/ddc/buffer/ddcchart.data");
                    tradedata(bfline, 10, _dm, "/home/donda/ddc/buffer/ddcchart.data");
                    tradedata(bfline, 15, _dm, "/home/donda/ddc/buffer/ddcchart.data");
                    tradedata(bfline, 30, _dm, "/home/donda/ddc/buffer/ddcchart.data");
*/


                    // Volta contador ao inicio
                    charts = 1;
                }

                // Limpa o buffer e seus auxiliares
                bzero(bfline, MAX_BUF_SIZE);
                bzero(bfline_aux1, 5);
                bzero(bfline_aux2, 10);                

            } else {

                // Aqui significa que o arquivo esta em seu final,
                // analizamos se não foi trocado o buffer

                // Le dado atual no arquivo de ultimo buffer
                char *_check;
                _check = malloc(strlen(BUFFER_PATH) + 60);
                blast(_check);

                //printf("Find end file, then check:%s | %s\r\n", _file_buffer, _check);

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
                        // Zera o contador
                        syn = 0;
                    }
                } else if (strcmp(_file_buffer, _check)) {
                    // Opa trocou, quebramos o loop de leitura
                    // para iniciar no nova arquivo e fechamos descritor atual
                    printf("Change file, breaking loop...\r\n");
                    fclose(bf_file);
                    free(_check);
                    break;
                } else {
                    // É o mesmo ainda, então aguarda 1/10 de segundo
                    //printf("Same, do nothing...\r\n");
                    free(_check);
                    usleep(10);
                }


            }

        }

    }


}



/**
 * Função responsável por retornar o proximo arquivo de leitura
 * de buffer.
 * @param _blast
 */
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
    strcpy(__s,_s);

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
    fs = fopen(snapfile,"w+");
    if(fs!=NULL){
        fprintf(fs,"%s",_v);
        fclose(fs);
    }
    free(__s);
}