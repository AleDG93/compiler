%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

void yyerror (char *s);

typedef struct symbol_table {

    char * var;
    int val;
    struct symbol_table * next;
} symb;

symb * head = NULL;

int getVarValue(char* var);
void updateSymbolVal(char * var, int val);
int computeOperation(int val1, char *op, int val2);

%}

%union {
	int value;
	char *lexeme;
	char *op;
}

%token <lexeme> ID
%token <value> VALUE
%token OP
%token ASSIGN

%type <op> OP
%type <value> expr
%start program


%%
program: program statement {}
	|	{}
	;
	
statement: ID ASSIGN expr		{
		updateSymbolTable($1,$3);
		printf("Found a statement with: '%s' <- '%d'", $1, $3);
	};
	;
expr: ID ASSIGN expr
	| VALUE 	{ 
		printf("Found VALUE '%d'\n", $1);
		$$ = $1;
		}
	| ID		{ 
			printf("Found ID '%s'\n", $1); 
			$$ = getVarValue($1);
		}	
	;
/*expr: expr OP expr	{
			$$ = computeOperation($1,$2,$3);
			}
	| '(' expr ')'	{
			$$ = $2;
			}
	| VALUE		{ 
			printf("Found VALUE '%d'\n", $1); 
			$$ = $1;
			}
	| ID		{ 
			printf("Found ID '%s'\n", $1); 
			$$ = getVarValue($1);
			}	
	;
  */ 

%%

int getVarValue(char * var){

	symb * current = head;

	printf("\n-----------------\n");
	while (current != NULL && (strcmp(current->var,var) != 0)) {
		printf("CURRENT-VAR: %s\nCURRENT-VAL: %d\n", current->var, current->val);
		current = current->next;
	}
	
	int result = current->val;

	printf("\n-----------------\n");
	return result;
}
 
void updateSymbolTable(char * var, int val) {
    
	printf("VAR: %s and VAL: %d\n", var,val);
	symb * current = head;
	// Check if variable already exists 
	while (current->next != NULL && (strcmp(current->var,var) != 0)) {
		current = current->next;
	}
	//If var already exists update the value	
	if(strcmp(current->var,var) == 0){
		printf("ID FOUND\n");
		current->val = val;	
	} else {
	// If var does not exist add a new value
		printf("\n\nShoul print this\n");
		current->next = malloc(sizeof(symb));
		current->next->var = var;
		current->next->val = val;
		current->next->next = NULL;
	}

	symb * current2 = head;
	printf("\n-----------------\n");
	while (current2 != NULL) {
		printf("CURRENT-VAR: %s\nCURRENT-VAL: %d\n", current2->var, current2->val);
		current2 = current2->next;
	}

	printf("\n-----------------\n");
}



int computeOperation(int val1, char *op, int val2){

	if(strcmp(op, "sum") == 0){
		printf("Do operation sum");
		return (val1 + val2);
	} else if(strcmp(op, "sub") == 0){
		printf("Do operation sub");
		return (val1 - val2);
	} else if(strcmp(op, "div") == 0){
		printf("Do operation dib");
		return (val1 / val2);
	} else if(strcmp(op, "prod") == 0){
		printf("Do operation prod");
		return (val1 * val2);
	}
}


int main (void) {
	
	/* init symbol table */

	
	head = malloc(sizeof(symb));
	if (head == NULL) {
	    return 1;
	}

	head->var = "head";
	head->val = 1;
	head->next = NULL;

	

	return yyparse ( );
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 

#include "lex.yy.c"





