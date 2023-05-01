// Compilers Laboratory
// Assignment 6
//
// Yashraj Singh (20CS10079)
// Vikas Vijayakumar Bastewad (20CS10073)
//
// translation source file

#include "myl.h"
#define BUFF 100
#define MaxInt 2147483647
#define MinIntAbs 2147483648

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


int readInt(int *n)
{

    char buff[BUFF];
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
    buff[i++] = '\n';                       // Adding new line
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
