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
          { std::cout << "accept" << std::endl; }
        | { ; }
        ;

expr    : LPAR expr RPAR expr
        |
        ;

