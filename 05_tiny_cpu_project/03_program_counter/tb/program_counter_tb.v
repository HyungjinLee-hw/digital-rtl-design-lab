`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hyung-Jin Lee
//
// Module Name: program_counter_tb
// Project Name: tiny_cpu_project
// Description: 
// Testbench for the Program Counter
// This testbench generates a clock, applies input stimulus to the DUT,
// and checks whether the PC output matches the expected value
//
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module program_counter_tb;
    localparam PC_WIDTH = 8;    // Keep the same PC width as the DUT configuration
    
    reg clk;
    reg reset;
    
    reg pc_write_en;
    reg pc_load;
    reg [PC_WIDTH-1:0] pc_load_value;
    
    wire [PC_WIDTH-1:0] pc;
    
    // Instantiates the actual program counter module that is being tested
    program_counter#(
        .PC_WIDTH(PC_WIDTH),
        .RESET_PC(8'd0)
    ) dut(
        .clk(clk),
        .reset(reset),
        
        .pc_write_en(pc_write_en),
        .pc_load(pc_load),
        .pc_load_value(pc_load_value),
        .pc(pc)
    );
    
    always #5 clk = ~clk;
    
    // Task for checking the current PC value
    task check_pc;
        input [PC_WIDTH-1:0] expected_pc;
        input [8*80-1:0]test_name;
        
        begin
            if (pc !== expected_pc) begin
                $display("FAIL: %0s | expected PC = %0d, actual PC = %0d",
                            test_name, expected_pc, pc);
            end else begin
                $display("PASS: %0s | PC = %0d", test_name, pc);
            end
        end
    endtask
    
    // Task for advancing simulation by one rising clock edge
    // Wait 1 timescale (1ns) after the rising edge so non-blocking assignments in
    // the DUT have time to update PC before check_pc is called
    task tick;
        begin
            @(posedge clk);
            #1;     // Wait 1 timescale (1ns) after the rising edge so non-blocking
                    // assignments in the D have time to update PC before
                    // check PC is called
        end
    endtask
    
    // Main test sequence
    initial begin
        clk             = 0;
        reset           = 0;
        pc_write_en     = 0;
        pc_load         = 0;
        pc_load_value   = 0;
        
        // Test 1: Reset
        reset = 1;
        tick;
        check_pc(8'd0, "Reset sets PC to 0");
        
        // Test 2: Normal increment
        reset = 0;
        pc_write_en = 1;
        pc_load = 0;
        
        tick;
        check_pc(8'd1, "PC increments from 0 to 1");
        
        tick;
        check_pc(8'd2, "PC increments from 1 to 2");
        
        tick;
        check_pc(8'd3, "PC increments from 2 to 3");
        
        // Test 3: Hold PC
        pc_write_en = 0;
        
        tick;
        check_pc(8'd3, "PC holds when pc_write_en = 0");
        
        tick;
        check_pc(8'd3, "PC still holds when pc_write_en = 0");
        
        // Test4: pc_load must not update PC when pc_write_en = 0
        pc_load = 1;
        pc_load_value = 8'd99;
        
        tick;
        check_pc(8'd3, "PC holds when pc_load = 1 but pc_write_en = 0");
        
        // Test5: Load branch / jump target
        pc_write_en = 1;
        pc_load = 1;
        pc_load_value = 8'd40;
        
        tick;
        check_pc(8'd40, "PC loads jump target");
        
        // Test6: Increment after jump
        pc_load = 0;
        
        tick;
        check_pc(8'd41, "PC increments after jump target");
        
        // Test7: Reset priority
        pc_load = 1;
        pc_load_value = 8'd100;
        reset = 1;
        
        tick;
        check_pc(8'd0, "Reset has priority over PC load");
        
        // Test8: Overflow
        reset = 0;
        pc_write_en = 1;
        pc_load = 1;
        pc_load_value = 8'hFF;
        
        tick;
        check_pc(8'hFF, "PC loads maximum address");
        
        pc_load = 0;
        
        tick;
        check_pc(8'h00, "PC wraps around after maximum address");
        
        $display("All Program Counter tests completed.");
        $finish;
    end
       
endmodule
























