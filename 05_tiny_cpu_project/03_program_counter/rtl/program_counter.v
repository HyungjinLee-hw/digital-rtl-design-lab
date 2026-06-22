`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hyung-Jin Lee
//
// Module Name: program_counter
// Project Name: tiny_cpu_project
//
// Description: 
// Program Counter (PC) register for the tiny CPU.
// The PC stores the address of the instruction currently being fetched.
//
// Additional Comments:
// This PC uses word addressing, so the normal increment is +1.
// In a byte-addressed CPU such as standard RISC-V, the PC would usually
// increment by +4 for 32-bit instructions.
// Reset is synchronous. Checked inside @(posedge clk)
//////////////////////////////////////////////////////////////////////////////////


module program_counter #(
    parameter PC_WIDTH = 8, // PC can represent addresses from 0 to 255
    parameter [PC_WIDTH-1:0] RESET_PC = {PC_WIDTH{1'b0}} // PC value after reset
)(
    input wire clk,     // PC updated only on the rising edge of clk
    input wire reset,   // Synchronous reset input
    
    // PC write enable. later useful for CPU halt, stall, or memory wait states
    // = 1: update PC on the next rising clk edge
    // = 0: Keep the current PC value
    input wire pc_write_en,
    
    // PC load control signal.
    // = 1: load pc_load_value into PC. Used for jump or taken branch instructions
    // = 0: increment PC normally by 1
    input wire pc_load,
    
    // Target address for a jump or branch
    input wire [PC_WIDTH-1:0] pc_load_value,
    
    // Current PC value. Type reg used for always block.
    // In synthesizable RTL, this becomes a bank of flip-flops.
    output reg [PC_WIDTH-1:0] pc   
);

    always @(posedge clk) begin
        if (reset) begin
            pc <= RESET_PC; 
        end
        else if (pc_write_en) begin      // PC updated only when pc_write_en = 1
            if (pc_load) begin          // Jump / branch case
                pc <= pc_load_value;    // Load the branch or jump target address
            end else begin              // Normal sequential instruction case
                pc <= pc + 1'b1;        // Move to the next instruction address
            end
        end
    end
endmodule
