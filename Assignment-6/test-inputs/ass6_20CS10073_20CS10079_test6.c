int printStr (char *ch);
int printInt (int n);
int readInt (int *eP);

int global_var = 0;                         // Testing global variable

int binarySearch (int a[], int l, int r, int x) {   
    while (l <= r) {
        int mid = (l + r) / 2;
        if (a[mid] == x) {                  // Testing conditionals                                         
            return mid;                     // Testing return statement
        } else if (a[mid] < x) {            // Testing array arithmetic
            l = mid + 1;
        } else {   
            r = mid - 1;
        }
    }
    return -1;                              // Testing return statement
}

int main() {
    global_var++;

    int a[10];                              // Testing 1-D array declaration
    int i, n, c;                            // Testing variable declarations

    // Testing read numbers
    printStr("Enter 10 array elements in sorted order, separated by newlines:\n");
    for (i = 0; i < 10; i++) {
        a[i] = readInt(&c);                 // Testing readInt
    }

    // Testing print numbers
    printStr("Entered array : ");
    for (i = 0; i < 10; i++) {              // Testing for loop
        printInt(a[i]);                     // Testing printInt
        printStr(" ");                      // Testing printStr     
    }
    printStr("\n");

    int x;
    printStr("Number to search: ");
    x = readInt(&c);
    int index = binarySearch(a, 0, 9, x);
    if (index == -1) {
        printStr("Invalid search, element not found");
    } else { 
        printStr("Element found\n");
        printStr("Position: ");
        printInt(index);
    }
    printStr("\n");
    return 0;
}
