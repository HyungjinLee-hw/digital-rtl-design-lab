`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hyung-Jin LEE
// 
// Module Name: register_file_tb
// Project Name: tiny_cpu_project
// Description: 
// Testbench for 2 read 1 write register file
// Tests reset, write, read, overwrite, write enable, same-address behavior,
// and hardwired R0 behavior
//
//////////////////////////////////////////////////////////////////////////////////


module register_file_tb;
    // Default settings for testbench
    localparam WIDTH = 8;
    localparam ADDR_WIDTH = 2;
    localparam NUM_REGS = 4;
    
    // reg: testbench driven input signals
    // wire: DUT driven output signals 
    reg clk;
    reg rst;
    
    reg we;
    reg [ADDR_WIDTH-1:0] waddr;
    reg [WIDTH-1:0] wdata;
    
    reg [ADDR_WIDTH-1:0] raddr1;
    wire [WIDTH-1:0] rdata1;
    wire [WIDTH-1:0] rdata1_hardr0;
    
    reg [ADDR_WIDTH-1:0] raddr2;
    wire [WIDTH-1:0] rdata2;
    wire [WIDTH-1:0] rdata2_hardr0;
    
    // Normal register file
    // HARDWIRE_R0 = 0 : R0 is a normal writable register
    register_file #(
        .WIDTH(WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .NUM_REGS(NUM_REGS),
        .HARDWIRE_R0(0)
    ) dut_normal(
        .clk(clk),
        .rst(rst),
        .we(we),
        .waddr(waddr),
        .wdata(wdata),
        .raddr1(raddr1),
        .rdata1(rdata1),
        .raddr2(raddr2),
        .rdata2(rdata2)
    );
    
    // Hardwired-R0 register file
    // HARDWIRE_R0 = 1: R0 is always 0 and ignores writes
    register_file #(
        .WIDTH(WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .NUM_REGS(NUM_REGS),
        .HARDWIRE_R0(1)
    ) dut_hardr0(
        .clk(clk),
        .rst(rst),
        .we(we),
        .waddr(waddr),
        .wdata(wdata),
        .raddr1(raddr1),
        .rdata1(rdata1_hardr0),
        .raddr2(raddr2),
        .rdata2(rdata2_hardr0)
    );
    
    // clock period = 10ns , frequency = 100MHz
    always #5 clk = ~clk;
    
    task check;
        input [WIDTH-1:0] actual;
        input [WIDTH-1:0] expected;
        // ASCII standard: 1 character = 8bit = 1 byte
        // [511:0]. 8 bit * 64 characters = 512 bit
        input [8*64-1:0] test_name;
        begin
            if (actual !== expected) begin
                $display("FAIL: %s | expected = %h, actual = %h",
                          test_name, expected, actual);
            end else begin
                $display("PASS: %s | value = %h",
                          test_name, actual);
            end
        end
    endtask
    
    initial begin
        clk = 0;
        rst = 0;
        we = 0;
        waddr = 0;
        wdata = 0;
        raddr1 = 0;
        raddr2 = 0;
        
        // Reset
        rst = 1;
        @(posedge clk);
        #1;
        rst = 0;
        
        raddr1 = 2'b00;
        raddr2 = 2'b01;
        #1;
        check(rdata1, 8'h00, "Normal: After reset R0");
        check(rdata2, 8'h00, "Normal: After reset R1");
        check(rdata1_hardr0, 8'h00, "HardR0: after reset R0");
        
        // Write R1 = 0xAA
        we = 1;
        waddr = 2'b01;
        wdata = 8'hAA;
        @(posedge clk);
        #1;
        we = 0;
        
        raddr1 = 2'b01;
        #1;
        check(rdata1, 8'hAA, "Normal: Write and read R1");
        check(rdata1_hardr0, 8'hAA, "HardR0: Write and read R1");
        
        // Write R2 = 0x55
        we = 1;
        waddr = 2'b10;
        wdata = 8'h55;
        @(posedge clk);
        #1;
        we = 0;
        
        // Read R1, R2 at the same time. No write performed
        // Check if the two read ports can output two different registers simultaneously.
        we = 0;
        raddr1 = 2'b01;
        raddr2 = 2'b10;
        #1;
        check(rdata1, 8'hAA, "Normal: Read port 1 reads R1");
        check(rdata2, 8'h55, "Normal: Read port 2 reads R2");
        check(rdata1_hardr0, 8'hAA, "HardR0: Read port 1 reads R1");
        check(rdata2_hardr0, 8'h55, "HardR0: Read port 2 reads R2");
        
        // Overwrite R1 = 0x0F
        we = 1;
        waddr = 2'b01;
        wdata = 8'h0F;
        @(posedge clk);
        #1;
        we = 0;
        
        raddr1 = 2'b01;
        #1;
        check(rdata1, 8'h0F, "Normal: Overwrite R1");
        check(rdata1_hardr0, 8'h0F, "HardR0: Overwrite R1");
        
        // Write enable disabled : R3 should not change
        we = 0;
        waddr = 2'b11;
        wdata = 8'hF0;
        @(posedge clk);
        #1;
        
        raddr1 = 2'b11;
        #1;
        check(rdata1, 8'h00, "Normal: WE disabled, R3 unchanged");
        
        // Same-address read/write behavior
        // Before clock edge : old value visible
        // After clock edge: new value visible
        raddr1 = 2'b11;
        we = 1;
        waddr = 2'b11;
        wdata = 8'hC3;
        #1;
        check(rdata1, 8'h00, "Normal: Before clock edge, R3 old value");
        
        @(posedge clk);
        #1;
        we = 0;
        check(rdata1, 8'hC3, "Normal: After clock edge, R3 new value");
        
        // Test R0 behavior
        // Normal DUT should allow writing to R0
        // HardR0 DUT should ignore writes to R0
        we = 1;
        waddr = 2'b00;
        wdata = 8'hA5;
        @(posedge clk);
        #1;
        we = 0;
        
        raddr1 = 2'b00;
        raddr2 = 2'b00;
        #1;
        check(rdata1, 8'hA5, "Normal: R0 writable on read port 1");
        check(rdata2, 8'hA5, "Normal: R0 writable on read port 2");
        check(rdata1_hardr0, 8'h00, "HardR0: R0 ignores write on read port 1");
        check(rdata2_hardr0, 8'h00, "HardR0: R0 ignores write on read port 2");
        
        // Check that writing to R0 in HardR0 mode does not affect other registers
        raddr1 = 2'b01;
        #1;
        check(rdata1_hardr0, 8'h0F, "HardR0: R1 still works normally");
        
        $display("Register file testbench finished.");
        $finish;
    end
    
endmodule
