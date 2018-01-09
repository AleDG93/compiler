%{
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
%}


%union {
       double value;//value of an identifier of type NUM
       double var;//value of angular coefficient
       double line;
       }

%token <value>  NUM
%token <var> VAR


%type <value> expr
%type <var> vari
%type <line> line
/* %type <value> line */


%left '-' '+'
%left '*' '/'


%start line

%%


line  : vari '+' expr  {printf("Result: %f and %f\n", $1, $3);}
      | vari '-' expr  {printf("Result: %f and %f\n", $1, $3);}
      | vari '*' expr  {printf("Result: %f and %f\n", $1, $3);}
      | vari '/' expr  {printf("Result: %f and %f\n", $1, $3);}
      | expr '+' vari  {printf("Result: %f and %f\n", $1, $3);}
      | expr '-' vari  {printf("Result: %f and %f\n", $1, $3);}
      | expr '*' vari  {printf("Result: %f and %f\n", $1, $3);}
      | expr '/' vari  {printf("Result: %f and %f\n", $1, $3);}
	  | expr '\n'      {printf("Result: %f\n", $1); exit(0);}     
      | vari '\n'      {printf("Result: %f\n", $1); exit(0);}   
      ;
      
expr  : expr '+' expr  {$$ = $1 + $3;}
      | expr '-' expr  {$$ = $1 - $3;}
      | expr '*' expr  {$$ = $1 * $3;}
      | expr '/' expr  {$$ = $1 / $3;}
      | NUM            {$$ = $1;}
      ;

vari  : vari '+' vari  {$$ = $1 + $3;}
      | vari '-' vari  {$$ = $1 - $3;}
      | vari '*' vari  {$$ = $1 * $3;}
      | vari '/' vari  {$$ = $1 / $3;}
      | VAR            {$$ = $1;}
      ;

%%

#include "lex.yy.c"
