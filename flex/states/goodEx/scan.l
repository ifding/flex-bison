%{
// Flex handles ambiguity by matching longest string;
// in case of tie, it matches the first one.

#include <iostream>
  int words = 0;
%}
letter      [a-zA-Z]

%x          COMMENT

%%
"/*"          { BEGIN(COMMENT);                               }
<COMMENT>.    {}
<COMMENT>"\n" {}
<COMMENT>"*/" { BEGIN(INITIAL);                                }
ab            { std::cout << "Matching ab" << std::endl;       }
aabb          { std::cout << "Matching aabb" << std::endl;     }
a*b*          { std::cout << "Matching a*b*" << std::endl;     }
{letter}*     { std::cout << "Matching 'letter'" << std::endl; }
.             { }
\n            {}
%%
int yywrap() { return 1; }

