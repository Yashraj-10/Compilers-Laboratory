#include<stdio.h>
#include "head.h"

extern int yylex();
extern char* yytext;
extern int yyline;

int main(){
    int ntoken;
    do{
        ntoken= yylex();
        if(ntoken==0){
            break;
        }
        if(ntoken==KEYWORD){                                                    // KEYWORD
            printf("<KEYWORD, %s> ", yytext); 
        }
        else if(ntoken==IDENTIFIER){                                            // IDENTIFIER
            printf("<IDENTIFIER, %s> ", yytext); 
        }
        else if(ntoken==INTEGER_CONSTANT){                                      // INTEGER CONSTANT
            printf("<INTEGER CONSTANT, %s> ", yytext);
        }
        else if(ntoken==FLOATING_CONSTANT){                                     // FLOATING CONSTANT
            printf("<FLOATING CONSTANT, %s> ", yytext);
        }
        else if(ntoken==ENUMERATION_CONSTANT){                                  // ENUMERATION CONSTANT
            printf("<ENUMERATION CONSTANT, %s> ", yytext);
        }
        else if(ntoken==CHARACTER_CONSTANT){                                    // CHARACTER CONSTANT
            printf("<CHARACTER CONSTANT, %s> ", yytext);
        }
        else if(ntoken==STRING_LITERAL){                                        // STRING LITERAL
            printf("<STRING_LITERAL, %s> ", yytext);
        }
        else if(ntoken==PUNCTUATOR){                                            // PUNCTUATOR
            printf("<PUNCTUATION, %s> ", yytext);
        }
        else if(ntoken==MULTI_LINE_COMMENT){                                    // MULTI LINE COMMENT
            printf("<MULTI LINE COMMENT, %s> ", yytext);
        }
        else if(ntoken==SINGLE_LINE_COMMENT){                                   // SINGLE LINE COMMENT
            printf("<SINGLE LINE COMMENT, %s> ", yytext);
        }
        else if (ntoken==NEWLINE){
            printf("\n");
        }
        else if (ntoken==ERROR){
            printf("<INVALID TOKEN, %s>",yytext);
        }
        else if (ntoken==WHITESPACE){
            ;
        }
    }
    while(1);

    return 0;
}
int yywrap(void){
    return (1);
}