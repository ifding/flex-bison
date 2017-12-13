%{
// Flex handles ambiguity by matching longest string;
// in case of tie, it matches the first one.
// Why does "xx ab c xx" get 4 matches but xxabcxx gets one?
// Why does c at eol take precendence  over first rule?

#include <iostream>

  int words = 0;
%}
%array
letter      [a-zA-Z]

%%
(?i:c)        { std::cout << "upper or lower case c" << std::endl; }
(?-i:d)       { std::cout << "only lower case d" << std::endl; }
(?-i:E)       { std::cout << "only upper case E" << std::endl; }
c             { std::cout << "never gets here!" << std::endl;  }
ab            { std::cout << "Matching ab" << std::endl;       }
%{ Question: %}
(?# why does flex choose the next rule over first 3? when?)
^0            { std::cout << "match 0 at eol" << std::endl;    }
{letter}$     { std::cout << "match  1 letter at eol" << std::endl; }
{letter}*     { std::cout << "bunches of letters" << std::endl;}
(?#: this is a commment)
.             { }
%%
int yywrap() { return 1; }

