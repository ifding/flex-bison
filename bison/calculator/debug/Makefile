CCC = g++
LEX = flex
YACC = bison
CFLAGS = -Wall
LEXFLAGS = -Wno-unused -Wno-sign-compare

LEXDEBUG = -d
# -v generates a file ending in .output
# -t, together with defining YYDEBUG, makes bison write messages
YACCDEBUG = -vtd

OBJS = main.o parse.tab.o lex.yy.o

run: $(OBJS)
	$(CCC) $(CFLAGS) -o run $(OBJS)

main.o: main.cpp parse.y scan.l parse.tab.c lex.yy.c
	$(CCC) $(CFLAGS) -c main.cpp

parse.tab.c: parse.y
	$(YACC) $(YACCDEBUG) parse.y

parse.tab.o: parse.tab.c
	$(CCC) $(CFLAGS) -c parse.tab.c

lex.yy.c: scan.l parse.tab.o
	$(LEX) $(LEXDEBUG) scan.l

lex.yy.o: lex.yy.c
	$(CCC) $(CFLAGS) $(LEXFLAGS) -c lex.yy.c
	
clean:
	rm -f run *.o parse.tab.c lex.yy.c
	rm -f parse.tab.h parse.output
