%option noyywrap
%{
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
%}

DIGIT    [0-9]
NUM      {DIGIT}+(\.{DIGIT}+)?
VAR		 {NUM}+[xX]

%%

[ ]		{ /* skip blanks */ }

{NUM}    {yylval.value = atof(yytext);
        	return NUM;}

{VAR}	{char* ooo = yytext; printf(ooo);
yylval.var = atof(ooo);
			return VAR;}

"+"     {return '+';}
"-"     {return '-';}
"*"     {return '*';}
"/"     {return '/';}
\n      {return '\n';}

%%
