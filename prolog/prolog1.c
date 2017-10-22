#include "prolog1.tab.c"
#include "lex.yy.c"
#include "yyerror.c"


int main()
{
	int status = yyparse();
	if(status == 1) /* if parsing failed, due to a syntax error */
	{
		printf("\nSyntactically incorrect (INVALID) string\n");
	    printf("\n");
	}
	else if(status == 0) /* if parsing was successful */
	    printf("\nThe input string is a SYNTACTICALLY CORRECT Prolog set of clauses.\n");
	return(1);
}
