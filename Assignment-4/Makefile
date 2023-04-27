asgn4_20CS10079_20CS10073_output.txt: parser asgn4_20CS10079_20CS10073_test.c
	./parser <asgn4_20CS10079_20CS10073_test.c> asgn4_20CS10079_20CS10073_output.txt

parser: lex.yy.o y.tab.o asgn4_20CS10079_20CS10073.o
	gcc lex.yy.o y.tab.o asgn4_20CS10079_20CS10073.o -lfl -o parser

asgn4_20CS10079_20CS10073.o: asgn4_20CS10079_20CS10073.c
	gcc -c asgn4_20CS10079_20CS10073.c

lex.yy.o: lex.yy.c
	gcc -c lex.yy.c

y.tab.o: y.tab.c
	gcc -c y.tab.c

lex.yy.c: asgn4_20CS10079_20CS10073.l y.tab.h
	flex asgn4_20CS10079_20CS10073.l

y.tab.c y.tab.h: asgn4_20CS10079_20CS10073.y
	bison -dty --report=all asgn4_20CS10079_20CS10073.y

clean: 
	rm -f parser lex.yy.c y.tab.h y.output y.tab.c *.o asgn4_20CS10079_20CS10073_output.txt
