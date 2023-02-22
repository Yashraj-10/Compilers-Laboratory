# Assignment 2: Creating Library

In this assignment we have to make a library which can perform the following functions  
- int printStr(char *)
- int readInt(int *)
- int printInt(int)
- int readFloat(float *)
- int printFloat(float)

Run the following command to compile the library and get an executable and then to run the program
    
        $ make
        $ ./ass2


Run the following command to run the program at once
    
        $ make run

Run the following command to clean the directory
        
        $ make clean

## Files and their description

### **ass2_20CS10079.c** 
This is the file which contains the functions which are to be implemented in the library.   
### **main.c**
This is the main file, it demonstrates the use of the library functions by printing and reading the values of int, float and string.
### **myl.h**
This is the header file which contains the function declarations of the functions to be implemented in the library.
### **makefile**
This is the makefile which contains the commands to compile the library and the main file and to run the program at once and to clean the generated files.