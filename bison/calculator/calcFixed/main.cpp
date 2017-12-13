#include <iostream>
extern int yyparse();

int main() {
  if ( yyparse() ) {
    std::cout << "syntactically correct" << std::endl;
  }
  return 0;
}
