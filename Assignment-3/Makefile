output.txt: a.out ass3_20CS10073_20CS10079_test.c
	touch output.txt
	./a.out < ass3_20CS10073_20CS10079_test.c > output.txt

a.out: head.h lex.yy.c ass3_20CS10073_20CS10079.c
	gcc lex.yy.c ass3_20CS10073_20CS10079.c

lex.yy.c: head.h ass3_20CS10073_20CS10079.l
	flex ass3_20CS10073_20CS10079.l 

clean:
	rm a.out lex.yy.c output.txt 

correct:
	cat correct.txt > ass3_20CS10073_20CS10079.c