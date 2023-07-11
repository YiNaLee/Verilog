`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/13 20:54:42
// Design Name: 
// Module Name: pcreg
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

//数字逻辑实验写过，直接拿来用即可
module pcreg(clk,rst,ena,data_in,data_out);
input clk;
input rst;
input ena;
input [31:0]data_in;
output [31:0]data_out;
reg [31:0] PcRegister;
 // always @(posedge clk or posedge rst) begin//时钟的上升沿和下降沿有什么区别，会影响什么？
  always @(negedge clk or posedge rst) begin//时钟需要设置为下降沿，不然仿真会慢一个时钟
      if (ena) begin
          if (rst) begin
              PcRegister <= 32'h00400000;
          end
          else begin
              PcRegister <= data_in;
          end
      end
  end
  
  assign data_out = (ena && !rst) ? PcRegister : 32'hz;
endmodule


