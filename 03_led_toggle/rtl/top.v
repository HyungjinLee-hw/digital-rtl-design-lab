// Top-level module for the button-controlled LED toggle system.
//
// Overall data flow:
// btn -> synchronizer -> debounce -> edge_detector -> led_controller -> led
//
// Purpose of each stage:
// 1. synchronizer : safely brings the asynchronous button input into the clock domain
// 2. debounce     : filters out mechanical button bounce
// 3. edge_detector: converts the stable button level into a one-clock pulse
// 4. led_controller: toggles and stores the LED state

module top (
    input wire clk,
    input wire rst,
    input wire btn,
    output wire led     // Wire because this module only connects the led_controller output
);

    wire sync_btn;      // Button signal after synchronization
    wire clean_btn;     // Button signal after debounce filtering
    wire pulse;         // One-clock pulse generated on button rising edge
                        
    
    // 1. synchronizer
    // Converts the asynchronous external button input into
    // a signal aligned with the system clock domain.
    // btn → synchronizer → sync_btn
    synchronizer u_sync (
        .clk(clk),
        .rst(rst),
        .async_in(btn),
        .sync_out(sync_btn)
    );
    
    // 2. debounce
    // Removes short unstable transitions caused by mechanical button bounce
    // sync_btn → debounce → clean_btn
    debounce #(
        .WIDTH(3)   // To see simulation faster
        ) u_db (
        .clk(clk),
        .rst(rst),
        .mnoisy_in(sync_btn),
        .clean_out(clean_btn)
    );
    
    // 3. edge detector
    // Generates a one-clock cycle pulse when the debounce signal transitions from 0 to 1
    // clean_btn → edge_detector → pulse
    edge_detector u_edge (
        .clk(clk),
        .rst(rst),
        .signal_in(clean_btn),
        .rising_edge(pulse)
    );
    
    // 4. LED controller
    // Toggles the LED state whenever a pulse is received
    // pulse → led_controller → led
    led_controller u_led (
        .clk(clk),
        .rst(rst),
        .toggle_pulse(pulse),
        .led(led)
    );

endmodule