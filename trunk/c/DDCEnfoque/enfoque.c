/*
 * File:   enfoque.h
 * Author: Anderson Donda
 *
 * Funções usadas para tratamento do sinal Enfoque.
 *
 * Created on May 28, 2010, 6:33 PM
 */

/*Bibliotecas do sistema*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

/*Include de suas proprias prototypes*/
#include "enfoque.h"

/*Biblioteca Acoes Invest*/
#include "ailib.h"

/**
 * Realiza leitura do arquivo que contem os ativos
 * que deverão ser chamados ao servidor da enfoque.
 * Retorna -1 caso haja erro de leitura do arquivo, ou
 * 1 para leitura bem sucedida.
 *
 *  _fd : Descritor do socket com a conexao a enfoque.
 *  _sfile : Arquivo que contem a lista de ativos.
 *  _smax : Tamanho maximo para o simbolo do ativo.
 * */
int subsymbols(int _fd, char *_sfile, int _smax) {

    // Descritor do arquivo de ativos
    FILE *fsymbols;

    // Abre o arquivo
    fsymbols = fopen(_sfile, "r");

    // Verifica se foi possivel abrir
    if (fsymbols == NULL) {

        // Retorna -1
        return -1;

    } else {

        // Variavel para leitura da linha
        char *line;
        line = malloc(_smax);

        // Montagem do comando
        char *cmd;
        cmd = malloc(_smax + 4);


        // Lê dados
        while ((fgets(line, _smax, fsymbols)) != NULL) {

            //Monta comando - S
            sprintf(cmd, "%s%s\r\n", "S:", line);

            // Realiza chamada
            send(_fd, cmd, strlen(cmd), 0);


            //Monta comando - D
            sprintf(cmd, "%s%s\r\n", "D:", line);

            // Realiza chamada
            send(_fd, cmd, strlen(cmd), 0);

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
 * Aqui pega um arquivo, e lê até o final, simulando uma cotacao
 */
void test(char *_sfile) {
    // Descritor do arquivo de ativos
    FILE *fsymbols;

    // Abre o arquivo
    fsymbols = fopen(_sfile, "r");

    extern char *cedrobooks;
    extern int addcountc;
    extern int addcountv;

    // Verifica se foi possivel abrir
    if (fsymbols == NULL) {


    } else {

        // Variavel para leitura da linha
        char *line;
        line = malloc(1000);

        // Montagem do comando
        char *cmd;
        cmd = malloc(1000 + 4);


        // Lê dados
        while ((fgets(line, 1000, fsymbols)) != NULL) {

            printf("Line:%s\r\n", line);

            // Analisa a primeira letra da mensagem.
            // para ver que tipo de mensagem é
            if (line[0] == 'T') {
                // Mensagens Tick ( T: ) e Negocios ( N: )

                // Variavel que conterá a mensagem convertida para o formato cedro
                char *cedrofmt = malloc(sizeof (char) *1000);

                // Utiliza a funcao da biblioteca Ailib que ja faz as conversoes
                entoce(line, cedrofmt);

                // Certo, como o dado foi convertido escrevemos
                // a mensagem no buffer central
                if (cedrofmt != NULL) {
                    writeln("/home/donda/ddc/buffer/test.tbf", cedrofmt, "a+");
                }

                // Limpa a variavel da memoria
                free(cedrofmt);

            } else if (line[0] == 'N') {

                // Mensagens Tick ( T: ) e Negocios ( N: )

                // Variavel que conterá a mensagem convertida para o formato cedro
                char *cedrofmt = malloc(sizeof (char) *1000);

                // Utiliza a funcao da biblioteca Ailib que ja faz as conversoes
                entoce(line, cedrofmt);

                // Certo, como o dado foi convertido escrevemos
                // a mensagem no buffer central
                if (cedrofmt != NULL) {
                    writeln("/home/donda/ddc/buffer/test.tbf", cedrofmt, "a+");
                }

                printf("Line:%s\r\n", line, cedrofmt);

                sleep(1);

                // Limpa a variavel da memoria
                free(cedrofmt);

            } else if (line[0] == 'D') {

                // Mensagem de livro dinamico
                // faz um tratamento diferente já que o separador
                // de dados é o : e nao o TAB

                // Estrutura para analise
                struct TDDCData *dbook = createlist();

                // Popula a estrutura ( 58 é o codigo asci para o :
                splitcolumns(line, 58, dbook);

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
                            sprintf(bookcedro, "M:%s:U", cedrobooks);

                            // Altera a falg que identifica que tipo de mensagem é
                            book_type = 1;

                        } else if (tmp->value[0] == 'D') {

                            // Mensagem de delecao, montamos
                            // o cabecao da mensagem com o ativo
                            // que esta na variavel global.
                            sprintf(bookcedro, "M:%s:D", cedrobooks);

                            // Altera a flag que identifica que tipo de mensagem é
                            book_type = 2;

                        } else if (tmp->value[0] == 'A') {

                            // Mensagem de adição, vai para o proximo indice
                            // e ve qual é a direcao
                            tmp = tmp->next;

                            if (tmp->value[0] == 'A') {
                                // Direcao compra
                                sprintf(bookcedro, "M:%s:A:%d", cedrobooks, addcountc);
                                addcountc++;
                            } else if (tmp->value[0] == 'V') {
                                // Direcao venda
                                sprintf(bookcedro, "M:%s:A:%d", cedrobooks, addcountv);
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
                    writeln("/home/donda/ddc/buffer/test.tbf", bookcedro, "a+");
                }

                // Limpa variaveis
                free(bookcedro);
                free(position);

                // Destroi a lista
                destroylist(dbook);

                tmp = NULL;


            }

        }

        // Limpa variaveis da memoria
        free(line);
        free(cmd);

        // Fecha arquivo de ativos
        fclose(fsymbols);

    }
}