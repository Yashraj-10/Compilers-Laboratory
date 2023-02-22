#include "myl.h"
#define BUFF 50
#define MaxInt 2147483647
#define MinIntAbs 2147483648
//----------------------------------------------------------------------------------------------------------------------------------------------
int printStr(char *str)
{
    int len = 0;                // length of string

    while(str[len] != '\0')     // Counts the number of characters in the string
        len += 1;


    __asm__ __volatile__ (
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(str), "d"(len)
    );

    return len;
}

//----------------------------------------------------------------------------------------------------------------------------------------------
int readInt(int *n)
{

    char buff[BUFF] = "";
    int len;

    __asm__ __volatile__ (
        "movl $0, %%eax \n\t"
        "movq $0, %%rdi \n\t"
        "syscall \n\t"
        :"=a"(len)
        :"S"(buff), "d"(BUFF)
    );

    if((buff[0] != '+' && buff[0] != '-' && (buff[0] < '0' || buff[0] > '9')) || len <= 0)      // Invalid Character checking
        return ERR;

    int i = 0;              // Index of buff
    int flag = 0;           // Flag to check if negative number

    if(buff[0] == '-')      // Checking if negative number
    {
        flag = 1;
        i++;
        if(buff[i] < '0' || buff[i] > '9')                                                      // Invalid Character checking
            return ERR;
    }

    if(buff[0] == '+')      // Checking if positive number
    {
        i++;

        if(buff[i] < '0' || buff[i] > '9')                                                      // Invalid Character checking
            return ERR;
    }

    int num = 0;            // Number to be returned

    while(buff[i] != ' ' && buff[i] != '\n' && buff[i] != '\t' && i<len)                        // Reading the number
    {
        if(buff[i] < '0' || buff[i] > '9')                                                      // Invalid Character checking
            return ERR;

        int digit = buff[i] - '0';                      // Converting the character to integer

        
        if((!flag && 1L * num * 10 + digit > MaxInt) || (flag && 1L * num * 10 + digit > MinIntAbs))        // Invalid Character checking
            return ERR;
        
        num = num * 10 + digit;
        i++;
    }

    if(flag)                    // If negative number
        num = (-1)*num;

    *n = (int)num;              // Assigning the number to n

    return OK;
}

//----------------------------------------------------------------------------------------------------------------------------------------------
int printInt(int n)
{   
    char buff[BUFF];
    int i = 0, j, k;                // Index of buff

    if(n == 0)                      // If n is 0
    {
        buff[i++] = '0';
    }
    else 
    {
        if(n < 0)                           // If n is negative
        {
            buff[i++] = '-';
            n = (-1)*n;
        }

        while(n)                            // Converting the number to string
        {
            buff[i++] = '0' + (n % 10);
            n /= 10;
        }

        j = (buff[0] == '-' ? 1 : 0);       
        k = i - 1;

        while(j<k)                          // Swapping the digits
        {
            char temp = buff[j];
            buff[j++] = buff[k];
            buff[k--] = temp;
        }
    }
    
    int size = i;                           // Size of buff

    __asm__ __volatile__ (
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(buff), "d"(size)
    );
    return size;
}

//----------------------------------------------------------------------------------------------------------------------------------------------
int readFlt(float *f)
{
    char buff[BUFF] = "";
    int len;

    __asm__ __volatile__ (
        "movl $0, %%eax \n\t"
        "movq $0, %%rdi \n\t"
        "syscall \n\t"
        :"=a"(len)
        :"S"(buff), "d"(BUFF)
    );

    if(((buff[0] != '+') && (buff[0] != '-') && (buff[0] != '.') && (buff[0] < '0' || buff[0] > '9')) || len <= 0)      // Invalid Character checking
        return ERR;

    int i = 0, j, flag = 0, dotFound = 0, div=1;                
    float num = 0;
    
    if(buff[i] == '-' || buff[i] == '+')                
    {
        if(buff[0] == '-')
            flag = 1;

        i++;

        if((buff[i] < '0' || buff[i] > '9') && buff[i] != '.')                      // Invalid Character checking
            return ERR;
    }

    while(buff[i] != ' ' && buff[i] != '\n' && buff[i] != '\t' && i<len)            
    {
        if(buff[i] == 'e' || buff[i] == 'E')
        {
            i++;

            int expSign = 1;
            int exp = 0;
            float expVal = 1;

            if((buff[i] != '+') && (buff[i] != '-') && (buff[i] < '0' || buff[i] > '9'))        // Invalid Character checking
                return ERR;

            if(buff[i] == '-' || buff[i] == '+')
            {
                if(buff[i] == '-')
                    expSign = -1;
                i++;

                if(buff[i] < '0' || buff[i] > '9')                                              // Invalid Character checking
                    return ERR;
            }

            while(buff[i] != ' ' && buff[i] != '\n' && buff[i] != '\t') 
            {
                if(buff[i] < '0' || buff[i] > '9')                                              // Invalid Character checking
                    return ERR;
                else
                {
                    int digit = buff[i] - '0';
                    exp = exp * 10 + digit;
                }

                i++;
            }
        
            for(j = 0; j < exp; j++)
                expVal *= 10.0;

            if(expSign > 0)
                num *= expVal;
            else
                num /= expVal;

            break;
        }
        else if(buff[i] == '.')
        {
            if(dotFound == 1)                                                                   // Invalid Character checking
                return ERR;
            else 
                dotFound = 1;
        }
        else if(buff[i] >= '0' && buff[i] <= '9')
        {
            int digit = buff[i] - '0';
            num = num * 10.0 + (float)digit;

            if(dotFound)
                div *= 10;
        }
        else
            return ERR;                                                                         // Invalid Character checking

        i++;
    }

    if(flag == 1)
    {
        num = (-1)*num;
    }

    num = num/((float)div);

    *f = num;

    return OK;
}

//----------------------------------------------------------------------------------------------------------------------------------------------
int printFlt(float f)
{
    char buff[BUFF];
    int i = 0;

    if(f < 0)
    {
        f = (-1)*f;
        buff[i++] = '-';
    }

    int intPart = (int)f;                                   // Integer part of the number
    int fracPart = (int)((f - intPart) * 1000000);          // Fractional part of the number

    if(intPart == 0)                    
    {
        buff[i++] = '0';
    }
    else
    {
        int j = i;

        while(intPart > 0)                                  // Converting the number to string
        {
            buff[i++] = '0' + (intPart % 10);
            intPart /= 10;
        }

        int k = i-1;
        while(j<k)                                          //Swapping the nos
        {
            char temp = buff[j];
            buff[j++] = buff[k];
            buff[k--] = temp;
        }
    }

    buff[i++] = '.';                                    // Adding .
    i = i+5;
    int x = i;
    int iter = 0;

    while(iter < 6)                                     //Adding fractional part
    {
        buff[x--] = '0' + (fracPart % 10);
        fracPart /= 10;
        iter++;
    }

    while(buff[i]=='0' && buff[i-1]!='.')               //Removing trailing zeroes
    {
        buff[i--] = '\n';
    }
    // buff[i+1] = '\n';
    int size = i+1;

    __asm__ __volatile__ (
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(buff), "d"(size)
    );
    return size;
}