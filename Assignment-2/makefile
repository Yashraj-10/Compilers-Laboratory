ass2: main.o libass2_20CS10079.a
	cc main.o -L. -lass2_20CS10079 -o ass2

main.o: main.c myl.h
	cc -Wall -c main.c

libass2_20CS10079.a: ass2_20CS10079.o
	ar -rcs libass2_20CS10079.a ass2_20CS10079.o

ass2_20CS10079.o: ass2_20CS10079.c myl.h
	cc -Wall -c ass2_20CS10079.c

clean:
	rm ass2 main.o libass2_20CS10079.a ass2_20CS10079.o

run: ass2
	./ass2
