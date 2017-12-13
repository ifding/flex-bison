CCC = g++
LEX = flex
YACC = bison
CFLAGS = -Wall
LEXFLAGS = -Wno-unused -Wno-sign-compare

OBJS = main.o parse.tab.o lex.yy.o ast.o symbolTable.o

run: $(OBJS)
	$(CCC) $(CFLAGS) -o run $(OBJS)

main.o: main.cpp
	$(CCC) $(CFLAGS) -c main.cpp

parse.tab.c: includes/parse.y
	$(YACC) -d includes/parse.y

parse.tab.o: parse.tab.c
	$(CCC) $(CFLAGS) -c parse.tab.c

lex.yy.c: includes/scan.l parse.tab.o
	$(LEX) includes/scan.l

lex.yy.o: lex.yy.c
	$(CCC) $(CFLAGS) $(LEXFLAGS) -c lex.yy.c

ast.o: includes/ast.cpp includes/ast.h
	$(CCC) $(CFLAGS) -c includes/ast.cpp

symbolTable.o: includes/symbolTable.cpp includes/symbolTable.h
	$(CCC) $(CFLAGS) -c includes/symbolTable.cpp
	
clean:
	rm -f run *.o parse.tab.c lex.yy.c
	rm -f parse.tab.h
