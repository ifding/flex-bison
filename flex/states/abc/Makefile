CCC = g++
LEX = flex
CFLAGS = -Wall
LEXFLAGS = -Wno-unused

OBJS = main.o lex.yy.o

run: $(OBJS)
	$(CCC) $(CFLAGS) -o run $(OBJS)

main.o: main.cpp
	$(CCC) $(CFLAGS) -c main.cpp

lex.yy.c: scan.l
	$(LEX) scan.l

lex.yy.o: lex.yy.c
	$(CCC) $(CFLAGS) $(LEXFLAGS) -c lex.yy.c
	
clean:
	rm -f run *.o lex.yy.c
