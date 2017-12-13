#include <iostream>
int yylex();

extern int words;
extern int lines;
extern int chars;

int main() {
  yylex();
  std::cout << "words: " << words << std::endl;
  return 0;
}
