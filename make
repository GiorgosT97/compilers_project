bison -y -d bison_test.y 
flex flex_test.l
gcc -c y.tab.c lex.yy.c
gcc y.tab.o lex.yy.o -o parser

