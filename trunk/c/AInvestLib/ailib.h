/*
 * File:   ailib.h
 * Author: donda
 * Biblioteca com as principais funcoes utlizadas nos sistemas Acoes Invest
 * Created on May 21, 2010, 7:09 PM
 */

#ifndef _AILIB_H
#define	_AILIB_H

// Estrutura de dados DDC
struct TDDCData{
    int index; // Identificador da coluna
    char value[256]; // Valor da coluna
    struct TDDCData *next; // Proximo dado
};

/* Leitor de dados do socket.
 *  É considerado final de uma linha quando é recebido um LF seguido
 *  de um CR. Veja RFC 854 para melhor entendimento.
 *
 *  Retorna a quantidade de bytes lidos ou -1 para erro de leitura.
 */
extern int readline(int _fd, char *_t, int _readtimeout);

/* Conecta-se a um determinado host e porta.
 *
 * Retorna o descritor de conexão ou -1 para erro.
 */
extern int connecttoserver(char *host, int port) ;

/* Escreve em um arquivo especificado de acordo com o modo passado.
 * No final da linha escrita é adicionado um LF.
 * Retorna 0 para sucesso ou -1 para erro na escrita.
 */
extern int writeln(char *_fname, char *text, char *_modes) ;

/* Obtem em __bf o nome do arquivo TBF baseado na hora
 *  local da máquina.
 */
extern void gettbf(char *__bf);

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
extern void gettime(char *__f, char *__t);

/* Converte texto em maiuscula
 */
extern void uppercase(char *_t);

/* Remove os caracteres \r e \n
 */
void removechars(char *__b, char *_r);

/* Obtem em __bf o nome do arquivo TBF baseado na hora
 *  local da máquina, concatenando com o diretorio passado.
 */
void gettbf_d(char *__dir, char *_n);

// Separa os valores baseado no caracter de separa��o(separator) e popula
// a lista com os dados separados.
// Utilize a conversao de caracter para obter o separador desejado.
// Ex: (unsigned int)':' Coloca como separador o caracter de dois pontos( : )
extern void splitcolumns(char *data, unsigned int separator, struct TDDCData *list);

// Obtem o numero de colunas de uma lista
extern int columnscount(struct TDDCData *list);

// Cria uma nova lista, alocando na memoria.
extern struct TDDCData* createlist();

// Destroi a lista liberando toda memoria utilizada
extern void destroylist(struct TDDCData *list);

// Converte os dados de Tick da enfoque para formato Cedro
extern void entick(struct TDDCData *list, char *cedro);

// Converte os negocios realizados da enfoque para formato Cedro
extern void entrade(struct TDDCData *list, char *cedro);

// Recebe um dado enfoque e converte-o em cedro.
// Essa função ira analisar e chamar sua funcao
// correspondente.
extern void entoce(char *data, char *cedrof);

/*#ifdef	__cplusplus
extern "C" {
#endif

#ifdef	__cplusplus
}
#endif
*/
#endif	/* _AILIB_H */