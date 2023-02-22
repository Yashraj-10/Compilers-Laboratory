#include "myl.h"

int main()
{

    printStr("---------------------- Testing printStr ----------------------\n");
    char *s[3] = {"qwertyuiop", "", "yashraj"};
    char *newline = "\n";
    int ret;

    for (int i = 0; i < 3; i++)
    {
        ret = printStr(s[i]);
        printStr("\n'-> Number of characters printed = ");
        printInt(ret);
        printStr(newline);
        printStr(newline);
    }

    printStr("---------------------- Testing printInt ----------------------\n");
    int ints[5] = {0, 1, -1, 123456, -123456};
    for (int i = 0; i < 5; i++)
    {
        int ret = printInt(ints[i]);
        printStr("\n'-> Number of characters printed = ");
        printInt(ret);
        printStr(newline);
        printStr(newline);
    }

    printStr("---------------------- Testing printFlt ----------------------\n");
    float floats[10] = {0, -12.34, 12.345, -2, 2, 0.1234, -0.1234, 123.456, 0.001, -0.0106};
    for (int i = 0; i < 10; i++)
    {
        int ret = printFlt(floats[i]);
        printStr("\n'-> Number of characters printed = ");
        printInt(ret);
        printStr(newline);
        printStr(newline);
    }

    printStr("---------------------- Testing readInt ----------------------\n");
    int ntemp;
    int rep = 0;

    do
    {
        printStr("Enter an integer: ");
        int ret = readInt(&ntemp);
        if (ret == ERR)
            printStr("Invalid input. ");
        else
        {
            printStr("Successfuly read integer: ");
            printInt(ntemp);
        }
        printStr("\nTo continue reading, enter 1 otherwise 0: ");
        readInt(&rep);
    } while (rep != 0);

    printStr(newline);

    printStr("---------------------- Testing readFlt ----------------------\n");
    float ftemp;
    rep = 0;

    do
    {
        printStr("Enter a float: ");
        int ret = readFlt(&ftemp);
        if (ret == ERR)
            printStr("Invalid input. ");
        else
        {
            printStr("Successfuly read float: ");
            printFlt(ftemp);
        }
        printStr("\nTo continue reading, enter 1 otherwise 0: ");
        readInt(&rep);
    } while (rep != 0);

    printStr(newline);

    return 0;
}