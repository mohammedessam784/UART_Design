`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.08.2025 03:21:52
// Design Name: 
// Module Name: tb_baud_rate_generator
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


module tb_baud_rate_generator;
// Parameters
    localparam BITS = 10;
    localparam FINAL_VAL =10;
    // Testbench signals
    reg clk;
    reg rst;
    reg en;
    wire done;

    // DUT instantiation
    baud_rate_generator #(
        .BITS(BITS)
    ) uut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .FINAL_VALUE(FINAL_VAL),
        .done(done)
    );

    // Clock generation (period = 10ns => 100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
        // Stimulus
        initial begin
            // Initialize
            rst = 1;
            en  = 0;
            #20;             // hold reset
            rst = 0;
            en  = 1;
    
            // Run for some cycles
            #1500;
    
            // Disable enable to test behavior
            en = 0;
            #50;
            en = 1;
    
            // Run again
            #200;
    
            // Finish simulation
            $stop;
        end
  

endmodule
