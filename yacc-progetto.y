%{
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
%}


%union {
       double value;//value of an identifier of type NUM
       double var;//value of angular coefficient
       }

%token <value>  NUM
%token <var> VAR

%type <value> expr
%type <var> vari
/* %type <value> line */


%left '-' '+'
%left '*' '/'


%start line

%%

line  : expr '\n'      {printf("Result: %f\n", $1); exit(0);}     
      | vari '\n'      {printf("Result: %f\n", $1); exit(0);}   
      ;
expr  : expr '+' expr  {$$ = $1 + $3;}
      | expr '-' expr  {$$ = $1 - $3;}
      | expr '*' expr  {$$ = $1 * $3;}
      | expr '/' expr  {$$ = $1 / $3;}
      | NUM            {$$ = $1;}
/*      | vari '+' expr {$$ = $1;$$ = $3;}
      | VAR '+' NUM {printf("Coefficient: %f AND num: %f\n", $1,$3); exit(0);}*/
      ;

vari  : vari '+' vari  {$$ = $1 + $3;}
      | vari '-' vari  {$$ = $1 - $3;}
      | vari '*' vari  {$$ = $1 * $3;}
      | vari '/' vari  {$$ = $1 / $3;}
      | VAR            {$$ = $1;}
      ;
/*
term  : term '+' term  {$$ = $1 + $3;}
      | term '-' term  {$$ = $1 - $3;}
      | term '*' term  {$$ = $1 * $3;}
      | term '/' term  {$$ = $1 / $3;}
      | NUM            {$$ = $1;}
      ;
      ;
expr  : expr '+' expr  {$$ = $1 + $3;}
      | expr '-' expr  {$$ = $1 - $3;}
      | expr '*' expr  {$$ = $1 * $3;}
      | expr '/' expr  {$$ = $1 / $3;}
      | NUM            {$$ = $1;}
	  | vari '+' vari  {$$ = $1 + $3;}
      | vari '-' vari  {$$ = $1 - $3;}
      | vari '*' vari  {$$ = $1 * $3;}
      | vari '/' vari  {$$ = $1 / $3;}
      | VAR            {$$ = $1;}
      | vari '+' expr  {$$ = $1; $$ = $3;}
      | vari '-' expr  {$$ = $1; $$ = $3;}
      | vari '*' expr  {$$ = $1; $$ = $3;}
      | vari '/' expr  {$$ = $1; $$ = $3;}
      | expr '+' vari  {$$ = $1; $$ = $3;}
      | expr '-' vari  {$$ = $1; $$ = $3;}
      | expr '*' vari  {$$ = $1; $$ = $3;}
      | expr '/' vari  {$$ = $1; $$ = $3;}
      ;
vari  : vari '+' vari  {$$ = $1 + $3;}
      | vari '-' vari  {$$ = $1 - $3;}
      | vari '*' vari  {$$ = $1 * $3;}
      | vari '/' vari  {$$ = $1 / $3;}
      | NUM            {$$ = $1;}
      ;
*/
%%

#include "lex.yy.c"
