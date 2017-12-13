%{
#include <iostream>
#include <map>
#include <cmath>
extern int yylex();
void yyerror(const char * msg);
std::map<std::string, int> table;
%}

%union {
  int number;
  char *id;
}

%token CR
%token EQ
%token<id> IDENT
%token NUMBER
%type<number> lines expr
%left PLUS MINUS
%left MULT DIV

%%
lines   : lines expr CR
          { std::cout << $2 << std::endl; }
        | lines IDENT EQ expr CR
          { table[$2] = $4;               
            delete [] $2;
          }
        | lines CR
        | { ; }
        ;

expr    : expr PLUS expr     { $$ = $1 + $3;   }
        | expr MINUS expr    { $$ = $1 - $3;   }
        | expr MULT expr     { $$ = $1 * $3;   }
        | expr DIV expr      { $$ = $1 / $3;   }
        | NUMBER             { $$ = yylval.number; }
        | IDENT              { $$ = table[$1]; 
                               delete [] $1;
                             }
        ;
%%
void yyerror(const char * msg) { std::cout << msg << std::endl; }
