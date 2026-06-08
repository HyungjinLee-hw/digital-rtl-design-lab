\# 01. Parameterized ALU



\## Overview



This module implements a parameterized combinational ALU in Verilog.



The ALU supports arithmetic, logic, comparison, and pass-through operations. It is intended as one of the core datapath blocks for the Tiny CPU project.





\## Design Goal



The goal of this project is to understand how a CPU datapath performs basic operations selected by control logic.



The ALU receives two operands and an operation code, then produces a result and several status flags.





\## Files



01\_alu/

├── rtl/

│   └── alu.v

├── tb/

│   └── alu\_tb.v

└── README.md





\*\* Signed and Unsigned Interpretation

The ALU inputs 'a' and 'b' are declared as plain Verilog vectors: input wire \[WIDTH-1:0] a;

Therefore Verilog treats them as unsigned values by default.

However, flags(negative and overflow) helps interpret the result also as signed.



ex1) Unsigned carry without signed overflow



a = 1111\_1111

b = 0000\_0001

operation = ADD

=> temp  = 1\_0000\_0000



output :

result =  0000\_0000

carry = 1 

overflow = 0

negative = 0

zero = 1



Unsigned interpretation:

carry = 1 , so 255+1 = 256

The mathematical unsigned result is 256, but the 8-bit result wraps to 0 and carry is set.



Signed interpretation:

if overflow = 0 :  result can be interpreted as a valid sign result.

Interpretation should be 0.







ex2) Signed overflow without unsigned carry



a = 0111\_1111

b = 0000\_0001

operation = ADD

=> temp = 0\_1000\_0000



output:

result = 1000\_0000

carry = 0

overflow = 1

negative = 1

zero = 0



Unsigned interpretation:

Result valid in 8bit unsigned arithmetic. carry = 0  not set.



Signed interpretation:

If overflow = 1:  result is invalid within the selected bit width.

In this case, the negative flag only shows the MSB of the raw result.

Interpretation should be +128.

+128 cannot be represented in 8-bit signed two's complement.

