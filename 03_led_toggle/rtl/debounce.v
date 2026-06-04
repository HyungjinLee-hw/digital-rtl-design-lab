// Debounce: filters out short, unstable transitions from a noisy input signal.
//
// Mechanical buttons do not switch cleanly between 0 and 1.
// When pressed or released, they often bounce for a short time:
// ex) 0 -> 1 -> 0 -> 1 -> 1 ...
//
// This module changes the output only when the input has remained
// different from the current stable state for a sufficiently long time.
//
// Operation:
// - If the input matches the current stable state, reset the counter.
// - If the input is different, start counting.
// - Only after the input stays different long enough, accept the new state.
//
// Usually used after synchronizer
//
// Counter Width:
// reg [3:0] counter; is a 4bit register. It can count from 0000 to 1111 which is 0 to 15.
// reg [WIDTH-1:0] counter becomes reg [19:0] counter when WITDH = 20. Therefore, a 20 bit counter.

module debounce #(
    parameter WIDTH = 20    // Counter width: determines how long the input must remain stable
)(
    input wire clk,
    input wire rst,
    input wire mnoisy_in,   // Noisy input signal (for example, from a push button)
    output reg clean_out    // Debounced, stable output signal
);
    reg [WIDTH-1:0] counter;    // Counts how long the input stays different from the stable state. 
    reg stable_state;           // Stores the currently accepted stable state   
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter      <= 0;
            stable_state <= 0;
            clean_out    <= 0;
        end else begin
            if(mnoisy_in == stable_state) begin     // Input matches the current stable state: 
            counter <= 0;                           // no new transition is happening, so clear the counter
            
            end else begin 
                counter <= counter + 1;     // Input is different from the current stable state:
                                            // This may be a new press/release, so keep counting
                // Replication Operator: {repetition{bit size'(numeral system)value}}
                // ex.{4{1'b1} is 1111. {8{1'b0}} is 00000000. b stands for binary number.
                // {WIDTH{1'b1}} creates a WIDTH-bit value where all bits are 1.
                // (counter == {WIDTH{1'b1}}). This condition checks whether the counter is full.
                if (counter == {WIDTH{1'b1}}) begin     // The input has remained different for long enough:
                    stable_state <= mnoisy_in;          // Accept it as the new stable state
                    clean_out    <= mnoisy_in;
                end
            end
        end
    end

endmodule