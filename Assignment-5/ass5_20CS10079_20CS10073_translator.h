#ifndef _TRANSLATE_H
#define _TRANSLATE_H

#include <bits/stdc++.h>

using namespace std;

// MACROS
#define ltsit list<sym>::iterator
#define ltiit list<int>::iterator
#define ltstit list<symtable*>::iterator
#define qdit vector<quad>::iterator
#define ltsym list<sym>
#define ltst list<symtable*>
#define stri string


// class names
// format of the entry of a symbol table 
class sym;
// description of symboltype attribute of symbol table						
class symboltype;				
// description of symbol table, containing associated functions for lookup, printing and updating
class symtable;
// class that describes a quad					
class quad;						
// class that describes the quad array object
class quadArray;				


// CLASSES

// Information stored in symbol table
// 1. name of symbol
// 2. symbol type (which is also a class as elaborated below)
// 3. symbol size
// 4. offset of symbol
// 5. initial value of symbol
class sym {                                    
	
	public:
		stri name; // 1				
		symboltype *type; // 2			
		int size; // 3				
		int offset;	// 4			
		symtable* nested; 
		stri val; // 5	

		// Constructor
		sym (stri , stri t="int", symboltype* ptr = NULL, int width = 0);
		// Update the ST Entry 
		// A method to update symboltype of current symbol (and change size etc. accordingly)
		sym* update(symboltype*); 	
};

// Attributes that constitute the symbol type
// 1. string name for type of symbol
// 2. width (for size of array), constructur assigns 1 by default
// 3. arrtype, needed for multidim arrays 
class symboltype {                            
	
    public:
		stri type;				// 1 
		int width;			    // 2
		symboltype* arrtype;		// 3
		// Constructor
		symboltype(stri , symboltype* ptr = NULL, int width = 1);
};

// Attributes stored for the symbol table
// 1. Name of the symbol table
// 2. Number of temporary variables
// 3. a list of symbols (sym)
// 4. parent symbol table of current symbol table
class symtable { 				
	
    public: 
		stri name;				// 1		
		int count;				// 2
		ltsym table; 			// 3
		symtable* parent;		// 4
		// Constructor
		symtable (stri name="NULL");
		// Lookup for a symbol in symbol table
		sym* lookup (stri);		
		// Print the symbol table					
		void print();	
		// Update the symbol table      			
		void update();						        			
};

// format of a quad 
// A quad contains 4 attributes (all are strings)
// 1. Result of expression
// 2. Operator of experssion
// 3. First Argument
// 4. Second Argument
class quad {                   
			
	public:
		stri res;				// 1
		stri op;				// 2
		stri arg1;				// 3
		stri arg2;				// 4

		// Functions to print the quad
		void print();	
		void print1();          
		void print2();

		// Constructors (arg2 delafults to none)
		quad (stri , stri , stri op = "=", stri arg2 = "");			
		quad (stri , int , stri op = "=", stri arg2 = "");				
		quad (stri , float , stri op = "=", stri arg2 = "");			
};

// quadArray class contains
// 1. a vector of quads
class quadArray                
{ 		
	public:
		vector <quad> Array;   // 1
		// Print the quadArray
		void print();								
};

// Denotes basic variable types (not user defined)
class basicType {                                
	
    public:
		// type name (e.g. float)
		vector <stri> type;			
		// type size (in bytes)
		vector <int> size;			
		// add a new basic type
		void addType(stri ,int );
};

// STRUCTS

// Statement
struct Statement {
	// nextlist for statements
	list<int> nextList;		
};

// Array (to handle 1D and multi D arrays) 
struct Array {
	// Used for type of Array: may be ptr or arr
	stri atype;				
	// Location used to compute address of Array
	sym* location;			
	// pointer to the symbol table entry	
	sym* Array;				
	// type of the subarray generated (needed for multidim arrays)
	symboltype* type;		
};

// Expression
struct Expression {
	// pointer to the symbol table entry
	sym* location;			
	// to store type of expression out of int, char, float, bool
	stri type; 				
	// truelist for boolean expressions
	list<int> trueList;		
	// falselist for boolean expressions
	list<int> falseList;	
	// for statement expressions
	list<int> nextList;		
};


// typedefs
typedef Expression* expr;
typedef symboltype symtyp;

// extern (include external variables)
extern char* yytext;
extern int yyparse();
extern symtable* ST;			// denotes the current Symbol Table
extern symtable* globalST;		// global symbol table
extern sym* currSymbolPtr;		// pointer to current symbol
extern quadArray Q;				// quad array (for TAC)
extern basicType bt;            // basic types
extern long long int instr_count;// denotes count of instr
extern bool debug_on;			// bool for printing debug output

// just to format the output
void formatOutput(int);

// generate a temporary variable and insert it in the current symbol table
sym* gentemp (symtyp* , stri init = "");	  

// Emit Functions
void emit(stri , stri , int, stri arg = "");		  
void emit(stri , stri , float , stri arg = "");   
void emit(stri , stri , stri arg1="", stri arg2 = "");

// backpatch
// Input: list of addresses that have dangling exits, integer (address value) to be filled in (backpatched)
// Output: backpatched quads/instructions
// Algo: iterate through entire vector of quads denoted by Array and set the result attribute to the second argument int given
// Purpose: to do the backpatching, i.e. fill in address for danging exits (res part)
void backpatch (list <int> , int );
// makelist
// Input: Initial value
// Output: A new list containing the initial value
// Algo: Generate list of variables using newlist function of stl library with one node, having the init value
// Purpose: to construct the list of dangling exits
list<int> makelist (int );							    // Make a new list contaninig an integer
// merge
// Input: two lists of dangling exits
// Output: merged list of dangling exits
// Algo: simply concatenate two lists (here inbuilt c++ stl, merge function available for lists is used)
// Purpose: to unite lists of dangling exits
list<int> merge (list<int> &l1, list <int> &l2);		// Merge two lists into a single list
int nextinstr();										// Returns the next instruction number
void updateNextInstr();
// void updateNextInstr();

// For printing debugging output
void debug();											

// Type checking and conversion functions
// for type conversion (symbol to be converted, target type as a string)
sym* convertType(sym*, stri);
// compare the entire symbol table entries					
bool compareSymbolType(sym* &s1, sym* &s2);
// compare just the symboltype attribute
bool compareSymbolType(symtyp*, symtyp*);	  
// compute size of a given symbol type
int computeSize(symtyp*);						
// print type name of symbol
stri printType(symtyp*);	
// to make new symbol table						
void changeTable(symtable*);					

// Type conversion functions (for typecasting needed for expressions)
// convert int to string
stri convertInt2String(int);                
// convert float to string
stri convertFloat2String(float);            
// convertInt2Bool
// convert int to boolean
// Input: int expression
// Output: bool expression
expr convertInt2Bool(expr);				
// convertBool2Int
// convert boolean to int
// Input: bool expression 
// Output: int expression 
expr convertBool2Int(expr);				

#endif