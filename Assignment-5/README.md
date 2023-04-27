# Assignment 3: Parser for tinyC

In this assignment we have to write semantic actions on the Parser built in the previous [assingnment](../Assignment-4/).
The semantic actions have to be embedded in the yacc file created in the previous assignment.

In this assignmnent, we have to output the following:
- Array of 3-address quads
- Symbol Table

The guidelines regarding the Quads and Symbol Tables is given in the [problem statement](./Assignment-5.pdf).

The input to the parser is a file containing the tinyC code. The output of the parser is a file containing the 3-address quads and the symbol table. The 3-address quads are generated in the form of a list of tuples. Each tuple contains the operator and the operands. The 3-address quads are generated in the order in which they appear in the input file. After the 3-address quads, the Global Symbol Table and other Symbol Tables are printed.

The input files are in the [testFiles](./testFiles) directory. The output files are in the [outputFiles](./outputFiles) directory.

## How to run the code

The code is written in C and uses yacc/bison for parsing. The code is compiled using g++ compiler. The code is tested on Ubuntu 20.04 and 22.04. The code can be run using the following commands:

```bash
$ make
```
To clean the directory of all the generated files and the output file:
```bash
$ make clean
```

<!-- ## Files and their description -->
