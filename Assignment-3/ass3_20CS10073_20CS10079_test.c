#define num 7379
#define pi 3.142
#define str "Hello World"

enum names{yashraj,vikas,singh,bastewad} ;

/* hello world
This is a Multi line comment*/

void function(){
	
	double a,b,c;     //declaring variables
	/*initialising variables*/
	b = 45.e+34;	  
	c = 23.e5;
	a += (b+c);
	return ;
}
// testing struct and union
union student
{
    int roll;
    float marks;
};

struct complex{
    _Bool x;
    _Complex y;
    _Imaginary z;
};

typedef struct complex complex;

static inline int func_3(){return num;}

float* func2(float* restrict f)
{
    return f;
}

int main(){
    char c;
    int i;
    float f;
    // this is a single line comment
    i=0;
    f=1.23;
    c='a';

    int j = 10;
    i=j;
    i = i + j;
    i = i - j;
    i = i * j;
    i = i / j;
    i = i % j;
    i = i & j;
    i = i & j;
    i = i & j;

    i+= j;
    i*=j;
    i-=j;
    i/=j;
    i%=j;
    i&=j;
    i^=j;
    i|=j;
    i<<=j;
    i>>=j;

    const volatile int p = 100;
    unsigned int q = 674;
// testing if, else, >=
    if(p>=10 || p<0){
        printf("if");
    }
    else{
        printf("else");
    }
// testing do-while, if, ++, ==, long, --, != 
    long int k=7;
    do{
        i++;
        if(k!=5) k--;
    }while(i<10);

// testing for, 
    for(int t=0;t<10;t++){
        if(t+9 <10 ) continue;
    }
// testing short, >, ?, :, ;
    short int h = (k>5)? 6 : 9; 
// testing swich, case, break, default, signed, sizeof, 
    signed int a=2;
    int size =sizeof(a);
    char ch;
    switch (a)
    {
    case 1:
        ch = 'c';
        break;
    case 2:
        ch = '1';
        break;
    default:
        break;
    }

    auto vikas = 1.233e5;

    register int a = 10;

    enum names var__2 = yashraj;

    int lo=0;
    int hi = 100;
    while(lo<=hi){
        int mid = (lo+hi)/2;
        if(mid < 10){
            goto label;
        }
        continue;
        label:
            break;
    }
    
    return 0;
} 




