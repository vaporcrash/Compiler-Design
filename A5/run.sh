yacc -d calc.y
lex calc.l
gcc lex.yy.c
