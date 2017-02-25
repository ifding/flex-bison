
Bison learning notes
=========
>9-25-2016

####Introduction

* Bison is a general-purpose parser generator that converts an annotated context-free grammar into a deterministic LR or generalized LR (GLR) parser employing LALR(1) parser tables. As an experimental feature, Bison can also generate IELR(1) or canonical LR(1) parser tables. Once you are proficient with Bison, you can use it to develop a wide range of language parsers, from those used in simple desk calculators to complex programming languages.

* Bison is upward compatible with Yacc: all properly-written Yacc grammars ought to work with Bison with no change. Anyone familiar with Yacc should be able to use Bison with little trouble. You need to be fluent in C or C++ programming in order to use Bison or to understand this manual. Java is also supported as an experimental feature.

* Bison was written originally by Robert Corbett. Richard Stallman made it Yacc-compatible. Wilfred Hansen of Carnegie Mellon University added multi-character string literals and other features. 

#####1 The Concepts of Bison
######1.1 Languages and Context-Free Grammars

* In order for Bison to parse a language, it must be described by a context-free grammar. This means that you specify one or more syntactic groupings and give rules for constructing them from their parts. For example, in the C language, one kind of grouping is called an ‘expression’. One rule for making an expression might be, “An expression can be made of a minus sign and another expression”. Another would be, “An expression can be an integer”. As you can see, rules are often recursive, but there must be at least one rule which leads out of the recursion.

* The most common formal system for presenting such rules for humans to read is Backus-Naur Form or “BNF”, which was developed in order to specify the language Algol 60. Any grammar expressed in BNF is a context-free grammar. The input to Bison is essentially machine-readable BNF.

* There are various important subclasses of context-free grammars. Although it can handle almost all context-free grammars, Bison is optimized for what are called LR(1) grammars. In brief, in these grammars, it must be possible to tell how to parse any portion of an input string with just a single token of lookahead. For historical reasons, Bison by default is limited by the additional restrictions of LALR(1), which is hard to explain simply. See Mysterious Conflicts, for more information on this. As an experimental feature, you can escape these additional restrictions by requesting IELR(1) or canonical LR(1) parser tables. See LR Table Construction, to learn how.

* Parsers for LR(1) grammars are deterministic, meaning roughly that the next grammar rule to apply at any point in the input is uniquely determined by the preceding input and a fixed, finite portion (called a lookahead) of the remaining input. A context-free grammar can be ambiguous, meaning that there are multiple ways to apply the grammar rules to get the same inputs. Even unambiguous grammars can be nondeterministic, meaning that no fixed lookahead always suffices to determine the next grammar rule to apply. With the proper declarations, Bison is also able to parse these more general context-free grammars, using a technique known as GLR parsing (for Generalized LR). Bison’s GLR parsers are able to handle any context-free grammar for which the number of possible parses of any given string is finite.

* In the formal grammatical rules for a language, each kind of syntactic unit or grouping is named by a symbol. Those which are built by grouping smaller constructs according to grammatical rules are called nonterminal symbols; those which can’t be subdivided are called terminal symbols or token types. We call a piece of input corresponding to a single terminal symbol a token, and a piece corresponding to a single nonterminal symbol a grouping.

* We can use the C language as an example of what symbols, terminal and nonterminal, mean. The tokens of C are identifiers, constants (numeric and string), and the various keywords, arithmetic operators and punctuation marks. So the terminal symbols of a grammar for C include ‘identifier’, ‘number’, ‘string’, plus one symbol for each keyword, operator or punctuation mark: ‘if’, ‘return’, ‘const’, ‘static’, ‘int’, ‘char’, ‘plus-sign’, ‘open-brace’, ‘close-brace’, ‘comma’ and many more. (These tokens can be subdivided into characters, but that is a matter of lexicography, not grammar.)

Here is a simple C function subdivided into tokens:

```
int             /* keyword ‘int’ */
square (int x)  /* identifier, open-paren, keyword ‘int’,
                   identifier, close-paren */
{               /* open-brace */
  return x * x; /* keyword ‘return’, identifier, asterisk,
                   identifier, semicolon */
}               /* close-brace */
```

* The syntactic groupings of C include the expression, the statement, the declaration, and the function definition. These are represented in the grammar of C by nonterminal symbols ‘expression’, ‘statement’, ‘declaration’ and ‘function definition’. The full grammar uses dozens of additional language constructs, each with its own nonterminal symbol, in order to express the meanings of these four. The example above is a function definition; it contains one declaration, and one statement. In the statement, each ‘x’ is an expression and so is ‘x * x’.

* Each nonterminal symbol must have grammatical rules showing how it is made out of simpler constructs. For example, one kind of C statement is the return statement; this would be described with a grammar rule which reads informally as follows:

* A ‘statement’ can be made of a ‘return’ keyword, an ‘expression’ and a ‘semicolon’.
* There would be many other rules for ‘statement’, one for each kind of statement in C.
* One nonterminal symbol must be distinguished as the special one which defines a complete utterance in the language. It is called the start symbol. In a compiler, this means a complete input program. In the C language, the nonterminal symbol ‘sequence of definitions and declarations’ plays this role.

* For example, ‘1 + 2’ is a valid C expression—a valid part of a C program—but it is not valid as an entire C program. In the context-free grammar of C, this follows from the fact that ‘expression’ is not the start symbol.

* The Bison parser reads a sequence of tokens as its input, and groups the tokens using the grammar rules. If the input is valid, the end result is that the entire token sequence reduces to a single grouping whose symbol is the grammar’s start symbol. If we use a grammar for C, the entire input must be a ‘sequence of definitions and declarations’. If not, the parser reports a syntax error.

######1.2 From Formal Rules to Bison Input

* A formal grammar is a mathematical construct. To define the language for Bison, you must write a file expressing the grammar in Bison syntax: a Bison grammar file. See Bison Grammar Files.

* A nonterminal symbol in the formal grammar is represented in Bison input as an identifier, like an identifier in C. By convention, it should be in lower case, such as expr, stmt or declaration.

* The Bison representation for a terminal symbol is also called a token type. Token types as well can be represented as C-like identifiers. By convention, these identifiers should be upper case to distinguish them from nonterminals: for example, INTEGER, IDENTIFIER, IF or RETURN. A terminal symbol that stands for a particular keyword in the language should be named after that keyword converted to upper case. The terminal symbol error is reserved for error recovery. 

* A terminal symbol can also be represented as a character literal, just like a C character constant. You should do this whenever a token is just a single character (parenthesis, plus-sign, etc.): use that same character in a literal as the terminal symbol for that token.

* A third way to represent a terminal symbol is with a C string constant containing several characters. 
* The grammar rules also have an expression in Bison syntax. For example, here is the Bison rule for a C return statement. The semicolon in quotes is a literal character token, representing part of the C syntax for the statement; the naked semicolon, and the colon, are Bison punctuation used in every rule.

```
stmt: RETURN expr ';' ;
```

######1.3 Semantic Values

* A formal grammar selects tokens only by their classifications: for example, if a rule mentions the terminal symbol ‘integer constant’, it means that any integer constant is grammatically valid in that position. The precise value of the constant is irrelevant to how to parse the input: if ‘x+4’ is grammatical then ‘x+1’ or ‘x+3989’ is equally grammatical.

* But the precise value is very important for what the input means once it is parsed. A compiler is useless if it fails to distinguish between 4, 1 and 3989 as constants in the program! Therefore, each token in a Bison grammar has both a token type and a semantic value. 

* The token type is a terminal symbol defined in the grammar, such as INTEGER, IDENTIFIER or ','. It tells everything you need to know to decide where the token may validly appear and how to group it with other tokens. The grammar rules know nothing about tokens except their types.

* The semantic value has all the rest of the information about the meaning of the token, such as the value of an integer, or the name of an identifier. (A token such as ',' which is just punctuation doesn’t need to have any semantic value.)

* For example, an input token might be classified as token type INTEGER and have the semantic value 4. Another input token might have the same token type INTEGER but value 3989. When a grammar rule says that INTEGER is allowed, either of these tokens is acceptable because each is an INTEGER. When the parser accepts the token, it keeps track of the token’s semantic value.

* Each grouping can also have a semantic value as well as its nonterminal symbol. For example, in a calculator, an expression typically has a semantic value that is a number. In a compiler for a programming language, an expression typically has a semantic value that is a tree structure describing the meaning of the expression.

######1.4 Semantic Actions

* In order to be useful, a program must do more than parse input; it must also produce some output based on the input. In a Bison grammar, a grammar rule can have an action made up of C statements. Each time the parser recognizes a match for that rule, the action is executed. 

* Most of the time, the purpose of an action is to compute the semantic value of the whole construct from the semantic values of its parts. For example, suppose we have a rule which says an expression can be the sum of two expressions. When the parser recognizes such a sum, each of the subexpressions has a semantic value which describes how it was built up. The action for this rule should create a similar sort of value for the newly recognized larger expression.

For example, here is a rule that says an expression can be the sum of two subexpressions:

```
expr: expr '+' expr   { $$ = $1 + $3; } ;
```

The action says how to produce the semantic value of the sum expression from the values of the two subexpressions.

######1.5 Writing GLR Parsers

In some grammars, Bison’s deterministic LR(1) parsing algorithm cannot decide whether to apply a certain grammar rule at a given point. That is, it may not be able to decide (on the basis of the input read so far) which of two possible reductions (applications of a grammar rule) applies, or whether to apply a reduction or read more of the input and apply a reduction later in the input. These are known respectively as reduce/reduce conflicts, and shift/reduce conflicts.


A reduce/reduce conflict occurs if there are two or more rules that apply to the same sequence of input. This usually indicates a serious error in the grammar.
Suppose we are parsing a language which has if-then and if-then-else statements, with a pair of rules like this:

```
if_stmt:
  "if" expr "then" stmt
| "if" expr "then" stmt "else" stmt
;
```

Here "if", "then" and "else" are terminal symbols for specific keyword tokens.
When the "else" token is read and becomes the lookahead token, the contents of the stack (assuming the input is valid) are just right for reduction by the first rule. But it is also legitimate to shift the "else", because that would lead to eventual reduction by the second rule.
This situation, where either a shift or a reduction would be valid, is called a shift/reduce conflict. Bison is designed to resolve these conflicts by choosing to shift, unless otherwise directed by operator precedence declarations.

To use a grammar that is not easily modified to be LR(1), a more general parsing algorithm is sometimes necessary. If you include %glr-parser among the Bison declarations in your file (see Grammar Outline), the result is a Generalized LR (GLR) parser. These parsers handle Bison grammars that contain no unresolved conflicts (i.e., after applying precedence declarations) identically to deterministic parsers. However, when faced with unresolved shift/reduce and reduce/reduce conflicts, GLR parsers use the simple expedient of doing both, effectively cloning the parser to follow both possibilities. Each of the resulting parsers can again split, so that at any given time, there can be any number of possible parses being explored. The parsers proceed in lockstep; that is, all of them consume (shift) a given input symbol before any of them proceed to the next. Each of the cloned parsers eventually meets one of two possible fates: either it runs into a parsing error, in which case it simply vanishes, or it merges with another parser, because the two of them have reduced the input to an identical set of symbols.

During the time that there are multiple parsers, semantic actions are recorded, but not performed. When a parser disappears, its recorded semantic actions disappear as well, and are never performed. When a reduction makes two parsers identical, causing them to merge, Bison records both sets of semantic actions. Whenever the last two parsers merge, reverting to the single-parser case, Bison resolves all the outstanding actions either by precedences given to the grammar rules involved, or by performing both actions, and then calling a designated user-defined function on the resulting values to produce an arbitrary merged result.


######1.6 Locations

Many applications, like interpreters or compilers, have to produce verbose and useful error messages. To achieve this, one must be able to keep track of the textual location, or location, of each syntactic construct. Bison provides a mechanism for handling these locations.

Each token has a semantic value. In a similar fashion, each token has an associated location, but the type of locations is the same for all tokens and groupings. Moreover, the output parser is equipped with a default data structure for storing locations.

Like semantic values, locations can be reached in actions using a dedicated set of constructs. In the example above, the location of the whole grouping is @$, while the locations of the subexpressions are @1 and @3.

When a rule is matched, a default action is used to compute the semantic value of its left hand side. In the same way, another default action is used for locations. However, the action for locations is general enough for most cases, meaning there is usually no need to describe for each rule how @$ should be formed. When building a new location for a given grouping, the default behavior of the output parser is to take the beginning of the first symbol, and the end of the last symbol.

######1.7 Bison Output: the Parser Implementation File

When you run Bison, you give it a Bison grammar file as input. The most important output is a C source file that implements a parser for the language described by the grammar. This parser is called a Bison parser, and this file is called a Bison parser implementation file. Keep in mind that the Bison utility and the Bison parser are two distinct programs: the Bison utility is a program whose output is the Bison parser implementation file that becomes part of your program.

The job of the Bison parser is to group tokens into groupings according to the grammar rules—for example, to build identifiers and operators into expressions. As it does this, it runs the actions for the grammar rules it uses.

The tokens come from a function called the lexical analyzer that you must supply in some fashion (such as by writing it in C). The Bison parser calls the lexical analyzer each time it wants a new token. It doesn’t know what is “inside” the tokens (though their semantic values may reflect this). Typically the lexical analyzer makes the tokens by parsing characters of text, but Bison does not depend on this.

The Bison parser implementation file is C code which defines a function named yyparse which implements that grammar. This function does not make a complete C program: you must supply some additional functions. One is the lexical analyzer. Another is an error-reporting function which the parser calls to report an error. In addition, a complete C program must start with a function called main; you have to provide this, and arrange for it to call yyparse or the parser will never run. 

Aside from the token type names and the symbols in the actions you write, all symbols defined in the Bison parser implementation file itself begin with ‘yy’ or ‘YY’. This includes interface functions such as the lexical analyzer function yylex, the error reporting function yyerror and the parser function yyparse itself. This also includes numerous identifiers used for internal purposes. Therefore, you should avoid using C identifiers starting with ‘yy’ or ‘YY’ in the Bison grammar file except for the ones defined in this manual. Also, you should avoid using the C identifiers ‘malloc’ and ‘free’ for anything other than their usual meanings.

In some cases the Bison parser implementation file includes system headers, and in those cases your code should respect the identifiers reserved by those headers. On some non-GNU hosts, <alloca.h>, <malloc.h>, <stddef.h>, and <stdlib.h> are included as needed to declare memory allocators and related types. <libintl.h> is included if message translation is in use (see Internationalization). Other system headers may be included if you define YYDEBUG to a nonzero value.

######1.8 Stages in Using Bison

The actual language-design process using Bison, from grammar specification to a working compiler or interpreter, has these parts:

Formally specify the grammar in a form recognized by Bison. For each grammatical rule in the language, describe the action that is to be taken when an instance of that rule is recognized. The action is described by a sequence of C statements.
Write a lexical analyzer to process input and pass tokens to the parser. The lexical analyzer may be written by hand in C . It could also be produced using Lex, but the use of Lex is not discussed in this manual.
Write a controlling function that calls the Bison-produced parser.
Write error-reporting routines.
To turn this source code as written into a runnable program, you must follow these steps:

Run Bison on the grammar to produce the parser.
Compile the code output by Bison, as well as any other source files.
Link the object files to produce the finished product.

######1.9 The Overall Layout of a Bison Grammar

The input file for the Bison utility is a Bison grammar file. The general form of a Bison grammar file is as follows:

```
%{
Prologue
%}
```

Bison declarations

```
%%
Grammar rules
%%
Epilogue
```

* The ‘%%’, ‘%{’ and ‘%}’ are punctuation that appears in every Bison grammar file to separate the sections.

* The prologue may define types and variables used in the actions. You can also use preprocessor commands to define macros used there, and use #include to include header files that do any of these things. You need to declare the lexical analyzer yylex and the error printer yyerror here, along with any other global identifiers used by the actions in the grammar rules.

* The Bison declarations declare the names of the terminal and nonterminal symbols, and may also describe operator precedence and the data types of semantic values of various symbols.

* The grammar rules define how to construct each nonterminal symbol from its parts.

* The epilogue can contain any code you want to use. Often the definitions of functions declared in the prologue go here. In a simple program, all the rest of the program can go here.

####Reference

* [Schalkoff, Programming Languages and Methodologies, Jones and Bartlett Publishers, 2007.](https://www.amazon.com/Programming-Languages-Methodologies-Robert-Schalkoff/dp/0763740594)
