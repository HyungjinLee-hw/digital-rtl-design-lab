module led_blink(
    input wire clk,
    output reg led
);

reg[25:0] counter = 0;
always @(posedge clk) begin
    counter <= counter + 1;
    led <= counter[25];
end

endmodule