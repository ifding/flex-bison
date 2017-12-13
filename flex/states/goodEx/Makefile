CXX = g++
LEX = flex
CXXFLAGS = -Wall
LEXFLAGS = -Wno-unused

OBJS = main.o lex.yy.o

run: $(OBJS)
	$(CXX) $(CXXFLAGS) -o run $(OBJS)

main.o: main.cpp
	$(CXX) $(CXXFLAGS) -c main.cpp

lex.yy.c: scan.l
	$(LEX) scan.l

lex.yy.o: lex.yy.c
	$(CXX) $(CXXFLAGS) $(LEXFLAGS) -c lex.yy.c
	
clean:
	rm -f run *.o lex.yy.c
