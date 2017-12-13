#include <iostream>
#include <vector>

class Token {
public:
  Token()              { std::cout << "default" << std::endl;    }
  Token(const char*)   { std::cout << "convert" << std::endl;    }
  Token(const Token&){ std::cout << "copy" << std::endl;       }
  Token& operator=(const Token&) { 
    std::cout << "assign" << std::endl; 
    return *this;
  }
};

int main() {
  std::vector<Token> tokens;
  tokens.emplace_back( "IDENT" );
  tokens.emplace_back( "FLOAT" );
}
