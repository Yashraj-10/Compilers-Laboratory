
tinyC: lex.yy.o ass6_20CS10073_20CS10079.tab.o ass6_20CS10073_20CS10079_translator.o ass6_20CS10073_20CS10079_target_translator.o
	g++ lex.yy.o ass6_20CS10073_20CS10079.tab.o ass6_20CS10073_20CS10079_translator.o ass6_20CS10073_20CS10079_target_translator.o -lfl -o tinyC
	@echo "\nMake process successful. The binary generated is tinyC\n"

ass6_20CS10073_20CS10079_target_translator.o: ass6_20CS10073_20CS10079_target_translator.cxx
	g++ -c ass6_20CS10073_20CS10079_target_translator.cxx

ass6_20CS10073_20CS10079_translator.o: ass6_20CS10073_20CS10079_translator.h ass6_20CS10073_20CS10079_translator.cxx
	g++ -c ass6_20CS10073_20CS10079_translator.h
	g++ -c ass6_20CS10073_20CS10079_translator.cxx

lex.yy.o: lex.yy.c
	g++ -c lex.yy.c

ass6_20CS10073_20CS10079.tab.o: ass6_20CS10073_20CS10079.tab.c
	g++ -c ass6_20CS10073_20CS10079.tab.c

lex.yy.c: ass6_20CS10073_20CS10079.l ass6_20CS10073_20CS10079.tab.h ass6_20CS10073_20CS10079_translator.h
	flex ass6_20CS10073_20CS10079.l

ass6_20CS10073_20CS10079.tab.c: ass6_20CS10073_20CS10079.y
	bison -dtv ass6_20CS10073_20CS10079.y

ass6_20CS10073_20CS10079.tab.h: ass6_20CS10073_20CS10079.y
	bison -dtv ass6_20CS10073_20CS10079.y

libass6_20CS10073_20CS10079.a: ass6_20CS10073_20CS10079.o
	ar -rcs libass6_20CS10073_20CS10079.a ass6_20CS10073_20CS10079.o

ass6_20CS10073_20CS10079.o: ass6_20CS10073_20CS10079.c myl.h
	gcc -c ass6_20CS10073_20CS10079.c

ass6_20CS10073_20CS10079.c:
	touch ass6_20CS10073_20CS10079.c

runtest: tinyC libass6_20CS10073_20CS10079.a
	@mkdir -p test-outputs

	@echo "\nRunning....\n"
	./tinyC 1 < test-inputs/ass6_20CS10073_20CS10079_test1.c > test-outputs/ass6_20CS10073_20CS10079_quads1.out
	mv ass6_20CS10073_20CS100791.s test-outputs/ass6_20CS10073_20CS10079_1.s

	@echo "\nRunning....\n"
	./tinyC 2 < test-inputs/ass6_20CS10073_20CS10079_test2.c > test-outputs/ass6_20CS10073_20CS10079_quads2.out
	mv ass6_20CS10073_20CS100792.s test-outputs/ass6_20CS10073_20CS10079_2.s

	@echo "\nRunning....\n"
	./tinyC 3 < test-inputs/ass6_20CS10073_20CS10079_test3.c > test-outputs/ass6_20CS10073_20CS10079_quads3.out
	mv ass6_20CS10073_20CS100793.s test-outputs/ass6_20CS10073_20CS10079_3.s

	@echo "\nRunning....\n"
	./tinyC 4 < test-inputs/ass6_20CS10073_20CS10079_test4.c > test-outputs/ass6_20CS10073_20CS10079_quads4.out
	mv ass6_20CS10073_20CS100794.s test-outputs/ass6_20CS10073_20CS10079_4.s

	@echo "\nRunning....\n"
	./tinyC 5 < test-inputs/ass6_20CS10073_20CS10079_test5.c > test-outputs/ass6_20CS10073_20CS10079_quads5.out
	mv ass6_20CS10073_20CS100795.s test-outputs/ass6_20CS10073_20CS10079_5.s

	@echo "\nRunning....\n"
	./tinyC 6 < test-inputs/ass6_20CS10073_20CS10079_test6.c > test-outputs/ass6_20CS10073_20CS10079_quads6.out
	mv ass6_20CS10073_20CS100796.s test-outputs/ass6_20CS10073_20CS10079_6.s


runtest1: tinyC libass6_20CS10073_20CS10079.a
	@mkdir -p test-outputs

	@echo "\nRunning....\n"
	./tinyC 1 < test-inputs/ass6_20CS10073_20CS10079_test1.c > test-outputs/ass6_20CS10073_20CS10079_quads1.out
	mv ass6_20CS10073_20CS100791.s test-outputs/ass6_20CS10073_20CS10079_1.s

runtest2: tinyC libass6_20CS10073_20CS10079.a
	@mkdir -p test-outputs

	@echo "\nRunning....\n"
	./tinyC 2 < test-inputs/ass6_20CS10073_20CS10079_test2.c > test-outputs/ass6_20CS10073_20CS10079_quads2.out
	mv ass6_20CS10073_20CS100792.s test-outputs/ass6_20CS10073_20CS10079_2.s

runtest3: tinyC libass6_20CS10073_20CS10079.a
	@mkdir -p test-outputs
	
	@echo "\nRunning....\n"
	./tinyC 3 < test-inputs/ass6_20CS10073_20CS10079_test3.c > test-outputs/ass6_20CS10073_20CS10079_quads3.out
	mv ass6_20CS10073_20CS100793.s test-outputs/ass6_20CS10073_20CS10079_3.s

runtest4: tinyC libass6_20CS10073_20CS10079.a
	@mkdir -p test-outputs
	
	@echo "\nRunning....\n"
	./tinyC 4 < test-inputs/ass6_20CS10073_20CS10079_test4.c > test-outputs/ass6_20CS10073_20CS10079_quads4.out
	mv ass6_20CS10073_20CS100794.s test-outputs/ass6_20CS10073_20CS10079_4.s

runtest5: tinyC libass6_20CS10073_20CS10079.a
	@mkdir -p test-outputs
	
	@echo "\nRunning....\n"
	./tinyC 5 < test-inputs/ass6_20CS10073_20CS10079_test5.c > test-outputs/ass6_20CS10073_20CS10079_quads5.out
	mv ass6_20CS10073_20CS100795.s test-outputs/ass6_20CS10073_20CS10079_5.s

runtest6: tinyC libass6_20CS10073_20CS10079.a
	@mkdir -p test-outputs
	
	@echo "\nRunning....\n"
	./tinyC 6 < test-inputs/ass6_20CS10073_20CS10079_test6.c > test-outputs/ass6_20CS10073_20CS10079_quads6.out
	mv ass6_20CS10073_20CS100796.s test-outputs/ass6_20CS10073_20CS10079_6.s

clean:
	rm -f lex.yy.c *.tab.c *.tab.h *.output *.o *.s *.a *.out *.gch tinyC test-outputs/* bin/*
