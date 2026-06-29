\# 04\_instruction\_memory



\## Overview / Design Goal



This module implements the Instruction Memory for the Tiny CPU project.



The Instruction Memory stores the program instructions that the CPU executes.



The Program Counter (PC) provides an instruction address, and this module outputs the instruction stored at that address.



This module is currently implemented as read-only memory.



It can:



* Load a program from a memory initialization file
* Store up to 256 instructions by default
* Output the instruction at the requested address
* Return an all-zero instruction for an out-of-range address
* Initialize unused memory locations to zero



The current Tiny CPU uses 16-bit instructions and word addressing.





\## Files



04\_instruction\_memory/



├── rtl/

│   └── instruction\_memory.v

│   └── program.mem

│   └── tiny_cpu_defs.vh

├── tb/

│   ├── instruction\_memory\_tb.v

└── README.md





\## Memory Parameters



The default Instruction Memory configuration is:





Instruction width:     16 bits

Address width:         8 bits

Memory depth:          256 entries

Address range:         0 to 255

Program file:          program.mem





The module is parameterized so that these values can later be changed without rewriting the full module.



parameter INSTR\_WIDTH = `CPU\_INSTR\_WIDTH

parameter ADDR\_WIDTH  = `CPU\_PC\_WIDTH

parameter DEPTH       = `CPU\_IMEM\_DEPTH

parameter INIT\_FILE   = "program.mem"







\## Program File



The current `program.mem` file contains a test program that includes every currently defined Tiny CPU instruction.



140F    // MOVI r1, 15

1803    // MOVI r2, 3

2D80    // ADD  r3, r1, r2

3D80    // SUB  r3, r1, r2

4D80    // AND  r3, r1, r2

5D80    // OR   r3, r1, r2

6D80    // XOR  r3, r1, r2

7D80    // EQ   r3, r1, r2

8E40    // LT   r3, r2, r1

9D00    // MOV  r3, r1

9B00    // MOV  r2, r3

A000    // HALT





This program is not yet executed by the complete CPU datapath.



At this stage, it is used to verify that the Instruction Memory returns the correct instruction for each address.





\## Testbench



The testbench verifies the following cases:



1\. program.mem is correctly loaded into Instruction Memory

2. All program instructions are returned at their correct addresses

3. An unused valid memory location returns 16'h0000



All tests passed in Vivado Behavioral Simulation.



