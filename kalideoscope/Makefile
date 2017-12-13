CFLAGS  = -g -g -O3 -std=c++11 -I/usr/include/llvm-3.8
LDFLAGS = -lm

run:	main.o
	clang++ ${CFLAGS} -o run main.o ${LDFLAGS}

main.o:	main.cpp
	g++ ${CFLAGS} -c main.cpp

clean:
	rm -rf *.o
	rm -rf *~
	rm -rf run a.out
