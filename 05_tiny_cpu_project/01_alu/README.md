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



