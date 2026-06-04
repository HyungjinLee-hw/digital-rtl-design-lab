`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:  Hyung-Jin Lee
// Module Name: top
// Project Name: 1011detector
// Description: 
// Top-level integration module for the 1011 sequence detector system.
//
// Overall data flow:
// signal_in -> synchronizer -> sync_in -> sequence_detector -> signal_out
//
// Purpose of each block:
//
// 1. synchronizer
//    - Safely brings the asynchronous external input into the system clock domain.
//    - Reduces metastability risk.
//
// 2. sequence_detector
//    - FSM-based detector for the serial pattern "1011".
//    - Generates a one-clock detection pulse.
//
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input wire clk, rst, signal_in,
    output wire signal_out
    );
    
    // Internal synchronized signal
    wire sync_in;
    
    synchronizer u_sync(
        .clk(clk),
        .rst(rst),
        .async_in(signal_in),
        .sync_out(sync_in)
    );
    
    sequence_detector u_sequence(
        .clk(clk),
        .rst(rst),
        .signal_in(sync_in),
        .signal_out(signal_out)
    );
endmodule