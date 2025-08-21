`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.08.2025 16:18:55
// Design Name: 
// Module Name: UART
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


module UART #(parameter DBITS=8,SB_TICK=16, BITS=10)(
input clk,rst,
input [BITS-1:0]FINAL_VALUE,

input [7:0]w_data,
input wr_uart,
output tx_full,tx,

output [7:0] r_data,
output rx_empty,
input  rd_uart,
input rx
    );
    wire [7:0] dout_to_tx_din;
    wire tx_done_tick_to_rd_en;
    wire tx_empty;
    wire tx_start;
    wire s_tick;
    
    wire [7:0] rx_dout_to_din ;
    wire rx_done_tick_to_wr_en ;
            
   fifo_generator_0 tx_fifo (
      .clk(clk),      // input wire clk
      .srst(rst),    // input wire srst
      .din(w_data),      // input wire [7 : 0] din
      .wr_en(wr_uart),  // input wire wr_en
      .rd_en(tx_done_tick_to_rd_en),  // input wire rd_en
      .dout(dout_to_tx_din),    // output wire [7 : 0] dout
      .full(tx_full),    // output wire full
      .empty(tx_empty)  // output wire empty
    ); 
    
    assign tx_start=~tx_empty;
    
     transmitter #(.DBITS(DBITS), .SB_TICK(SB_TICK)) tx_UART (
           .clk(clk),
           .rst(rst),
           .s_tick(s_tick),
           .tx_start(tx_start),
           .tx_din(dout_to_tx_din),
           .tx(tx),
           .tx_done_tick(tx_done_tick_to_rd_en)
       );
       
        baud_rate_generator #(
             .BITS(DBITS)
         ) baud_rate (
             .clk(clk),
             .rst(rst),
             .en(1'b1),
             .FINAL_VALUE(FINAL_VALUE),
             .done(s_tick)
         ); 
        receiver #(.DBITS(8), .SB_TICK(16)) rx_UART (
             .clk(clk),
             .rst(rst),
             .rx(rx),
             .s_tick(s_tick),
             .rx_dout(rx_dout_to_din),
             .rx_done_tick(rx_done_tick_to_wr_en)
         ); 
        
       fifo_generator_0 rx_fifo (
              .clk(clk),      // input wire clk
              .srst(rst),    // input wire srst
              .din(rx_dout_to_din),      // input wire [7 : 0] din
              .wr_en(rx_done_tick_to_wr_en),  // input wire wr_en
              .rd_en(rd_uart),  // input wire rd_en
              .dout(r_data),    // output wire [7 : 0] dout
             // .full(rx_full),    // output wire full
              .empty(rx_empty)  // output wire empty
            );    
         
         
    
    
endmodule
