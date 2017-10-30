## Customising Attribute Types

### YYSTYPE

The macro YYSTYPE denotes the type of the attribute stack. YYSTYPE is int by default.

```c
#define YYSTYPE int;
```

can be found in the y.tab.c file. YACC automatically declares yylval to be of the type YYSTYPE.

Since by default, YACC defines YYSTYPE to be the type int, only integer valued attributes can be passed from yylex() to yyparse() and only integer attributes can be synthesized by default. If we were to attempt to assign any other value to yylval or any of the attribute stack variables, a type error would be flagged on compiling y.tab.c using gcc.

The type of YYSTYPE can be overriden manually as shown below. This may be used (not recommended) to change the type of all the attributes from int to some other type.

```c
#define char YYSTYPE;
```

### User defined type

Input: 33+42*(21-16)

Intermediate data structure:

![](http://silcnitc.github.io/img/ywlexp0.png)

How the expression tree was created is [here](http://silcnitc.github.io/ywl.html)

The final result:

![](http://silcnitc.github.io/img/ywlexp37.png)

### union

But in order to have multiple custom attribute values, YACC offers a useful feature called %union to customize the type of YYSTYPE.
%union is useful when we require to have different tokens of different types. For example, if we wanted some tokens to be of the type int and some tokens to be the type of char.

```
/* YACC Auxiliary declarations*/

/* YACC Declarations*/

%union
{
	char character;
	int integer;

};

%token OP
%token NUMBER

%type <character> OP
%type <integer> NUMBER

%%

expr: expr OP expr { printf("%c %d %d",$2,$1,$3); }
    | DIGIT        { $$=$1; }
    ;

%%

/* Auxiliary functions */
```

Note that the type the attribute of each token must be mentioned when the token is being declared using the following syntax.

```c
%token tokenname 
%type <token-type> tokenname
```

`token-type` must be declared under %union prior to use in the declaration of a token.
If the type of a token is not explicitly mentioned, no attribute value can be assigned
to the token i.e, it is assumed to be of type void.

## Reference

- [USING LEX WITH YACC](http://silcnitc.github.io/ywl.html)
