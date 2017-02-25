
Flex learning notes
=========
>9-25-2016

####1.Introduction

* flex is a tool for generating scanners. A scanner is a program which recognizes lexical patterns in text. The flex program reads the given input files, or its standard input if no file names are given, for a description of a scanner to generate. The description is in the form of pairs of regular expressions and C code, called rules. flex generates as output a C source file, lex.yy.c by default, which defines a routine yylex(). This file can be compiled and linked with the flex runtime library to produce an executable. When the executable is run, it analyzes its input for occurrences of the regular expressions. Whenever it finds one, it executes the corresponding C code.

####2.Some Simple Examples

```
/* scanner for a toy Pascal-like language */
%{
/* need this for the call to atof() below */
#include <math.h>
%}
DIGIT    [0-9]
ID       [a-z][a-z0-9]*
%%     
{DIGIT}+    {
            printf( "An integer: %s (%d)\n", yytext,
            atoi( yytext ) );
            }
{DIGIT}+"."{DIGIT}*        {
            printf( "A float: %s (%g)\n", yytext,
            atof( yytext ) );
            }
if|then|begin|end|procedure|function        {
            printf( "A keyword: %s\n", yytext );
            }
{ID}        printf( "An identifier: %s\n", yytext );
"+"|"-"|"*"|"/"   printf( "An operator: %s\n", yytext );
"{"[\^{}}\n]*"}"     /* eat up one-line comments */
[ \t\n]+          /* eat up whitespace */
.           printf( "Unrecognized character: %s\n", yytext );
%%
int main( int argc, char **argv )
{     ++argv, --argc;  /* skip over program name */
    if ( argc > 0 )
         yyin = fopen( argv[0], "r" );
    else
         yyin = stdin;
    yylex();
}
```

####3. Format of the Input File

The flex input file consists of three sections, separated by a line containing only ‘%%’.

```
definitions
%%
rules
%%
user code
```

#####3.1 Format of the Definitions Section

* The definitions section contains declarations of simple name definitions to simplify the scanner specification, and declarations of start conditions, which are explained in a later section.
* Name definitions have the form:

```
name definition
```

* The ‘name’ is a word beginning with a letter or an underscore (‘_’) followed by zero or more letters, digits, ‘_’, or ‘-’ (dash). The definition is taken to begin at the first non-whitespace character following the name and continuing to the end of the line. The definition can subsequently be referred to using ‘{name}’, which will expand to ‘(definition)’. For example,

```
DIGIT    [0-9]
ID       [a-z][a-z0-9]*
```

* Defines ‘DIGIT’ to be a regular expression which matches a single digit, and ‘ID’ to be a regular expression which matches a letter followed by zero-or-more letters-or-digits. A subsequent reference to
 
```
{DIGIT}+"."{DIGIT}*            is identical to        ([0-9])+"."([0-9])*
```
and matches one-or-more digits followed by a ‘.’ followed by zero-or-more digits.
* An unindented comment (i.e., a line beginning with ‘/*’) is copied verbatim to the output up to the next ‘*/’.
* Any indented text or text enclosed in ‘%{’ and ‘%}’ is also copied verbatim to the output (with the %{ and %} symbols removed). The %{ and %} symbols must appear unindented on lines by themselves.
* A %top block is similar to a ‘%{’ ... ‘%}’ block, except that the code in a %top block is relocated to the top of the generated file, before any flex definitions 1. The %top block is useful when you want certain preprocessor macros to be defined or certain files to be included before the generated code. The single characters, ‘{’ and ‘}’ are used to delimit the %top block, as show in the example below:

```
%top{
  /* This code goes at the "top" of the generated file. */
  #include <stdint.h>
  #include <inttypes.h>
}
```

Multiple %top blocks are allowed, and their order is preserved.

#####3.2 Format of the Rules Section

The rules section of the flex input contains a series of rules of the form:

`pattern   action`

* where the pattern must be unindented and the action must begin on the same line. See Patterns, for a further description of patterns and actions.
* In the rules section, any indented or %{ %} enclosed text appearing before the first rule may be used to declare variables which are local to the scanning routine and (after the declarations) code which is to be executed whenever the scanning routine is entered. Other indented or %{ %} text in the rule section is still copied to the output, but its meaning is not well-defined and it may well cause compile-time errors (this feature is present for POSIX compliance. See Lex and Posix, for other such features).
* Any indented text or text enclosed in ‘%{’ and ‘%}’ is copied verbatim to the output (with the %{ and %} symbols removed). The %{ and %} symbols must appear unindented on lines by themselves.

#####3.3 Format of the User Code Section
* The user code section is simply copied to lex.yy.c verbatim. It is used for companion routines which call or are called by the scanner. The presence of this section is optional; if it is missing, the second ‘%%’ in the input file may be skipped, too.

#####3.4 Comments in the Input
* Flex supports C-style comments, that is, anything between ‘/*’ and ‘*/’ is considered a comment. Whenever flex encounters a comment, it copies the entire comment verbatim to the generated source code. Comments may appear just about anywhere, but with the following exceptions:
* Comments may not appear in the Rules Section wherever flex is expecting a regular expression. This means comments may not appear at the beginning of a line, or immediately following a list of scanner states.
* Comments may not appear on an ‘%option’ line in the Definitions Section.
* If you want to follow a simple rule, then always begin a comment on a new line, with one or more whitespace characters before the initial ‘/*’). This rule will work anywhere in the input file.
* All the comments in the following example are valid:

```
     %{
     /* code block */
     %}
     /* Definitions Section */
     %x STATE_X
     
     %%
         /* Rules Section */
     ruleA   /* after regex */ { /* code block */ } /* after code block */
             /* Rules Section (indented) */
     <STATE_X>{
     ruleC   ECHO;
     ruleD   ECHO;
     %{
     /* code block */
     %}
     }
     %%
     /* User Code Section */
```
####4 Patterns

The patterns in the input (see Rules Section) are written using an extended set of regular expressions. These are:

```
‘x’                match the character 'x' 
‘.’                 any character (byte) except newline
‘[xyz]’          a character class; in this case, the pattern matches either an 'x', a 'y', or a 'z'
‘[abj-oZ]’
a "character class" with a range in it; matches an 'a', a 'b', any letter from 'j' through 'o', or a 'Z'
‘[^A-Z]’
a "negated character class", i.e., any character but those in the class. In this case, any character EXCEPT an uppercase letter. 
‘[^A-Z\n]’                    any character EXCEPT an uppercase letter or a newline 
‘[a-z]{-}[aeiou]’           the lowercase consonants 
‘r*’                             zero or more r's, where r is any regular expression 
‘R+’                           one or more r's 
‘R?’                           zero or one r's (that is, “an optional r”)
‘R{2,5}’                     anywhere from two to five r's 
‘R{2,}’                       two or more r's 
‘R{4}’                        exactly 4 r's
‘{name}’                    the expansion of the ‘name’ definition (see Format).
‘"[xyz]\"foo"’              the literal string: ‘[xyz]"foo’
‘\X’                            if X is ‘a’, ‘b’, ‘f’, ‘n’, ‘r’, ‘t’, or ‘v’, then the ANSI-C interpretation of ‘\x’. Otherwise, a literal ‘X’ (used to escape operators such as ‘*’)
‘\0’                           a NUL character (ASCII code 0)
‘\123’                       the character with octal value 123 
‘\x2a’                       the character with hexadecimal value 2a 
‘(r)’                          match an ‘r’; parentheses are used to override precedence (see below) 
‘(?r-s:pattern)’
apply option ‘r’ and omit option ‘s’ while interpreting pattern. Options may be zero or more of the characters ‘i’, ‘s’, or ‘x’.
‘i’ means case-insensitive. ‘-i’ means case-sensitive.
‘s’ alters the meaning of the ‘.’ syntax to match any single byte whatsoever. ‘-s’ alters the meaning of ‘.’ to match any byte except ‘\n’.
‘x’ ignores comments and whitespace in patterns. Whitespace is ignored unless it is backslash-escaped, contained within ‘""’s, or appears inside a character class.
```

The following are all valid:

```
     (?:foo)         same as  (foo)
     (?i:ab7)        same as  ([aA][bB]7)
     (?-i:ab)        same as  (ab)
     (?s:.)          same as  [\x00-\xFF]
     (?-s:.)         same as  [^\n]
     (?ix-s: a . b)  same as  ([Aa][^\n][bB])
     (?x:a  b)       same as  ("ab")
     (?x:a\ b)       same as  ("a b")
     (?x:a" "b)      same as  ("a b")
     (?x:a[ ]b)      same as  ("a b")
     (?x:a
         /* comment */
         b
         c)          same as  (abc)
```

`‘(?# comment )’`

omit everything within ‘()’. The first ‘)’ character encountered ends the pattern. It is not possible to for the comment to contain a ‘)’ character. The comment may span lines.

`‘rs’`

the regular expression ‘r’ followed by the regular expression ‘s’; called concatenation 

`‘r|s’`

either an ‘r’ or an ‘s’

`‘r/s’`

an ‘r’ but only if it is followed by an ‘s’. The text matched by ‘s’ is included when determining whether this rule is the longest match, but is then returned to the input before the action is executed. So the action only sees the text matched by ‘r’. This type of pattern is called trailing context. (There are some combinations of ‘r/s’ that flex cannot match correctly. See Limitations, regarding dangerous trailing context.)

`‘^r’`

an ‘r’, but only at the beginning of a line (i.e., when just starting to scan, or right after a newline has been scanned).

`‘r$’`

an ‘r’, but only at the end of a line (i.e., just before a newline). Equivalent to ‘r/\n’.
Note that flex's notion of “newline” is exactly whatever the C compiler used to compile flex interprets ‘\n’ as; in particular, on some DOS systems you must either filter out ‘\r’s in the input yourself, or explicitly use ‘r/\r\n’ for ‘r$’.

`‘<s>r’`

an ‘r’, but only in start condition s (see Start Conditions for discussion of start conditions). 

`‘<s1,s2,s3>r’`

same, but in any of start conditions s1, s2, or s3. 

`‘<*>r’`

an ‘r’ in any start condition, even an exclusive one.

`‘<<EOF>>’`

an end-of-file. 

`‘<s1,s2><<EOF>>’`

an end-of-file when in start condition s1 or s2

* Note that inside of a character class, all regular expression operators lose their special meaning except escape (‘\’) and the character class operators, ‘-’, ‘]]’, and, at the beginning of the class, ‘^’.
* The regular expressions listed above are grouped according to precedence, from highest precedence at the top to lowest at the bottom. Those grouped together have equal precedence (see special note on the precedence of the repeat operator, ‘{}’, under the documentation for the ‘--posix’ POSIX compliance option). For example,

```
foo|bar*   is the same as         (foo)|(ba(r*))
```

* since the ‘*’ operator has higher precedence than concatenation, and concatenation higher than alternation (‘|’). This pattern therefore matches either the string ‘foo’ or the string ‘ba’ followed by zero-or-more ‘r’'s. To match ‘foo’ or zero-or-more repetitions of the string ‘bar’, use:

```
foo|(bar)*
```

And to match a sequence of zero or more repetitions of ‘foo’ and ‘bar’:

```
(foo|bar)*
```

In addition to characters and ranges of characters, character classes can also contain character class expressions. These are expressions enclosed inside ‘[’: and ‘:]’ delimiters (which themselves must appear between the ‘[’ and ‘]’ of the character class. Other elements may occur inside the character class, too). The valid expressions are:
 
``` 
         [:alnum:] [:alpha:] [:blank:]
         [:cntrl:] [:digit:] [:graph:]
         [:lower:] [:print:] [:punct:]
         [:space:] [:upper:] [:xdigit:]
```

These expressions all designate a set of characters equivalent to the corresponding standard C isXXX function. For example, ‘[:alnum:]’ designates those characters for which isalnum() returns true - i.e., any alphabetic or numeric character. Some systems don't provide isblank(), so flex defines ‘[:blank:]’ as a blank or a tab.
For example, the following character classes are all equivalent:

```
         [[:alnum:]]
         [[:alpha:][:digit:]]
         [[:alpha:][0-9]]
         [a-zA-Z0-9]
```

* A word of caution. Character classes are expanded immediately when seen in the flex input. This means the character classes are sensitive to the locale in which flex is executed, and the resulting scanner will not be sensitive to the runtime locale. This may or may not be desirable.
* If your scanner is case-insensitive (the ‘-i’ flag), then ‘[:upper:]’ and ‘[:lower:]’ are equivalent to ‘[:alpha:]’.
* Character classes with ranges, such as ‘[a-Z]’, should be used with caution in a case-insensitive scanner if the range spans upper or lowercase characters. Flex does not know if you want to fold all upper and lowercase characters together, or if you want the literal numeric range specified (with no case folding). When in doubt, flex will assume that you meant the literal numeric range, and will issue a warning. The exception to this rule is a character range such as ‘[a-z]’ or ‘[S-W]’ where it is obvious that you want case-folding to occur. Here are some examples with the ‘-i’ flag enabled:

```
Range	Result	Literal Range	Alternate Range 
‘[a-t]’	ok	‘[a-tA-T]’	
‘[A-T]’	ok	‘[a-tA-T]’	
‘[A-t]’	ambiguous	‘[A-Z\[\\\]_`a-t]’	‘[a-tA-T]’ 
‘[_-{]’	ambiguous	‘[_`a-z{]’	‘[_`a-zA-Z{]’ 
‘[@-C]’	ambiguous	‘[@ABC]’	‘[@A-Z\[\\\]_`abc]’ 
```

A negated character class such as the example ‘[^A-Z]’ above will match a newline unless ‘\n’ (or an equivalent escape sequence) is one of the characters explicitly present in the negated character class (e.g., ‘[^A-Z\n]’). This is unlike how many other regular expression tools treat negated character classes, but unfortunately the inconsistency is historically entrenched. Matching newlines means that a pattern like ‘[^"]*’ can match the entire input unless there's another quote in the input.
Flex allows negation of character class expressions by prepending ‘^’ to the POSIX character class name.

```
              [:^alnum:] [:^alpha:] [:^blank:]
              [:^cntrl:] [:^digit:] [:^graph:]
              [:^lower:] [:^print:] [:^punct:]
              [:^space:] [:^upper:] [:^xdigit:]
```

* Flex will issue a warning if the expressions ‘[:^upper:]’ and ‘[:^lower:]’ appear in a case-insensitive scanner, since their meaning is unclear. The current behavior is to skip them entirely, but this may change without notice in future revisions of flex.
* The ‘{-}’ operator computes the difference of two character classes. For example, ‘[a-c]{-}[b-z]’ represents all the characters in the class ‘[a-c]’ that are not in the class ‘[b-z]’ (which in this case, is just the single character ‘a’). The ‘{-}’ operator is left associative, so ‘[abc]{-}[b]{-}[c]’ is the same as ‘[a]’. Be careful not to accidentally create an empty set, which will never match.
* The ‘{+}’ operator computes the union of two character classes. For example, ‘[a-z]{+}[0-9]’ is the same as ‘[a-z0-9]’. This operator is useful when preceded by the result of a difference operation, as in, ‘[[:alpha:]]{-}[[:lower:]]{+}[q]’, which is equivalent to ‘[A-Zq]’ in the "C" locale.
* A rule can have at most one instance of trailing context (the ‘/’ operator or the ‘$’ operator). The start condition, ‘^’, and ‘<<EOF>>’ patterns can only occur at the beginning of a pattern, and, as well as with ‘/’ and ‘$’, cannot be grouped inside parentheses. A ‘^’ which does not occur at the beginning of a rule or a ‘$’ which does not occur at the end of a rule loses its special properties and is treated as a normal character.
* The following are invalid:

```
              foo/bar$
              <sc1>foo<sc2>bar
```

Note that the first of these can be written ‘foo/bar\n’.
The following will result in ‘$’ or ‘^’ being treated as a normal character:

```
              foo|(bar$)
              foo|^bar
```
If the desired meaning is a ‘foo’ or a ‘bar’-followed-by-a-newline, the following could be used (the special | action is explained below, see Actions):

```
foo      |
bar$     /* action goes here */
```

A similar trick will work for matching a ‘foo’ or a ‘bar’-at-the-beginning-of-a-line.

####5. How the Input Is Matched

* When the generated scanner is run, it analyzes its input looking for strings which match any of its patterns. If it finds more than one match, it takes the one matching the most text (for trailing context rules, this includes the length of the trailing part, even though it will then be returned to the input). If it finds two or more matches of the same length, the rule listed first in the flex input file is chosen.
* Once the match is determined, the text corresponding to the match (called the token) is made available in the global character pointer yytext, and its length in the global integer yyleng. The action corresponding to the matched pattern is then executed (see Actions), and then the remaining input is scanned for another match.
* If no match is found, then the default rule is executed: the next character in the input is considered matched and copied to the standard output. Thus, the simplest valid flex input is:
 
 ```
 %%
 ```
 
* which generates a scanner that simply copies its input (one character at a time) to its output.
* Note that yytext can be defined in two different ways: either as a character pointer or as a character array. You can control which definition flex uses by including one of the special directives %pointer or %array in the first (definitions) section of your flex input. The default is %pointer, unless you use the ‘-l’ lex compatibility option, in which case yytext will be an array. The advantage of using %pointer is substantially faster scanning and no buffer overflow when matching very large tokens (unless you run out of dynamic memory). The disadvantage is that you are restricted in how your actions can modify yytext (see Actions), and calls to the unput() function destroys the present contents of yytext, which can be a considerable porting headache when moving between different lex versions.
* The advantage of %array is that you can then modify yytext to your heart's content, and calls to unput() do not destroy yytext (see Actions). Furthermore, existing lex programs sometimes access yytext externally using declarations of the form:
 
 ```
 extern char yytext[];
 ```
 
* This definition is erroneous when used with %pointer, but correct for %array.
* The %array declaration defines yytext to be an array of YYLMAX characters, which defaults to a fairly large value. You can change the size by simply #define'ing YYLMAX to a different value in the first section of your flex input. As mentioned above, with %pointer yytext grows dynamically to accommodate large tokens. While this means your %pointer scanner can accommodate very large tokens (such as matching entire blocks of comments), bear in mind that each time the scanner must resize yytext it also must rescan the entire token from the beginning, so matching such tokens can prove slow. yytext presently does not dynamically grow if a call to unput() results in too much text being pushed back; instead, a run-time error results.

####6. Actions
* Each pattern in a rule has a corresponding action, which can be any arbitrary C statement. The pattern ends at the first non-escaped whitespace character; the remainder of the line is its action. If the action is empty, then when the pattern is matched the input token is simply discarded. For example, here is the specification for a program which deletes all occurrences of ‘zap me’ from its input:
 
 ```
 %%
"zap me"
```

* This example will copy all other characters in the input to the output since they will be matched by the default rule.
* Here is a program which compresses multiple blanks and tabs down to a single blank, and throws away whitespace found at the end of a line:

```
         %%
         [ \t]+        putchar( ' ' );
         [ \t]+$       /* ignore this token */
```

* If the action contains a ‘{’, then the action spans till the balancing ‘}’ is found, and the action may cross multiple lines. flex knows about C strings and comments and won't be fooled by braces found within them, but also allows actions to begin with ‘%{’ and will consider the action to be all the text up to the next ‘%}’ (regardless of ordinary braces inside the action).
* An action consisting solely of a vertical bar (‘|’) means “same as the action for the next rule”. See below for an illustration.
* Actions can include arbitrary C code, including return statements to return a value to whatever routine called yylex(). Each time yylex() is called it continues processing tokens from where it last left off until it either reaches the end of the file or executes a return.
* Actions are free to modify yytext except for lengthening it (adding characters to its end–these will overwrite later characters in the input stream). This however does not apply when using %array (see Matching). In that case, yytext may be freely modified in any way.
* Actions are free to modify yyleng except they should not do so if the action also includes use of yymore() (see below).
* There are a number of special directives which can be included within an action:

```
ECHO
```

* copies yytext to the scanner's output. 

```
BEGIN
```

followed by the name of a start condition places the scanner in the corresponding start condition (see below). 

```
REJECT
```

directs the scanner to proceed on to the “second best” rule which matched the input (or a prefix of the input). The rule is chosen as described above in Matching, and yytext and yyleng set up appropriately. It may either be one which matched as much text as the originally chosen rule but came later in the flex input file, or one which matched less text. For example, the following will both count the words in the input and call the routine special() whenever ‘frob’ is seen:

```
                      int word_count = 0;
              %%
              frob        special(); REJECT;
              [^ \t\n]+   ++word_count;
```

Without the REJECT, any occurrences of ‘frob’ in the input would not be counted as words, since the scanner normally executes only one action per token. Multiple uses of REJECT are allowed, each one finding the next best choice to the currently active rule. For example, when the following scanner scans the token ‘abcd’, it will write ‘abcdabcaba’ to the output:

```
              %%
              a        |
              ab       |
              abc      |
              abcd     ECHO; REJECT;
              .|\n     /* eat up any unmatched character */
```

* The first three rules share the fourth's action since they use the special ‘|’ action.
* REJECT is a particularly expensive feature in terms of scanner performance; if it is used in any of the scanner's actions it will slow down all of the scanner's matching. Furthermore, REJECT cannot be used with the ‘-Cf’ or ‘-CF’ options (see Scanner Options).
* Note also that unlike the other special actions, REJECT is a branch. Code immediately following it in the action will not be executed. 

```
yymore()
```

tells the scanner that the next time it matches a rule, the corresponding token should be appended onto the current value of yytext rather than replacing it. For example, given the input ‘mega-kludge’ the following will write ‘mega-mega-kludge’ to the output:

```
              %%
              mega-    ECHO; yymore();
              kludge   ECHO;
```

* First ‘mega-’ is matched and echoed to the output. Then ‘kludge’ is matched, but the previous ‘mega-’ is still hanging around at the beginning of yytext so the ECHO for the ‘kludge’ rule will actually write ‘mega-kludge’.
* Two notes regarding use of yymore(). First, yymore() depends on the value of yyleng correctly reflecting the size of the current token, so you must not modify yyleng if you are using yymore(). Second, the presence of yymore() in the scanner's action entails a minor performance penalty in the scanner's matching speed.
* yyless(n) returns all but the first n characters of the current token back to the input stream, where they will be rescanned when the scanner looks for the next match. yytext and yyleng are adjusted appropriately (e.g., yyleng will now be equal to n). For example, on the input ‘foobar’ the following will write out ‘foobarbar’:

```
         %%
         foobar    ECHO; yyless(3);
         [a-z]+    ECHO;
```

* An argument of 0 to yyless() will cause the entire current input string to be scanned again. Unless you've changed how the scanner will subsequently process its input (using BEGIN, for example), this will result in an endless loop.
* Note that yyless() is a macro and can only be used in the flex input file, not from other source files.
* unput(c) puts the character c back onto the input stream. It will be the next character scanned. The following action will take the current token and cause it to be rescanned enclosed in parentheses.

```
         {
         int i;
         /* Copy yytext because unput() trashes yytext */
         char *yycopy = strdup( yytext );
         unput( ')' );
         for ( i = yyleng - 1; i >= 0; --i )
             unput( yycopy[i] );
         unput( '(' );
         free( yycopy );
         }
```

* Note that since each unput() puts the given character back at the beginning of the input stream, pushing back strings must be done back-to-front.
* An important potential problem when using unput() is that if you are using %pointer (the default), a call to unput() destroys the contents of yytext, starting with its rightmost character and devouring one character to the left with each call. If you need the value of yytext preserved after a call to unput() (as in the above example), you must either first copy it elsewhere, or build your scanner using %array instead (see Matching).
* Finally, note that you cannot put back ‘EOF’ to attempt to mark the input stream with an end-of-file.
* input() reads the next character from the input stream. For example, the following is one way to eat up C comments:

```
         %%
         "/*"        {
                     register int c;
                     for ( ; ; )
                         {
                         while ( (c = input()) != '*' &&
                                 c != EOF )
                             ;    /* eat up text of comment */
                         if ( c == '*' )
                             {
                             while ( (c = input()) == '*' )
                                 ;
                             if ( c == '/' )
                                 break;    /* found the end */
                             }
                         if ( c == EOF )
                             {
                             error( "EOF in comment" );
                             break;
                             }
                         }
                     }
```

(Note that if the scanner is compiled using C++, then input() is instead referred to as yyinput(), in order to avoid a name clash with the C++ stream by the name of input.)
* YY_FLUSH_BUFFER; flushes the scanner's internal buffer so that the next time the scanner attempts to match a token, it will first refill the buffer using YY_INPUT() (see Generated Scanner). This action is a special case of the more general yy_flush_buffer; function, described below (see Multiple Input Buffers)
yyterminate() can be used in lieu of a return statement in an action. It terminates the scanner and returns a 0 to the scanner's caller, indicating “all done”. By default, yyterminate() is also called when an end-of-file is encountered. It is a macro and may be redefined.

####7. The Generated Scanner

* The output of flex is the file lex.yy.c, which contains the scanning routine yylex(), a number of tables used by it for matching tokens, and a number of auxiliary routines and macros. By default, yylex() is declared as follows:

```
         int yylex()
             {
             ... various definitions and the actions in here ...
             }
```

(If your environment supports function prototypes, then it will be int yylex( void ).) This definition may be changed by defining the YY_DECL macro. For example, you could use:

```
         #define YY_DECL float lexscan( a, b ) float a, b;
```

* to give the scanning routine the name lexscan, returning a float, and taking two floats as arguments. Note that if you give arguments to the scanning routine using a K&R-style/non-prototyped function declaration, you must terminate the definition with a semi-colon (;).

* flex generates ‘C99’ function definitions by default. However flex does have the ability to generate obsolete, er, ‘traditional’, function definitions. This is to support bootstrapping gcc on old systems. Unfortunately, traditional definitions prevent us from using any standard data types smaller than int (such as short, char, or bool) as function arguments. For this reason, future versions of flex may generate standard C99 code only, leaving K&R-style functions to the historians. Currently, if you do not want ‘C99’ definitions, then you must use %option noansi-definitions.

* Whenever yylex() is called, it scans tokens from the global input file yyin (which defaults to stdin). It continues until it either reaches an end-of-file (at which point it returns the value 0) or one of its actions executes a return statement.

* If the scanner reaches an end-of-file, subsequent calls are undefined unless either yyin is pointed at a new input file (in which case scanning continues from that file), or yyrestart() is called. yyrestart() takes one argument, a FILE * pointer (which can be NULL, if you've set up YY_INPUT to scan from a source other than yyin), and initializes yyin for scanning from that file. Essentially there is no difference between just assigning yyin to a new input file or using yyrestart() to do so; the latter is available for compatibility with previous versions of flex, and because it can be used to switch input files in the middle of scanning. It can also be used to throw away the current input buffer, by calling it with an argument of yyin; but it would be better to use YY_FLUSH_BUFFER (see Actions). Note that yyrestart() does not reset the start condition to INITIAL (see Start Conditions).

* If yylex() stops scanning due to executing a return statement in one of the actions, the scanner may then be called again and it will resume scanning where it left off.

* By default (and for purposes of efficiency), the scanner uses block-reads rather than simple getc() calls to read characters from yyin. The nature of how it gets its input can be controlled by defining the YY_INPUT macro. The calling sequence for YY_INPUT() is YY_INPUT(buf,result,max_size). Its action is to place up to max_size characters in the character array buf and return in the integer variable result either the number of characters read or the constant YY_NULL (0 on Unix systems) to indicate ‘EOF’. The default YY_INPUT reads from the global file-pointer yyin.

* Here is a sample definition of YY_INPUT (in the definitions section of the input file):

```
         %{
         #define YY_INPUT(buf,result,max_size) \
             { \
             int c = getchar(); \
             result = (c == EOF) ? YY_NULL : (buf[0] = c, 1); \
             }
         %}
```

This definition will change the input processing to occur one character at a time.

When the scanner receives an end-of-file indication from YY_INPUT, it then checks the yywrap() function. If yywrap() returns false (zero), then it is assumed that the function has gone ahead and set up yyin to point to another input file, and scanning continues. If it returns true (non-zero), then the scanner terminates, returning 0 to its caller. Note that in either case, the start condition remains unchanged; it does not revert to INITIAL.

If you do not supply your own version of yywrap(), then you must either use %option noyywrap (in which case the scanner behaves as though yywrap() returned 1), or you must link with ‘-lfl’ to obtain the default version of the routine, which always returns 1.

####8. Start Conditions
flex provides a mechanism for conditionally activating rules. Any rule whose pattern is prefixed with ‘<sc>’ will only be active when the scanner is in the start condition named sc. For example,

```
         <STRING>[^"]*        { /* eat up the string body ... */
                     ...
                     }
```

will be active only when the scanner is in the STRING start condition, and

```
         <INITIAL,STRING,QUOTE>\.        { /* handle an escape ... */
                     ...
                     }
```

will be active only when the current start condition is either INITIAL, STRING, or QUOTE.

Start conditions are declared in the definitions (first) section of the input using unindented lines beginning with either ‘%s’ or ‘%x’ followed by a list of names. The former declares inclusive start conditions, the latter exclusive start conditions. A start condition is activated using the BEGIN action. Until the next BEGIN action is executed, rules with the given start condition will be active and rules with other start conditions will be inactive. If the start condition is inclusive, then rules with no start conditions at all will also be active. If it is exclusive, then only rules qualified with the start condition will be active. A set of rules contingent on the same exclusive start condition describe a scanner which is independent of any of the other rules in the flex input. Because of this, exclusive start conditions make it easy to specify “mini-scanners” which scan portions of the input that are syntactically different from the rest (e.g., comments).

If the distinction between inclusive and exclusive start conditions is still a little vague, here's a simple example illustrating the connection between the two. The set of rules:

```
         %s example
         %%  
         <example>foo   do_something();
         bar            something_else();
```

is equivalent to

```
         %x example
         %%
         <example>foo   do_something();
         <INITIAL,example>bar    something_else();
```

Without the <INITIAL,example> qualifier, the bar pattern in the second example wouldn't be active (i.e., couldn't match) when in start condition example. If we just used <example> to qualify bar, though, then it would only be active in example and not in INITIAL, while in the first example it's active in both, because in the first example the example start condition is an inclusive (%s) start condition.

Also note that the special start-condition specifier <*> matches every start condition. Thus, the above example could also have been written:

```
         %x example
         %%
         <example>foo   do_something();
         <*>bar    something_else();
```

The default rule (to ECHO any unmatched character) remains active in start conditions. It is equivalent to:

```
         <*>.|\n     ECHO;
```

BEGIN(0) returns to the original state where only the rules with no start conditions are active. This state can also be referred to as the start-condition INITIAL, so BEGIN(INITIAL) is equivalent to BEGIN(0). (The parentheses around the start condition name are not required but are considered good style.)

BEGIN actions can also be given as indented code at the beginning of the rules section. For example, the following will cause the scanner to enter the SPECIAL start condition whenever yylex() is called and the global variable enter_special is true:

```
         int enter_special;
     
         %x SPECIAL
         %%
                 if ( enter_special )
                     BEGIN(SPECIAL);
     
         <SPECIAL>blahblahblah
```

####Reference

* [Schalkoff, Programming Languages and Methodologies, Jones and Bartlett Publishers, 2007.](https://www.amazon.com/Programming-Languages-Methodologies-Robert-Schalkoff/dp/0763740594)
