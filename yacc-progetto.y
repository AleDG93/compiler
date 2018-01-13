%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

void yyerror (char *s);

typedef struct symbol_table {

    char * var;
    char * val;
    struct symbol_table * next;
} symb;

symb * head = NULL;

char* getVarValue(char* var);
void updateSymbolVal(char * val, char * var);


%}


%union {
	char* var; //Name of the variable
	char* val; //Value of the variable

       }

%token <var> VAR
%token <val> VAL
%token print
%token exit_command

/* %type <value> line */
%type <var> line expr 


%start line

%%


line	: assign ';'		{;}
	| exit_command		{exit(EXIT_SUCCESS);}
	| print expr ';'	{printf("Printing: %s\n", $2);}
	| line assign ';'	{;}
	| line print expr ';'	{printf("Printing %s\n", $3);}
	| line exit_command	{exit(EXIT_SUCCESS);}


assign	: VAR '=' expr		{updateSymbolTable($1, $3);}
	;			

expr	: VAL			{$$ = $1;}
	| VAR			{$$ = getVarValue($1);}
	;



/*
line  : VAR '=' VAL {printf("Assign: %s to %s", $1,$3);}
      | print '(' VAR ')' {printf("Printing: %s", $3);}
      ;
  */    

%%

char* getVarValue(char * var){

	return "ciao";
}
 
void updateSymbolTable(char * val, char * var) {
    
	symb * current = head;
	/* Check if variable already exists */
	while (current->next != NULL && current->var != var) {
		current = current->next;
	}
	/*If var already exists update the value*/	
	if(current->var == var){
		current->val = val;	
	} else {
	/* If var does not exist add a new value */
		current->next = malloc(sizeof(symb));
		current->next->val = val;
		current->next->next = NULL;
	}
}

int main (void) {
	
	/* init symbol table */

	
	head = malloc(sizeof(symb));
	if (head == NULL) {
	    return 1;
	}

	head->var = "head";
	head->val = "head";
	head->next = NULL;

	symb * current = head;

	while (current != NULL) {
		printf("%s\n", current->val);
		current = current->next;
	}

	return yyparse ( );
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 

#include "lex.yy.c"





