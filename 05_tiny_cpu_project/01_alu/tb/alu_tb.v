`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hyung-Jin Lee 
// Module Name: alu_tb
// Project Name: tiny_cpu_project
//
// Description: 
// Testbench for the parameterized combinational ALU
// Applies basic arithmetic, logic, comparison, and pass-through test cases
// Checks the ALU result using a simple check task
//
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module alu_tb; // no port list

    localparam WIDTH = 8; // Define ALU width
    
    // Use reg for signals driven inside procedural blocks.
    // In a testbench, this does not necessarily imply a hardware flip-flop.
    reg  [WIDTH-1:0] a;
    reg  [WIDTH-1:0] b;
    reg  [2:0]       op;
    
    // Use wire for signals driven by uut/dut outputs
    wire [WIDTH-1:0] result;
    wire             zero;
    wire             carry;
    wire             negative;
    wire             overflow;

    alu #(
        .WIDTH(WIDTH) // parameter WIDTH from ALU module (= testbench WIDTH)
    ) uut (     // instance name. Unit Under Test
        .a(a),  // port ALU name (testbench signal name)
        .b(b),
        .op(op),
        .result(result),
        .zero(zero),
        .carry(carry),
        .negative(negative),
        .overflow(overflow)
    );

    // Understand task as a function, which makes repeated checking easier
    task check;
        input [WIDTH-1:0] expected;     // expected value from the task
        begin
            #1;     // delay for safety issues such as delta cycle or event scheduling
                    // ALU is combinational. No need to wait clk. Just short delay
                    
            if (result !== expected) begin  // !== is case inequality. Safer than != in testbench
                                            // Strict comparison including x,z in Verilog
                                            // x: unknown , z: high impedance
                                            
                $display("FAIL: a=%d b=%d op=%b result=%d expected=%d",     // %d is decimal
                         a, b, op, result, expected);                       // %b is binary
            end else begin
                $display("PASS: a=%d b=%d op=%b result=%d",
                         a, b, op, result);
            end
        end
    endtask

    initial begin
        $display("Starting ALU test...");

        // ADD
        a = 8'd10;      // a = 0000 1010
        b = 8'd5;
        op = 3'b000;    // 000 is ADD in ALU code
        check(8'd15);   // check made easier. Makes expected = 8'd15
        // PASS or FAIL should be printed here. Should be PASS.

        // SUB
        a = 8'd10;
        b = 8'd5;
        op = 3'b001;
        check(8'd5);

        // AND
        a = 8'b1010_1100;
        b = 8'b1100_1010;
        op = 3'b010;
        check(8'b1000_1000);

        // OR
        a = 8'b1010_1100;
        b = 8'b1100_1010;
        op = 3'b011;
        check(8'b1110_1110);

        // XOR
        a = 8'b1010_1100;
        b = 8'b1100_1010;
        op = 3'b100;
        check(8'b0110_0110);

        // EQ true
        a = 8'd7;
        b = 8'd7;
        op = 3'b101;
        check(8'd1);

        // EQ false
        a = 8'd7;
        b = 8'd8;
        op = 3'b101;
        check(8'd0);

        // LT true
        a = 8'd3;
        b = 8'd9;
        op = 3'b110;
        check(8'd1);

        // LT false
        a = 8'd9;
        b = 8'd3;
        op = 3'b110;
        check(8'd0);

        // PASS_A
        a = 8'd123;
        b = 8'd44;
        op = 3'b111;
        check(8'd123);

        // zero flag test
        a = 8'd5;
        b = 8'd5;
        op = 3'b001;    // SUB
        #1;
        if (zero !== 1'b1 || result !== 8'b0)
            $display("FAIL: zero flag should be 1");
        else
            $display("PASS: zero flag");

        // carry flag test : 255+1
        a = 8'd255;
        b = 8'd1;
        op = 3'b000;
        #1;
        if (carry !== 1'b1 || result !== 8'b0 || zero !== 1'b1)
            $display("FAIL: carry flag should be 1");
        else
            $display("PASS: carry flag");
        
        // overflow flag test : 127+1
        a = 8'd127;
        b = 8'd1;
        op = 3'b000;
        #1;
        // Practice concatenation: {1'b1,7'b0} = 8'b1000_0000
        if (overflow !== 1'b1 || result !== {1'b1, 7'b0})
            $display("FAIL: overflow flag should be 1");
        else
            $display("PASS: overflow flag");
        
        // negative flag test
        a = 8'd128;
        b = 8'd0;
        op = 3'b111; // PASS_A
        #1;
        if (negative !== 1'b1)
            $display("FAIL: negative should be 1");
        else
            $display("PASS: negative flag");

        $display("ALU test finished.");
        $finish;
    end

endmodule
