#include <stdio.h>
#include <stdlib.h>
#include <string.h>


#define GREEN   "\x1b[32m"
#define YELLOW  "\x1b[33m"
#define CYAN    "\x1b[36m"
#define RESET   "\x1b[0m"


// Precondicion: str apunta a un arreglo de caracteres terminado en null.
// Postcondicion: Imprime la representacion binaria de cada uno de los caracteres en str.
void print_binary_rep(char *str) {
	int i = 0,j = 0;
	char curr;
	unsigned char mask;
	while (curr = str[i]) {
		// printf("%d:",curr);
		// Los codigos ascii son: A: 65, B: 66, C: 67, D: 68.
		mask = 0x80;
		for (j=0;j<8;j++) {
			if (curr & mask)
				printf("1");
			else
				printf("0");
			mask = mask >> 1;
		}
		printf(" ");
		i += 1;
	}
	printf("\n");
}


// Precondicion: str apunta a la salida del algoritmo de codificacion (termina con dos 00 consecutivos en la representacion binaria de la salida)
// Postcondicion: Imprime la representacion binaria de la salida del algoritmo de codificacion
void print_encoded_string(char *str) {
	int i = 0,j = 0;
	char curr;
	unsigned char mask;
	int prev_zero = 0, finished = 0;
	while (!finished) {
		curr = str[i];
		mask = 0x80;
		for (j=0;j<8;j++) {
			if (curr & mask) {
				printf("1");
				prev_zero = 0;
			}
			else {
				printf("0");
				if (prev_zero) {
					finished = 1;
					break;
				} else {
					prev_zero = 1;
				}
			}
			mask = mask >> 1;
		}
		i += 1;
	}
	printf("\n");
}


/* 
 * Codifica la cadena de caracteres de entrada 'str', y retorna el resultado en 'encoded_str'. 
 * Recordar que 'encoded_str' debe terminar con dos bits consecutivos en 0. 
 * Ademas, el procedimiento debe retornar en el parametro 'table' la codificacion usada para cada una de las letras
 * 
 * IMPLEMENTADO EN Assembly
*/
void encode(char *str, char *table, char *encoded_str);


/* 
 * Toma como entradas una cadena de caracteres codificada 'decoded_str' (que finaliza con dos bits consecutivos en cero), 
 * la tabla con la codificacion usada por cada letra, 'table', y retornar la cadena decodificada en el parametro 'decoded_str'.
 * Es importante agregar al final de 'decoded_str' el caracter null. 
 * 
 * IMPLEMENTADO EN Assembly
*/
void decode(char *encoded_str, char *table, char *decoded_str);

int main(int argc, char *argv[]) {

	char table[5];
	table[4] = 0;
	int str_elems = 20;

	char *str;
	char *encoded_str;
	char *decoded_str;

	str = argv[1];
	str_elems = strlen(str) + 1;
	
	
	printf(YELLOW  "---------------- Cadena de entrada  --------------" RESET "\n");
	printf("N° de elems: %d\n", str_elems);
	printf("Cadena: %s\n\n", str);

	encoded_str = malloc(str_elems);
	decoded_str = malloc(str_elems);

	encode(str, table, encoded_str);

	printf(YELLOW "----------- Resultado de la codificación  --------" RESET "\n");
	printf(CYAN "Matriz de codificación: " RESET);
	print_binary_rep(table);

	printf(GREEN "Cadena codificada: " RESET);
	print_encoded_string(encoded_str);
	print_nl();

	decode(encoded_str, table, decoded_str);

	printf(YELLOW "--------  Resultado de la decodificación  --------" RESET "\n");
	printf("Cadena decodificada: %s\n\n", decoded_str);

}