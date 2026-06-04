// Edge Detector (Rising Edge)
// This module generates a one-clock-cycle pulse
// when the input signal transitions from 0 to 1.
//
// Why needed:
// After debounce, the signal is a stable level (0 or 1).
// But we often need a single pulse (event) instead of a level.
// For example, to toggle an LED only once per button press.
//
// Core idea:
// rising_edge = current_value AND (NOT previous_value)
//
// IMPORTANT:
// Non-blocking assignment (<=) ensures that 'prev' still holds
// the previous cycle value when used in the expression.

module edge_detector (
    input wire clk,
    input wire rst,
    input wire signal_in,
    output reg rising_edge
);
    reg prev;   // to store the previous state
    
    always @(posedge clk or posedge rst) begin
        if (rst)begin
            prev         <= 0;
            rising_edge  <= 0;
        end else begin  // Storing current data for the next clock
            rising_edge  <= signal_in & ~prev;
            prev         <= signal_in;
        end
    end

endmodule
