`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: HJ Lee 
// Module Name: dff
// Create Date: 2026/03/19 15:24:02


//data stored in reg q, almost essential in sequential
//wire cannot remember/store data, only reg
//wire is used for continuous connections (no procedural assignment)
//reg is used when assigned inside always/initial blocks

//reg ist not hardware register.
//reg is a variable in a procedural block(always,initial etc)
//q is declared as reg because it is assigned inside an always block.
//In this clocked always block, q behaves like stored state.
module dff(
    input wire clk,
    input wire rst,
    input wire d,
    output reg q 

);

//block runs only when clock,reset goes up(positive edge)
// <= non-blocking assignment. For sequential
// <= schedules value. used to update everything at once
// new value is applied after block_always finishes
//if(rst) gives reset priority
always @(posedge clk or posedge rst) begin 
    if (rst)
        q <= 0;
    else
        q <= d;
end
//begin...end groups multiple statements into one block
//always at (...) : run this block when the listed event happens

endmodule
