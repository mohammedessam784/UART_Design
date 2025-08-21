`timescale 1ns/1ns

module tb_receiver;

reg clk, rst, s_tick, rx;
wire [7:0] rx_dout;
wire rx_done_tick;

// Instantiate receiver
receiver #(.DBITS(8), .SB_TICK(16)) uut (
    .clk(clk),
    .rst(rst),
    .rx(rx),
    .s_tick(s_tick),
    .rx_dout(rx_dout),
    .rx_done_tick(rx_done_tick)
);

// Generate clk
always #5 clk = ~clk; // 100 MHz -> period = 10ns

// Generate s_tick (16x oversampling)
integer count_tick = 0;
always @(posedge clk) begin
    count_tick <= count_tick + 1;
    if (count_tick == 15) begin
        s_tick <= 1;
        count_tick <= 0;
    end else begin
        s_tick <= 0;
    end
end

// Task to send 1 byte serially (LSB first)
task send_byte;
    input [7:0] data;
    integer i;
    begin
        // Start bit
        rx <= 0;
        repeat (256) @(posedge clk); // 1 bit period

        // Data bits
        for (i = 0; i < 8; i = i + 1) begin
            rx <= data[i];
            repeat (256) @(posedge clk);
        end

        // Stop bit
        rx <= 1;
        repeat (256) @(posedge clk);
    end
endtask

// Test sequence
initial begin
    clk = 0;
    s_tick = 0;
    rx = 1; // idle high
    rst = 1;
    #50;
    rst = 0;

    // Send byte 0xA5
    send_byte(8'hA5);

    // Send byte 0x3C
    send_byte(8'h3C);

    #200;
    $stop;
end

endmodule
