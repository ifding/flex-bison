%{
#include "includes/ast.h"
#include "parse.tab.h"
%}
letter      [a-zA-Z]
digit       [0-9]
digits      [0-9]+
float       {digits}"."{digits}
ident       {letter}({letter}|{digit})*

%%

"="       { return EQ;    }
"+"       { return PLUS;  }
"-"       { return MINUS; }
"*"       { return MULT;  }
"/"       { return DIV;   }
{digits}  { 
            yylval.intNumber = atoi(yytext);
            return INT; 
          }
{float}   { 
            yylval.fltNumber = atof(yytext);
            return FLOAT; 
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
