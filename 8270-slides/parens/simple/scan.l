%{
#include <iostream>
#include <cstring>
#include "parse.tab.h"
%}

%%

"("       { return LPAR; }
")"       { return RPAR; }
"\n"      { return CR; }
.         { ; }

%%
int yywrap() { return 1; }
