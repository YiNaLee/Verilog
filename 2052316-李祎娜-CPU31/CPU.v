`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/22 11:29:49
// Design Name: 
// Module Name: CCPU
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


module CPU(
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
    );
 /*31条指令的简记符 通过识别op和func来判断之....................................................*/
 wire _add,_addu,_sub,_subu,_and,_or,_xor,_nor;//8条
 wire _slt,_sltu,_sll,_srl,_sra,_sllv,_srlv,_srav,_jr;//9条
 wire _addi,_addiu,_andi,_ori,_xori,_lw,_sw;//7条
 wire _beq,_bne,_slti,_sltiu,_lui,_j,_jal;//7条
 //判断各条指令是不是简记符，若是赋值为1
 //1-17条指令码的高六位都是000000； 编码方式相当于独热码
 assign _add=(IM_inst[31:26]==6'b000000&&IM_inst[5:0]==6'b100000)?1'b1:1'b0;
 assign _addu=(IM_inst[31:26]==6'b000000&&IM_inst[5:0]==6'b100001)?1'b1:1'b0;
 assign _sub=(IM_inst[31:26]==6'b000000&&IM_inst[5:0]==6'b100010)?1'b1:1'b0;
 assign _subu=(IM_inst[31:26]==6'b000000&&IM_inst[5:0]==6'b100011)?1'b1:1'b0;
 assign _and=(IM_inst[31:26]==6'b000000&&IM_inst[5:0]==6'b100100)?1'b1:1'b0;
 assign _or=(IM_inst[31:26]==6'b000000&&IM_inst[5:0]==6'b100101)?1'b1:1'b0;
 assign _xor=(IM_inst[31:26]==6'b000000&&IM_inst[5:0]==6'b100110)?1'b1:1'b0;
 assign _nor=(IM_inst[31:26]==6'b000000&&IM_inst[5:0]==6'b100111)?1'b1:1'b0;
 assign _slt=(IM_inst[31:26]==6'b000000&&IM_inst[5:0]==6'b101010)?1'b1:1'b0;
 assign _sltu=(IM_inst[31:26]==6'b000000&&IM_inst[5:0]==6'b101011)?1'b1:1'b0;
 assign _sll=(IM_inst[31:26]==6'b000000&&IM_inst[5:0]==6'b000000)?1'b1:1'b0;
 assign _srl=(IM_inst[31:26]==6'b000000&&IM_inst[5:0]==6'b000010)?1'b1:1'b0;
 assign _sra=(IM_inst[31:26]==6'b000000&&IM_inst[5:0]==6'b000011)?1'b1:1'b0;
 assign _sllv=(IM_inst[31:26]==6'b000000&&IM_inst[5:0]==6'b000100)?1'b1:1'b0;
 assign _srlv=(IM_inst[31:26]==6'b000000&&IM_inst[5:0]==6'b000110)?1'b1:1'b0;
 assign _srav=(IM_inst[31:26]==6'b000000&&IM_inst[5:0]==6'b000111)?1'b1:1'b0;
 assign _jr=(IM_inst[31:26]==6'b000000&&IM_inst[5:0]==6'b001000)?1'b1:1'b0;
 //18-31条 只从高六位判断
assign _addi = (IM_inst[31:26]==6'b001000)?1'b1:1'b0;
assign _addiu = (IM_inst[31:26]==6'b001001)?1'b1:1'b0;
assign _andi = (IM_inst[31:26]==6'b001100)?1'b1:1'b0;
assign _ori = (IM_inst[31:26]==6'b001101)?1'b1:1'b0;
assign _xori = (IM_inst[31:26]==6'b001110)?1'b1:1'b0;
assign _lw = (IM_inst[31:26]==6'b100011)?1'b1:1'b0;
assign _sw = (IM_inst[31:26]==6'b101011)?1'b1:1'b0;
assign _beq = (IM_inst[31:26]==6'b000100)?1'b1:1'b0;
assign _bne = (IM_inst[31:26]==6'b000101)?1'b1:1'b0;
assign _slti = (IM_inst[31:26]==6'b001010)?1'b1:1'b0;
assign _sltiu = (IM_inst[31:26]==6'b001011)?1'b1:1'b0;
assign _lui = (IM_inst[31:26]==6'b001111)?1'b1:1'b0;
assign _j = (IM_inst[31:26]==6'b000010)?1'b1:1'b0;
assign _jal = (IM_inst[31:26]==6'b000011)?1'b1:1'b0;

wire [3:0]ALUC;//4位aluc判断运算类型
wire zerof,carryf,negf,overflowf;//alu标志位
/*根据aluc的要求进行每一位的分配..............................................................................*/
assign ALUC[0]=_sub||_subu||_or||_nor||_slt||_srl||_srlv||_ori||_beq||_bne||_slti;
assign ALUC[1]=_sub||_xor||_nor||_sll||_sllv||_addi||_xori||_lw||_sw||_beq||_bne||_jal||_slti||_sltiu||_slt||_sltu;
assign ALUC[2]=_and||_or||_xor||_nor||_sll||_srl||_sra||_sllv||_srlv||_srav||_andi||_ori||_xori;
assign ALUC[3]=_sll||_srl||_sra||_sllv||_srlv||_srav||_lui||_slti||_sltiu||_slt||_sltu;
/*确定寄存器的读写地址........................................................................................*/
wire [4:0]rsc,rdc,rtc;//寄存器地址
assign rsc=(_sll||_srl||_sra||_lui||_j||_jal)?5'bz:IM_inst[25:21];//从寄存器读的地址1
assign rdc=(_add|_addu||_sub||_subu||_and||_or||_xor||_nor||_slt||_sltu||_sll||_srl||_sra||_sllv||_srlv||_srav)?IM_inst[15:11]:5'bz;
assign rtc=(_j||_jal)?5'bz:IM_inst[20:16];//从寄存器读的地址2
wire RF_w;//向寄存器堆写入标志 
assign RF_w = !(_jr || _sw || _beq || _bne|| _j);//只有几条指令不用RF_w
wire [31:0]npc,rs,rt,rd,alu_result;
wire [31:0]PC,pc_from;
assign pcout=PC;
assign npc=pcout+32'd4;//下一条指令的地址
assign aluout=alu_result;
wire DM_CS;//DM有效，读或者写数据
assign DM_CS=_lw||_sw;
assign DM_w=_sw;//向dmem内存写入数据
assign DM_r=_lw;//从dmem读出数据
assign DM_ena=_lw||_sw;//lw||sw
assign DM_wdata=DM_w?rt:32'bz;
wire [31:0] EXT18,HEXT16,UEXT16,SEXT16,EXT5,EXT1;
wire [31:0]j_comb,bjmpadder;
//12条取立即数的i型指令 将立即数存在imm_16中
wire [15:0]imm_16=(_addi||_addiu||_andi||_ori||_xori||_lw||_sw||_beq||_bne||_slti||_sltiu||_lui)?IM_inst[15:0]:16'bz;
//2条j型指令，跳转占用INST[25:0]
wire [25:0]address=(_j||_jal)?IM_inst[25:0]:26'bz;
//移位shamt：[10:6]
wire [4:0]shamt=(_sll||_srl||_sra)?IM_inst[10:6]:5'bz;
//下列操作都是为了填充到32位
assign EXT18=imm_16[15]==1?{14'b11111111111111,imm_16,2'b00}:{14'b0,imm_16,2'b00};//左移两位再进行符号扩展 BEQ指令所需要用到的操作
assign bjmpadder=EXT18+npc;//bjmpadder为BEQ所跳转地址
assign HEXT16={imm_16,16'b0};//低位填0 lui指令
assign UEXT16={16'b0,imm_16};//高位无符号扩展
assign SEXT16=imm_16[15]==1?{16'b1111111111111111,imm_16}:{16'b0,imm_16};//高位有符号扩展
assign EXT5={27'b0,shamt};//移动位数
assign EXT1={30'b0,negf};//;ext1不设计好像也可以
assign j_comb={pcout[31:28],address,2'b0};//j指令：跳转到26位长的地址；由PC[31:28]||IM[25:0]<<2组成
wire [4:0]RSC=rsc;
wire[4:0]RTC=rtc;

//每次采用二选一的数据选择器信号
wire m1,m2,m3,m4,m5,m6,m7,m8,m9,m10;
assign m1=(_beq&&zerof)||(_bne&&!zerof);
assign m2=_j||_jal;
assign m3=_jr;
/*always@(negedge clk or posedge rst)
	begin
		if(ena && rst)
			PC <= 32'h00400000;
		else if(ena)
		begin
			PC <= m3 ? rs : (m2 ? j_comb : (m1 ? npc + EXT18 : npc));//pc_from由m1m2m3联合给出
		end
	end*/
assign pc_from= m3 ? rs : (m2 ? j_comb : (m1 ? npc + EXT18 : npc));//pc_from由m1m2m3联合给出
//m4m5译码决定rd的来源	
assign m4=_jal;
assign m5=_lw;
assign rd = m4 ? pcout + 4 : (m5 ? DM_rdata : aluout);//_jal为pc+4；_lw为写入；否则写入alu运算结果
assign m6=_sll||_srl||_sra||_sllv||_srlv||_srav;//6条移位指令
assign m7=_sll||_srl||_sra;//立即数给出的移位指令
//m6m7译码决定第一个alu运算数的来源
wire [31:0]alu_a=m6 ? (m7 ?  EXT5 : {27'b0,rs[4:0]}) : rs;//lui指令是否要特殊处理？
//m8m9译码决定第二个alu运算数的来源
assign m8=_addi||_addiu||_andi||_ori||_xori||_lw||_sw||_slti||_sltiu||_lui;//无符号扩展
assign m9=_addi||_addiu||_lw||_sw||_slti||_sltiu;//有符号扩展
//在i型指令中addi/addiu/slti/sltiu都是有符号扩展，其他是无符号扩展
wire [31:0]alu_b = m8? (m9 ?  SEXT16 : UEXT16) : rt;
//m10处理rdc的取值
assign m10=_addi||_addiu||_andi||_ori||_xori||_lui||_lw||_slti||_sltiu;
wire [4:0]RDC=_jal ? 5'd31 : (m10 ? rtc : rdc);
pcreg mypcreg(
               .clk(clk),
               .rst(rst),
               .ena(1),
               .data_in(pc_from),
               .data_out(PC)
               );
alu myalu(
   .a(alu_a),
   .b(alu_b),
   .aluc(ALUC),
   .r(alu_result),
   .zero(zerof),
   .carry(carryf),
   .negative(negf),
   .overflow(overflowf)
   );
   
 Regfiles cpu_ref(
          .RF_ena(1),
          .RF_rst(rst),
          .RF_clk(clk),
          .Rdc(RDC),
          .Rsc(RSC),
          .Rtc(RTC),
          .Rd(rd),
          .Rs(rs),
          .Rt(rt),
          .RF_W(RF_w)
              );
              
endmodule
