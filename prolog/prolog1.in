%option nounput
%option noinput

%{
#include "prolog1.tab.h"
%}

A_LOW [a-z]
A_UPP [A-Z]
A_DIG [0-9]

%%

[ \r\t\n]+ /* whitespace */
"(" return LPARENS;
")" return RPARENS;
"." return PERIOD;
"'" return APOSTROPHE;
"," return COMMA;
":" return COLON;
"-" return HYPHEN;
{A_LOW} return LOW;
{A_UPP} return UPP;
{A_DIG} return DIG;
.  return yytext[0];
%%