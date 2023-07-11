`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/19 09:05:58
// Design Name: 
// Module Name: test_imem
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

/*module IMEM(
    input clk,
    input ena,
    input [10:0] addr,
    output [31:0] instr
    );*/
module test_imem;

reg [10:0]addr;
wire [31:0]instr;
initial 
begin
addr=11'b0;
end
always begin
#20 addr=addr+1'b1;
end
IMEM myimem(addr,instr);
endmodule
