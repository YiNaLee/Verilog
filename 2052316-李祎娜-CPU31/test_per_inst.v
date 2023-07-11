`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/19 14:35:51
// Design Name: 
// Module Name: test_per_inst
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


module test_per_inst;
/*module CPU(
//cpu需要五个输入，六个输出
 input clk,
 input rst,
 input ena,
 output DM_ena,
 output DM_w,
 output DM_r,
 input [31:0]IM_inst,
 input [31:0]DM_rdata,
 output [31:0]DM_wdata,
 output [31:0]pcout,
 output [31:0]aluout
    );*/
reg clk;
reg rst;
wire dmena;
wire dmw;
wire dmr;
reg [31:0]im_inst;
reg [31:0]dm_rdata;
wire [31:0]dm_wdata;
wire [31:0]pcout;
wire [31:0]aluout;
CPU mycpu(clk,rst,1,dmena,dmw,dmr,im_inst,dm_rdata,dm_wdata,pcout,aluout);
initial
begin
clk=0;
rst=1;
im_inst<=32'h2000ffff;//addi $0,$0,0xffffffff
#50 rst=0;
end
always
begin
#10  clk=~clk;
end
endmodule
