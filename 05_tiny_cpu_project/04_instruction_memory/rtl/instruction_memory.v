`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hyung-Jin Lee
// 
// Module Name: instruction_memory
// Project Name: tiny_cpu_project
// Description: 
// Stores the Tiny CPU program instructions.
//
// Program Counter (PC) provides an instruction address.
// This module outputs the 16-bit instruction stored at that address.
//
// This module has no write port, so the CPU can only read instructions during execution.
// The program is loaded once from program.mem at simulation start.
//
// Additional Comments:
// Addressing is instruction-based, not byte-based.
// Ex) addr = 0 -> mem[0] -> first instruction (16 bits)
//     addr = 1 -> mem[1] -> second instruction
//////////////////////////////////////////////////////////////////////////////////

// Import common CPU parameters such as instruction width,
// PC width, instruction memory depth, and opcode definitions.
`include "tiny_cpu_defs.vh"

module instruction_memory #(
    // Width of one instruction. Default: 16 bits.
    parameter INSTR_WIDTH = `CPU_INSTR_WIDTH,
    
    // Width of instruction address. Default: 8 bits.
    parameter ADDR_WIDTH  = `CPU_PC_WIDTH,
    
    // Number of instruction entries stored in memory. Default: 256 instructions.
    parameter DEPTH       = `CPU_IMEM_DEPTH,
    
    // File containing the program instructions in hexadecimal format.
    // Loaded into memory when simulation begins.
    parameter INIT_FILE   = "program.mem"
)(
    // Instruction address from Program Counter
    input  wire [ADDR_WIDTH-1:0]  addr,
    
    // Instruction stored at mem[addr].
    output wire [INSTR_WIDTH-1:0] instr
);
    
    // Instruction memory array.
    // Unpacked memory array: 
    // each entry has INSTR_WIDTH bits, and the array contains DEPTH entries.
    reg [INSTR_WIDTH-1:0] mem [0:DEPTH-1];
    
    // Loop variable used only for initialization.
    integer i;

    initial begin
        // First, initialize every instruction memory entry to 0.
        // This makes all unused program locations behave as NOP,
        // because an all-zero instruction has opcode 4'b0000.
        for (i = 0; i < DEPTH; i = i + 1) begin
            mem[i] = {INSTR_WIDTH{1'b0}};
        end
        
        // Load hexadecimal instruction values from INIT_FILE into mem[].
        // Ex) 140F -> mem[0] = 16'h140F
        //     1803 -> mem[1] = 16'h1803
        // $readmemh = read memory values as hexadecimal
        $readmemh(INIT_FILE, mem);
    end

    // Combinational read port. When addr changes, instr immediately becomes mem[addr].
    // Return all all-zero instruction if addr is outside the valid memory range.
    assign instr = (addr < DEPTH) ? mem[addr] : {INSTR_WIDTH{1'b0}};

endmodule