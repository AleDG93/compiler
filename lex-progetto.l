%option noyywrap
%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>


%}

WORD	 [a-zA-Z]+
DIGIT    [0-9]
NUM      {DIGIT}+(\.{DIGIT}+)?
VAR	 {WORD}[{WORD}|{NUM}]*
VAL	 ->[ ]?{VAR}
%%

[ ]		{ /* skip blanks */ }

"tellMe" {return print;}

{VAR}	{char* input = yytext; printf("\n\nVAR: %s\n\n", input); yylval.var = input;
			return VAR;}
{VAL}	{char* input = yytext; printf("\n\nVAL: %s\n\n", input); yylval.var = input;
			return VAL;}

"->"	{return '=';}
"+"     {return '+';}
"-"     {return '-';}
"*"     {return '*';}
"/"     {return '/';}
\n      {return ';';}


%%
