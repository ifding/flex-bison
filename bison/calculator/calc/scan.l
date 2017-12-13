%{
#include "parse.tab.h"
%}

%%

"+"       { return PLUS; }
"-"       { return MINUS; }
"*"       { return MULT; }
"/"       { return DIV; }
[0-9]+    {
            return NUMBER; 
          }
"\n"      { return CR; }
<<EOF>>   { yyterminate(); }

%%
int yywrap() { 
  yylex_destroy();
  return 1; 
}
