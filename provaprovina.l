
%{

%}
%%
[ \t] ;
[0-9]+\.[0-9]+ { printf ("Found a floating-point number:\n"); }
[0-9]+  { printf("Found an integer:\n"); }
[a-zA-Z0-9]+ { printf ( "Found a string: \n" ) ; }
%%
main() {
	
	yylex();
}
