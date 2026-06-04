`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hyung-Jin Lee
// Module Name: synchronizer
// Project Name: 1011detector
// Description: 
// 2-stage flip-flop synchronizer for single-bit asynchronous input
//
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module synchronizer(
    input wire clk, rst, async_in,
    output reg sync_out
);
    reg sync_mid;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sync_mid <= 0;
            sync_out <= 0;
        end else begin
            sync_mid <= async_in;
            sync_out <= sync_mid;
        end
    end
endmodule