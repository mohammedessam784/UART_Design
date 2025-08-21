`timescale 1ns / 1ns

module tb_transmitter;

    // Parameters
    parameter DBITS   = 8;
    parameter SB_TICK = 16;

    // Signals
    reg clk;
    reg rst;
    reg s_tick;
    reg tx_start;
    reg [DBITS-1:0] tx_din;
    wire tx;
    wire tx_done_tick;

    // Instantiate the DUT
    transmitter #(.DBITS(DBITS), .SB_TICK(SB_TICK)) uut (
        .clk(clk),
        .rst(rst),
        .s_tick(s_tick),
        .tx_start(tx_start),
        .tx_din(tx_din),
        .tx(tx),
        .tx_done_tick(tx_done_tick)
    );

    // Clock generation (50 MHz -> 20 ns period)
    initial clk = 0;
    always #10 clk = ~clk; // 50 MHz

    // Generate s_tick (Baud rate tick)
    // ??? ???? ??? s_tick ???? ?? 160 ns (???? 1/10 ?? ??????)
    initial begin
        s_tick = 0;
        forever begin
            #80  s_tick = 1;
            #20  s_tick = 0;
        end
    end

    // Test sequence
    initial begin
        // Initial values
        rst = 1;
        tx_start = 0;
        tx_din = 0;

        // Apply reset
        #50 rst = 0;

        // Send first byte
        @(negedge clk);
        tx_din = 8'hA5; // 10100101
        tx_start = 1;
        @(negedge clk);
        tx_start = 0;

        // Wait until transmission done
        wait(tx_done_tick == 1);
        @(posedge clk);
       #200
        // Send second byte
        @(negedge clk);
        tx_din = 8'h3C; // 00111100
        tx_start = 1;
        @(negedge clk);
        tx_start = 0;

        // Wait until done
        wait(tx_done_tick == 1);
        @(posedge clk);

        // Finish simulation
        #100 $stop;
    end

endmodule
