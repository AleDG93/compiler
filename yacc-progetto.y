%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
%}


%union {
	char* var; //Name of the variable
	char* val; //Value of the variable
       }

%token <var> VAR
%token <val> VAL
%token print

/* %type <value> line */


%start line

%%


line  : VAR '=' VAL {printf("Assign: %s to %s", $1,$3);}
      | print '(' VAR ')' {printf("Printing: %s", $3);}
      ;
      

%%

#include "lex.yy.c"
