\# 05. Tiny CPU Project



\## Overview



This project is a step-by-step implementation of a small CPU in Verilog.



The purpose is not to immediately build a complex processor, but to first design and verify the core building blocks of a CPU datapath.



Each block is implemented and tested seperately before being connected into a complete CPU





\## Design Approach



The CPU is developed from individual components:



1\. ALU

2\. Register file

3\. Program counter

4\. Instruction memory

5\. Control unit

6\. Datapath integration



Each block is implemented and tested separately before being connected into a complete CPU.





\## Current Status



Implemented:



* Parameterized ALU
* Parameterized Register file



Planned:



* Program counter
* Instruction memory
* Control unit
* Datapath integration





\## Files



05\_tiny\_cpu\_project/



├── README.md



├── 01\_alu/

│   ├── rtl/

│   │   └── alu.v

│   ├── tb/

│   │   └── alu\_tb.v

│   └── README.md



├── 02\_register\_file/

│   ├── rtl/

│   │   └── register\_file.v

│   ├── tb/

│   │   └── register\_file\_tb.v

│   └── README.md



├── 03\_program\_counter/

│   ├── rtl/

│   ├── tb/

│   └── README.md



├── 04\_instruction\_memory/

&#x20;   ├── rtl/

&#x20;   ├── tb/

&#x20;   └── README.md



├── 05\_control\_unit/

│   ├── rtl/

│   ├── tb/

│   └── README.md



└── 06\_datapath\_integration/

&#x20;   ├── rtl/

&#x20;   ├── tb/

&#x20;   └── README.md

