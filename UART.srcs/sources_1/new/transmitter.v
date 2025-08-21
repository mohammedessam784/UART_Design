`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.08.2025 03:16:20
// Design Name: 
// Module Name: transmitter
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


module transmitter#(parameter DBITS=8,SB_TICK=16)(
input clk,rst,
input s_tick,tx_start,
input [7:0] tx_din,
output reg tx,
output  reg tx_done_tick
    );
    localparam idle=2'b00;
    localparam start=2'b01;
    localparam data=2'b11;
    localparam stop=2'b10;
    reg [1:0] current_state,next_state;
    reg [4:0] s_reg,s_next;
    reg [4:0] n_reg,n_next;
    reg [DBITS-1:0] b_reg,b_next;
        //current state 
    always@(posedge clk or posedge rst) begin
          if(rst)begin
          current_state<=idle;
          s_reg <= 5'd0;
          n_reg <= 5'd0;
          b_reg <= {DBITS{1'd0}}; 
          end
          else begin
          current_state<=next_state;
          s_reg <= s_next;
          n_reg <= n_next;
          b_reg <= b_next;
          end
    end
    
     always@(*) begin
           
                       next_state=current_state;
                       s_next=s_reg ;
                       n_next=n_reg;
                       b_next= b_reg ;
                       tx=1'b1;
                       tx_done_tick=  1'b0;
              case(current_state)
              idle:    begin tx=1'b1;
                          if(tx_start==1'b1) begin 
                          tx_done_tick=  1'b1;
                          next_state=start;
                          s_next= 5'd0;
                          n_next =5'd0;
                         
                          
                          end
                       end 
              start :  begin  tx=1'b0;
                           if(s_tick) begin
                              if(s_reg==5'd15) begin
                                    next_state=data;
                                    s_next=5'd0;
                                    n_next=5'd0;
                                    b_next = tx_din ;                 
                              end
                              else s_next=s_reg+1;
                           end
                       end          
                       
                       
                       
               data : begin  tx=b_reg[n_reg];
                        if(s_tick) begin         
                             if(s_reg==5'd15) begin
                             s_next=5'd0;               
                             if(n_reg==DBITS-1) 
                             next_state= stop;
                             else 
                             n_next=n_reg+1;
                            end                             
                            else s_next=s_reg+1;
                          end
                       end                        
               stop :  begin  tx=1'b1;
                          if(s_tick) begin   
                               if(s_reg==SB_TICK-1) begin
                               //tx_done_tick =1'b1;
                               next_state= idle;
                               end
                               else s_next=s_reg+1;
                          end
                        end 
                 default : begin  
                              tx=1'b1;
                              next_state= idle; 
                           end
                 
              endcase
           
           end
    
   // assign tx_done_tick=(current_state==stop)&&(s_reg==SB_TICK-1);
        
endmodule
