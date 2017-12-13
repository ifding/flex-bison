CXX = clang++

# Warnings frequently signal eventual errors:
CXXFLAGS=-g -W -Wall -std=c++11 -Weffc++ -Wextra -pedantic -O0

OBJS = \
	main.o
EXEC = run

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(EXEC): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $@ $(OBJS) $(LDFLAGS)

main.o: main.cpp

clean:
	rm -rf $(OBJS)
	rm -rf $(EXEC)
