`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Engineer: Hyung-Jin Lee
// Module Name: sequence_detector
// Project Name: 1011detector
// Description:
// FSM-based 1011 sequence detector.
//
// This module checks the serial input stream one bit per clock cycle.
// When the pattern "1011" appears, signal_out becomes 1 for one clock cycle. 
//
// Additional Comments:
//
// State meanings:
// S0 : no match
// S1 : matched "1"
// S2 : matched "10"
// S3 : matched "101"
//
// Example:
//
// input stream : 1 0 1 1
// FSM states   : S1 S2 S3 detect
// output       : 0  0  0  1
//
// Overlapping patterns are supported.
// Example:
// input : 1011011
// output detects two "1011" patterns.
//////////////////////////////////////////////////////////////////////////////////


module sequence_detector(
    input wire clk, rst, signal_in,
    output reg signal_out
    );
    
    // FSM state definitions
    localparam S0 = 2'b00;  // matched nothing
    localparam S1 = 2'b01;  // matched "1"
    localparam S2 = 2'b10;  // matched "10"
    localparam S3 = 2'b11;  // matched "101"
    
    // Current FSM state register
    reg [1:0] state;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S0;
            signal_out <= 0;
        end else begin
            // Default output: signal_out is normally 0.
            // It becomes 1 only when "1011" is detected.
            signal_out <= 0;
            
            // FSM state transition logic
            case (state)
                // S0 : matched nothing
                // Waiting for first '1'
                S0: begin
                    if (signal_in == 1)
                        state <= S1;
                    else
                        state <= S0;
                end
                
                // S1 : matched "1"
                // Expecting next bit = 0 
                S1: begin
                    if (signal_in == 0)
                        // "10" matched
                        state <= S2;
                    else
                        // Another '1' can still be the start of a new pattern
                        state <= S1;
                end
                
                // S2 : matched "10"
                // Expecting next bit = 1
                S2: begin
                    if (signal_in == 1)
                        // "101" matched
                        state <= S3;
                    else
                        // Pattern broken
                        state <= S0;
                end
                
                // S3 : matched "101"
                // Expecting final bit = 1
                S3: begin
                    if (signal_in == 1) begin
                        // Full pattern "1011" detected
                        signal_out <= 1;
                        
                        // Overlap support:
                        // last '1' can become the start of the next pattern
                        state <= S1;
                    end else begin
                        // Input sequence becomes "1010"
                        // Last two bits are "10", so move to S2 instead of S0
                        state <= S2;
                    end
                end
                
                // Safety fallback state
                default: begin
                    state      <= S0;
                    signal_out <= 0;
                end
            endcase
        end
    end       
endmodule