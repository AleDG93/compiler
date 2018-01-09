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

{VAR}	{char* input = yytext; printf("%s\n", input); yylval.var = atof(input);
			return VAR;}

"+"     {return '+';}
"-"     {return '-';}
"*"     {return '*';}
"/"     {return '/';}
\n      {return '\n';}

%%
