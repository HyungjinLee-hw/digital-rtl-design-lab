// Instruction format:
// [15:12] opcode | [11:10] rd | [9:8] rs1 | [7:6] rs2 | [5:0] reserved

//=============================================================
// Include Guard
//
// `ifndef: Checks whether TINY_CPU_DEFS_VH has not been defined yet
// `define: Defines TINY_CPU_DEFS_VH as a marker that this header has already been included
// `endif:  Ends the conditional block started by `ifndef
//
// Purpose: 
// Prevents the definitions in this header from being processed more than once
// even if multiple Verilog files include it.
//=============================================================

`ifndef TINY_CPU_DEFS_VH        // If not defined,
`define TINY_CPU_DEFS_VH        // Leave a sign that header is executed

//=============================================================
// CPU basic configuration
//=============================================================

// Width of one data value in the CPU
// Registers, ALU inputs, ALU result, and immediate values use 8 bits
`define CPU_DATA_WIDTH      8

// Width of a register address. With 2 bits, up to 4 registers can be selected
`define CPU_REG_ADDR_WIDTH  2

// Width of Program Counter. With 8 bits, up to 256 instructions can be addressed
`define CPU_PC_WIDTH        8

// Width of one instruction
`define CPU_INSTR_WIDTH     16

// Number of instructions stored in Instruction Memory
`define CPU_IMEM_DEPTH      256


//=============================================================
// ISA OPCODES. instruction[15:12] is the 4-bit opcode field
// This is used to identify the instructions.
//=============================================================

`define OP_NOP   4'b0000    // No operation. PC simply moves to next instruction.
`define OP_MOVI  4'b0001    // Move immediate value into destination register.
`define OP_ADD   4'b0010    // Addition
`define OP_SUB   4'b0011    // Subtraction
`define OP_AND   4'b0100    // Bitwise AND
`define OP_OR    4'b0101    // Bitwise OR
`define OP_XOR   4'b0110    // Bitwise XOR
`define OP_EQ    4'b0111    // Equality comparison
`define OP_LT    4'b1000    // Unsigned less than comparison
`define OP_MOV   4'b1001    // Copy one register value to another register. ALU PASSA
`define OP_HALT  4'b1010    // Stop CPU execution. PC stops increment. 
// Opcodes 1011 to 1111 are currently reserved / invalid.

//=============================================================
// ALU control values. 
// Must be identical to alu.v operation encoding
// This signal is given to the ALU
//=============================================================
`define ALU_OP_WIDTH   3        // Width of ALU operation control signal

`define ALU_OP_ADD     3'b000
`define ALU_OP_SUB     3'b001
`define ALU_OP_AND     3'b010
`define ALU_OP_OR      3'b011
`define ALU_OP_XOR     3'b100
`define ALU_OP_EQ      3'b101
`define ALU_OP_LT      3'b110
`define ALU_OP_PASSA   3'b111

//=============================================================
// Writeback MUX select values. 
// Controls which value is written back to Register File
//=============================================================

// Select ALU result as register write data
// Used by ADD, SUB, AND, OR, XOR, EQ, LT, MOV
`define WB_SEL_ALU     1'b0

// Select instruction immediate value as register write data.
// Used by MOVI
`define WB_SEL_IMM     1'b1

`endif