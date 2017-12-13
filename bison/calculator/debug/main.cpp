extern int yyparse();

int main() {
  extern int yydebug;
  yydebug = 1;
  if ( yyparse() ) {
  }
  return 0;
}
