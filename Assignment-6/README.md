# Assignment 6: Target Code Generator for tinyC

In this assignment we will build upon the TAC generated in the previous assignment and convert it into assembly language of x86-64 architecture. The assembly code will be generated in the form of a list of tuples. Each tuple contains the operator and the operands. The assembly code is generated in the order in which they appear in the input file. 

In this assignment our final output will consist of assembly language files for each test file.

The input to the target Code Generator is a file containing the tinyC code. The output of the target Code Generator is a file containing the assembly code.

The input files are in the [test-inputs](./test-inputs) directory. The output files are in the [test-outputs](./test-outputs) directory.

## How to run the code

The code is written in C and uses yacc/bison for parsing. The code is compiled using g++ compiler. The code is tested on Ubuntu 20.04 and 22.04.

The command to generate the Target Code Generator is: 
```bash
$ make 
```

The command to get the assembly language outputs files is:
```bash
$ make runtest      # To generate assembly language files in test-outputs directory for each test file
$ make runtest1     # To generate assembly language files in test-outputs directory for test file 1
$ make runtest2     # To generate assembly language files in test-outputs directory for test file 2
$ make runtest3     # To generate assembly language files in test-outputs directory for test file 3
$ make runtest4     # To generate assembly language files in test-outputs directory for test file 4
$ make runtest5     # To generate assembly language files in test-outputs directory for test file 5
$ make runtest6     # To generate assembly language files in test-outputs directory for test file 6
```

The command to clean the directory is:
```bash
$ make clean
```

<!-- Files and their description>
