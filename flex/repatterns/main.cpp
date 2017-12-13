#include <iostream>
int yylex();

extern int words;

int main() {
  yylex();
  std::cout << "words: " << words << std::endl;
  return 0;
}
