#include <iostream>
extern int yyparse();

int main() {
  extern int yydebug;
  yydebug = 1;
  if ( yyparse() == 0 ) {
    std::cout << "Syntactically correct." << std::endl;
  }
  else {
    std::cout << "Oops!" << std::endl;
  }
  return 0;
}
