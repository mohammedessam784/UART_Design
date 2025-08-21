`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.08.2025 14:27:17
// Design Name: 
// Module Name: tb_UART
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_UART;

    // Parameters
    parameter DBITS = 8;
    parameter SB_TICK = 16;
    parameter BITS = 10;

    // Signals
    reg clk, rst;
    reg [BITS-1:0] FINAL_VALUE;
    reg [7:0] w_data;
    reg wr_uart;
    wire tx_full;
    wire tx;
    
    wire [7:0] r_data;
    wire rx_empty;
    reg  rd_uart;
    
    wire rx;
     
        
        wire [7:0] dout_to_tx_din;
        wire tx_done_tick_to_rd_en;
        wire tx_empty;
        wire tx_start;
        wire s_tick;
        
        wire [7:0] rx_dout_to_din ;
        wire rx_done_tick_to_wr_en ;

    // Instantiate UART
    UART #(.DBITS(DBITS), .SB_TICK(SB_TICK), .BITS(BITS)) uut (
        .clk(clk),
        .rst(rst),
        .FINAL_VALUE(FINAL_VALUE),
        .w_data(w_data),
        .wr_uart(wr_uart),
        .tx_full(tx_full),
        .tx(tx),
        
         .r_data(r_data),
         .rx_empty(rx_empty),
         .rd_uart(rd_uart),
         .rx(rx)
    );

    // Clock generation
    always #5 clk = ~clk; // 100MHz clock
    
           assign s_tick = uut.s_tick;
           assign dout_to_tx_din=uut.dout_to_tx_din;
           assign tx_done_tick_to_rd_en=uut.tx_done_tick_to_rd_en;
           assign tx_empty = uut.tx_empty;
           assign tx_start = uut.tx_start;
           assign rx_done_tick_to_wr_en= uut.rx_done_tick_to_wr_en;
           assign  rx_dout_to_din  = uut. rx_dout_to_din ;
            assign rx=tx;
          
    // Test procedure
    initial begin
        // Init
        clk = 0;
        rst = 1;
        wr_uart = 0;
        w_data = 8'h00;
        FINAL_VALUE = 10'd650; // small for fast simulation
        #50;
        
        // Release reset
        rst = 0;
        #20;

        // Send first byte
        send_byte(8'hA5);
        #50;

        // Send second byte
        send_byte(8'h3C);
        #50;

        // Send third byte
        send_byte(8'hF0);

        // Wait enough time for transmission
        #4000000;
receive_byte;
#50;
receive_byte;
#50;
receive_byte;
#50;
receive_byte;
#20;


        $stop;
    end

    // Task to send byte
    task send_byte(input [7:0] data);
    begin
        @(posedge clk);
        w_data = data;
        wr_uart = 1;
        @(posedge clk);
        wr_uart = 0;
    end
    endtask
   
   task receive_byte;
        begin
          // wait(rx_empty == 0);
            @(posedge clk);
            rd_uart = 1;
            @(posedge clk);
            rd_uart = 0;
        end
        endtask


endmodule
