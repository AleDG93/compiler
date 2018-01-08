flex -l lex-progetto.l
yacc -vd yacc-progetto.y
gcc y.tab.c -ly -ll


./a.out
