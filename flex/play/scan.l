%{
// Flex handles ambiguity by matching longest string;
// in case of tie, it matches the first one.

#include <iostream>
#include <string>
  int words = 0;
  void f(const std::string&);
%}
abc      [abc]
letter   [a-z]

%%
{abc}               { f("Matched a|b|c"); }
(?x:{letter}*)      { /*f("Matched letter"); */ }
.                   { std::cout << "caps" << std::endl; }
%%
int yywrap() { 
return 1; 
}

void f(const std::string& msg) {
  std::cout << msg << std::endl;
}
