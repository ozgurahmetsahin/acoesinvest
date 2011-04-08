/*
 *  Biblioteca que contem funcoes usadas em varios sistemas.
 *
 * Author: donda
 *
 * Versões:
 *
 *  21/06/2010 : Versão 1.0
 *
 * Created on June 21, 2010, 2:43 PM
 */


/* Bibliotecas necessarias.*/
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
#include <ctype.h>

/*Decalaracao da propria biblioteca*/
#include "ailib.h"

/* Leitor de dados do socket.
 *  É considerado final de uma linha quando é recebido um LF seguido
 *  de um CR. Veja RFC 854 para melhor entendimento.
 *
 *  Retorna a quantidade de bytes lidos ou -1 para erro de leitura.
 */
int readline(int _fd, char *_t, int _readtimeout) {

    // Variavel de retorno
    int _return = -1;

    // Controlador de ponteiro para char
    int position = 0;

    // Auxiliar para leitura do socket
    char *_charread;
    _charread = malloc(sizeof (char));

    // Total de bytes lidos
    unsigned short total = 0;

    // Estrutura para timeout
    struct timeval delay;

    // Configuracoes para select
    fd_set testSet;

    // Resuldado do select
    int ready;

    // Lê dados do buffer até encontrar \n
    do {

        // Se tiver timeout
        if (_readtimeout != 0) {

            // Configura timeout
            delay.tv_sec = _readtimeout;
            delay.tv_usec = 0;

            // Configura select no descritor
            FD_ZERO(&testSet);
            FD_SET(_fd, &testSet);

            // Aplica select
            ready = select(_fd + 1, &testSet, 0, 0, &delay);

            // Se estourou o timeout
            if (ready == 0) {
                _return = -10;
                break;
            }

        }

        // Coloca na variavel auxiliar, o caracter lido do socket
        _return = recv(_fd, _charread, sizeof (char), 0);

        // Analisa se foi uma queda ( retorno < 0 )
        if (_return < 0) {
            break;
        } else if (_return == 0) {
            // Fim do arquivo de leitura
            _return = -1;
            break;
        }

        total += _return;

        // Coloca na variavel de retorno de texto, o caracter lido
        _t[position] = _charread[0];

        // Muda posicao
        position++;

        // Analisa se é o \n
        if ((unsigned int) _charread[0] == 10) {
            // Finaliza leitura
            break;
        }

    } while (_return > 0);

    // Limpa da memoria a variavel auxiliar
    free(_charread);

    // Retorno da funcao
    if (_return <= 0)
        return _return;
    else return total;

}

/* Conecta-se a um determinado host e porta.
 *
 * Retorna o descritor de conexão ou -1 para erro.
 */
int connecttoserver(char *host, int port) {

    // Retorno padrão da função
    int r = -1;

    // Descritor do socket
    int sckcrystal;

    // Tamanho do endereçamento
    int size_addr;

    // Estrutura de endereçamento
    struct sockaddr_in sock_addr;

    // Flag de verificação
    int g;

    // Resolve endereço
    struct hostent *host_name;

    // Gera descritor do socket
    sckcrystal = socket(PF_INET, SOCK_STREAM, 0);

    // Seta memoria para estrutura
    memset(&sock_addr, 0, sizeof sock_addr);

    // Resolve
    host_name = gethostbyname(host);

    if (host_name == NULL) {
        r = -1;
    } else {

        // Configura enderecamento
        sock_addr.sin_family = PF_INET;
        sock_addr.sin_port = htons(port);
        sock_addr.sin_addr.s_addr = inet_addr(inet_ntoa(* (struct in_addr *) host_name->h_addr_list[0]));

        // Obtem o tamanho da estrutura ja configurada
        size_addr = sizeof (sock_addr);

        // Realiza conexao
        g = connect(sckcrystal, (struct sockaddr *) & sock_addr, size_addr);

        // Se connect bem sucedido retorna descritor
        if (g < 0) {
            r = -1;
        } else {
            r = sckcrystal;
        }
    }

    // Retorna valor
    return r;
}

/* Escreve em um arquivo especificado de acordo com o modo passado.
 * No final da linha escrita é adicionado um LF.
 * Retorna 0 para sucesso ou -1 para erro na escrita.
 */
int writeln(char *_fname, char *text, char *_modes) {
    int fw = 0;
    //Descritor do arquivo
    FILE *fl;
    //Abre o arquivo em modo de escrita no final do arquivo
    fl = fopen(_fname, _modes);
    // Verifica se abriu o arquivo
    if (fl != NULL) {
        fw = fprintf(fl, "%s\n", text);
        //Fecha descritor salvando alterações
        fclose(fl);
    } else {
        fw = -1;
    }
    return fw;
}

/* Obtem em __bf o nome do arquivo TBF baseado na hora
 *  local da máquina.
 */
void gettbf(char *__bf) {
    time_t t = time(NULL);
    struct tm *lt;
    lt = localtime(&t);
    strftime(__bf, 14, "%m%d%H%M.tbf", lt);
}

/* Obtem em __bf o nome do arquivo TBF baseado na hora
 *  local da máquina, concatenando com o diretorio passado.
 */
void gettbf_d(char *__dir, char *_n) {
    char *fname;

    fname = malloc(14);

    char *ffname;

    ffname = malloc(sizeof (__dir) + 20);

    strcpy(ffname, __dir);

    time_t t = time(NULL);
    struct tm *lt;

    lt = localtime(&t);

    strftime(fname, 14, "%m%d%H%M.tbf", lt);

    strcpy(_n, ffname);

    free(fname);

}

/* Obtem em __t a hora baseada no formato em __f.
 *
 * Formato:
 *   %a  	abbreviated weekday name
 *   %A 	full weekday name
 *   %b 	abbreviated month name
 *   %B 	full month name
 *   %c 	date and time representation
 *   %d 	decimal day of month number 01–31
 *   %H 	hour 00–23 (24 hour format)
 *   %I 	hour 01–12 (12 hour format)
 *   %j 	day of year 001–366
 *   %m 	month 01–12
 *   %M 	minute 00–59
 *   %p 	local equivalent of ‘AM’ or ‘PM’
 *  %S          second 00–61
 *   %U 	week number in year 00–53 (Sunday is first day of week
 *   %w 	weekday, 0–6 (Sunday is 0)
 *   %W 	week number in year 00–53 (Monday is first day of week
 *   %x 	local date representation
 *   %X 	local time representation
 *   %y 	year without century prefix 00–99
 *   %Y 	year with century prefix
 *   %Z 	timezone name, or no characters if no timezone exists
 *   %% 	a % character
 */
void gettime(char *__f, char *__t) {
    time_t t = time(NULL);
    struct tm *lt;
    lt = localtime(&t);
    strftime(__t, 14, __f, lt);
}

/* Converte texto em maiuscula
 */
void uppercase(char *_t) {
    int i = 0;
    for (i = 0; i <= strlen(_t); i++) {
        _t[i] = (char) toupper((unsigned int) _t[i]);
    }
}

// Remove os caracteres \r e \n

void removechars(char *__b, char *_r) {

    char *_m;
    _m = malloc(strlen(__b) + 1);

    int s = 0;
    int p = 0;

    for (s = 0; s <= strlen(__b); s++) {

        if ((unsigned int) __b[s] != 10 && (unsigned int) __b[s] != 13) {
            _m[p] = __b[s];
            p++;
        }

    }

    bzero(_r, strlen(__b) + 1);

    strcpy(_r, _m);

    free(_m);

}

// Separa os valores baseado no caracter de separa��o(separator) e popula
// a lista com os dados separados.
// Utilize a conversao de caracter para obter o separador desejado.
// Ex: (unsigned int)':' Coloca como separador o caracter de dois pontos( : )

void splitcolumns(char *data, unsigned int separator, struct TDDCData *list) {

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
    struct TDDCData *end;

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
                list->index = count;
                strcpy(list->value, tempdata);
                list->next = NULL;
                // Como � a primeira, a ultima usada � ela mesma
                end = list;
            } else {
                // Como nao � o primeiro, cria uma
                // nova estrutura e popula os dados
                // o malloc aloca a nova estrutura
                // na memoria.
                struct TDDCData *last;
                last = malloc(sizeof (struct TDDCData));
                // Popula os dados
                last->index = count;
                strcpy(last->value, tempdata);
                last->next = NULL;

                // Coloca na ultima usada, essa proxima estrutura
                end->next = last;

                // Atualiza a ultima usada para esta nova criada
                end = last;
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
    struct TDDCData *last;
    last = malloc(sizeof (struct TDDCData));
    // Popula os dados
    last->index = count;
    strcpy(last->value, tempdata);
    last->next = NULL;

    // Coloca na ultima usada, essa proxima estrutura
    end->next = last;

    // Atualiza a ultima usada para esta nova criada
    end = NULL;

}

// Obtem o numero de colunas de uma lista

int columnscount(struct TDDCData *list) {

    // Variavel temporaria para analise
    struct TDDCData *p = list;

    // Contador
    int counter = 0;

    // Varre a lista contado os dados
    while (p) {
        counter++;
        p = p->next;
    }

    // Retorna o dado
    return counter;
}

// Cria uma nova lista, alocando na memoria.

struct TDDCData* createlist() {
    struct TDDCData *newlist;
    newlist = (struct TDDCData*) malloc(sizeof (struct TDDCData));
    return newlist;
}

// Destroi a lista liberando toda memoria utilizada

void destroylist(struct TDDCData *list) {

    // Estrutura temporaria para manipulacao
    struct TDDCData *p = list;

    // Varre limpando os dados
    while (p != NULL) {
        // Referencia para o proximo elemento
        struct TDDCData *t = p->next;

        // Libera a memoria apontada por p;
        free(p);

        // Aponta para o proximo elemento
        p = t;
    }

    return;

}

// Recebe um dado enfoque e converte-o em cedro.
// Essa função ira analisar e chamar sua funcao
// correspondente.

void entoce(char *data, char *cedrof) {

    // Estrutura organizada com os dados
    struct TDDCData *trade = createlist();

    // Separa os dados na estrutura
    splitcolumns(data, 9, trade);


    // Dados conhecidos:
    // T: = Tick de cota��o
    // B: = Mini book 5 melhores
    // N: = Negocios realizados
    // D: = Livro completo

    // Verifica qual tipo de dado �
    if (trade->value[0] == 'T') {
        // Tick de trade
        entick(trade, cedrof);
    } else if (trade->value[0] == 'N') {

        // Altera N para T
        trade->value[0] == 'T';

        // Negocios realizados
        entrade(trade, cedrof);
    }

    // Destroi a lista
    destroylist(trade);

}

// Converte os dados de Tick da enfoque para formato Cedro

void entick(struct TDDCData *list, char *cedro) {
    // Estrutura temporaria para manipulacao dos dados
    struct TDDCData *t = list;

    // Dado temporiario para valor de ultimo
    char *lastvalue = malloc(sizeof (char) *1000);

    // Varre a estrutura analisando os dados
    while (t) {

        //Ve qual é a coluna
        switch (t->index) {

                // Coluna com o ativo
            case 0:
                // Apenas coloca na variavel
                strcpy(cedro, t->value);
                //break obrigatorio
                break;

                // Coluna com o Ultimo

            case 1:
                // Coloca na variavel temporaria lastvalue
                // para inserir posteriormente.
                strcpy(lastvalue, t->value);
                // break obrigatorio
                break;


                // Coluna com a Hora
            case 2:
                // Coloca na variavel da cedro ja formatado
                sprintf(cedro, "%s:%s00:5:%s00:2:%s", cedro, t->value, t->value, lastvalue);
                // break obrigatorio
                break;

                // Coluna com Variacao
            case 3:
                // Coloca na variavel da cedro ja formatado
                sprintf(cedro, "%s:664:%s:700:%s", cedro, t->value, t->value);
                // break obrigatorio
                break;

                // Coluna com Maxima
            case 4:
                // Coloca na variavel da cedro ja formatado
                sprintf(cedro, "%s:11:%s", cedro, t->value);
                // break obrigatorio
                break;

                // Coluna com Minima
            case 5:
                // Coloca na variavel da cedro ja formatado
                sprintf(cedro, "%s:12:%s", cedro, t->value);
                // break obrigatorio
                break;

                // Coluna com Fechamento
            case 6:
                // Coloca na variavel da cedro ja formatado
                sprintf(cedro, "%s:13:%s", cedro, t->value);
                // break obrigatorio
                break;

                // Coluna com Abertura
            case 7:
                // Coloca na variavel da cedro ja formatado
                sprintf(cedro, "%s:14:%s", cedro, t->value);
                // break obrigatorio

                break;

            case 8:
                // Coloca na variavel da cedro ja formatado
                sprintf(cedro, "%s:3:%s", cedro, t->value);
                // break obrigatorio

                break;

            case 9:
                // Coloca na variavel da cedro ja formatado
                sprintf(cedro, "%s:4:%s", cedro, t->value);
                // break obrigatorio

                break;

                // Coluna com Numero de Negocios
                /*          Comentado porque esse dado ja vem no pacote N:
                            case 10:
                                // Coloca na variavel da cedro ja formatado
                                sprintf(cedro,"%s:8:%s",cedro,t->value);
                                // break obrigatorio
                                break;
                 */

        }


        t = t->next;
    }

    // Chegou no final da analise, finaliza a string com ! obrigatorio e envia
    strcat(cedro, "!");

}

// Converte os negocios realizados da enfoque para formato Cedro

void entrade(struct TDDCData *list, char *cedro) {
    // Estrutura temporaria para manipulacao dos dados
    struct TDDCData *t = list;

    // Dado temporario para horario de negociacao
    char *hour = malloc(sizeof (char) *1000);

    // Varre a estrutura analisando os dados
    while (t) {

        //Ve qual é a coluna
        switch (t->index) {

                // Coluna com o ativo
            case 0:
                // Apenas coloca na variavel
                strcpy(cedro, t->value);

                // Altera N: Para T:
                cedro[0] = 'T';

                //break obrigatorio
                break;

                // Coluna com a Hora
            case 1:
                // Coloca na variavel temporaria hour
                // para inserir posteriormente.
                strcpy(hour, t->value);
                // break obrigatorio
                break;

                // Coluna com o Ultitmo
            case 2:
                // Tira os 0 a mais
                t->value[5] = '\0';
                t->value[6] = '\0';
                // Coloca na variavel da cedro ja formatado
                sprintf(cedro, "%s:%s00:2:%s:5:%s", cedro, hour, t->value, hour);
                // break obrigatorio
                break;

                // Coluna com o Numero de Negocios
            case 4:
                // Coloca na variavel da cedro ja formatado
                sprintf(cedro, "%s:8:%s", cedro, t->value);
                // break obrigatorio
                break;


        }


        t = t->next;
    }

    // Chegou no final da analise, finaliza a string com ! obrigatorio e envia
    strcat(cedro, "!");
}
