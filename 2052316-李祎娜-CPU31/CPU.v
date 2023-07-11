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
//cpu��Ҫ������룬�������
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
 /*31��ָ��ļ�Ƿ� ͨ��ʶ��op��func���ж�֮....................................................*/
 wire _add,_addu,_sub,_subu,_and,_or,_xor,_nor;//8��
 wire _slt,_sltu,_sll,_srl,_sra,_sllv,_srlv,_srav,_jr;//9��
 wire _addi,_addiu,_andi,_ori,_xori,_lw,_sw;//7��
 wire _beq,_bne,_slti,_sltiu,_lui,_j,_jal;//7��
 //�жϸ���ָ���ǲ��Ǽ�Ƿ������Ǹ�ֵΪ1
 //1-17��ָ����ĸ���λ����000000�� ���뷽ʽ�൱�ڶ�����
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
 //18-31�� ֻ�Ӹ���λ�ж�
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

wire [3:0]ALUC;//4λaluc�ж���������
wire zerof,carryf,negf,overflowf;//alu��־λ
/*����aluc��Ҫ�����ÿһλ�ķ���..............................................................................*/
assign ALUC[0]=_sub||_subu||_or||_nor||_slt||_srl||_srlv||_ori||_beq||_bne||_slti;
assign ALUC[1]=_sub||_xor||_nor||_sll||_sllv||_addi||_xori||_lw||_sw||_beq||_bne||_jal||_slti||_sltiu||_slt||_sltu;
assign ALUC[2]=_and||_or||_xor||_nor||_sll||_srl||_sra||_sllv||_srlv||_srav||_andi||_ori||_xori;
assign ALUC[3]=_sll||_srl||_sra||_sllv||_srlv||_srav||_lui||_slti||_sltiu||_slt||_sltu;
/*ȷ���Ĵ����Ķ�д��ַ........................................................................................*/
wire [4:0]rsc,rdc,rtc;//�Ĵ�����ַ
assign rsc=(_sll||_srl||_sra||_lui||_j||_jal)?5'bz:IM_inst[25:21];//�ӼĴ������ĵ�ַ1
assign rdc=(_add|_addu||_sub||_subu||_and||_or||_xor||_nor||_slt||_sltu||_sll||_srl||_sra||_sllv||_srlv||_srav)?IM_inst[15:11]:5'bz;
assign rtc=(_j||_jal)?5'bz:IM_inst[20:16];//�ӼĴ������ĵ�ַ2
wire RF_w;//��Ĵ�����д���־ 
assign RF_w = !(_jr || _sw || _beq || _bne|| _j);//ֻ�м���ָ���RF_w
wire [31:0]npc,rs,rt,rd,alu_result;
wire [31:0]PC,pc_from;
assign pcout=PC;
assign npc=pcout+32'd4;//��һ��ָ��ĵ�ַ
assign aluout=alu_result;
wire DM_CS;//DM��Ч��������д����
assign DM_CS=_lw||_sw;
assign DM_w=_sw;//��dmem�ڴ�д������
assign DM_r=_lw;//��dmem��������
assign DM_ena=_lw||_sw;//lw||sw
assign DM_wdata=DM_w?rt:32'bz;
wire [31:0] EXT18,HEXT16,UEXT16,SEXT16,EXT5,EXT1;
wire [31:0]j_comb,bjmpadder;
//12��ȡ��������i��ָ�� ������������imm_16��
wire [15:0]imm_16=(_addi||_addiu||_andi||_ori||_xori||_lw||_sw||_beq||_bne||_slti||_sltiu||_lui)?IM_inst[15:0]:16'bz;
//2��j��ָ���תռ��INST[25:0]
wire [25:0]address=(_j||_jal)?IM_inst[25:0]:26'bz;
//��λshamt��[10:6]
wire [4:0]shamt=(_sll||_srl||_sra)?IM_inst[10:6]:5'bz;
//���в�������Ϊ����䵽32λ
assign EXT18=imm_16[15]==1?{14'b11111111111111,imm_16,2'b00}:{14'b0,imm_16,2'b00};//������λ�ٽ��з�����չ BEQָ������Ҫ�õ��Ĳ���
assign bjmpadder=EXT18+npc;//bjmpadderΪBEQ����ת��ַ
assign HEXT16={imm_16,16'b0};//��λ��0 luiָ��
assign UEXT16={16'b0,imm_16};//��λ�޷�����չ
assign SEXT16=imm_16[15]==1?{16'b1111111111111111,imm_16}:{16'b0,imm_16};//��λ�з�����չ
assign EXT5={27'b0,shamt};//�ƶ�λ��
assign EXT1={30'b0,negf};//;ext1����ƺ���Ҳ����
assign j_comb={pcout[31:28],address,2'b0};//jָ���ת��26λ���ĵ�ַ����PC[31:28]||IM[25:0]<<2���
wire [4:0]RSC=rsc;
wire[4:0]RTC=rtc;

//ÿ�β��ö�ѡһ������ѡ�����ź�
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
			PC <= m3 ? rs : (m2 ? j_comb : (m1 ? npc + EXT18 : npc));//pc_from��m1m2m3���ϸ���
		end
	end*/
assign pc_from= m3 ? rs : (m2 ? j_comb : (m1 ? npc + EXT18 : npc));//pc_from��m1m2m3���ϸ���
//m4m5�������rd����Դ	
assign m4=_jal;
assign m5=_lw;
assign rd = m4 ? pcout + 4 : (m5 ? DM_rdata : aluout);//_jalΪpc+4��_lwΪд�룻����д��alu������
assign m6=_sll||_srl||_sra||_sllv||_srlv||_srav;//6����λָ��
assign m7=_sll||_srl||_sra;//��������������λָ��
//m6m7���������һ��alu����������Դ
wire [31:0]alu_a=m6 ? (m7 ?  EXT5 : {27'b0,rs[4:0]}) : rs;//luiָ���Ƿ�Ҫ���⴦��
//m8m9��������ڶ���alu����������Դ
assign m8=_addi||_addiu||_andi||_ori||_xori||_lw||_sw||_slti||_sltiu||_lui;//�޷�����չ
assign m9=_addi||_addiu||_lw||_sw||_slti||_sltiu;//�з�����չ
//��i��ָ����addi/addiu/slti/sltiu�����з�����չ���������޷�����չ
wire [31:0]alu_b = m8? (m9 ?  SEXT16 : UEXT16) : rt;
//m10����rdc��ȡֵ
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
