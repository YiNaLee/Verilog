`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/03 19:36:45
// Design Name: 
// Module Name: imemory
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

//前仿真专用
module imemory(
input [10:0]addr,
output [31:0]instr
    );
 reg [31:0] my_mem[2047:0];
 initial begin $readmemh("F:/jzsy/try_CPU31/try_CPU31.srcs/sources_1/new/data.txt",my_mem);
 end
assign instr=my_mem[addr];
endmodule
