
#--------------------------------------------------------------------------------------------------------------------------------------------------------
# GROUP : YASHRAJ SINGH 				(20CS10079)
#		  VIKAS VIJAYKUMAR BASTEWAD		(20CS10073)
# 
# COMPILERS LABORATORY ASSIGNMENT 5
#
#--------------------------------------------------------------------------------------------------------------------------------------------------------
# COMMANDS TO RUN THE FILES : make
#
# COMMANDS TO CLEAN THE GENERATED FILE : make clean			 			
#--------------------------------------------------------------------------------------------------------------------------------------------------------


all: a.out
	
	./a.out < testFiles/ass5_20CS10079_20CS10073_test1.c > outputFiles/ass5_20CS10079_20CS10073_quads1.out
	@echo "Test File 1 Successfully Translated !\n"
	./a.out < testFiles/ass5_20CS10079_20CS10073_test2.c > outputFiles/ass5_20CS10079_20CS10073_quads2.out
	@echo "Test File 2 Successfully Translated !\n"
	./a.out < testFiles/ass5_20CS10079_20CS10073_test3.c > outputFiles/ass5_20CS10079_20CS10073_quads3.out
	@echo "Test File 3 Successfully Translated !\n"
	./a.out < testFiles/ass5_20CS10079_20CS10073_test4.c > outputFiles/ass5_20CS10079_20CS10073_quads4.out
	@echo "Test File 4 Successfully Translated !\n"
	./a.out < testFiles/ass5_20CS10079_20CS10073_test5.c > outputFiles/ass5_20CS10079_20CS10073_quads5.out
	@echo "Test File 5 Successfully Translated !\n"
	./a.out < testFiles/ass5_20CS10079_20CS10073_test6.c > outputFiles/ass5_20CS10079_20CS10073_quads6.out
	@echo "Test File 6 Successfully Translated !\n"

	@echo "\nALL TEST FILES SUCCESSFULLY TRANSLATED !!\n"

a.out: lex.yy.o y.tab.o ass5_20CS10079_20CS10073_translator.o
	g++ -std=c++11 lex.yy.o y.tab.o ass5_20CS10079_20CS10073_translator.o -lfl

ass5_20CS10079_20CS10073_translator.o: ass5_20CS10079_20CS10073_translator.cxx ass5_20CS10079_20CS10073_translator.h
	g++ -std=c++11 -c ass5_20CS10079_20CS10073_translator.h
	g++ -std=c++11 -c ass5_20CS10079_20CS10073_translator.cxx

lex.yy.o: lex.yy.c
	g++ -std=c++11 -c lex.yy.c

y.tab.o: y.tab.c
	g++ -std=c++11 -c y.tab.c

lex.yy.c: ass5_20CS10079_20CS10073.l y.tab.h ass5_20CS10079_20CS10073_translator.h
	flex ass5_20CS10079_20CS10073.l

y.tab.c: ass5_20CS10079_20CS10073.y
	yacc -dtv ass5_20CS10079_20CS10073.y -W

y.tab.h: ass5_20CS10079_20CS10073.y
	yacc -dtv ass5_20CS10079_20CS10073.y -W

clean:
	rm lex.yy.c y.tab.c y.tab.h lex.yy.o y.tab.o ass5_20CS10079_20CS10073_translator.o y.output a.out ass5_20CS10079_20CS10073_translator.h.gch
