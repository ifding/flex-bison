%{
// Flex handles ambiguity by matching longest string;
// in case of tie, it matches the first one.

#include <iostream>
  int words = 0;
%}
letter      [a-zA-Z]

%%
ab            { std::cout << "Matching ab" << std::endl;       }
{letter}*     { std::cout << "Matching 'letter'" << std::endl; }
.             { }
%%
int yywrap() { return 1; }

