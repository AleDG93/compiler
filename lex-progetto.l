%option noyywrap
%{
#include <stdlib.h>
#include <string.h>
%}

DIGIT    [0-9]
NUM      {DIGIT}+(\.{DIGIT}+)?
VAR		 {NUM}+[xX]

%%

[ ]		{ /* skip blanks */ }

{NUM}    {yylval.value = atof(yytext);
        	return NUM;}

{VAR}	{yylval.var = strdup(yytext);
			return VAR;}

"+"     {return '+';}
"-"     {return '-';}
"*"     {return '*';}
"/"     {return '/';}
\n      {return '\n';}

%%
