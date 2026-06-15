\# 02. register\_file



\## Overview



This module implements a parameterized register file in Verilog.



The register file has 2 read ports and 1 write port. It is intended as one of the core datapath blocks for the Tiny CPU project.



In a CPU, the register file stores temporary values and provides operands to the ALU.





\## Design Goal



The goal of this project is to understand how a CPU stores and reads register values during instruction execution.



The register file receives read addresses and write information.



\* Read is combinational.

\* Write is synchronous.

\* Reset is synchronous.

\* Optional hardwired R0 behavior supported.





\## Files



02\_register\_file/

├── rtl/

│   └── register\_file.v

├── tb/

│   └── register\_file\_tb.v

└── README.md





\## Basic Structure



Default configuration:



WIDTH = 8

ADDR\_WIDTH = 2

NUM\_REGS = 4



Therefore, the register file has 4 registers, and each register has 8 bits.



Register mapping:



00 -> R0

01 -> R1

10 -> R2

11 -> R3



Internal register array:



reg \[WIDTH-1:0] regs \[0:NUM\_REGS-1];



With the default parameters, this becomes:



regs\[0] = R0, 8-bit

regs\[1] = R1, 8-bit

regs\[2] = R2, 8-bit

regs\[3] = R3, 8-bit





\## Read and Write Behavior



The register file has:



2 read ports

1 write port



This is useful because the ALU usually needs two operands at the same time.



ex) ADD R3, R1, R2	/ / R3 = R1 + R2



For this operation, the CPU has to read R1 and R2 at the same time, send them to the ALU, and then write the ALU result back to R3.





\## Synchronous Write



Write happens only on the rising clock edge.



If we = 1, the selected register is updated at posedge clk.



ex)



we = 1

waddr = 2'b01

wdata = 8'hAA



After the rising clock edge:



R1 = 8'hAA



If we = 0, no write happens even if waddr and wdata are changed.





\## Combinational Read



Read does not wait for the clock.



The read data changes when the read address changes.



ex)



raddr1 = 2'b01

=> rdata1 = R1



raddr2 = 2'b10

=> rdata2 = R2



Hardware interpretation:



Read port 1 is a mux selecting one of R0, R1, R2, R3.

Read port 2 is another mux selecting one of R0, R1, R2, R3.



Therefore, two different registers can be read at the same time.





\## HARDWIRE\_R0 Behavior



The parameter HARDWIRE\_R0 controls whether R0 is a normal register or a hardwired zero register.



1\. HARDWIRE\_R0 = 0



R0 is a normal writable register.



ex)



we = 1

waddr = 2'b00

wdata = 8'hA5



After the rising clock edge:



R0 = 8'hA5



So reading R0 returns:



rdata = 8'hA5





2\. HARDWIRE\_R0 = 1



R0 is always 0 and ignores writes, similar to RISC-V x0.



ex)



we = 1

waddr = 2'b00

wdata = 8'hA5



After the rising clock edge:



R0 = 8'h00



So reading R0 returns:



rdata = 8'h00



Other registers still work normally.



ex) R1 can still be written and read even when HARDWIRE\_R0 =1.





\## Testbench



The testbench instantiates two register files.



dut\_normal:

HARDWIRE\_R0 = 0



dut\_hardr0:

HARDWIRE\_R0 = 1



Both DUTs receive the same input signals.



This makes it easy to compare normal R0 behavior and hardwired R0 behavior.





\## Same-Address Read/Write Behavior



Testbench also checks what happens when the same register is read and written at the same time.



ex)



R3 old value = 8'h00

raddr1 = 2'b11

waddr = 2'b11

wdata = 8'hC3

we = 1



Before the clock edge:



rdata1 = 8'h00



After the clock edge:



R3 = 8'hC3

rdata1 = 8'hC3



Reason:



Write is synchronous, so the register changes only at the clock edge.

Read is combinational, so after the register changes, the read output also changes.



