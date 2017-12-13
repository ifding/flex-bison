%{
#include <iostream>
extern int yylex();
extern int yylval;
void yyerror(const char * msg);
%}

%token CR NUMBER
%left PLUS MINUS
%left MULT DIV

%locations

%%
lines   : lines expr CR
          { std::cout << $2 << std::endl; }
        | lines CR
        | 
        ;

expr    : expr PLUS expr  { $$ = $1 + $3; }
        | expr MINUS expr { $$ = $1 - $3; }
        | expr MULT expr  { $$ = $1 * $3; }
        | expr DIV expr   { $$ = $1 / $3; }
        | NUMBER          { $$ = $1;      }
        ;
%%
void yyerror(const char * msg) { 
  std::cout << yylloc.first_line << ": " << msg << std::endl; 
}

