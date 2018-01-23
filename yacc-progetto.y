%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void yyerror (char *s);

//Symbol table structure
typedef struct symbol_table {

    char * var;
    int val;
    char * str;
    struct symbol_table * next;
} symb;

//Action structure
typedef struct actions {

    char * action;
    char * val1;
    int val2;
    char *strVal;
} act;

//Data structure
typedef struct expressions {

	char * dataType;
	int intVal;
	char * strVal;	

} data;


symb * head = NULL;

data * getVarValue(char* var);
void updateSymbolTable(char * var, int val, char * str);
data * computeOperation(data *val1, char *op, data *val2);
int computeLogicOperation(data *val1, char *op, data *val2);
void pleaseDo(act *action);
void executeIf(int logicOp, act *val1, act *val2);
act * telling(data *val);
act * assignment(char * val1, data *val2);
data * createExpression(char * dataType, int intVal, char * strVal);
char * extractString(char *originalString);

%}

%union {
	int value;
	char *lexeme;
	char *op;
	act *opaction;
	symb *symbol;
	data *expression;
}

%token <lexeme> ID
%token <value> VALUE
%token OP
%token ASSIGN
%token LOGIC
%token TELLME
%token ELSE
%token STRING

%type <op> OP LOGIC STRING 
%type <value> logiceq
%type <opaction> neststmt
%type <expression> expr

//Solve conflict between doing OP or reducing EXPR to VALUE
%left VALUE
%left OP

%start program

%%
program: program stmt {}
		|	{}
		;
	
stmt: 	neststmt	{
			pleaseDo($1);
		}
		| logiceq '\n' '\t' neststmt ELSE '\n' '\t' neststmt {
			executeIf($1,$4,$8);
			}
		;

neststmt:ID ASSIGN expr	'\n' { 
			$$ = assignment($1, $3);
		}
		| TELLME '(' expr ')' '\n' {
			$$ = telling($3);
			}
		| logiceq '\n' '\t' neststmt '\t' ELSE '\n' '\t' neststmt {
			if($1 == 1){
				$$ = $4;
			} else {
				$$ = $9;		
			}
		}
	;

logiceq: expr LOGIC expr {
			if(strcmp($1->dataType, "INTEGER") == 0 && strcmp($3->dataType, "INTEGER") == 0){
				$$ = computeLogicOperation($1,$2,$3);
			} else {
				//Output error, logic operation allowed only between integers
				yyerror ("Type error: logical operation allowed only using format: INTEGER logicOperator INTEGER");
				exit(0);
			}
		}
		;

expr:	VALUE 	{ 
			$$ = createExpression("INTEGER", $1, NULL);
			}
		| ID	{ 
			$$ = getVarValue($1);
			}
		| STRING	{
			$$ = createExpression("STRING", 0, extractString($1));
			}
		| expr OP expr	{
			$$ = computeOperation($1,$2,$3);
			}
		| '(' expr ')'	{
			$$ = $2;
			}
		;
		
%%

//Get the value and dataType of a variable
data * getVarValue(char * var){

	symb * current = head;
	data * result = NULL;
	result = malloc(sizeof(data));
	
	while (current != NULL && (strcmp(current->var,var) != 0)) {
		current = current->next;
	}
	if(current->str == NULL){
		result->dataType = "INTEGER";
		result->intVal = current->val;
	} else {
		result->dataType = "STRING";
		result->strVal = strdup(current->str);
	}
	
	return result;
}

//Create data and assign type
data * createExpression(char * dataType, int intVal, char * strVal){

	data * theExpression = NULL;
	theExpression = malloc(sizeof(data));
	theExpression->dataType = strdup(dataType);
	if(strcmp(dataType, "INTEGER") == 0){
		theExpression->intVal = intVal;
	} else if(strcmp(dataType, "STRING") == 0){
		theExpression->strVal = strdup(strVal);
	}

	return theExpression;
}

//Select action to execute after logical operation
void executeIf(int logicOp, act *val1, act *val2){
	
	if(logicOp == 1){
		pleaseDo(val1);	
	} else {
		pleaseDo(val2);
	}
}

//Execute action
void pleaseDo(act *anAction){

	if(strcmp(anAction->action, "telling") == 0){
		printf("%d\n", anAction->val2);
	} else if(strcmp(anAction->action, "assign") == 0){
		updateSymbolTable(anAction->val1, anAction->val2, NULL);
	} else if(strcmp(anAction->action, "assignStr") == 0){
		updateSymbolTable(anAction->val1, 0, anAction->strVal);
	} else if(strcmp(anAction->action, "tellingStr") == 0){
		printf("%s\n", anAction->strVal);
	}
}

//Create print action
act * telling(data *val){
	 	
	act * theAction = NULL;
	theAction = malloc(sizeof(act));
	
	if(strcmp(val->dataType, "INTEGER") == 0 ){
		theAction->action = "telling";
		theAction->val2 = val->intVal;
	} else if(strcmp(val->dataType, "STRING") == 0 ){
		theAction->action = "tellingStr";
		theAction->strVal = val->strVal;	
	}
	
	return theAction;	
}

//Create assignment action
act * assignment(char * val1, data *val2){

	act * theAction = malloc(sizeof(act));
	
	if(strcmp(val2->dataType, "INTEGER") == 0){
	
		theAction->action = "assign";
		theAction->val1 = strdup(val1);
		theAction->val2 = val2->intVal;
		theAction->strVal = NULL;

	} else if(strcmp(val2->dataType, "STRING") == 0){
	
		theAction->action = "assignStr";
		theAction->val1 = strdup(val1);
		theAction->strVal = strdup(val2->strVal);
	
	}

	return theAction;
}

//Extract actual string from token STRING
char * extractString(char *originalString){

	char *newStr = strdup(originalString); 
	newStr++;
	newStr[strlen(newStr)-1] = 0;
	
	return newStr;
}

//Update symbol table or insert new symbol
void updateSymbolTable(char * var, int val, char * str) {

	//If we are inserting an integer
	if(str == NULL){
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
	//If we are inserting a string
	} else {
		symb * current = head;
		// Check if variable already exists 
		while (current->next != NULL && (strcmp(current->var,var) != 0)) {
			current = current->next;
		}
		//If var already exists update the value	
		if(strcmp(current->var,var) == 0){
			current->str = strdup(str);	
		} else {
		// If var does not exist add a new value
			current->next = malloc(sizeof(symb));
			current->next->var = var;
			current->next->str = strdup(str);
			current->next->next = NULL;
		}
	}
}

//Compute operation between integers or strings
data * computeOperation(data *val1, char *op, data *val2){
	
	data * result = NULL;
	result = malloc(sizeof(data));
	 	
	if(strcmp(val1->dataType, "INTEGER") == 0 && strcmp(val2->dataType, "INTEGER") == 0){
	 	
		result->dataType = "INTEGER";
		
		if(strcmp(op, "sum") == 0){
			result->intVal = (val1->intVal + val2->intVal);
		} else if(strcmp(op, "sub") == 0){
			result->intVal = (val1->intVal - val2->intVal);
		} else if(strcmp(op, "div") == 0){
			result->intVal = (val1->intVal / val2->intVal);
		} else if(strcmp(op, "prod") == 0){
			result->intVal = (val1->intVal * val2->intVal);
		} else {
			//wrong operation between integers
			yyerror ("Type error: only operation allowed between integer: INTEGET sum|sub|prod|div INTEGER");
			exit(0);
		}
	} else if(strcmp(val1->dataType, "STRING") == 0 && strcmp(val2->dataType, "STRING") == 0){

		result->dataType = "STRING";

		if(strcmp(op, "concat") == 0){
				result->strVal = strcat(val1->strVal, val2->strVal);
		} else {
			//wrong operation between Strings
			yyerror ("Type error: only operation allowed between string: STRING concat STRING");
			exit(0);
		}
	} else {	
		//operations between integers and strings
		yyerror ("Type error: operations between INTEGERS and STRINGS are not allowed");
		exit(0);
	}
	
	return result;
}

//Compute logical operation and return 0 if false, 1 if true
int computeLogicOperation(data *val1, char *logic, data *val2){
	 
	int result = 0;
	 	
	if(strcmp(val1->dataType, "INTEGER") == 0 && strcmp(val2->dataType, "INTEGER") == 0){
	
		if(strcmp(logic, "eq") == 0){
			if(val1->intVal == val2->intVal){
				result = 1;
			}		
		}else if(strcmp(logic, "lt") == 0){
			if(val1->intVal < val2->intVal){
				result = 1;
			}		
		}else if(strcmp(logic, "gt") == 0){
			if(val1->intVal > val2->intVal){
				result = 1;
			}
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
	head->str = "str";
	head->next = NULL;

	return yyparse ( );
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 

#include "lex.yy.c"
	
