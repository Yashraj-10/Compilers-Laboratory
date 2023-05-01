int printStr (char *ch);
int printInt (int n);
int readInt (int *eP);

// Global declarations
float d = 2.3;
char c; 
int i, j, k, l, m, n, o;
int a = 4, *p, b;                           // Pointer declaration

int main() {
    int do_iterator = 1;
    do {                                    // Testing do while loop
        printStr("Entered for iteration ");
        printInt(do_iterator++);            // Incrementor in printStr
        printStr("\n");
    } while (do_iterator < 10);

    // Scope management 
    { 
        int w = 10;
        printStr("\nScope 1: ");
        printInt(w);
        { 
            int w = 2;
            printStr("\nScope 2: ");
            printInt(w);
            { 
                int w = 3;
                if (w == 3) {
                    printStr("\nEntered in the w == 3 condition if block.");
                }
                printStr("\nScope 3: ");
                printInt(w);
                printStr("\n");
            }
        }
    }
    return 0;
}
