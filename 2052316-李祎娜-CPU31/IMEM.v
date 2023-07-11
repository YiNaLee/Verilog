`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/19 09:44:48
// Design Name: 
// Module Name: IMEM
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


module IMEM(
input [10:0]addr,
output [31:0]instr
    );
    dist_mem_gen_0 intr_mem(.a(addr), .spo(instr)); 
    /*µ÷ÓÃipºËmodule dist_mem_gen_0(a, spo)*/
  
     /* input [10:0]a;
      output [31:0]spo;*/
endmodule
