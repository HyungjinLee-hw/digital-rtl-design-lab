\# 01. Zybo LED Test



\## Overview



This project is my first FPGA bring-up design on a Zybo / Zynq-7020 board.



The purpose of this project is to verify the basic FPGA design flow using a simple LED output design.





\## Design Goal



The design drives an LED output on the FPGA board.



This project focuses on the complete FPGA workflow:



1\. Write a simple Verilog RTL module

2\. Add FPGA pin constraints

3\. Run synthesis

4\. Run implementation

5\. Generate bitstream

6\. Program the FPGA board

7\. Verify LED behavior on hardware





\## Files



01\_zybo\_led\_test/



├── rtl/



│   └── led\_blink.v



├── constraints/



│   └── zybo.xdc



└── README.md

