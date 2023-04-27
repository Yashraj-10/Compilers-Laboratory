#include "ass5_20CS10079_20CS10073_translator.h"
#include<sstream>
#include<string>
#include<iostream>
using namespace std;

// reference to global variables declared in header file 
symtable* globalST;						// global symbol table
quadArray Q;							// quad array (for TAC)
string var_type;						// store current variable type
symtable* ST;							// pointer to current symbol table
sym* currSymbolPtr; 					// pointer to current symbol
basicType bt;							// basic types
long long int instr_count;				// count of instr (used for sanity check)
bool debug_mode;						// flag to print debug output
void debug_print(){cout<<"";}			// used for debugging the code

// to implement switch case for strings in c++
int s2i(string s){
    map <string, int> m = {{"+", 0}, {"-", 1}, {"*", 2},
        {"/", 3}, {"%", 4}, {"|", 5}, {"^", 6}, {"&", 7},
        {"==", 8}, {"!=", 9}, {"<=", 10}, {"<", 11}, 
		{">", 12}, {">=", 13}, {"goto", 14}, {">>", 15},
        {"<<", 16}, {"=", 17}, {"=&", 18}, {"=*", 19},
        {"*=", 20}, {"uminus", 21}, {"~", 22}, {"!", 23},
        {"=[]", 24}, {"[]=", 25}, {"return", 26}, 
		{"param", 27}, {"call", 28}, {"label", 29}
    }; 
    if (m.find(s) == m.end())
        return -1;
    return m[s];
}

// Functions related to symbol table

// Constructor for class sym
sym::sym(string name, string t, symboltype* arrtype, int width) 
{     	//Symbol table entry
		debug_print();
		(*this).name=name;
		debug_print();
		// Construct symboltype for symbol
		type=new symboltype(t, arrtype, width);       
		debug_print();
		// set size according to type
		size=computeSize(type);                  
		debug_print();
		// set offset to 0
		offset=0;                                   
		debug_print();
		// no initial value allocated
		val="-";                                    
		debug_print();
		// set to NULL as no nested table has been defined yet
		nested=NULL;                                
		debug_print();
}

// function to update symbol (modify attributes for typecasting)
sym* sym::update(symboltype* t) 
{
	debug_print();
	// Update to the new type
	type = t;										 
	debug_print();
	// Update the size
	(*this).size = computeSize(t);                 
	debug_print();
	// return the variable	being updated
	return this;                                 
}

// Constructor for class symboltype
symboltype::symboltype(string type, symboltype* arrtype, int w)        
{
	debug_print();
	// set type
	(*this).type = type;
	debug_print();
	// set width
	(*this).width = w;
	debug_print();
	// set arrtype
	(*this).arrtype = arrtype;
	debug_print();
	// please refer to translator.h for significance of each attribute of the symbol type
}

// Constructor for class symtable, i.e. a symbol table
symtable::symtable(string name)            
{
	(*this).name = name;
	debug_print();
	// count = 0 as there are zero temporary variables initially
	count = 0;                           
	debug_print();
}

// lookup function for, looking up id of a symbol
sym* symtable::lookup(string name)               
{
	sym* s;
	// ltsit is iterator of list<sym> type
	ltsit iter;                      
	iter = table.begin();
	// iterate through all symbols in the table
	while(iter != table.end()) 
	{
		// if symbol is found it is returned (address of iterator)
		if(iter->name == name) 
			return &(*iter);         
		iter++;
	}
	// new symbol to be added to table if not found
	s = new sym(name);
	// push symbol to the list (added at back)
	table.push_back(*s);
	// return refernce to the back i.e. newly added symbol           
	return &table.back();              
}

//Update the symbol table 
void symtable::update()                      
{
	// list of tables
	ltst tb;                 
	ltsit iter;
	iter = table.begin();
	int temp;
	
	while(iter!=table.end()) 
	{
		if(iter==table.begin()) 
		{
			iter->offset=0;
			temp = iter->size;
		}
		else 
		{
			iter->offset = temp;
			temp = iter->offset + iter->size;
		}
		if(iter->nested!=NULL) 
			tb.push_back(iter->nested);
		iter++;
	}
	
	ltstit iter1;
	iter1 = tb.begin();
	while(iter1 !=tb.end()) 
	{
	  (*iter1)->update();
	  iter1++;
	}
}
// print a symbol table
void symtable::print()                            
{
	int next_instr=0;
	// list of tables
	ltst tb;                       
	for(int t1=0;t1<50;t1++) 
		cout<<"__";             
	cout<<endl;
	// print table name and parent's name for the table
	cout<<"Table Name: "<<(*this).name<<"\t\t\t Parent Name: ";          
	if(((*this).parent==NULL))
		cout<<"NULL  "<<"\t\t\t\t\t\t\t\t\t\t\t\t\t|"<<endl;
	else
		cout<<(*this).parent->name<<"\t\t\t\t\t\t\t\t\t\t\t\t\t|"<<endl; 
	for(int ti=0;ti<50;ti++) 
		cout<<"__";
	cout<<"|"<<endl;
	
	cout<<"Name";              
	formatOutput(11);
	cout<<"Type";             
	formatOutput(16);
	cout<<"Initial Value";   
	formatOutput(7);
	cout<<"Size";              
	formatOutput(11);
	cout<<"Offset";            
	formatOutput(9);
	cout<<"Nested         |"<<endl;      
	formatOutput(100);
	cout<<"|"<<endl;
	ostringstream str1;
	 
	// print all the attributes corresponding to the entries
	for(ltsit it=table.begin(); it!=table.end(); it++) {          
		// print name
		cout<<it->name;                                    
		formatOutput(15-it->name.length());
		string typeres=printType(it->type);               
		// print type	
		cout<<typeres;
		formatOutput(20-typeres.length());
		// print initial value 
		cout<<it->val;                                    
		
		//print size
		formatOutput(20-it->val.length());
		cout<<it->size;                                   
		str1<<it->size;
		
		//print offset
		formatOutput(15-str1.str().length());
		str1.str("");
		str1.clear();
		cout<<it->offset;                                 
		str1<<it->offset;
		
		
		formatOutput(15-str1.str().length());
		str1.str("");
		str1.clear();

		//print nested
		if(it->nested==NULL) 
		{                             
			cout<<"NULL"<<"\t\t\t|"<<endl;	
		}
		else 
		{
			cout<<it->nested->name<<"\t\t\t|"<<endl;
			tb.push_back(it->nested);
		}
	}
	
	for(int i=0;i<100;i++) 
		cout<<"_";
	cout<<"|"<<"\n\n";
	for(ltstit iter = tb.begin(); iter !=tb.end(); ++iter) 
	{
    	(*iter)->print();                               //print symbol table
	}
			
}

// make new symbol table
void changeTable(symtable* newtable) 
{	      
	debug_print();
	ST = newtable;
	debug_print();
} 

// Check if the symbols have same symbol table entries or not
bool compareSymbolType(sym*& s1,sym*& s2)
{ 	
	debug_print();
	symboltype* t1=s1->type;                         //get the base types
	debug_print();
	symboltype* t2=s2->type;
	int flag=0;
	//if one can be converted to the other. convert them
	if(compareSymbolType(t1,t2)) 
		flag=1;       
	else if(s1=convertType(s1,t2->type)) 
		flag=1;	
	else if(s2=convertType(s2,t1->type)) 
		flag=1;
	if(flag)
		return true;
	else 
		return false;
}

// Check if the symbol types are same or not
bool compareSymbolType(symboltype* t1,symboltype* t2)
{ 	
	debug_print();
	int flag=0;	
	//if two symboltypes are NULL
	if(t1 == NULL && t2 == NULL)
		return true;
	//if only one of them is NULL
	else if(t1==NULL || t2==NULL || t1->type!=t2->type)
		return false;
	else 
		return compareSymbolType(t1->arrtype,t2->arrtype);       //otherwise check their Array type
}

// Functions related to quads and TAC

// Constructor for quad object
quad::quad(string res,string arg1,string op,string arg2)           
{
	debug_print();
	(*this).res=res;
	debug_print();
	(*this).arg1=arg1;
	debug_print();
	(*this).op=op;
	debug_print();
	(*this).arg2=arg2;
	debug_print();
}

quad::quad(string res,int arg1,string op,string arg2)             //general constructor for quad
{
	debug_print();
	(*this).res=res;
	debug_print();
	(*this).arg2=arg2;
	debug_print();
	(*this).op=op;
	debug_print();
	(*this).arg1=convertInt2String(arg1);
	debug_print();
}

quad::quad(string res,float arg1,string op,string arg2)           //general constructor for quad
{
	debug_print();
	(*this).res=res;
	debug_print();
	(*this).arg2=arg2;
	debug_print();
	(*this).op=op;
	debug_print();
	(*this).arg1=convertFloat2String(arg1);
	debug_print();
}

// function that prints quads
void quad::print() 
{   
	int next_instr=0;	
    switch(s2i(op))
    {
        // Binary Operations
        case 0:
            debug_print();	
		    (*this).print1();
            break;
        
        case 1:
            debug_print();
		    (*this).print1();
            break;
    
        case 2:
            debug_print();
		    (*this).print1();
            break;

        case 3:
            debug_print();
		    (*this).print1();
            break;

        case 4:
            debug_print();	
		    (*this).print1();
            break;

        case 5:
            debug_print();	
		    (*this).print1();
            break;

        case 6:
            debug_print();
		    (*this).print1();
            break;

        case 7:
            debug_print();
		    (*this).print1();
            break;

        case 8:
            debug_print();
		    (*this).print2();
            break;

        case 9:
            debug_print();
		    (*this).print2();
            break;

        case 10:
            debug_print();
		    (*this).print2();
            break;

        case 11:
            debug_print();	
		    (*this).print2();
            break;

        case 12:
            debug_print();
		    (*this).print2();
            break;

        case 13:
            debug_print();
		    (*this).print2();
            break;

        case 14:
            debug_print();
		    cout<<"goto "<<res;
            break;

        // Shift Operations
        case 15:
            debug_print();
		    (*this).print1();
            break;

        case 16:
            debug_print();
		    (*this).print1();
            break;
    
        case 17:
            debug_print();			
		    cout<<res<<" = "<<arg1;
            break;

        // Unary Operators 
        case 18:
            debug_print();			
		    cout<<res<<" = &"<<arg1;
            break;

        case 19:
            debug_print();			
		    cout<<res<<" = *"<<arg1;
            break;

        case 20:
            debug_print();			
		    cout<<"*"<<res<<" = "<<arg1;
            break;

        case 21:
            debug_print();			
		    cout<<res<<" = -"<<arg1;
            break;
    
        case 22:
            debug_print();			
		    cout<<res<<" = ~"<<arg1;
            break;

        case 23:
            debug_print();			
		    cout<<res<<" = !"<<arg1;
            break;

        // Other operations
        case 24:
            debug_print();			
		    cout<<res<<" = "<<arg1<<"["<<arg2<<"]";
            break;

        case 25:
            debug_print();			
		    cout<<res<<"["<<arg1<<"]"<<" = "<< arg2;
            break;

        case 26:
            debug_print();			
		    cout<<"return "<<res;
            break;

        case 27:
            debug_print();			
		    cout<<"param "<<res;
            break;

        case 28:
            debug_print();			
		    cout<<res<<" = "<<"call "<<arg1<<", "<<arg2;
            break;

        case 29:
            debug_print();			
		    cout<<res<<": ";
            break;

        default:
            cout<<"Can't find "<<op;
            break;
    }  
    cout<<endl;         
}

void quad::print1()
{
	debug_print();
	cout<<res<<" = "<<arg1<<" "<<op<<" "<<arg2;
	debug_print();
}

// for printing if statmennts
void quad::print2()
{
	debug_print();
	cout<<"if "<<arg1<< " "<<op<<" "<<arg2<<" goto "<<res;
	debug_print();
}

// Add a new basic C type to type symbol table
void basicType::addType(string t, int s)          
{
	debug_print();
	type.push_back(t);
	debug_print();
	size.push_back(s);
	debug_print();
}

// print the quad Array i.e the TAC
void quadArray::print()                                   
{
	for(int i=0;i<100;i++) 
		cout<<"*";
	cout<<endl;
	//print TAC
	cout<<"Three Address Code:"<<endl;           
	for(int i=0; i<100; i++) 
		cout<<"_";
	cout<<endl;
	int j=0;
	qdit iter;
	iter = Array.begin();
	while(iter != Array.end()) 
	{
		if(iter->op=="label") 
		{           // it is a label, print it
			cout<<endl<<"L"<<j<<": ";
			iter->print();
		}
		else {                         //otherwise give 4 spaces and then print
			cout<<"L"<<j<<": ";
			formatOutput(4);
			iter->print();
		}
		iter++;
		j++;
	}
	for(int i=0; i<100; i++) 
		cout<<"*";      
	cout<<endl;
}

// helper function, just to format output
void formatOutput(int n)
{
	debug_print();
	for(int i = 0; i<n; i++)
	{
		cout<<" ";
	}
	debug_print();
}

// conversion function (for int to string)
string convertInt2String(int a)                    
{
	stringstream strs;                      
    strs<<a; 
    string temp=strs.str();
    char* integer=(char*) temp.c_str();
	string str=string(integer);
	return str;                              
}

// conversion function (for float to string)
string convertFloat2String(float x)                       
{
	std::ostringstream buff;
	buff<<x;
	return buff.str();
}


// function overloading done to deal with different instruction types
void emit(string op, string res, string arg1, string arg2) 
{             //Emit a quad: add the quad into the Array
	quad *q1= new quad(res,arg1,op,arg2);
	debug_print();
	Q.Array.push_back(*q1);
}

void emit(string op, string res, int arg1, string arg2) 
{                 //Emit a quad: add the quad into the Array
	quad *q2= new quad(res,arg1,op,arg2);
	debug_print();
	Q.Array.push_back(*q2);
}

void emit(string op, string res, float arg1, string arg2) 
{                 //Emit a quad: add the quad into the Array
	quad *q3= new quad(res,arg1,op,arg2);
	Q.Array.push_back(*q3);
}

// for carrying out type conversions
// symbol is converted to required type (return_type)
sym* convertType(sym* s, string return_type) 
{                            
	sym* new_s = gentemp(new symboltype(return_type));	
	// if symbol is currently float
	if((*s).type->type == "float")                                      
	{
		// if target type is int
		if(return_type == "int")                                      
		{
			emit("=",new_s->name,"float2int("+(*s).name+")");
			return new_s;
		}
		// if target type is char
		else if(return_type == "char")                             
		{
			emit("=",new_s->name,"float2char("+(*s).name+")");
			return new_s;
		}
		return s;
	}

	// if symbol is currently int
	else if((*s).type->type == "int")                                  
	{
		// if target type is float
		if(return_type == "float") 									
		{
			emit("=",new_s->name,"int2float("+(*s).name+")");
			return new_s;
		}
		// if target type is char
		else if(return_type == "char") 								
		{
			emit("=",new_s->name,"int2char("+(*s).name+")");
			return new_s;
		}
		return s;
	}

	// if symbol is currently char
	else if((*s).type->type == "char") 								 
	{
		// if target type is int
		if(return_type == "int") 									
		{
			emit("=",new_s->name,"char2int("+(*s).name+")");
			return new_s;
		}
		// if target type is double
		if(return_type == "double") 								//or converting to double
		{
			emit("=",new_s->name,"char2double("+(*s).name+")");
			return new_s;
		}
		return s;
	}
	return s;
}

// refer to header file for greater details of these functions
// For backpatching grammar 
void backpatch(list<int> list1,int addr)                
{
	// get string form of the address
	string str = convertInt2String(addr);              
	ltiit iter;
	iter = list1.begin();
	debug_print();
	while( iter != list1.end()) 
	{
		Q.Array[*iter].res=str;                     //do the backpatching
		iter++;
	}
}

// make a new list
list<int> makelist(int init) 
{
	list<int> newlist(1,init);                     
	debug_print();
	return newlist;
}

// merge existing lists
list<int> merge(list<int> &a,list<int> &b)
{
	a.merge(b);                                
	debug_print();
	return a;
}

// Convert Int expression to Bool 
expr convertInt2Bool(expr e)        
{	// update the falselist, truelist and also emit general goto statements, if not bool
	if(e->type!="bool")                
	{
		e->falseList=makelist(nextinstr());    
		emit("==","",e->location->name,"0");
		e->trueList=makelist(nextinstr());
		emit("goto","");
	}
}

// Convert bool Expression to int
expr convertBool2Int(expr e) 
{	// use general goto statements and standard procedure
	if(e->type == "bool") 
	{
		debug_print();
		e->location = gentemp(new symboltype("int"));         
		
		debug_print();
		backpatch(e->trueList,nextinstr());
		
		debug_print();
		emit("=",e->location->name,"true");
		
		debug_print();
		int p = nextinstr()+1;
		
		debug_print();
		string str = convertInt2String(p);
		
		debug_print();
		emit("goto",str);
		
		debug_print();
		backpatch(e->falseList,nextinstr());
		
		debug_print();
		emit("=",e->location->name,"false");
		debug_print();
	}
}

void updateNextInstr()
{
	instr_count++;
	if(debug_mode == 1)
	{
		cout<<"Current Line Number:"<<instr_count<<endl;
		cout<<"Press [ENTER] to continue:";
		cin.get();
	}
}

void debug()
{
	if(debug_mode == 1)
		cout<<instr_count<<endl;
}


int nextinstr() 
{
	debug_print();
	return Q.Array.size();                //next instruction will be 1+last index and lastindex=size-1. hence return size
}

sym* gentemp(symboltype* t, string str_new) 
{           //generate temp variable
	string tmp_name = "t"+convertInt2String(ST->count++);             //generate name of temporary
	sym* s = new sym(tmp_name);
	(*s).type = t;
	(*s).size=computeSize(t);                        //calculate its size
	(*s).val = str_new;
	ST->table.push_back(*s);                        //push it in ST
	return &ST->table.back();
}

//calculate size function
int computeSize(symboltype* t)                   
{
	if(t->type.compare("void")==0)	
		return bt.size[1];
	else if(t->type.compare("char")==0) 
		return bt.size[2];
	else if(t->type.compare("int")==0) 
		return bt.size[3];
	else if(t->type.compare("float")==0) 
		return  bt.size[4];
	else if(t->type.compare("arr")==0) 
		return t->width*computeSize(t->arrtype);     //recursive founction call for arrays and multidim arrays 
	else if(t->type.compare("ptr")==0) 
		return bt.size[5];
	else if(t->type.compare("func")==0) 
		return bt.size[6];
	else 
		return -1;
}

// Print the type of variable (needed for multidim arrays)
string printType(symboltype* t)                    
{
	if(t==NULL) return bt.type[0];
	if(t->type.compare("void")==0)	return bt.type[1];
	else if(t->type.compare("char")==0) return bt.type[2];
	else if(t->type.compare("int")==0) return bt.type[3];
	else if(t->type.compare("float")==0) return bt.type[4];
	else if(t->type.compare("ptr")==0) return bt.type[5]+"("+printType(t->arrtype)+")";       //recursive for ptr
	else if(t->type.compare("arr")==0) 
	{
		string str=convertInt2String(t->width);                                //recursive for arrays
		return bt.type[6]+"("+str+","+printType(t->arrtype)+")";
	}
	else if(t->type.compare("func")==0) return bt.type[7];
	else return "NA";
}

int main()
{
	// Add all the base types initially
	bt.addType("null",0);                 
	bt.addType("void",0);
	bt.addType("char",1);
	bt.addType("int",4);
	bt.addType("float",8);
	bt.addType("ptr",4);
	bt.addType("arr",0);
	bt.addType("func",0);
	// count of instr (used for debugging/validation)
	instr_count = 0;   
	// debugging is off, instruction count not printed
	debug_mode = 0;       
	// the global symbol table
	globalST=new symtable("Global");                        
	ST=globalST;
	// call parser
	yyparse();												 
	// update the Golbal symbo table
	globalST->update();										 
	cout<<"\n";
	//print TAC
	Q.print();	
	//print all STs
	globalST->print();										
	
};