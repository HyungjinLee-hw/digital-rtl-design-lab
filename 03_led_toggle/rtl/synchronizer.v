// Synchronizer: safely brings an asynchronous signal into the local clock domain
// by reducing metastability risk using a 2-stage flip-flop chain
// Metastability: if the input changes close to the clock edge,
// the flip-flop may enter an unstable state (neither 0 nor 1 for a short time)
// NOTE: This structure does NOT eliminate metastability,
// but reduces its probability to an acceptable level

module synchronizer (       //start of the module
    input wire clk,         // you can call synchronizer u_sync (...) from a higher module
    input wire rst,         
    input wire async_in,    // pins that are connected to the external part of the module
    output reg sync_out     // use reg, bc its value changes inside the always block
);

reg sync_ff;        // first stage flip-flop (intermediate register)
    
always @(posedge clk or posedge rst) begin  // ff. Executed at the positive edge of the clock or reset
    if (rst) begin              // resets sync_ff and sync_out
        sync_ff <= 0;           // use non-blocking assignment <= in sequential 
        sync_out <= 0;
    end 
    else begin
        sync_ff <= async_in;    // 1st stage: sample async input
        sync_out <= sync_ff;    // 2nd stage: re-sample for stability
    end
end
    
endmodule