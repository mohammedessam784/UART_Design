`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.08.2025 04:43:52
// Design Name: 
// Module Name: reseiver
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


module receiver#(parameter DBITS=8,SB_TICK=16)(
input clk,rst,rx,s_tick,
output [7:0] rx_dout,
output reg rx_done_tick
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
          s_reg <= 4'd0;
          n_reg <= 4'd0;
          b_reg <= {DBITS{1'd0}};   
          end
          else begin
          current_state<=next_state;
          s_reg <= s_next;
          n_reg <= n_next;
          b_reg <= b_next;
          end
    end
    
       //next_state
        always@(*) begin
        
                    next_state=current_state;
                    s_next=s_reg ;
                    n_next=n_reg;
                    b_next= b_reg ;
                    rx_done_tick =1'b0;
           case(current_state)
           idle:    begin
                       if(rx==1'b0) begin   
                       next_state=start;
                       s_next= 4'd0;
                       n_next =4'd0;
                       b_next = {DBITS{1'b0}};
                       end
                    end 
                    
           start :  begin
                       if(s_tick) begin
                           if(s_reg==4'd7) begin
                             next_state=data;
                             s_next=4'd0;
                             n_next=4'd0;                 
                            end
                            else s_next=s_reg+1;
                         end
                      end
             data : begin
                       if(s_tick) begin
                           if(s_reg==4'd15) begin
                               s_next=4'd0;
                               b_next = {rx, b_reg[DBITS-1:1]};                   
                               if(n_reg==DBITS-1) 
                               next_state= stop;
                               else 
                               n_next=n_reg+1;
                           end                             
                           else s_next=s_reg+1;
                       end         
                     end
             stop :  begin
                         if(s_tick) begin   
                            if(s_reg==SB_TICK-1) begin
                             next_state= idle;
                             rx_done_tick =1'b1;
                             end
                             else s_next=s_reg+1;
                          end
                      end   

              default :next_state= idle;
              
           endcase
        
        end
       
       assign rx_dout=b_reg;
      // assign rx_done_tick=(current_state==stop)&&(s_reg==SB_TICK-1);
    
endmodule
