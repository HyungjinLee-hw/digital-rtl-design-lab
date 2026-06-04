`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Hyung-Jin Lee
// Create Date: 2026/03/19 15:48:19
// Module Name: dff_tb
//////////////////////////////////////////////////////////////////////////////////

module dff_tb; //no port that's why ; not (..)
reg clk; //inputs. I should give the value
reg rst; //procedural assignment needed -> use reg
reg d;
wire q; //output. I do not give value myself

//get a circuit called dff and put in testbench
//uut = unit under test
dff uut (
    .clk(clk), //connect clk_testbench and clk_dff
    .rst(rst), //dff module port(choose testbench signal)
    .d(d),
    .q(q)
);

//toggle clk every 5 time units > clock period is 10 time units
always #5 clk = ~clk;

//executed only once at start
initial begin
    clk = 0;
    rst = 1;
    d = 0;
    
    #10 rst = 0;
    #10 d = 1;
    #10 d = 0;
    #10 d = 1;
    
    #20 $finish;
end

endmodule
