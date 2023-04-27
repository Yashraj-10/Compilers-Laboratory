%{
/*
 Compilers Lab
 Autumn Semester 2022
 Assignment No. 4
 Vikas Vijaykumar Bastewad - 20CS10073
 Yashraj Singh - 20CS10079
*/


/* C Declarations and Definitions */

	#include "y.tab.h" 		// Generated from Bison 
	#include <stdio.h>
	int line = 1;
%}

/* Regular Expression Definitions */

/*------- Keywords ---------------*/
AUTO        "auto"
BREAK		"break"
CASE		"case"
CHAR		"char"
CONST 		"const"
CONTINUE	"continue"
DEFAULT		"default"
DO 			"do"
DOUBLE		"double"
ELSE		"else"
ENUM        "enum"
EXTERN		"extern"
FLOAT		"float"
FOR			"for"
GOTO		"goto"
IF			"if"
INLINE		"inline"	
INT 		"int"
LONG		"long"
REGISTER    "register"
RESTRICT 	"restrict"
RETURN		"return"
SHORT		"short"
SIGNED      "signed"
SIZEOF		"sizeof"
STATIC		"static"
STRUCT		"struct"
SWITCH		"switch"
TYPEDEF		"typedef"
UNION		"union"
UNSIGNED    "unsigned"
VOID		"void"
VOLATILE	"volatile"
WHILE		"while"
BOOL        "_Bool"
COMPLEX     "_Complex"
IMAGINARY   "_Imaginary"

/*--------Identifier-----------------*/
ID 			[a-zA-Z_][a-zA-Z0-9_]*

/*--------Integer Constant-----------*/
INT_CONST   0+|[1-9][0-9]*

/*--------Floating Point Constant----*/
FLT_CONST   {FRACTION}{EXPONENT}?|{DIGIT}{EXPONENT}
EXPONENT	[eE][+-]?{DIGIT}
FRACTION 	({DIGIT}?\.{DIGIT})|({DIGIT}\.)
DIGIT		[0-9]+

/*-------Character Constant----------*/
CHAR_CONST	'{CHAR_SEQ}'
CHAR_SEQ	{C_CHAR}+
C_CHAR		{SRC_SET}|{ESC_SEQ}
SRC_SET		[^("\'"|"\\"|"\n")]

/*-------Enumeration Constant--------*/
ENUM_CONST  {ID}

/*-------String Literal--------------*/
STRING		\"{STR_SEQ}?\"
STR_SEQ		{STR_CHAR}+
STR_CHAR	{ESC_SEQ}|{STR_SET}
STR_SET		[^("\""|"\\"|"\n")]

ESC_SEQ 	\\a|\\b|\\f|\\n|\\t|\\r|\\v|\\\'|\\\"|\\\\|\\\?

/*---------Punctuation---------------*/

BRACKET 	"["|"]"|"{"|"}"|"("|")"
UNARY_OP 	"++"|"--"
PUNC     	"<<="|">>="|"<<"|">>"|"<="|">="|"=="|"!="|"&&"|"||"|"<"|">"|"&"|"|"|"="|"*="|"/="|"%="|"+="|"-="|"|="|"&="|"^="|"->"|"^"|"..."|"."|"*"|"+"|"-"|"~"|"!"|"/"|"%"|"?"|":"|","|"#"|";"


/*---------Whitespace,Tab,New Line Character-----------*/
WS			[ \t]
NL			[\n]


%x single_line_comment multi_line_comment

%%

"//"			{BEGIN(single_line_comment);}
<single_line_comment>[^\n]	{}
<single_line_comment>"\n"		{BEGIN(INITIAL);}
<single_line_comment><<EOF>>	{BEGIN(INITIAL);}

"/*"			{BEGIN(multi_line_comment);}
<multi_line_comment>[^*]	{}
<multi_line_comment>"*"[^/]	{}
<multi_line_comment>"*/"	{BEGIN(INITIAL);}

{AUTO}      return AUTO;
{BREAK}		return BREAK;
{CASE}		return CASE;
{CHAR}		return CHAR;
{CONST}		return CONST;
{CONTINUE}	return CONTINUE;
{DEFAULT}	return DEFAULT;
{DO}		return DO;
{DOUBLE}	return DOUBLE;
{ELSE}		return ELSE;
{ENUM}      return ENUM;
{EXTERN}	return EXTERN;
{FLOAT}		return FLOAT;
{FOR}		return FOR;
{GOTO}		return GOTO;
{IF}		return IF;
{INLINE} 	return INLINE;
{INT}		return INT;
{LONG}		return LONG;
{REGISTER}  return REGISTER;
{RESTRICT} 	return RESTRICT;
{RETURN}	return RETURN;
{SIGNED}    return SIGNED;
{SHORT}		return SHORT;
{SIZEOF}	return SIZEOF;
{STATIC}	return STATIC;
{STRUCT}	return STRUCT;
{SWITCH}	return SWITCH;
{TYPEDEF}	return TYPEDEF;
{UNION}		return UNION;
{UNSIGNED}  return UNSIGNED;
{VOID}		return VOID;
{VOLATILE} 	return VOLATILE;
{WHILE}		return WHILE;
{BOOL}      return BOOL;
{COMPLEX}   return COMPLEX;
{IMAGINARY} return IMAGINARY;

{ID}		return IDENTIFIER;

{INT_CONST}	return INTEGER_CONSTANT;
{FLT_CONST} return FLOATING_CONSTANT;
{CHAR_CONST}return CHARACTER_CONSTANT;
{ENUM_CONST}return ENUM_CONSTANT;

{STRING}	return STRING_LITERAL;

{BRACKET}	{
			if(strcmp(yytext,"[") == 0) 
				return SQUARE_BRACKET_OPEN;
			if(strcmp(yytext,"]") == 0) 
				return SQUARE_BRACKET_CLOSE;
			if(strcmp(yytext,"(") == 0) 
				return ROUND_BRACKET_OPEN;
			if(strcmp(yytext,")") == 0) 
				return ROUND_BRACKET_CLOSE;
			if(strcmp(yytext,"{") == 0) 
				return CURLY_BRACKET_OPEN;
			if(strcmp(yytext,"}") == 0) 
				return CURLY_BRACKET_CLOSE;
			}

{UNARY_OP}	{
			if(strcmp(yytext,"++") == 0) 
				return UNARY_INCREMENT;
			if(strcmp(yytext,"--") == 0) 
				return UNARY_DECREMENT;
			}

{PUNC}		{
			if(strcmp(yytext,"<<=") == 0) 
				return BITWISE_LEFT_ASSIGN;
			if(strcmp(yytext,">>=") == 0) 
				return BITWISE_RIGHT_ASSIGN;
			if(strcmp(yytext,"<<") == 0) 
				return BITWISE_LEFT;
			if(strcmp(yytext,">>") == 0) 
				return BITWISE_RIGHT;
			if(strcmp(yytext,"<=") == 0) 
				return LESS_EQUAL;
			if(strcmp(yytext,">=") == 0) 
				return GREATER_EQUAL;
			if(strcmp(yytext,"==") == 0) 
				return EQUAL;
			if(strcmp(yytext,"<") == 0) 
				return LESS_THAN;
			if(strcmp(yytext,">") == 0) 
				return GREATER_THAN;
			if(strcmp(yytext,"!=") == 0) 
				return NOT_EQUAL;
			if(strcmp(yytext,"&&") == 0) 
				return LOGICAL_AND;
			if(strcmp(yytext,"||") == 0) 
				return LOGICAL_OR;
			if(strcmp(yytext,"&") == 0) 
				return BITWISE_AND;
			if(strcmp(yytext,"|") == 0) 
				return BITWISE_OR;
			if(strcmp(yytext,"=") == 0) 
				return ASSIGN;
			if(strcmp(yytext,"*=") == 0) 
				return MUL_ASSIGN;
			if(strcmp(yytext,"/=") == 0) 
				return DIV_ASSIGN;
			if(strcmp(yytext,"%=") == 0) 
				return MOD_ASSIGN;
			if(strcmp(yytext,"+=") == 0) 
				return PLUS_ASSIGN;
			if(strcmp(yytext,"-=") == 0) 
				return MINUS_ASSIGN;
			if(strcmp(yytext,"|=") == 0) 
				return BITWISE_OR_ASSIGN;
			if(strcmp(yytext,"&=") == 0) 
				return BITWISE_AND_ASSIGN;
			if(strcmp(yytext,"^=") == 0) 
				return XOR_ASSIGN;
			if(strcmp(yytext,"->") == 0) 
				return IMPLIES;
			if(strcmp(yytext,"^") == 0) 
				return XOR;
			if(strcmp(yytext,"...") == 0) 
				return DOTS;
			if(strcmp(yytext,".") == 0) 
				return DOT;
			if(strcmp(yytext,"*") == 0) 
				return MUL;
			if(strcmp(yytext,"+") == 0) 
				return PLUS;
			if(strcmp(yytext,"-") == 0) 
				return MINUS;
			if(strcmp(yytext,"~") == 0) 
				return COMPLEMENT;
			if(strcmp(yytext,"!") == 0) 
				return NOT;
			if(strcmp(yytext,"/") == 0) 
				return DIV;
			if(strcmp(yytext,"%") == 0) 
				return MOD;
			if(strcmp(yytext,"?") == 0) 
				return QUES_MARK;
			if(strcmp(yytext,":") == 0) 
				return COLON;
			if(strcmp(yytext,",") == 0) 
				return COMMA;
			if(strcmp(yytext,"#") == 0) 
				return HASH;
			if(strcmp(yytext,";") == 0) 
				return SEMICOLON;
			}

{WS} 		{}

{NL}		{line++;}

%%