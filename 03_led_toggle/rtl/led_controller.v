// LED Controller
// ---------------------------------------------
// Toggles the LED state whenever a one-cycle toggle pulse is received.
//
// Operation:
// - reset -> LED OFF
// - toggle_pulse = 1 -> invert LED state
// - otherwise -> keep current LED state
//
// This is a simple sequential state-holding circuit.

module led_controller (
    input wire clk,             // System clock
    input wire rst,             // Asynchronous active-high reset
    input wire toggle_pulse,    // One-cycle pulse from edge_detector
    output reg led              // LED output state
);
    always @(posedge clk or posedge rst) begin
        if(rst) begin           // Initialize LED to OFF
            led <= 0;
        end else begin
            if (toggle_pulse)   // Toggle LED state on pulse
                led <= ~led;
        end
    end

endmodule