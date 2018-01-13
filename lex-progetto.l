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
VAL	 [ ]?{VAR}
%%

[ ]		{ /* skip blanks */ }

"tellMe" {return print;}
"exit"	 {return exit_command;}

{VAR}	{char* input = yytext; yylval.var = input;printf("\n\nVAR: %s\n\n", input); 
			return VAR;}

{VAL}	{char* input = yytext; yylval.val = input;printf("\n\nVAL: %s\n\n", input); 
			return VAL;}


"("	{return '(';}
")"	{return ')';}
"->"	{return '=';}
"+"     {return '+';}
"-"     {return '-';}
"*"     {return '*';}
"/"     {return '/';}
\n      {return ';';}
[ \t\n]	;


%%
