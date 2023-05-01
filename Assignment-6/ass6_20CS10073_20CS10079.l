/* Compilers Laboratory                     */
/* Assignment 6                             */
/*                                          */
/* Yashraj Singh (20CS10079)                */
/* Vikas Vijayakumar Bastewad (20CS10073)   */
/*                                          */
/* lexeme generator for the tinyC language  */
/* C Declarations and Definitions           */
%{  

    #include <stdio.h>
    #include "ass6_20CS10073_20CS10079_translator.h"
    #include "ass6_20CS10073_20CS10079.tab.h"
    extern "C" int yylex(void);
%}

%option yylineno
%option noyywrap

%x SINGLE_LINE_COMMENT
%x MULTI_LINE_COMMENT

/* Regular Expression Definitions */

IDENTIFIER                      [_a-zA-Z][_a-zA-Z0-9]*

INTEGER_CONSTANT                [1-9][0-9]*|[0]

DIGIT_SEQUENCE                  [0-9]+
EXPONENT_PART                   [eE]([+-]?){DIGIT_SEQUENCE}
FRACTIONAL_CONSTANT             ({DIGIT_SEQUENCE}?\.{DIGIT_SEQUENCE})|({DIGIT_SEQUENCE}\.)
FLOATING_CONSTANT               ({FRACTIONAL_CONSTANT}{EXPONENT_PART}?)|({DIGIT_SEQUENCE}{EXPONENT_PART})

ENUM_CONSTANT                   {IDENTIFIER}

ESCAPE_SEQUENCE                 \\['"?\\abfnrtv]
C_CHAR                          [^\'\\\n]|{ESCAPE_SEQUENCE}
C_CHAR_SEQUENCE                 {C_CHAR}+
CHAR_CONSTANT                   \'({C_CHAR_SEQUENCE})\'

CONSTANT                        {INTEGER_CONSTANT}|{FLOATING_CONSTANT}|{ENUM_CONSTANT}|{CHAR_CONSTANT}

S_CHAR                          [^\"\\\n]|{ESCAPE_SEQUENCE}
S_CHAR_SEQUENCE                 {S_CHAR}+
STRING_LITERAL                  \"({S_CHAR_SEQUENCE}?)\"

WS                              [ \t\n]

/* Definitions */
%%

"//"                            { BEGIN(SINGLE_LINE_COMMENT); }
<SINGLE_LINE_COMMENT>.          {}
<SINGLE_LINE_COMMENT>\n         { BEGIN(INITIAL); }
<SINGLE_LINE_COMMENT><<EOF>>    { BEGIN(INITIAL); }

"/*"                            { BEGIN(MULTI_LINE_COMMENT); }
<MULTI_LINE_COMMENT>"*/"        { BEGIN(INITIAL); }
<MULTI_LINE_COMMENT>.           {}
<MULTI_LINE_COMMENT>\n          {}

"auto"                          { return AUTO; }
"break"                         { return BREAK; }
"case"                          { return CASE; }
"char"                          { return CHAR_; }
"const"                         { return CONST; }
"continue"                      { return CONTINUE; }
"default"                       { return DEFAULT; }
"do"                            { return DO; }
"double"                        { return DOUBLE; }
"else"                          { return ELSE; }
"enum"                          { return ENUM; }             
"extern"                        { return EXTERN; }
"float"                         { return FLOAT_; }
"for"                           { return FOR; }
"goto"                          { return GOTO_; }
"if"                            { return IF; }
"inline"                        { return INLINE; }
"int"                           { return INT_; }
"long"                          { return LONG; }
"register"                      { return REGISTER; }
"restrict"                      { return RESTRICT; }
"return"                        { return RETURN_; }
"short"                         { return SHORT; }
"signed"                        { return SIGNED; }
"sizeof"                        { return SIZEOF; }
"static"                        { return STATIC; }
"struct"                        { return STRUCT; }
"switch"                        { return SWITCH; }
"typedef"                       { return TYPEDEF; }
"union"                         { return UNION; }
"unsigned"                      { return UNSIGNED; }
"void"                          { return VOID_; }
"volatile"                      { return VOLATILE; }
"while"                         { return WHILE; }
"_Bool"                         { return BOOL_; }
"_Complex"                      { return COMPLEX; }
"_Imaginary"                    { return IMAGINARY; }

"["                             { return SQUARE_BRACE_OPEN; }
"]"                             { return SQUARE_BRACE_CLOSE; }
"("                             { return PARENTHESIS_OPEN; }
")"                             { return PARENTHESIS_CLOSE; }
"{"                             { return CURLY_BRACE_OPEN; }
"}"                             { return CURLY_BRACE_CLOSE; }
"."                             { return DOT; }
"->"                            { return ARROW; }
"++"                            { return INCREMENT; }
"--"                            { return DECREMENT; }
"&"                             { return BITWISE_AND; }
"*"                             { return MULTIPLY; }
"+"                             { return ADD_; }
"-"                             { return SUBTRACT; }
"~"                             { return BITWISE_NOR; }
"!"                             { return NOT; }
"/"                             { return DIVIDE; }
"%"                             { return MODULO; }
"<<"                            { return LSHIFT; }
">>"                            { return RSHIFT; }
"<"                             { return LESS_THAN; }
">"                             { return GREATER_THAN; }
"<="                            { return LESS_THAN_EQUAL; }
">="                            { return GREATER_THAN_EQUAL; }
"=="                            { return EQUAL; }
"!="                            { return NOT_EQUAL; }
"^"                             { return BITWISE_XOR; }
"|"                             { return BITWISE_OR; }
"&&"                            { return LOGICAL_AND; }
"||"                            { return LOGICAL_OR; }
"?"                             { return QUESTION_MARK; }
":"                             { return COLON; }
";"                             { return SEMICOLON; }
"..."                           { return ELLIPSIS; }
"="                             { return ASSIGN_; }
"*="                            { return MULTIPLY_ASSIGN; }
"/="                            { return DIVIDE_ASSIGN; }
"%="                            { return MODULO_ASSIGN; }
"+="                            { return ADD_ASSIGN; }
"-="                            { return SUBTRACT_ASSIGN; }
"<<="                           { return LSHIFT_ASSIGN; }
">>="                           { return RSHIFT_ASSIGN; }
"&="                            { return AND_ASSIGN; }
"^="                            { return XOR_ASSIGN; }
"|="                            { return OR_ASSIGN; }
","                             { return COMMA; }
"#"                             { return HASH; }

{IDENTIFIER}                    { yylval.str = new string(yytext); return IDENTIFIER; }
{INTEGER_CONSTANT}              { yylval.intval = atoi(yytext); return INTEGER_CONSTANT; }
{FLOATING_CONSTANT}             { yylval.floatval = atof(yytext); return FLOATING_CONSTANT; }
{CHAR_CONSTANT}                 { yylval.charval = yytext[1]; return CHAR_CONSTANT; }
{STRING_LITERAL}                { yylval.str = new string(yytext); return STRING_LITERAL; }
{WS}                            {}

%%
