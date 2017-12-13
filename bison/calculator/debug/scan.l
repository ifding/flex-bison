%{
#include "parse.tab.h"
%}

%%

"+"       { return PLUS; }
"-"       { return MINUS; }
"*"       { return MULT; }
"/"       { return DIV; }
[0-9]+    { yylval = atoi(yytext);
            return NUMBER; 
          }
"\n"      { return CR; }

%%
int yywrap() { 
  yylex_destroy();
  return 1; 
}
