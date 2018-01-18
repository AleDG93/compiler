%option noyywrap
%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

#include "y.tab.h"

%}

LETTER	 [a-zA-Z]
WORD	 {LETTER}+
DIGIT    [0-9]
NUM      {DIGIT}+(\.{DIGIT}+)?
ID	 {LETTER}({WORD}|{NUM})*
NEW_L    (\r\n|\n)

%%

{NUM} {
	yylval.value = atoi(yytext);
        return VALUE;
}

{ID} {
	yylval.lexeme = strdup(yytext);
	return ID;
}

"<-"	{
	return ASSIGN;
}



%%

/*
[ ]		{  skip blanks  }

"tellMe" {return print;}
"exit"	 {return exit_command;}

{VAR}	{char* input = yytext; yylval.var = input;printf("\n\nVAR: %s\n\n", input); 
			return VAR;}

{VAL}	{char* input = yytext; yylval.val = input;printf("\n\nVAL: %s\n\n", input); 
			return VAL;}


"("		{return '(';}
")"		{return ')';}
"->"	{return '=';}
"+"     {return '+';}
"-"     {return '-';}
"*"     {return '*';}
"/"     {return '/';}
\n      {return ';';}
[ \t\n]	;
*/

