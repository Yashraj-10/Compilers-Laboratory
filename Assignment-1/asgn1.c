/*
 * ass1.c Generate assembly code of x86-64 and comment
 */

#include <stdio.h>

int length(char str[20]);
void sort(char str[20], int len, char dest[20]);
void reverse(char str[20], int len, char dest[20]);

int main()
{
    char str[20], dest[20];
    int len;

    printf("Enter the string (all lowrer case): ");
    scanf("%s", str);
    
    len = length(str); // calling length function
    
    printf("Length of the string: %d\n", len);
    
    sort(str, len, dest); // calling sorting function
    
    printf("The string in descending order: %s\n", dest);
    
    return 0;
}

int length(char str[20])
{
    int i;

    for (i = 0; str[i] !='\0'; i++) // computing length of the string
    {
        ;
    }
    
    return i;
}

void sort(char str[20], int len, char dest[20])
{
    int i, j;
    char temp;
    
    for (i = 0; i < len; i++)
    {
        for (j = 0; j < len; j++)
        {
            if (str[i] < str[j]) // sorting in ascending order
            {
                temp = str[i];
                str[i] = str[j];
                str[j] = temp;
            }
        }
    }
    
    // calling reverse to sort the array in descending order
    reverse(str, len, dest);
}

void reverse(char str[20], int len, char dest[20])
{
    int i, j;
    char temp;
    
    for (i = 0; i < len / 2; i++)
    {
        for (j = len - i - 1; j >= len / 2; j--) // reversing the string
        {
            if (i == j)
                break;
            else
            {
                temp = str[i];
                str[i] = str[j];
                str[j] = temp;
                break;
            }
        }
    }
    
    for (i = 0; i < len; i++)
        dest[i]=str[i];
}