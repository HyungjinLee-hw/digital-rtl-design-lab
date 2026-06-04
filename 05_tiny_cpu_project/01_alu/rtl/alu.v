`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Engineer:  Hyung-Jin Lee
// Module Name: alu
// Project Name: tiny_cpu_project
//
// Description: 
// Combinational ALU for a tiny CPU.
// Supports arithmetic, logic, comparison, and pass-through operations.
// This module does not contain flip-flops.
// Output changes immediately when input a, b, or op changes.
//
// Additional Comments:
//   Later, CPU control logic will select op.
//   Branch logic can use zero/negative flags.
//   Carry/overflow are mainly meaningful for ADD/SUB.
//////////////////////////////////////////////////////////////////////////////////

module alu #(               // #( ) declares configurable compile-time parameters for this module.
    parameter WIDTH = 8     // Data width of ALU. Easy to change.
)(
    input wire [WIDTH-1:0] a,   // First operand
    input wire [WIDTH-1:0] b,   // Second operand
    input wire [2:0] op,        // Selects which ALU operation to perform
    
    output reg [WIDTH-1:0] result,  // ALU output. reg because assigned inside always @(*)
    output wire     zero,           // 1 if result is 0. Useful for branch-if-zero
    output reg      carry,          // Carry-out for ADD. For SUB, indicates unsigned borrow behavior
    output wire     negative,       // MSB of result. Used as sign bit in signed interpretation
    output reg      overflow        // Signed overflow flag for ADD/SUB
);

    // Operation encoding.
    // In a CPU, instruction decoder will generate this op value.
    localparam OP_ADD = 3'b000;
    localparam OP_SUB   = 3'b001;
    localparam OP_AND   = 3'b010;
    localparam OP_OR    = 3'b011;
    localparam OP_XOR   = 3'b100;
    localparam OP_EQ    = 3'b101;
    localparam OP_LT    = 3'b110;
    localparam OP_PASSA = 3'b111;

    // One extra bit is used to catch carry-out from addition/subtraction.
    // Example: WIDTH=8 -> temp is 9 bits.
    reg [WIDTH:0] temp;

// Combinational logic block.
// No clock. No flip-flop.
// Output depends only on current inputs.
    always @(*) begin   // Default values. Important to avoid unintended latch inference.
        result   = {WIDTH{1'b0}};
        carry    = 1'b0;
        overflow = 1'b0;
        temp     = {(WIDTH+1){1'b0}};

        case (op)
  
            OP_ADD: begin   // Unsigned addition plus signed overflow detection.
                temp   = {1'b0, a} + {1'b0, b};     // Extend operands to catch carry-out
                result = temp[WIDTH-1:0];           // Lower WIDTH bits become result
                carry  = temp[WIDTH];               // Extra bit becomes carry-out

                // Signed overflow happens when:
                // positive + positive = negative, or negative + negative = positive.
                overflow = (a[WIDTH-1] == b[WIDTH-1]) &&
                           (result[WIDTH-1] != a[WIDTH-1]);
            end


            OP_SUB: begin
                temp   = {1'b0, a} - {1'b0, b};
                result = temp[WIDTH-1:0];
                carry  = temp[WIDTH];
 // Signed overflow happens when signs of a and b are different, and result sign differs from a sign.
                overflow = (a[WIDTH-1] != b[WIDTH-1]) &&
                           (result[WIDTH-1] != a[WIDTH-1]);
            end

            OP_AND: begin   // Bitwise AND.
                result = a & b;
            end

            OP_OR: begin    // Bitwise OR.
                result = a | b;
            end

            OP_XOR: begin   // Bitwise XOR.
                result = a ^ b;
            end

            // Equality comparison.
            // Result is 1 if equal, otherwise 0.
            OP_EQ: begin
                result = (a == b) ? {{(WIDTH-1){1'b0}}, 1'b1} : {WIDTH{1'b0}};
                // Condition? value when true : value when false
            end

            // Unsigned less-than comparison.
            // Careful: this is unsigned because a and b are not declared signed.
            OP_LT: begin
                result = (a < b) ? {{(WIDTH-1){1'b0}}, 1'b1} : {WIDTH{1'b0}};
            end
            
            // Pass-through operation.
            // Useful for move/load/immediate-style datapath operations later.
            OP_PASSA: begin
                result = a;
            end
            
            // Safety default.
            // If op is invalid, output zero.
            default: begin
                result = {WIDTH{1'b0}};
            end
        endcase
    end

    // Flag generation.
    // These are continuous assignments, so they always reflect current result.
    assign zero     = (result == {WIDTH{1'b0}});
    assign negative = result[WIDTH-1];

endmodule