#include <iostream>
extern int yyparse();

int main() {
  if ( yyparse() == 0 ) {
    std::cout << "Done." << std::endl;
  }
  else {
    std::cout << "Oops!" << std::endl;
  }
  return 0;
}
