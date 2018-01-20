%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void yyerror (char *s);

typedef struct symbol_table {

    char * var;
    int val;
    struct symbol_table * next;
} symb;

typedef struct actions {

    char * action;
    int val1;
    int val2;
} act;

symb * head = NULL;

int getVarValue(char* var);
void updateSymbolVal(char * var, int val);
int computeOperation(int val1, char *op, int val2);
int computeLogicOperation(int val1, char *op, int val2);
void pleaseDo(act *action);
void executeIf(int logicOp, act *val1, act *val2);
act * telling(int val);
act * assignment(char * val1, int val2);


%}

%union {
	int value;
	char *lexeme;
	char *op;
	act *opaction;
}

%token <lexeme> ID
%token <value> VALUE
%token OP
%token ASSIGN
%token LOGIC
%token TELLME
%token ELSE

%type <op> OP LOGIC
%type <value> expr logiceq
%type <opaction> neststmt

%start program


%%
program: program stmt {}
	|	{}
	;
	
stmt: 	ID ASSIGN expr	'\n' {
			updateSymbolTable($1,$3);
			}
	| TELLME '(' expr ')' '\n' {
			printf("\nTellin' you: %d\n",$3);
			}
	| logiceq '\n' '\t' neststmt ELSE '\n' '\t' neststmt	{
			executeIf($1,$4,$8);
			}
	;

neststmt:ID ASSIGN expr	'\n' {
			$$ = assignment($1, $3);
			}
	| TELLME '(' expr ')' '\n' {
			$$ = telling($3);
			}
	| logiceq '\n' '\t' neststmt ELSE '\n' '\t' neststmt	{
				if($1 == 1){
					$$ = $4;
				} else {
					$$ = $8;	
				}
			}
	;

logiceq: expr LOGIC expr {
		$$ = computeLogicOperation($1,$2,$3);
		}
	;


expr:	VALUE 	{ 
		$$ = $1;
		}
	| ID		{ 
		$$ = getVarValue($1);
		}	
	| expr OP expr	{
		$$ = computeOperation($1,$2,$3);
		}
	| '(' expr ')'	{
		$$ = $2;
		}
	;


%%


int getVarValue(char * var){

	symb * current = head;

	while (current != NULL && (strcmp(current->var,var) != 0)) {
		current = current->next;
	}
	
	int result = current->val;

	return result;
}


void executeIf(int logicOp, act *val1, act *val2){
	
	if(logicOp == 0){
		pleaseDo(val1);	
	} else {
		pleaseDo(val2);
	}
}

void pleaseDo(act *anAction){

	if(strcmp(anAction->action, "telling") == 0){
		printf("\n\nPLEASEDO PRINT: %d\n\n", anAction->val2);
	} else if(strcmp(anAction->action, "assign") == 0){
		printf("\n\nPLEASE DO ASSIGNMENT\n\n");
		updateSymbolTable(anAction->val1,anAction->val2);
	}
}

act * telling(int val){
	
	act * theAction = NULL;
	theAction = malloc(sizeof(act));
	theAction->action = "telling";
	theAction->val2 = val;

	return theAction;
	
}

act * assignment(char * val1, int val2){

	act * theAction = malloc(sizeof(act));
	theAction->action = "assign";
	theAction->val1 = strdup(val1);
	theAction->val2 = val2;

	return theAction;

}
void updateSymbolTable(char * var, int val) {

	symb * current = head;
	// Check if variable already exists 
	while (current->next != NULL && (strcmp(current->var,var) != 0)) {
		current = current->next;
	}
	//If var already exists update the value	
	if(strcmp(current->var,var) == 0){
		current->val = val;	
	} else {
	// If var does not exist add a new value
		current->next = malloc(sizeof(symb));
		current->next->var = var;
		current->next->val = val;
		current->next->next = NULL;
	}
}


int computeOperation(int val1, char *op, int val2){
	 	
	int result;

	if(strcmp(op, "sum") == 0){
		result = (val1 + val2);
	} else if(strcmp(op, "sub") == 0){
		result = (val1 - val2);
	} else if(strcmp(op, "div") == 0){
		result = (val1 / val2);
	} else if(strcmp(op, "prod") == 0){
		result = (val1 * val2);
	} else {
		result = 99;
	}
	return result;
}

int computeLogicOperation(int val1, char *logic, int val2){
	 
	int result = 0;

	if(strcmp(logic, "eq") == 0){
		if(val1 == val2){
			result = 1;
		}		
	}else if(strcmp(logic, "lt") == 0){
		if(val1 < val2){
			result = 1;
		}		
	}else if(strcmp(logic, "gt") == 0){
		if(val1 > val2){
			result = 1;
		}
	}		
	return result;
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

