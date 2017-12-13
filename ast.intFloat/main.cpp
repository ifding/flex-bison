#include <iostream>
#include <string>
#include "includes/symbolTable.h"
#include "includes/poolOfNodes.h"

extern int yyparse();

int main() {
  try {
    if ( yyparse() == 0 ) {
      std::cout << "Program syntactically correct" << std::endl;
      PoolOfNodes::getInstance().drainThePool();
    }
  }
  catch ( const std::string& msg ) {
    std::cout << "oops: " << msg << std::endl;
  }
}
