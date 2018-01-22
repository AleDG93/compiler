%option noyywrap
%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

#include "y.tab.h"

%}

LETTER	 [a-zA-Z]
OP	 sum|sub|prod|div
WORD	 {LETTER}+
DIGIT    [0-9]
NUM      {DIGIT}+(\.{DIGIT}+)?
ID	 {LETTER}({WORD}|{NUM})*
NEW_L    (\r\n|\n)
LOGIC	 eq|lt|gt
STRING   '({WORD}|{NUM}|{LETTER}|[ ])*'
TABS	 [\t]+
%%

[ ]	 {}

{NEW_L}	{
	return '\n';
}

{TABS}	{
	return '\t';
}

"else"	{
	return ELSE;
}

"tellMe" {
	return TELLME;
}

{LOGIC}	{
	yylval.op = strdup(yytext);
	return LOGIC;
}

{OP} 	{
	yylval.op = strdup(yytext);
	return OP;
}

{NUM} 	{
	yylval.value = atoi(yytext);
        return VALUE;
}

{ID} 	{
	printf("Lexer found id \n");
	yylval.lexeme = strdup(yytext);
	return ID;
}

{STRING} {
	yylval.lexeme = strdup(yytext);
	printf("Lexer found a string\n%s \n", strdup(yytext));
	return STRING;
}
"<-"	{
	printf("Lexer found assignment \n");
	return ASSIGN;
}

"(" 	{
	return '(';
}

")" 	{
	return ')';
}

"'"	{
	return '\'';
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

