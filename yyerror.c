int yyerror (s)  /* Called by yyparse on error */
     char *s;
{
  printf ("%s\n", s);
  return(-1);
}
