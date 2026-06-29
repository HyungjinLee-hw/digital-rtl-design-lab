`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hyung-Jin Lee
// 
// Module Name: instruction_memory_tb
// Project Name: tiny_cpu
//
// Description: 
// Testbench for instruction_memory.
// This testbench gives different instruction addresses to Instruction Memory
// and checks whether the expected 16-bit instruction is returned.
// The expected instruction values come from program.mem
//
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "tiny_cpu_defs.vh"

module instruction_memory_tb;

    // Address input given to Instruction Memory
    reg  [`CPU_PC_WIDTH-1:0]  addr;
    // Instruction output returned by Instruction Memory
    wire [`CPU_INSTR_WIDTH-1:0] instr;
    
    // Device Under Test
    // program.mem loaded into the internal memory array when the simulation begins.
    instruction_memory #(
        .INSTR_WIDTH(`CPU_INSTR_WIDTH),
        .ADDR_WIDTH(`CPU_PC_WIDTH),
        .DEPTH(`CPU_IMEM_DEPTH),
        .INIT_FILE("program.mem")   // Program file loaded by $readmemh
    ) dut (
        .addr(addr),
        .instr(instr)
    );

    integer error_count;    // Count the number of errors
    
    // Task:
    // 1. Apply a test address to Instruction Memory
    // 2. Wait for the combinational output to update
    // 3. Compare the returned instruction with expected_instr
    task check_instruction;
        input [`CPU_PC_WIDTH-1:0]  test_addr;
        input [`CPU_INSTR_WIDTH-1:0] expected_instr;

        begin
            // Give the test address to the DUT
            addr = test_addr;
            // Wait 1 time unit so DUT output can settle
            #1;

            // Case Inequality !==
            // Also treats X and Z values as mismatches.
            
            // X: unknown logic value
            // Can appear when a signal is uninitialized or conflicting drivers exist.
            
            // Z: high impedance/disconnected.
            // The signal is not actively driving the line with 0 or 1.
            if (instr !== expected_instr) begin
                error_count = error_count + 1;
                $display(
                    "FAIL | addr=%0d | expected=%h | got=%h",
                            test_addr, expected_instr, instr);
            end
            else begin
                $display(
                    "PASS | addr=%0d | instruction=%h",
                            test_addr, instr);
            end
        end
    endtask

    // Main test sequence
    initial begin
        // Initialize address, error_count before test start
        addr = 8'd0;
        error_count = 0;

        check_instruction(8'd0,  16'h140F);     // MOVI r1, 15 . left: destination
        check_instruction(8'd1,  16'h1803);     // MOVI r2, 3
        check_instruction(8'd2,  16'h2D80);     // ADD r3, r1, r2
        check_instruction(8'd3,  16'h3D80);     // SUB r3, r1, r2
        check_instruction(8'd4,  16'h4D80);     // AND r3, r1, r2
        check_instruction(8'd5,  16'h5D80);     // OR r3, r1, r2
        check_instruction(8'd6,  16'h6D80);     // XOR r3, r1, r2
        check_instruction(8'd7,  16'h7D80);     // EQ r3, r1, r2
        check_instruction(8'd8,  16'h8E40);     // LT r3, r2, r1
        check_instruction(8'd9,  16'h9D00);     // MOV r3, r1
        check_instruction(8'd10, 16'h9B00);     // MOV r2, r3
        check_instruction(8'd11, 16'hA000);     // HALT 

        // Check an unused valid memory location.
        // All entries initialized to 0. So mem[20] should be 16'h0000
        check_instruction(8'd20, 16'h0000);
        
        if (error_count == 0) begin
            $display("PASS: ALL Instruction memory tests passed");
        end else begin
            $display("FAIL: %0d Instruction Memory test(s) failed.", error_count);
        end
        $finish;
    end

endmodule