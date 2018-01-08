flex -l lex-progetto.l
yacc -vd yacc-progetto.y
gcc y.tab.c -ly -ll


*To read from an input file (called e.g. in-file.txt) run the command
./a.out
