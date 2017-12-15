%{
#include <iostream>
extern int yylex();
void yyerror(const char * msg) { std::cout << msg << std::endl; }
%}
%token CR
%token LPAR
%token RPAR
%%

lines   : lines expr CR
          { std::cout << "parens: " << $2<< std::endl; }
        | { ; }
        ;

expr    : LPAR expr RPAR expr
          { $$ = $2 + $4 + 1; }
        | { $$ = 0; }
        ;

