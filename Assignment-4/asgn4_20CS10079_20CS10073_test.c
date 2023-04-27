/*
 Compilers Lab
 Autumn Semester 2022
 Assignment No. 4
 Vikas Vijaykumar Bastewad - 20CS10073
 Yashraj Singh - 20CS10079
*/
/*------------------- Test File -----------------------------*/

extern int value;
static const double pi = 3.14;
auto b = 5;
volatile long y = 10;
_Bool x = 1;
enum week { Mon , Tue, Wed, Thur, Fri, Sat, Sun };

inline char toUpper(char ch)
{
    if(ch >= 97 && ch <= 122)
        ch -= 32;
    return ch;
}

int main()
{
    short signed int number0 = 40; 
    enum week _day = Sun;        
    float f2_ = 23.E-2;
    float f3_ = 23.56e+3;
    float f4_ = .56E2;
    float f5_ = 232e3;
    char _1 = 48;

    char s[2] = "";
    char str[] = "Testing a string\\\"\'\n";

    int a = 1, b = 1;
    a++;
    a--;
    a = a&b;
    a = a*b;
    a = a+b;
    a = a-b;
    a = !b;
    a = ~b;
    a = a/b;
    a = a%b;
    a = a<<b;
    a = a>>b;
    a = a^b;
    a = a|b;
    a = (a) ? a : b;
    a *= b;
    a /= b;
    a %= b;
    a += b;
    a -= b;
    a <<= b;
    a >>= b;
    a &= b;
    a ^= b;
    a |= b, b = 0;

    switch (_day) {
        case 1:
            break;
        default:;
    }

    int n = 10, t = 20;
    do {
        n -= 1;
    } while (n > 1);

    for(int i = 0; (i < 3 && i >= 0) || (i > 100 && i != 101); i++) {
        continue;
    }
 
    if (t <= 30) {
        t = 31;
    } else {
        t = 30;
    }
    return 0;
}