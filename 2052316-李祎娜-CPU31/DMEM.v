`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/14 21:30:55
// Design Name: 
// Module Name: DMEM
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

//数据存储器,大小为32*32
module DMEM(clk,ena,dmw,dmr,dm_addr,dm_wdata,dm_rdata);
    input clk;
    input ena;
    input dmw;
    input dmr;
    input [10:0] dm_addr;
    input [31:0] dm_wdata;
    output [31:0] dm_rdata;
   
    
    reg [31:0] Dmem[0:31];
    always @(posedge clk) begin//negedge
        if (dmw && ena) begin//写入
            Dmem[dm_addr] <= dm_wdata;
        end
    end
    
    assign dm_rdata = (dmr && ena) ? Dmem[dm_addr] : 32'bz;//读信号，并且ena无效时为高阻抗；
endmodule
