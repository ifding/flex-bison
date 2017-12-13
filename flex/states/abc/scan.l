%{
#include <iostream>
%}

%x LETTERS

%%

^abc           { BEGIN(LETTERS); 
                 std::cout << "Beginning LETTERS" << std::endl;
               }
<LETTERS>"abc" { 
                std::cout << "Starting over: " << std::endl; 
                BEGIN(INITIAL);
              }
abc           { 
                std::cout << "Middle: " << yytext << std::endl;
              }
"\n"          { }
.             { }
%%
int yywrap() { return 1; }

