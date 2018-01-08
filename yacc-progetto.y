%{
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
%}


%union {
       double value;//value of an identifier of type NUM
       char* var;//value of angular coefficient
       }

%token <value>  NUM
%token <var> VAR

%type <value> expr
/* %type <value> line */


%left '-' '+'
%left '*' '/'


%start line

%%
line  : expr '\n'      {printf("Result: %f\n", $1); exit(0);}     
      ;
expr  : expr '+' expr  {$$ = $1 + $3;}
      | expr '-' expr  {$$ = $1 - $3;}
      | expr '*' expr  {$$ = $1 * $3;}
      | expr '/' expr  {$$ = $1 / $3;}
      | NUM            {$$ = $1;}
      | VAR '+' expr {printf("Coefficient: %s AND num: %f\n", $1,$3); exit(0);}
      ;

%%

#include "lex.yy.c"
