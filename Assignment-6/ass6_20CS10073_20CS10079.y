%{
    // Compilers Laboratory
    // Assignment 6
    //
    // Yashraj Singh (20CS10079)
    // Vikas Vijayakumar Bastewad (20CS10073)
    //
    // specification for the parser

    #include <iostream>
    #include "ass6_20CS10073_20CS10079_translator.h"
    using namespace std;

    extern "C" int yylex();                     
    void yyerror(string s);                 
    extern char* yytext;                    
    extern int yylineno;                    

    extern int nextinstr;                   
    extern quadArray quadList;              
    extern symbolTable globalST;            
    extern symbolTable* ST;                 
    extern vector<string> stringConsts;     

    int strCount = 0;                       
%}

%union {
    int intval;                     
    char charval;                   
    float floatval;                 
    void* ptr;                      
    string* str;                    
    symbolType* symType;            
    symbol* symp;                   
    DataType types;                 
    opcode opc;                     
    expression* expr;               
    declaration* dec;               
    vector<declaration*> *decList;  
    param* prm;                     
    vector<param*> *prmList;        
}

/*
    All tokens
*/
%token AUTO BREAK CASE CHAR_ CONST CONTINUE DEFAULT DO DOUBLE ELSE ENUM EXTERN FLOAT_ FOR GOTO_ IF INLINE INT_ LONG REGISTER RESTRICT RETURN_ SHORT SIGNED SIZEOF STATIC STRUCT SWITCH TYPEDEF UNION UNSIGNED VOID_ VOLATILE WHILE BOOL_ COMPLEX IMAGINARY
%token SQUARE_BRACE_OPEN SQUARE_BRACE_CLOSE PARENTHESIS_OPEN PARENTHESIS_CLOSE CURLY_BRACE_OPEN CURLY_BRACE_CLOSE 
%token DOT ARROW INCREMENT DECREMENT BITWISE_AND MULTIPLY ADD_ SUBTRACT BITWISE_NOR NOT DIVIDE MODULO 
%token LSHIFT RSHIFT LESS_THAN GREATER_THAN LESS_THAN_EQUAL GREATER_THAN_EQUAL EQUAL NOT_EQUAL BITWISE_XOR BITWISE_OR 
%token LOGICAL_AND LOGICAL_OR QUESTION_MARK COLON SEMICOLON ELLIPSIS 
%token ASSIGN_ MULTIPLY_ASSIGN DIVIDE_ASSIGN MODULO_ASSIGN ADD_ASSIGN SUBTRACT_ASSIGN LSHIFT_ASSIGN RSHIFT_ASSIGN AND_ASSIGN XOR_ASSIGN OR_ASSIGN COMMA HASH


%token <str> IDENTIFIER


%token <intval> INTEGER_CONSTANT


%token <floatval> FLOATING_CONSTANT


%token <charval> CHAR_CONSTANT


%token <str> STRING_LITERAL


%type <expr> 
        expression
        primary_expression 
        multiplicative_expression
        additive_expression
        shift_expression
        relational_expression
        equality_expression
        and_expression
        exclusive_or_expression
        inclusive_or_expression
        logical_and_expression
        logical_or_expression
        conditional_expression
        assignment_expression
        postfix_expression
        unary_expression
        cast_expression
        expression_statement
        statement
        compound_statement
        selection_statement
        iteration_statement
        labeled_statement 
        jump_statement
        block_item
        block_item_list
        initializer
        M
        N


%type <charval> unary_operator


%type <intval> pointer


%type <types> type_specifier declaration_specifiers


%type <dec> direct_declarator initializer_list init_declarator declarator function_prototype


%type <decList> init_declarator_list


%type <prm> parameter_declaration


%type <prmList> parameter_list parameter_type_list parameter_type_list_opt argument_expression_list


%expect 1
%nonassoc ELSE


%start translation_unit

%%

primary_expression: 
        IDENTIFIER
        {
            $$ = new expression();  
            string s = *($1);
            ST->lookup(s);          
            $$->loc = s;            
        }
        | INTEGER_CONSTANT
        {
            $$ = new expression();                  
            $$->loc = ST->gentemp(INT);             
            emit($$->loc, $1, ASSIGN);
            symbolValue* val = new symbolValue();
            val->setInitVal($1);                    
            ST->lookup($$->loc)->initVal = val;     
        }
        | FLOATING_CONSTANT
        {
            $$ = new expression();                  
            $$->loc = ST->gentemp(FLOAT);           
            emit($$->loc, $1, ASSIGN);
            symbolValue* val = new symbolValue();
            val->setInitVal($1);                    
            ST->lookup($$->loc)->initVal = val;     
        }
        | CHAR_CONSTANT
        {
            $$ = new expression();                  
            $$->loc = ST->gentemp(CHAR);            
            emit($$->loc, $1, ASSIGN);
            symbolValue* val = new symbolValue();
            val->setInitVal($1);                    
            ST->lookup($$->loc)->initVal = val;     
        }
        | STRING_LITERAL
        {
            $$ = new expression();                  
            $$->loc = ".LC" + to_string(strCount++);
            stringConsts.push_back(*($1));          
        }
        | PARENTHESIS_OPEN expression PARENTHESIS_CLOSE
        {
            $$ = $2;                                
        }
        ;

postfix_expression: 
        primary_expression
        {}
        | postfix_expression SQUARE_BRACE_OPEN expression SQUARE_BRACE_CLOSE
        {
            symbolType to = ST->lookup($1->loc)->type;      
            string f = "";
            if(!($1->fold)) {
                f = ST->gentemp(INT);                       
                emit(f, 0, ASSIGN);
                $1->folder = new string(f);
            }
            string temp = ST->gentemp(INT);

            
            emit(temp, $3->loc, "", ASSIGN);
            emit(temp, temp, "4", MULT);
            emit(f, temp, "", ASSIGN);
            $$ = $1;
        }
        | postfix_expression PARENTHESIS_OPEN PARENTHESIS_CLOSE
        {   
            
            symbolTable* funcTable = globalST.lookup($1->loc)->nestedTable;
            emit($1->loc, "0", "", CALL);
        }
        | postfix_expression PARENTHESIS_OPEN argument_expression_list PARENTHESIS_CLOSE
        {   
            
            symbolTable* funcTable = globalST.lookup($1->loc)->nestedTable;
            vector<param*> parameters = *($3);                          
            vector<symbol*> paramsList = funcTable->symbols;

            for(int i = 0; i < (int)parameters.size(); i++) {
                emit(parameters[i]->name, "", "", PARAM);               
            }

            DataType retType = funcTable->lookup("RETVAL")->type.type;  
            if(retType == VOID)                                         
                emit($1->loc, (int)parameters.size(), CALL);
            else {                                                      
                string retVal = ST->gentemp(retType);
                emit($1->loc, to_string(parameters.size()), retVal, CALL);
                $$ = new expression();
                $$->loc = retVal;
            }
        }
        | postfix_expression DOT IDENTIFIER
        {}
        | postfix_expression ARROW IDENTIFIER
        {}
        | postfix_expression INCREMENT
        {   
            $$ = new expression();                                          
            symbolType t = ST->lookup($1->loc)->type;                       
            if(t.type == ARRAY) {
                $$->loc = ST->gentemp(ST->lookup($1->loc)->type.nextType);
                emit($$->loc, $1->loc, *($1->folder), ARR_IDX_ARG);
                string temp = ST->gentemp(t.nextType);
                emit(temp, $1->loc, *($1->folder), ARR_IDX_ARG);
                emit(temp, temp, "1", ADD);
                emit($1->loc, temp, *($1->folder), ARR_IDX_RES);
            }
            else {
                $$->loc = ST->gentemp(ST->lookup($1->loc)->type.type);
                emit($$->loc, $1->loc, "", ASSIGN);                         
                emit($1->loc, $1->loc, "1", ADD);                           
            }
        }
        | postfix_expression DECREMENT
        {
            $$ = new expression();                                          
            $$->loc = ST->gentemp(ST->lookup($1->loc)->type.type);          
            symbolType t = ST->lookup($1->loc)->type;
            if(t.type == ARRAY) {
                $$->loc = ST->gentemp(ST->lookup($1->loc)->type.nextType);
                string temp = ST->gentemp(t.nextType);
                emit(temp, $1->loc, *($1->folder), ARR_IDX_ARG);
                emit($$->loc, temp, "", ASSIGN);
                emit(temp, temp, "1", SUB);
                emit($1->loc, temp, *($1->folder), ARR_IDX_RES);
            }
            else {
                $$->loc = ST->gentemp(ST->lookup($1->loc)->type.type);
                emit($$->loc, $1->loc, "", ASSIGN);                         
                emit($1->loc, $1->loc, "1", SUB);                           
            }
        }
        | PARENTHESIS_OPEN type_name PARENTHESIS_CLOSE CURLY_BRACE_OPEN initializer_list CURLY_BRACE_CLOSE
        {}
        | PARENTHESIS_OPEN type_name PARENTHESIS_CLOSE CURLY_BRACE_OPEN initializer_list COMMA CURLY_BRACE_CLOSE
        {}
        ;

argument_expression_list: 
        assignment_expression
        {
            param* first = new param();                 
            first->name = $1->loc;
            first->type = ST->lookup($1->loc)->type;
            $$ = new vector<param*>;
            $$->push_back(first);                       
        }
        | argument_expression_list COMMA assignment_expression
        {
            param* next = new param();                  
            next->name = $3->loc;
            next->type = ST->lookup(next->name)->type;
            $$ = $1;
            $$->push_back(next);                        
        }
        ;

unary_expression: 
        postfix_expression
        {}
        | INCREMENT unary_expression
        {
            $$ = new expression();
            symbolType type = ST->lookup($2->loc)->type;
            if(type.type == ARRAY) {
                string t = ST->gentemp(type.nextType);
                emit(t, $2->loc, *($2->folder), ARR_IDX_ARG);
                emit(t, t, "1", ADD);
                emit($2->loc, t, *($2->folder), ARR_IDX_RES);
                $$->loc = ST->gentemp(ST->lookup($2->loc)->type.nextType);
            }
            else {
                emit($2->loc, $2->loc, "1", ADD);                       
                $$->loc = ST->gentemp(ST->lookup($2->loc)->type.type);
            }
            $$->loc = ST->gentemp(ST->lookup($2->loc)->type.type);
            emit($$->loc, $2->loc, "", ASSIGN);                         
        }
        | DECREMENT unary_expression
        {
            $$ = new expression();
            symbolType type = ST->lookup($2->loc)->type;
            if(type.type == ARRAY) {
                string t = ST->gentemp(type.nextType);
                emit(t, $2->loc, *($2->folder), ARR_IDX_ARG);
                emit(t, t, "1", SUB);
                emit($2->loc, t, *($2->folder), ARR_IDX_RES);
                $$->loc = ST->gentemp(ST->lookup($2->loc)->type.nextType);
            }
            else {
                emit($2->loc, $2->loc, "1", SUB);                       
                $$->loc = ST->gentemp(ST->lookup($2->loc)->type.type);
            }
            emit($$->loc, $2->loc, "", ASSIGN);                         
        }
        | unary_operator cast_expression
        {
            
            switch($1) {
                case '&':   
                    $$ = new expression();
                    $$->loc = ST->gentemp(POINTER);                 
                    emit($$->loc, $2->loc, "", REFERENCE);          
                    break;
                case '*':   
                    $$ = new expression();
                    $$->loc = ST->gentemp(INT);                     
                    $$->fold = 1;
                    $$->folder = new string($2->loc);
                    emit($$->loc, $2->loc, "", DEREFERENCE);        
                    break;
                case '-':   
                    $$ = new expression();
                    $$->loc = ST->gentemp();                        
                    emit($$->loc, $2->loc, "", U_MINUS);            
                    break;
                case '!':   
                    $$ = new expression();
                    $$->loc = ST->gentemp(INT);                     
                    int temp = nextinstr + 2;
                    emit(to_string(temp), $2->loc, "0", GOTO_EQ);   
                    temp = nextinstr + 3;
                    emit(to_string(temp), "", "", GOTO);
                    emit($$->loc, "1", "", ASSIGN);
                    temp = nextinstr + 2;
                    emit(to_string(temp), "", "", GOTO);
                    emit($$->loc, "0", "", ASSIGN);
                    break;
            }
        }
        | SIZEOF unary_expression
        {}
        | SIZEOF PARENTHESIS_OPEN type_name PARENTHESIS_CLOSE
        {}
        ;

unary_operator:
        BITWISE_AND
        {
            $$ = '&';
        }
        | MULTIPLY
        {
            $$ = '*';
        }
        | ADD_
        {
            $$ = '+';
        }
        | SUBTRACT
        {
            $$ = '-';
        }
        | BITWISE_NOR
        {
            $$ = '~';
        }
        | NOT
        {
            $$ = '!';
        }
        ;

cast_expression: 
        unary_expression
        {}
        | PARENTHESIS_OPEN type_name PARENTHESIS_CLOSE cast_expression
        {}
        ;

multiplicative_expression: 
        cast_expression
        {
            $$ = new expression();                                  
            symbolType tp = ST->lookup($1->loc)->type;
            if(tp.type == ARRAY) {                                  
                string t = ST->gentemp(tp.nextType);                
                if($1->folder != NULL) {
                    emit(t, $1->loc, *($1->folder), ARR_IDX_ARG);   
                    $1->loc = t;
                    $1->type = tp.nextType;
                    $$ = $1;
                }
                else
                    $$ = $1;        
            }
            else
                $$ = $1;            
        }
        | multiplicative_expression MULTIPLY cast_expression
        {   
            
            $$ = new expression();
            symbol* one = ST->lookup($1->loc);                  
            symbol* two = ST->lookup($3->loc);                  
            if(two->type.type == ARRAY) {                       
                string t = ST->gentemp(two->type.nextType);
                emit(t, $3->loc, *($3->folder), ARR_IDX_ARG);
                $3->loc = t;
                $3->type = two->type.nextType;
            }
            if(one->type.type == ARRAY) {                       
                string t = ST->gentemp(one->type.nextType);
                emit(t, $1->loc, *($1->folder), ARR_IDX_ARG);
                $1->loc = t;
                $1->type = one->type.nextType;
            }

            
            DataType final = ((one->type.type > two->type.type) ? (one->type.type) : (two->type.type));
            $$->loc = ST->gentemp(final);                       
            emit($$->loc, $1->loc, $3->loc, MULT);
        }
        | multiplicative_expression DIVIDE cast_expression
        {
            
            $$ = new expression();
            symbol* one = ST->lookup($1->loc);                  
            symbol* two = ST->lookup($3->loc);                  
            if(two->type.type == ARRAY) {                       
                string t = ST->gentemp(two->type.nextType);
                emit(t, $3->loc, *($3->folder), ARR_IDX_ARG);
                $3->loc = t;
                $3->type = two->type.nextType;
            }
            if(one->type.type == ARRAY) {                       
                string t = ST->gentemp(one->type.nextType);
                emit(t, $1->loc, *($1->folder), ARR_IDX_ARG);
                $1->loc = t;
                $1->type = one->type.nextType;
            }

            
            DataType final = ((one->type.type > two->type.type) ? (one->type.type) : (two->type.type));
            $$->loc = ST->gentemp(final);                       
            emit($$->loc, $1->loc, $3->loc, DIV);
        }
        | multiplicative_expression MODULO cast_expression
        {
            
            $$ = new expression();
            symbol* one = ST->lookup($1->loc);                  
            symbol* two = ST->lookup($3->loc);                  
            if(two->type.type == ARRAY) {                       
                string t = ST->gentemp(two->type.nextType);
                emit(t, $3->loc, *($3->folder), ARR_IDX_ARG);
                $3->loc = t;
                $3->type = two->type.nextType;
            }
            if(one->type.type == ARRAY) {                       
                string t = ST->gentemp(one->type.nextType);
                emit(t, $1->loc, *($1->folder), ARR_IDX_ARG);
                $1->loc = t;
                $1->type = one->type.nextType;
            }

            
            DataType final = ((one->type.type > two->type.type) ? (one->type.type) : (two->type.type));
            $$->loc = ST->gentemp(final);                       
            emit($$->loc, $1->loc, $3->loc, MOD);
        }
        ;

additive_expression: 
        multiplicative_expression
        {}
        | additive_expression ADD_ multiplicative_expression
        {   
            
            $$ = new expression();
            symbol* one = ST->lookup($1->loc);                  
            symbol* two = ST->lookup($3->loc);                  
            if(two->type.type == ARRAY) {                       
                string t = ST->gentemp(two->type.nextType);
                emit(t, $3->loc, *($3->folder), ARR_IDX_ARG);
                $3->loc = t;
                $3->type = two->type.nextType;
            }
            if(one->type.type == ARRAY) {                       
                string t = ST->gentemp(one->type.nextType);
                emit(t, $1->loc, *($1->folder), ARR_IDX_ARG);
                $1->loc = t;
                $1->type = one->type.nextType;
            }

            
            DataType final = ((one->type.type > two->type.type) ? (one->type.type) : (two->type.type));
            $$->loc = ST->gentemp(final);                       
            emit($$->loc, $1->loc, $3->loc, ADD);
        }
        | additive_expression SUBTRACT multiplicative_expression
        {
            
            $$ = new expression();
            symbol* one = ST->lookup($1->loc);                  
            symbol* two = ST->lookup($3->loc);                  
            if(two->type.type == ARRAY) {                       
                string t = ST->gentemp(two->type.nextType);
                emit(t, $3->loc, *($3->folder), ARR_IDX_ARG);
                $3->loc = t;
                $3->type = two->type.nextType;
            }
            if(one->type.type == ARRAY) {                       
                string t = ST->gentemp(one->type.nextType);
                emit(t, $1->loc, *($1->folder), ARR_IDX_ARG);
                $1->loc = t;
                $1->type = one->type.nextType;
            }

            
            DataType final = ((one->type.type > two->type.type) ? (one->type.type) : (two->type.type));
            $$->loc = ST->gentemp(final);                       
            emit($$->loc, $1->loc, $3->loc, SUB);
        }
        ;

shift_expression: 
        additive_expression
        {}
        | shift_expression LSHIFT additive_expression
        {
            
            $$ = new expression();
            symbol* one = ST->lookup($1->loc);                  
            symbol* two = ST->lookup($3->loc);                  
            if(two->type.type == ARRAY) {                       
                string t = ST->gentemp(two->type.nextType);
                emit(t, $3->loc, *($3->folder), ARR_IDX_ARG);
                $3->loc = t;
                $3->type = two->type.nextType;
            }
            if(one->type.type == ARRAY) {                       
                string t = ST->gentemp(one->type.nextType);
                emit(t, $1->loc, *($1->folder), ARR_IDX_ARG);
                $1->loc = t;
                $1->type = one->type.nextType;
            }
            $$->loc = ST->gentemp(one->type.type);              
            emit($$->loc, $1->loc, $3->loc, SL);
        }
        | shift_expression RSHIFT additive_expression
        {
            
            $$ = new expression();
            symbol* one = ST->lookup($1->loc);                  
            symbol* two = ST->lookup($3->loc);                  
            if(two->type.type == ARRAY) {                       
                string t = ST->gentemp(two->type.nextType);
                emit(t, $3->loc, *($3->folder), ARR_IDX_ARG);
                $3->loc = t;
                $3->type = two->type.nextType;
            }
            if(one->type.type == ARRAY) {                       
                string t = ST->gentemp(one->type.nextType);
                emit(t, $1->loc, *($1->folder), ARR_IDX_ARG);
                $1->loc = t;
                $1->type = one->type.nextType;
            }
            $$->loc = ST->gentemp(one->type.type);              
            emit($$->loc, $1->loc, $3->loc, SR);
        }
        ;

relational_expression: 
        shift_expression
        {}
        | relational_expression LESS_THAN shift_expression
        {
            $$ = new expression();
            symbol* one = ST->lookup($1->loc);                  
            symbol* two = ST->lookup($3->loc);                  
            if(two->type.type == ARRAY) {                       
                string t = ST->gentemp(two->type.nextType);
                emit(t, $3->loc, *($3->folder), ARR_IDX_ARG);
                $3->loc = t;
                $3->type = two->type.nextType;
            }
            if(one->type.type == ARRAY) {                       
                string t = ST->gentemp(one->type.nextType);
                emit(t, $1->loc, *($1->folder), ARR_IDX_ARG);
                $1->loc = t;
                $1->type = one->type.nextType;
            }
            $$ = new expression();
            $$->loc = ST->gentemp();
            $$->type = BOOL;                                    
            emit($$->loc, "1", "", ASSIGN);
            $$->truelist = makelist(nextinstr);                 
            emit("", $1->loc, $3->loc, GOTO_LT);                
            emit($$->loc, "0", "", ASSIGN);
            $$->falselist = makelist(nextinstr);                
            emit("", "", "", GOTO);                             
        }
        | relational_expression GREATER_THAN shift_expression
        {
            $$ = new expression();
            symbol* one = ST->lookup($1->loc);                  
            symbol* two = ST->lookup($3->loc);                  
            if(two->type.type == ARRAY) {                       
                string t = ST->gentemp(two->type.nextType);
                emit(t, $3->loc, *($3->folder), ARR_IDX_ARG);
                $3->loc = t;
                $3->type = two->type.nextType;
            }
            if(one->type.type == ARRAY) {                       
                string t = ST->gentemp(one->type.nextType);
                emit(t, $1->loc, *($1->folder), ARR_IDX_ARG);
                $1->loc = t;
                $1->type = one->type.nextType;
            }
            $$ = new expression();
            $$->loc = ST->gentemp();
            $$->type = BOOL;                                    
            emit($$->loc, "1", "", ASSIGN);
            $$->truelist = makelist(nextinstr);                 
            emit("", $1->loc, $3->loc, GOTO_GT);                
            emit($$->loc, "0", "", ASSIGN);
            $$->falselist = makelist(nextinstr);                
            emit("", "", "", GOTO);                             
        }
        | relational_expression LESS_THAN_EQUAL shift_expression
        {
            $$ = new expression();
            symbol* one = ST->lookup($1->loc);                  
            symbol* two = ST->lookup($3->loc);                  
            if(two->type.type == ARRAY) {                       
                string t = ST->gentemp(two->type.nextType);
                emit(t, $3->loc, *($3->folder), ARR_IDX_ARG);
                $3->loc = t;
                $3->type = two->type.nextType;
            }
            if(one->type.type == ARRAY) {                       
                string t = ST->gentemp(one->type.nextType);
                emit(t, $1->loc, *($1->folder), ARR_IDX_ARG);
                $1->loc = t;
                $1->type = one->type.nextType;
            }
            $$ = new expression();
            $$->loc = ST->gentemp();
            $$->type = BOOL;                                    
            emit($$->loc, "1", "", ASSIGN);
            $$->truelist = makelist(nextinstr);                 
            emit("", $1->loc, $3->loc, GOTO_LTE);               
            emit($$->loc, "0", "", ASSIGN);
            $$->falselist = makelist(nextinstr);                
            emit("", "", "", GOTO);                             
        }
        | relational_expression GREATER_THAN_EQUAL shift_expression
        {
            $$ = new expression();
            symbol* one = ST->lookup($1->loc);                  
            symbol* two = ST->lookup($3->loc);                  
            if(two->type.type == ARRAY) {                       
                string t = ST->gentemp(two->type.nextType);
                emit(t, $3->loc, *($3->folder), ARR_IDX_ARG);
                $3->loc = t;
                $3->type = two->type.nextType;
            }
            if(one->type.type == ARRAY) {                       
                string t = ST->gentemp(one->type.nextType);
                emit(t, $1->loc, *($1->folder), ARR_IDX_ARG);
                $1->loc = t;
                $1->type = one->type.nextType;
            }
            $$ = new expression();
            $$->loc = ST->gentemp();
            $$->type = BOOL;                                    
            emit($$->loc, "1", "", ASSIGN);
            $$->truelist = makelist(nextinstr);                 
            emit("", $1->loc, $3->loc, GOTO_GTE);               
            emit($$->loc, "0", "", ASSIGN);
            $$->falselist = makelist(nextinstr);                
            emit("", "", "", GOTO);                             
        }
        ;

equality_expression: 
        relational_expression
        {
            $$ = new expression();
            $$ = $1;                
        }
        | equality_expression EQUAL relational_expression
        {
            $$ = new expression();
            symbol* one = ST->lookup($1->loc);                  
            symbol* two = ST->lookup($3->loc);                  
            if(two->type.type == ARRAY) {                       
                string t = ST->gentemp(two->type.nextType);
                emit(t, $3->loc, *($3->folder), ARR_IDX_ARG);
                $3->loc = t;
                $3->type = two->type.nextType;
            }
            if(one->type.type == ARRAY) {                       
                string t = ST->gentemp(one->type.nextType);
                emit(t, $1->loc, *($1->folder), ARR_IDX_ARG);
                $1->loc = t;
                $1->type = one->type.nextType;
            }
            $$ = new expression();
            $$->loc = ST->gentemp();
            $$->type = BOOL;                                    
            emit($$->loc, "1", "", ASSIGN);
            $$->truelist = makelist(nextinstr);                 
            emit("", $1->loc, $3->loc, GOTO_EQ);                
            emit($$->loc, "0", "", ASSIGN);
            $$->falselist = makelist(nextinstr);                
            emit("", "", "", GOTO);                             
        }
        | equality_expression NOT_EQUAL relational_expression
        {
            $$ = new expression();
            symbol* one = ST->lookup($1->loc);                  
            symbol* two = ST->lookup($3->loc);                  
            if(two->type.type == ARRAY) {                       
                string t = ST->gentemp(two->type.nextType);
                emit(t, $3->loc, *($3->folder), ARR_IDX_ARG);
                $3->loc = t;
                $3->type = two->type.nextType;
            }
            if(one->type.type == ARRAY) {                       
                string t = ST->gentemp(one->type.nextType);
                emit(t, $1->loc, *($1->folder), ARR_IDX_ARG);
                $1->loc = t;
                $1->type = one->type.nextType;
            }
            $$ = new expression();
            $$->loc = ST->gentemp();
            $$->type = BOOL;                                    
            emit($$->loc, "1", "", ASSIGN);
            $$->truelist = makelist(nextinstr);                 
            emit("", $1->loc, $3->loc, GOTO_NEQ);               
            emit($$->loc, "0", "", ASSIGN);
            $$->falselist = makelist(nextinstr);                
            emit("", "", "", GOTO);                             
        }
        ;

and_expression: 
        equality_expression
        {}
        | and_expression BITWISE_AND equality_expression
        {
            $$ = new expression();
            symbol* one = ST->lookup($1->loc);                  
            symbol* two = ST->lookup($3->loc);                  
            if(two->type.type == ARRAY) {                       
                string t = ST->gentemp(two->type.nextType);
                emit(t, $3->loc, *($3->folder), ARR_IDX_ARG);
                $3->loc = t;
                $3->type = two->type.nextType;
            }
            if(one->type.type == ARRAY) {                       
                string t = ST->gentemp(one->type.nextType);
                emit(t, $1->loc, *($1->folder), ARR_IDX_ARG);
                $1->loc = t;
                $1->type = one->type.nextType;
            }
            $$ = new expression();
            $$->loc = ST->gentemp();                            
            emit($$->loc, $1->loc, $3->loc, BW_AND);            
        }
        ;

exclusive_or_expression: 
        and_expression
        {
            $$ = $1;    
        }
        | exclusive_or_expression BITWISE_XOR and_expression
        {
            $$ = new expression();
            symbol* one = ST->lookup($1->loc);                  
            symbol* two = ST->lookup($3->loc);                  
            if(two->type.type == ARRAY) {                       
                string t = ST->gentemp(two->type.nextType);
                emit(t, $3->loc, *($3->folder), ARR_IDX_ARG);
                $3->loc = t;
                $3->type = two->type.nextType;
            }
            if(one->type.type == ARRAY) {                       
                string t = ST->gentemp(one->type.nextType);
                emit(t, $1->loc, *($1->folder), ARR_IDX_ARG);
                $1->loc = t;
                $1->type = one->type.nextType;
            }
            $$ = new expression();
            $$->loc = ST->gentemp();                            
            emit($$->loc, $1->loc, $3->loc, BW_XOR);            
        }
        ;

inclusive_or_expression: 
        exclusive_or_expression
        {
            $$ = new expression();
            $$ = $1;                
        }
        | inclusive_or_expression BITWISE_OR exclusive_or_expression
        {
            $$ = new expression();
            symbol* one = ST->lookup($1->loc);                  
            symbol* two = ST->lookup($3->loc);                  
            if(two->type.type == ARRAY) {                       
                string t = ST->gentemp(two->type.nextType);
                emit(t, $3->loc, *($3->folder), ARR_IDX_ARG);
                $3->loc = t;
                $3->type = two->type.nextType;
            }
            if(one->type.type == ARRAY) {                       
                string t = ST->gentemp(one->type.nextType);
                emit(t, $1->loc, *($1->folder), ARR_IDX_ARG);
                $1->loc = t;
                $1->type = one->type.nextType;
            }
            $$ = new expression();
            $$->loc = ST->gentemp();                            
            emit($$->loc, $1->loc, $3->loc, BW_OR);             
        }
        ;

logical_and_expression: 
        inclusive_or_expression
        {}
        | logical_and_expression LOGICAL_AND M inclusive_or_expression
        {
            /*
                Here, we have augmented the grammar with the non-terminal M to facilitate backpatching
            */
            backpatch($1->truelist, $3->instr);                     
            $$->falselist = merge($1->falselist, $4->falselist);    
            $$->truelist = $4->truelist;                            
            $$->type = BOOL;                                        
        }
        ;

logical_or_expression: 
        logical_and_expression
        {}
        | logical_or_expression LOGICAL_OR M logical_and_expression
        {
            backpatch($1->falselist, $3->instr);                    
            $$->truelist = merge($1->truelist, $4->truelist);       
            $$->falselist = $4->falselist;                          
            $$->type = BOOL;                                        
        }
        ;

conditional_expression: 
        logical_or_expression
        {
            $$ = $1;    
        }
        | logical_or_expression N QUESTION_MARK M expression N COLON M conditional_expression
        {   
            /*
                Note the augmented grammar with the non-terminals M and N
            */
            symbol* one = ST->lookup($5->loc);
            $$->loc = ST->gentemp(one->type.type);      
            $$->type = one->type.type;
            emit($$->loc, $9->loc, "", ASSIGN);         
            list<int> temp = makelist(nextinstr);
            emit("", "", "", GOTO);                     
            backpatch($6->nextlist, nextinstr);         
            emit($$->loc, $5->loc, "", ASSIGN);
            temp = merge(temp, makelist(nextinstr));
            emit("", "", "", GOTO);                     
            backpatch($2->nextlist, nextinstr);         
            convertIntToBool($1);                       
            backpatch($1->truelist, $4->instr);         
            backpatch($1->falselist, $8->instr);        
            backpatch($2->nextlist, nextinstr);         
        }
        ;

M: %empty
        {   
            
            $$ = new expression();
            $$->instr = nextinstr;
        }
        ;

N: %empty
        {
            
            $$ = new expression();
            $$->nextlist = makelist(nextinstr);
            emit("", "", "", GOTO);
        }
        ;

assignment_expression: 
        conditional_expression
        {}
        | unary_expression assignment_operator assignment_expression
        {
            symbol* sym1 = ST->lookup($1->loc);         
            symbol* sym2 = ST->lookup($3->loc);         
            if($1->fold == 0) {
                if(sym1->type.type != ARRAY)
                    emit($1->loc, $3->loc, "", ASSIGN);
                else
                    emit($1->loc, $3->loc, *($1->folder), ARR_IDX_RES);
            }
            else
                emit(*($1->folder), $3->loc, "", L_DEREF);
            $$ = $1;        
        }
        ;

assignment_operator: 
        ASSIGN_
        {}
        | MULTIPLY_ASSIGN
        {}
        | DIVIDE_ASSIGN
        {}
        | MODULO_ASSIGN
        {}
        | ADD_ASSIGN
        {}
        | SUBTRACT_ASSIGN
        {}
        | LSHIFT_ASSIGN
        {}
        | RSHIFT_ASSIGN
        {}
        | AND_ASSIGN
        {}
        | XOR_ASSIGN
        {}
        | OR_ASSIGN
        {}
        ;

expression: 
        assignment_expression
        {}
        | expression COMMA assignment_expression
        {}
        ;

constant_expression: 
        conditional_expression
        {}
        ;

declaration: 
        declaration_specifiers init_declarator_list SEMICOLON
        {
            DataType currType = $1;
            int currSize = -1;
            
            if(currType == INT)
                currSize = __INTEGER_SIZE;
            else if(currType == CHAR)
                currSize = __CHARACTER_SIZE;
            else if(currType == FLOAT)
                currSize = __FLOAT_SIZE;
            vector<declaration*> decs = *($2);
            for(vector<declaration*>::iterator it = decs.begin(); it != decs.end(); it++) {
                declaration* currDec = *it;
                if(currDec->type == FUNCTION) {
                    ST = &globalST;
                    emit(currDec->name, "", "", FUNC_END);
                    symbol* one = ST->lookup(currDec->name);        
                    symbol* two = one->nestedTable->lookup("RETVAL", currType, currDec->pointers);
                    one->size = 0;
                    one->initVal = NULL;
                    continue;
                }

                symbol* three = ST->lookup(currDec->name, currType);        
                three->nestedTable = NULL;
                if(currDec->li == vector<int>() && currDec->pointers == 0) {
                    three->type.type = currType;
                    three->size = currSize;
                    if(currDec->initVal != NULL) {
                        string rval = currDec->initVal->loc;
                        emit(three->name, rval, "", ASSIGN);
                        three->initVal = ST->lookup(rval)->initVal;
                    }
                    else
                        three->initVal = NULL;
                }
                else if(currDec->li != vector<int>()) {         
                    three->type.type = ARRAY;
                    three->type.nextType = currType;
                    three->type.dims = currDec->li;
                    vector<int> temp = three->type.dims;
                    int sz = currSize;
                    for(int i = 0; i < (int)temp.size(); i++)
                        sz *= temp[i];
                    ST->offset += sz;
                    three->size = sz;
                    ST->offset -= 4;
                }
                else if(currDec->pointers != 0) {               
                    three->type.type = POINTER;
                    three->type.nextType = currType;
                    three->type.pointers = currDec->pointers;
                    ST->offset += (__POINTER_SIZE - currSize);
                    three->size = __POINTER_SIZE;
                }
            }
        }
        | declaration_specifiers SEMICOLON
        {}
        ;

declaration_specifiers: 
        storage_class_specifier declaration_specifiers
        {}
        |storage_class_specifier
        {}
        | type_specifier declaration_specifiers
        {}
        | type_specifier
        {}
        | type_qualifier declaration_specifiers
        {}
        | type_qualifier
        {}
        | function_specifier declaration_specifiers
        {}
        | function_specifier
        {}
        ;

init_declarator_list: 
        init_declarator
        {
            $$ = new vector<declaration*>;      
            $$->push_back($1);
        }
        | init_declarator_list COMMA init_declarator
        {
            $1->push_back($3);                  
            $$ = $1;
        }
        ;

init_declarator: 
        declarator
        {
            $$ = $1;
            $$->initVal = NULL;         
        }
        | declarator ASSIGN_ initializer
        {   
            $$ = $1;
            $$->initVal = $3;           
        }
        ;

storage_class_specifier: 
        EXTERN
        {}
        | STATIC
        {}
        | AUTO
        {}
        | REGISTER
        {}
        ;

type_specifier: 
        VOID_
        {
            $$ = VOID;
        }
        | CHAR_
        {
            $$ = CHAR;
        }
        | SHORT
        {}
        | INT_
        {
            $$ = INT; 
        }
        | LONG
        {}
        | FLOAT_
        {
            $$ = FLOAT;
        }
        | DOUBLE
        {}
        | SIGNED
        {}
        | UNSIGNED
        {}
        | BOOL_
        {}
        | COMPLEX
        {}
        | IMAGINARY
        {}
        | enum_specifier
        {}
        ;

specifier_qualifier_list: 
        type_specifier specifier_qualifier_list_opt
        {}
        | type_qualifier specifier_qualifier_list_opt
        {}
        ;

specifier_qualifier_list_opt: 
        specifier_qualifier_list
        {}
        | %empty
        {}
        ;

enum_specifier: 
        ENUM CURLY_BRACE_OPEN enumerator_list CURLY_BRACE_CLOSE
        {}
        | ENUM IDENTIFIER CURLY_BRACE_OPEN enumerator_list CURLY_BRACE_CLOSE
        {}
        | ENUM IDENTIFIER CURLY_BRACE_OPEN enumerator_list COMMA CURLY_BRACE_CLOSE
        {}
        | ENUM IDENTIFIER
        {}
        ;

enumerator_list: 
        enumerator
        {}
        | enumerator_list COMMA enumerator
        {}
        ;

enumerator: 
        IDENTIFIER
        {}
        | IDENTIFIER ASSIGN_ constant_expression
        {}
        ;

type_qualifier: 
        CONST
        {}
        | RESTRICT
        {}
        | VOLATILE
        {}
        ;

function_specifier: 
        INLINE
        {}
        ;

declarator: 
        pointer direct_declarator
        {
            $$ = $2;
            $$->pointers = $1;
        }
        | direct_declarator
        {
            $$ = $1;
            $$->pointers = 0;
        }
        ;

direct_declarator: 
        IDENTIFIER
        {
            $$ = new declaration();
            $$->name = *($1);
        }
        | PARENTHESIS_OPEN declarator PARENTHESIS_CLOSE
        {}
        | direct_declarator SQUARE_BRACE_OPEN type_qualifier_list_opt SQUARE_BRACE_CLOSE
        {
            $1->type = ARRAY;       
            $1->nextType = INT;     
            $$ = $1;
            $$->li.push_back(0);
        }
        | direct_declarator SQUARE_BRACE_OPEN type_qualifier_list_opt assignment_expression SQUARE_BRACE_CLOSE
        {
            $1->type = ARRAY;       
            $1->nextType = INT;     
            $$ = $1;
            int index = ST->lookup($4->loc)->initVal->i;
            $$->li.push_back(index);
        }
        | direct_declarator SQUARE_BRACE_OPEN STATIC type_qualifier_list assignment_expression SQUARE_BRACE_CLOSE
        {}
        | direct_declarator SQUARE_BRACE_OPEN type_qualifier_list STATIC assignment_expression SQUARE_BRACE_CLOSE
        {}
        | direct_declarator SQUARE_BRACE_OPEN type_qualifier_list_opt MULTIPLY SQUARE_BRACE_CLOSE
        {
            $1->type = POINTER;     
            $1->nextType = INT;
            $$ = $1;
        }
        | direct_declarator PARENTHESIS_OPEN parameter_type_list_opt PARENTHESIS_CLOSE
        {
            $$ = $1;
            $$->type = FUNCTION;    
            symbol* funcData = ST->lookup($$->name, $$->type);
            symbolTable* funcTable = new symbolTable();
            funcData->nestedTable = funcTable;
            vector<param*> paramList = *($3);   
            for(int i = 0; i < (int)paramList.size(); i++) {
                param* curParam = paramList[i];
                if(curParam->type.type == ARRAY) {          
                    funcTable->lookup(curParam->name, curParam->type.type);
                    funcTable->lookup(curParam->name)->type.nextType = INT;
                    funcTable->lookup(curParam->name)->type.dims.push_back(0);
                }
                else if(curParam->type.type == POINTER) {   
                    funcTable->lookup(curParam->name, curParam->type.type);
                    funcTable->lookup(curParam->name)->type.nextType = INT;
                    funcTable->lookup(curParam->name)->type.dims.push_back(0);
                }
                else                                        
                    funcTable->lookup(curParam->name, curParam->type.type);
            }
            ST = funcTable;         
            emit($$->name, "", "", FUNC_BEG);
        }
        | direct_declarator PARENTHESIS_OPEN identifier_list PARENTHESIS_CLOSE
        {}
        ;

parameter_type_list_opt:
        parameter_type_list
        {}
        | %empty
        {
            $$ = new vector<param*>;
        }
        ;

type_qualifier_list_opt: 
        type_qualifier_list
        {}
        | %empty
        {}
        ;

pointer: 
        MULTIPLY type_qualifier_list
        {}
        | MULTIPLY
        {
            $$ = 1;
        }
        | MULTIPLY type_qualifier_list pointer
        {}
        | MULTIPLY pointer
        {
            $$ = 1 + $2;
        }
        ;

type_qualifier_list: 
        type_qualifier
        {}
        | type_qualifier_list type_qualifier
        {}
        ;

parameter_type_list: 
        parameter_list
        | parameter_list COMMA ELLIPSIS
        ;

parameter_list: 
        parameter_declaration
        {
            $$ = new vector<param*>;         
            $$->push_back($1);              
        }
        | parameter_list COMMA parameter_declaration
        {
            $1->push_back($3);              
            $$ = $1;
        }
        ;

parameter_declaration: 
        declaration_specifiers declarator
        {
            $$ = new param();
            $$->name = $2->name;
            if($2->type == ARRAY) {
                $$->type.type = ARRAY;
                $$->type.nextType = $1;
            }
            else if($2->pc != 0) {
                $$->type.type = POINTER;
                $$->type.nextType = $1;
            }
            else
                $$->type.type = $1;
        }
        | declaration_specifiers
        {}
        ;

identifier_list: 
        IDENTIFIER
        {}
        | identifier_list COMMA IDENTIFIER
        {}
        ;

type_name: 
        specifier_qualifier_list
        {}
        ;

initializer: 
        assignment_expression
        {
            $$ = $1;   
        }
        | CURLY_BRACE_OPEN initializer_list CURLY_BRACE_CLOSE
        {}
        | CURLY_BRACE_OPEN initializer_list COMMA CURLY_BRACE_CLOSE
        {}
        ;

initializer_list: 
        designation_opt initializer
        {}
        | initializer_list COMMA designation_opt initializer
        {}
        ;

designation_opt: 
        designation
        {}
        | %empty
        {}
        ;

designation: 
        designator_list ASSIGN_
        {}
        ;

designator_list: 
        designator
        {}
        | designator_list designator
        {}
        ;

designator: 
        SQUARE_BRACE_OPEN constant_expression SQUARE_BRACE_CLOSE
        {}
        | DOT IDENTIFIER
        {}
        ;

statement: 
        labeled_statement
        {}
        | compound_statement
        | expression_statement
        | selection_statement
        | iteration_statement
        | jump_statement
        ;

labeled_statement: 
        IDENTIFIER COLON statement
        {}
        | CASE constant_expression COLON statement
        {}
        | DEFAULT COLON statement
        {}
        ;

compound_statement: 
        CURLY_BRACE_OPEN CURLY_BRACE_CLOSE
        {}
        | CURLY_BRACE_OPEN block_item_list CURLY_BRACE_CLOSE
        {
            $$ = $2;
        }
        ;

block_item_list: 
        block_item
        {
            $$ = $1;    
            backpatch($1->nextlist, nextinstr);
        }
        | block_item_list M block_item
        {   
            /*
                This production rule has been augmented with the non-terminal M
            */
            $$ = new expression();
            backpatch($1->nextlist, $2->instr);    
            $$->nextlist = $3->nextlist;
        }
        ;

block_item: 
        declaration
        {
            $$ = new expression();   
        }
        | statement
        ;

expression_statement: 
        expression SEMICOLON
        {}
        | SEMICOLON
        {
            $$ = new expression();  
        }
        ;

selection_statement: 
        IF PARENTHESIS_OPEN expression N PARENTHESIS_CLOSE M statement N
        {
            /*
                This production rule has been augmented for control flow
            */
            backpatch($4->nextlist, nextinstr);         
            convertIntToBool($3);                       
            backpatch($3->truelist, $6->instr);         
            $$ = new expression();                      
            
            $7->nextlist = merge($8->nextlist, $7->nextlist);
            $$->nextlist = merge($3->falselist, $7->nextlist);
        }
        | IF PARENTHESIS_OPEN expression N PARENTHESIS_CLOSE M statement N ELSE M statement N
        {
            /*
                This production rule has been augmented for control flow
            */
            backpatch($4->nextlist, nextinstr);         
            convertIntToBool($3);                       
            backpatch($3->truelist, $6->instr);         
            backpatch($3->falselist, $10->instr);
            $$ = new expression();                      
            
            $$->nextlist = merge($7->nextlist, $8->nextlist);
            $$->nextlist = merge($$->nextlist, $11->nextlist);
            $$->nextlist = merge($$->nextlist, $12->nextlist);
        }
        | SWITCH PARENTHESIS_OPEN expression PARENTHESIS_CLOSE statement
        {}
        ;

iteration_statement: 
        WHILE M PARENTHESIS_OPEN expression N PARENTHESIS_CLOSE M statement
        {   
            /*
                This production rule has been augmented with non-terminals like M and N to handle the control flow and backpatching
            */
            $$ = new expression();                   
            emit("", "", "", GOTO);
            backpatch(makelist(nextinstr - 1), $2->instr);
            backpatch($5->nextlist, nextinstr);
            convertIntToBool($4);                   
            $$->nextlist = $4->falselist;           
            backpatch($4->truelist, $7->instr);     
            backpatch($8->nextlist, $2->instr);     
        }
        | DO M statement M WHILE PARENTHESIS_OPEN expression N PARENTHESIS_CLOSE SEMICOLON
        {
            /*
                This production rule has been augmented with non-terminals like M and N to handle the control flow and backpatching
            */
            $$ = new expression();                  
            backpatch($8->nextlist, nextinstr);     
            convertIntToBool($7);                   
            backpatch($7->truelist, $2->instr);     
            backpatch($3->nextlist, $4->instr);     
            $$->nextlist = $7->falselist;
        }
        | FOR PARENTHESIS_OPEN expression_statement M expression_statement N M expression N PARENTHESIS_CLOSE M statement
        {
            /*
                This production rule has been augmented with non-terminals like M and N to handle the control flow and backpatching
            */
            $$ = new expression();                   
            emit("", "", "", GOTO);
            $12->nextlist = merge($12->nextlist, makelist(nextinstr - 1));
            backpatch($12->nextlist, $7->instr);    
            backpatch($9->nextlist, $4->instr);     
            backpatch($6->nextlist, nextinstr);     
            convertIntToBool($5);                   
            backpatch($5->truelist, $11->instr);    
            $$->nextlist = $5->falselist;           
        }
        ;

jump_statement: 
        GOTO_ IDENTIFIER SEMICOLON
        {}
        | CONTINUE SEMICOLON
        {}
        | BREAK SEMICOLON
        {}
        | RETURN_ SEMICOLON
        {
            if(ST->lookup("RETVAL")->type.type == VOID) {
                emit("", "", "", RETURN);           
            }
            $$ = new expression();
        }
        | RETURN_ expression SEMICOLON
        {
            if(ST->lookup("RETVAL")->type.type == ST->lookup($2->loc)->type.type) {
                emit($2->loc, "", "", RETURN);      
            }
            $$ = new expression();
        }
        ;

translation_unit: 
        external_declaration
        {}
        | translation_unit external_declaration
        {}
        ;

external_declaration: 
        function_definition
        {}
        | declaration
        {}
        ;

function_definition: 
        declaration_specifiers declarator declaration_list compound_statement
        {}
        | function_prototype compound_statement
        {
            ST = &globalST;                     
            emit($1->name, "", "", FUNC_END);
        }
        ;

function_prototype:
        declaration_specifiers declarator
        {
            DataType currType = $1;
            int currSize = -1;
            if(currType == CHAR)
                currSize = __CHARACTER_SIZE;
            if(currType == INT)
                currSize = __INTEGER_SIZE;
            if(currType == FLOAT)
                currSize = __FLOAT_SIZE;
            declaration* currDec = $2;
            symbol* sym = globalST.lookup(currDec->name);
            if(currDec->type == FUNCTION) {
                symbol* retval = sym->nestedTable->lookup("RETVAL", currType, currDec->pointers);   
                sym->size = 0;
                sym->initVal = NULL;
            }
            $$ = $2;
        }
        ;

declaration_list: 
        declaration
        {}
        | declaration_list declaration
        {}
        ;

%%

void yyerror(string s) {
    /*
        This function prints any error encountered while parsing
    */
    cout << "Error occurred: " << s << endl;
    cout << "Line no.: " << yylineno << endl;
    cout << "Unable to parse: " << yytext << endl; 
}
