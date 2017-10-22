%{
#include <stdio.h>
#include <ctype.h>
int yylex (void);
int yyerror (char *s);
%}

%token LPARENS
%token RPARENS
%token PERIOD
%token COMMA
%token APOSTROPHE
%token COLON
%token HYPHEN
%token LOW
%token UPP
%token DIG
%start S

%%  /* Grammar rules */

S: clauselist
;
clauselist: clause | clauselist clause
;
clause: predicate PERIOD | predicate special predicatelist PERIOD
;
predicatelist: predicate | predicatelist COMMA predicate
;
predicate: atom | atom LPARENS termlist RPARENS
;
special: COLON HYPHEN
;
termlist: term | termlist COMMA term
;
term: numeral | atom | variable
;
atom: smallatom | APOSTROPHE string APOSTROPHE
;
smallatom: lowercaseletter | smallatom character
;
variable: uppercaseletter | variable character
;
lowercaseletter: LOW
;
uppercaseletter: UPP
;
numeral: digit | numeral digit
;
digit: DIG
;
character: lowercaseletter | uppercaseletter | digit
;
string: character | string character
;
%%