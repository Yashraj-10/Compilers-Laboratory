// Compilers Laboratory
// Assignment 6
//
// Yashraj Singh (20CS10079)
// Vikas Vijayakumar Bastewad (20CS10073)
//
// translation header file

#ifndef __TRANSLATOR_H
#define __TRANSLATOR_H

#include <iostream>
#include <vector>
#include <list>
#include <map>

using namespace std;
//---------------------------------------------------------------------------------------------------------------
#define __VOID_SIZE 0
#define __FUNCTION_SIZE 0
#define __CHARACTER_SIZE 1
#define __INTEGER_SIZE 4
#define __POINTER_SIZE 8
#define __FLOAT_SIZE 8
//---------------------------------------------------------------------------------------------------------------
typedef enum {
    VOID,
    BOOL,
    CHAR,
    INT,
    FLOAT,
    ARRAY,
    POINTER,
    FUNCTION
} DataType;

typedef enum  {
    ADD, SUB, MULT, DIV, MOD, SL, SR, 
    BW_AND, BW_OR, BW_XOR, 
    BW_U_NOT ,U_PLUS, U_MINUS, REFERENCE, DEREFERENCE, U_NEG, 
    GOTO_EQ, GOTO_NEQ, GOTO_GT, GOTO_GTE, GOTO_LT, GOTO_LTE, IF_GOTO, IF_FALSE_GOTO, 
    CtoI, ItoC, FtoI, ItoF, FtoC ,CtoF, 
    ASSIGN, GOTO, RETURN, PARAM, CALL, ARR_IDX_ARG, ARR_IDX_RES, FUNC_BEG, FUNC_END, L_DEREF
} opcode;
//---------------------------------------------------------------------------------------------------------------
class symbol;
class symbolType;
class symbolValue;
class symbolTable;

class quad;
class quadArray;
//---------------------------------------------------------------------------------------------------------------
extern char* yytext;
extern int yyparse();
//---------------------------------------------------------------------------------------------------------------
class symbolType 
{
public:
    int pointers;
    DataType type;
    DataType nextType;
    vector<int> dims;
};
//---------------------------------------------------------------------------------------------------------------
class symbolValue 
{
public:
    int i;
    char c;
    float f;
    void* p;

    void setInitVal(int val);
    void setInitVal(char val);
    void setInitVal(float val);
};
//---------------------------------------------------------------------------------------------------------------
class symbol 
{
public:
    string name;
    symbolType type;
    symbolValue* initVal;
    int size;
    int offset;
    symbolTable* nestedTable;

    symbol();
};
//---------------------------------------------------------------------------------------------------------------
class symbolTable 
{
public:
    map<string, symbol*> table;
    vector<symbol*> symbols;
    int offset;
    static int tempCount;

    symbolTable();
    symbol* lookup(string name, DataType t = INT, int pc = 0);
    symbol* searchGlobal(string name);
    string gentemp(DataType t = INT);

    void print(string tableName);
};
//---------------------------------------------------------------------------------------------------------------
class quad 
{
public:
    opcode op;
    string arg1;
    string arg2;
    string result;

    quad(string, string, string, opcode);

    string print();
};
//---------------------------------------------------------------------------------------------------------------
class quadArray 
{
public:
    vector<quad> quads;

    void print();
};
//---------------------------------------------------------------------------------------------------------------
class param 
{
public:
    string name;
    symbolType type;
};
//---------------------------------------------------------------------------------------------------------------
class expression 
{
public:
    int instr;
    DataType type;
    string loc;
    list<int> truelist;
    list<int> falselist;
    list<int> nextlist;
    int fold;
    string* folder;

    expression();
};
//---------------------------------------------------------------------------------------------------------------
class declaration 
{
public:
    string name;
    int pointers;
    DataType type;
    DataType nextType;
    vector<int> li;
    expression* initVal;
    int pc;
};
//---------------------------------------------------------------------------------------------------------------
void emit(string result, string arg1, string arg2, opcode op);
void emit(string result, int constant, opcode op);
void emit(string result, char constant, opcode op);
void emit(string result, float constant, opcode op);
//---------------------------------------------------------------------------------------------------------------
list<int> makelist(int i);

list<int> merge(list<int> list1, list<int> list2);

void backpatch(list<int> l, int address);

void convertToType(expression* arg, expression* res, DataType toType);

void convertToType(string t, DataType to, string f, DataType from);

void convertIntToBool(expression* expr);

int sizeOfType(DataType t);

string checkType(symbolType t);

string getInitVal(symbol* sym);

#endif