`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/16 15:40:34
// Design Name: 
// Module Name: clk_div
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


module clk_div(
input clk_in,
input rst,
output clk_out
    );
   reg [20:0]counter;
        always @ (posedge clk_in or posedge rst)begin
            if(rst)begin 
                counter<=0;
            end
            else begin
                counter<=counter+1'b1;
            end
        end
        assign clk_out=counter[20];
endmodule

