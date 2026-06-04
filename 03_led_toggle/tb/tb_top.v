`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hyung-Jin Lee
// Module Name: tb_top
//
// Testbench for the full button-controlled LED toggle system.
//
// Signals to observe:
// btn       : raw button input with fake bouncing
// sync_btn  : synchronized button signal
// clean_btn : debounced stable button signal
// pulse     : one-clock-cycle pulse from edge detector
// led       : final LED state
//////////////////////////////////////////////////////////////////////////////////

module tb_top;

    reg clk;
    reg rst;
    reg btn;
    wire led;

    // Internal signals from the DUT for waveform observation
    wire sync_btn;
    wire clean_btn;
    wire pulse;

    // DUT: full top-level system
    top uut (
        .clk(clk),
        .rst(rst),
        .btn(btn),
        .led(led)
    );

    // Connect internal DUT signals to testbench wires
    // These are only for simulation/debug observation.
    assign sync_btn  = uut.sync_btn;
    assign clean_btn = uut.clean_btn;
    assign pulse     = uut.pulse;

    // 100MHz clock: period = 10ns
    always #5 clk = ~clk;

    initial begin
        // Initial values
        clk = 0;
        rst = 1;
        btn = 0;

        // Reset
        #20 rst = 0;

        // --------------------------------------------------
        // First button press with fake bouncing
        // Expected:
        // - btn bounces several times
        // - clean_btn changes only after debounce delay
        // - pulse becomes 1 for one clock cycle
        // - led toggles once
        // --------------------------------------------------
        #30 btn = 1;
        #10 btn = 0;
        #10 btn = 1;
        #10 btn = 0;
        #10 btn = 1;   // finally stable pressed

        // Hold button pressed long enough for debounce
        #200;

        // --------------------------------------------------
        // Button release with fake bouncing
        // Expected:
        // - clean_btn eventually returns to 0
        // - pulse should NOT occur because this edge detector
        //   only detects rising edges
        // - led should not toggle on release
        // --------------------------------------------------
        btn = 0;
        #10 btn = 1;
        #10 btn = 0;
        #10 btn = 1;
        #10 btn = 0;   // finally stable released

        #200;

        // --------------------------------------------------
        // Second button press without bounce
        // Expected:
        // - clean_btn goes high after debounce delay
        // - pulse occurs once
        // - led toggles again
        // --------------------------------------------------
        btn = 1;
        #200;

        // Release again
        btn = 0;
        #200;

        $finish;
    end

endmodule