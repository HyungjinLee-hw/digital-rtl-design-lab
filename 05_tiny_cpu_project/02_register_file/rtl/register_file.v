`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Engineer: Hyung-Jin Lee
// 
// Module Name: register_file
// Project Name: tiny_cpu_project
//
// Description: 
// 2 read, 1 write register file for a tiny CPU
// Synchronous write
// Combinational read
// Optional hardwired R0 behavior.
//
// Additional Comments:
// This module is intended as a basic CPU building block
// In a real CPU, the register file feeds operands to the ALU
//
//////////////////////////////////////////////////////////////////////////////////


module register_file #(
    parameter WIDTH = 8,            // Bit-Width of each register. 
                                    // If 8-bit CPU, then normally 8-bit register.
    parameter ADDR_WIDTH = 2,       // Register address width. 2bits can address 4 registers
    parameter NUM_REGS = 4,         // Number of registers. Should match 2^ADDR_WIDTH
    parameter HARDWIRE_R0 = 0       // HARDWIRE_R0 = 0: R0 is a normal register
                                    // 1: R0 is hardwired to 0 and ignores writes. like RISC-V x0.
)(
    input wire clk,         // "Write" on clock edge. Selected register update
    input wire rst,         // Synchronous reset. Reset is inside: always @(posedge clk)
    
    input wire we,                          // write enable
    input wire [ADDR_WIDTH-1:0] waddr,      // write address. (hardware)write decoder 
    input wire [WIDTH-1:0] wdata,           // write data. D input of selected register
    
    input wire [ADDR_WIDTH-1:0] raddr1,     // read address 1
    output wire [WIDTH-1:0] rdata1,          // read data 1
    
    input wire [ADDR_WIDTH-1:0] raddr2,     // read address 2
    output wire [WIDTH-1:0] rdata2           // read data 2 
    // 2 read ports while ALU has 2 inputs. ALU has to read 2 registers at the same time
    // If only 1 read port, there has to be more cycles to read, which slows down the process
);
    // regs = array. Number of elements in regs: 0 to 3. Each element has 8 bits
    // regs[0] = 8 bit, regs[1] = 8 bit, regs[2] = 8 bit, regs[3] = 8 bit
    // This becomes R0, R1, R2, R3. Real register bc updated inside: always @(posedge clk)
    reg [WIDTH-1:0] regs [0:NUM_REGS-1];
    integer i;      // loop index for reset
    
    // Synchronous write (Sequential)
    always @(posedge clk) begin
        if (rst) begin      // If reset = 1, reset all registers to 8'b0
            for (i=0; i<NUM_REGS; i=i+1) begin
                regs[i] <= {WIDTH{1'b0}};   // {WIDTH{1'b0}} replication operator
            end                             // Easier to change than hard coding(8'b0)
        end else begin
            // Write only when write enable is active.
            // If HARDWIRE_R0 is enabled, writes to R0 are ignored
            // Otherwise, write wdata into the selected register on the clock edge
            if (we && !(HARDWIRE_R0 && (waddr == {ADDR_WIDTH{1'b0}}))) begin
                regs[waddr] <= wdata;
            end
            
            // Keep R0 = 0 every clock cycle when HARDWIRE_R0 is enabled
            if (HARDWIRE_R0) begin
                regs[0] <= {WIDTH{1'b0}};
            end
        end
    end
    
    // Combinational read. Implemented as(hardware)MUX. 2 read port, so 2 MUX
    // assign y = sel ? a:b. If sel = 1, y = a. If sel = 0, y = b. 
    // & bitwise AND. && logic AND. == equality comparison.
    // If HARDWIRE_R0 enabled and R0 selected, return 0.
    // Otherwise, return the selected register value
    assign rdata1 = (HARDWIRE_R0 && (raddr1 == {ADDR_WIDTH{1'b0}})) ? {WIDTH{1'b0}} : regs[raddr1];   
    assign rdata2 = (HARDWIRE_R0 && (raddr2 == {ADDR_WIDTH{1'b0}})) ? {WIDTH{1'b0}} : regs[raddr2];
    
endmodule
