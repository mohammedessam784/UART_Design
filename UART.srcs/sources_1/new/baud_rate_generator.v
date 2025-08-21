`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.08.2025 02:24:48
// Design Name: 
// Module Name: baud_rate_generator
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


module baud_rate_generator #(parameter BITS=10)(
input clk ,rst,en,
input [BITS-1:0]FINAL_VALUE,
output done
    );
    
    reg [BITS-1:0] Q_reg,Q_next;
    always @(posedge clk or posedge rst) begin
       if(rst)
       Q_reg<={BITS{1'b0}}; 
       else if(en)
        Q_reg<=Q_next;
     end
     always @(*) begin
         Q_next=done?{BITS{1'b0}}: Q_reg+1;
     end
    assign done =( Q_reg==FINAL_VALUE);
       
endmodule
