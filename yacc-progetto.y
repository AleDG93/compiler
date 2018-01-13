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
void updateSymbolVal(char * var, char * val);


%}


%union {
	char* var; //Name of the variable
	char* val; //Value of the variable
	char* str;
       }

%token <var> VAR
%token <val> VAL
%token print
%token exit_command

/* %type <value> line */
%type <var> line expr 
%type <str> assign

%start line

%%


line	: assign ';'			{;}
	| exit_command			{exit(EXIT_SUCCESS);}
	| print '(' expr ')' ';'	{;}
	| line assign ';'		{;}
	| line print '(' expr ')' ';'	{;}
	| line exit_command		{exit(EXIT_SUCCESS);}
	;

assign	: expr '=' expr		{printf("Distinguish assign: %s + %s\n",$1,$3);updateSymbolTable($1, $3);}
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

	symb * current = head;

	printf("\n-----------------\n");
	while (current != NULL && current->var != var) {
		printf("CURRENT-VAR: %s\nCURRENT-VAL: %s\n", current->var, current->val);
		current = current->next;
	}

	printf("\n-----------------\n");
	return "ciao";
}
 
void updateSymbolTable(char * var, char * val) {
    
	printf("VAR: %s and VAL: %s\n", var,val);
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
		current->next->var = var;
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

	

	return yyparse ( );
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 

#include "lex.yy.c"





