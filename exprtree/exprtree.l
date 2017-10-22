%{
	#include <stdio.h>
	#include "y.tab.h"
	#include <stdlib.h>

	int number;

%}

%%

[0-9]+	{number = atoi(yytext); yylval = makeLeafNode(number); return NUM;}
"+"	{return PLUS;}
"-"	{return MINUS;}
"*"	{return MUL;}
"/"	{return DIV;}
[ \t]	{}
[()]	{return *yytext;}
[\n]	{return END;}
.	{yyerror("unknown character\n");exit(1);}

%%

int yywrap(void) {
	return 1;
}
