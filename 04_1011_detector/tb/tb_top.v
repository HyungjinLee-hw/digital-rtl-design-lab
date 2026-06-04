`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hyung-Jin Lee
// Module Name: tb_top
// Project Name: 1011detector 
// Description: 
// Testbench for top-level 1011 sequence detector.
// Includes directed input patterns and random input patterns.
//
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module tb_top;
    reg clk, rst, signal_in;
    wire signal_out;
    
    // Internal observation signals
    wire sync_in;
    wire [1:0] state;
    
    integer i;
    
    top uut(
        .clk(clk),
        .rst(rst),
        .signal_in(signal_in),
        .signal_out(signal_out)
    );
    
    // Observe internal signals inside top
    assign sync_in = uut.sync_in;
    assign state = uut.u_sequence.state;
    
    // Clock generation
    // #5 -> 100MHz clock, period = 10ns
    always #5 clk = ~clk;
    
    
    task apply_bit;
        input bit_value;
        begin 
            @(negedge clk);
            signal_in = bit_value;
        end
    endtask    
        
    initial begin
        clk = 1'b0;
        rst = 1'b1;
        signal_in = 1'b0;
        
        #20 rst = 1'b0;
        
        // Wait a little after reset
        repeat(3) @(negedge clk);
        
        // Directed test 1: exact 1011
        // Expected: signal_out becomes 1 once
        apply_bit(1);
        apply_bit(0);
        apply_bit(1);
        apply_bit(1);

        repeat (5) @(negedge clk);
        
        // Directed test 2: non-matching pattern 1111
        // Expected: no detection
        apply_bit(1);
        apply_bit(1);
        apply_bit(1);
        apply_bit(1);

        repeat (5) @(negedge clk);
        
        // Directed test 3: overlapping pattern 1011011
        // Expected: detection twice
        // 1011 appears, then another 1011 overlaps later
        apply_bit(1);
        apply_bit(0);
        apply_bit(1);
        apply_bit(1);
        apply_bit(0);
        apply_bit(1);
        apply_bit(1);

        repeat (5) @(negedge clk);
        
        // Random test
        // Expected:
        // Watch signal_in, sync_in, state, and signal_out.
        // Whenever synchronized input stream contains 1011,
        // signal_out should pulse high for one clock.
        for (i = 0; i < 40; i = i + 1) begin
            apply_bit($random);
        end

        repeat (10) @(negedge clk);
        
        $finish;
    end
endmodule
