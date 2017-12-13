%{
#include "includes/ast.h"
#include "parse.tab.h"
%}
letter      [a-zA-Z]
digit       [0-9]
ident       {letter}({letter}|{digit})*

%%

"="       { return EQ;    }
"+"       { return PLUS;  }
"-"       { return MINUS; }
"*"       { return MULT;  }
"/"       { return DIV;   }
{digit}+  { 
            yylval.number = atoi(yytext);
            return INT; 
          }
{ident}   {
            yylval.id = new char[yyleng+1];
            strcpy(yylval.id, yytext);
            return IDENT; 
          }
"\n"      { return CR;    }
.         {}
%%
int yywrap() { 
  yylex_destroy();
  return 1; 
}
