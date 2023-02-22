%{
    #include<stdio.h>
    #include "head.h"
%}


DIGIT                   [0-9]
DIGIT_SEQUENCE          {DIGIT}+
NONZERO_DIGIT           [1-9]

FRACTIONAL_CONSTANT     ({DIGIT_SEQUENCE}\.)|({DIGIT_SEQUENCE}?\.{DIGIT_SEQUENCE})       
EXPONENT_PART           [eE]([+-]?){DIGIT_SEQUENCE}
FLOATING_CONSTANT       {FRACTIONAL_CONSTANT}?{EXPONENT_PART}

ESCAPE_SEQUENCE         "\\\'"|"\\\""|"\\?"|"\\\\"|"\\a"|"\\b"|"\\f"|"\\n"|"\\r"|"\\t"|"\\v"
C_CHAR                  [^\'\n\\]|{ESCAPE_SEQUENCE}
C_CHAR_SEQUENCE         {C_CHAR}+

ENUMERATION_CONSTANT    [a-zA-Z][_a-zA-Z0-9]*

S_CHAR                  [^\"\n\\]|{ESCAPE_SEQUENCE}
S_CHAR_SEQUENCE         {S_CHAR}+

PUNCTUATOR              "["|"]"|"("|")"|"{"|"}"|"."|"->"|"++"|"--"|"&"|"*"|"+"|"-"|"~"|"!"|"/"|"%"|"<<"|">>"|"<"|">"|"<="|">="|"=="|"!="|"^"|"|"|"&&"|"||"|"?"|":"|";"|"..."|"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|="|","|"#"
KEYWORD                 "auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"inline"|"int"|"long"|"register"|"restrict"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while"|"_Bool"|"_Complex"|"_Imaginary"

SINGLE_LINE_COMMENT     {BACKSLASHES}.*
BACKSLASHES             "//"

MULTI_LINE_COMMENT      {START}{STRING1}{END}
START                   "/*"
END                     "*/"
STRING1                 [^*]|{STRING2}
STRING2                 [*][^*/]
%%

{KEYWORD}                                                                       return KEYWORD;                 

[a-zA-Z][_a-zA-Z0-9]*                                                           return IDENTIFIER;

[1-9][0-9]*                                                                     return INTEGER_CONSTANT;

{FLOATING_CONSTANT}                                                             return FLOATING_CONSTANT;

\'{C_CHAR_SEQUENCE}\'                                                           return CHARACTER_CONSTANT;

{ENUMERATION_CONSTANT}                                                          return ENUMERATION_CONSTANT;

\"({S_CHAR_SEQUENCE}?)\"                                                        return STRING_LITERAL;

{PUNCTUATOR}                                                                    return PUNCTUATOR;

{MULTI_LINE_COMMENT}                                                            return MULTI_LINE_COMMENT;

{SINGLE_LINE_COMMENT}                                                           return SINGLE_LINE_COMMENT; 

[ \t]                                                                           return WHITESPACE;

[\n]                                                                            return NEWLINE;

.                                                                               return ERROR;

%%
