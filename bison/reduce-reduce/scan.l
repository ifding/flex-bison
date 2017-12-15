%{
#include <iostream>
#include <cstring>
#include "parse.tab.h"
%}
%option noyywrap

%%

"X"   { return X;}
"Y"   { return Y;}
"\n"  { }
.		  { }
%%
