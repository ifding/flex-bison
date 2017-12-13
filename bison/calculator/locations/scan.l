%{
#include "parse.tab.h"
/* Code to handle locations */
/* This is taken from Chapter 8 - flex & bison by John Levine */
int yycolumn = 1;

#define YY_USER_ACTION yylloc.first_line = yylloc.last_line = yylineno; \
    yylloc.first_column = yycolumn; yylloc.last_column = yycolumn+yyleng-1; \
    yycolumn += yyleng;


static const int FIRST_COLUMN = 1;    /* Start a line in column 1 (not 0) */


%}
%option yylineno

%%

"+"       { return PLUS; }
"-"       { return MINUS; }
"*"       { return MULT; }
"/"       { return DIV; }
[0-9]+    { yylval = atoi(yytext);
            return NUMBER; 
          }
"\n"      { return CR; }
<<EOF>>   { yyterminate(); }

%%
int yywrap() { 
  yylex_destroy();
  return 1; 
}
