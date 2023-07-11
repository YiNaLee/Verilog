`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/19 15:11:31
// Design Name: 
// Module Name: scccomp_dataflow
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

//顶层模块 做一个映射 哪些时钟需要上升沿？
module sccomp_dataflow(
    input clk_in,
    input reset,

    //output  [7:0]o_seg,
    //output [7:0]o_sel
   output [31:0]inst,
   output [31:0]pc
   // output [31:0]DMWda,
    //output [31:0]DMRda
    );//读取inst，改变pc
   // wire[31:0]inst;
    //wire[31:0]pc;
    reg [31:0] my_mem[2047:0];
    wire dw, dr, dena;
    wire [31:0] dmw_data;
    wire [31:0] dmr_data;
    wire [10:0] dm_addr;
    wire [31:0] im_addr;
    wire [31:0] res;
    wire clk;
    wire [7:0]seg;
    wire [7:0]sel;
    assign o_seg=seg;
    assign o_sel=sel;
    assign dm_addr = (res - 32'h1001_0000) / 4;
   // assign DMWda=dmw_data;//写入dm的检查
    //assign DMRda=dmr_data;
/*  clk_div div(
        .clk_in(clk_in),.rst(reset),.clk_out(clk)
        );*/
        //   input clk,
        // input ena,
         ///input [10:0] addr,
         //output [31:0] instr
    imemory imemory(
        .addr(im_addr[10:0]),
        .instr(inst)
    );
  
    /*
    module IMEM(
    input [10:0]addr,
    output [31:0]instr
        );*/
   // assign instr=my_mem[im_addr];
    assign im_addr = (pc - 32'h0040_0000)/4;//右移两位后可以只取[10:0]
    //  input clk;
    //  input ena;
      //input dmw;
      //input dmr;
      //input [9:0] dm_addr;
      //input [31:0] dm_wdata;
      //output [31:0] dm_rdata;
    DMEM dmemory(
        .clk(clk_in), .ena(1), .dmw(dw), .dmr(dr), .dm_addr(dm_addr[10:0]), .dm_wdata(dmw_data),
        .dm_rdata(dmr_data)
    );
    //input clk,1
     //input rst,1
     //input ena,1
     //output DM_ena,1
     //output DM_w,1
     //output DM_r,1
     //input [31:0]IM_inst,1
     //input [31:0]DM_rdata,1
     //output [31:0]DM_wdata,1
     //output [31:0]pcout,1
     //output [31:0]aluout 1
CPU sccpu(
        .clk(clk_in),.rst(reset), .ena(1),.IM_inst(inst), .DM_rdata(dmr_data),
        .DM_ena(dena), .DM_w(dw), .DM_r(dr), .DM_wdata(dmw_data), .pcout(pc),.aluout(res)
    );
   /* seg7x16 segt(
            .clk(clk_in),.reset(reset),.cs(1'b1),.i_data(pc),.o_seg(seg),.o_sel(sel)
        );//选择将PC的值输出到七段数码管上*/
        
endmodule
