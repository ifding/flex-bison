%{
#include <iostream>
extern int yylex();
void yyerror(const char * msg) { std::cout << msg << std::endl; }
%}
%token X Y 

%%
start   : a Y
        | b Y;
        ;
a       : X;
b       : X;
