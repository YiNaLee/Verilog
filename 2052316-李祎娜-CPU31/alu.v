`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/13 19:29:48
// Design Name: 
// Module Name: alu
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

//alu是数字逻辑课上写过的，直接拿来用
module alu(
input [31:0]a,
input [31:0]b,
input [3:0]aluc,
output reg [31:0]r,
output zero,
output reg carry,
output reg negative,
output reg overflow

    );
    assign zero=(aluc==4'b1011||aluc==4'b1010)?(a==b):(r==0)?1:0;
    reg[32:0]temp;
    initial
    begin r=0; carry=0; negative=0; overflow=0; end
    always @(a or b or aluc)
    begin
    case(aluc)
    4'b0000://ADDU
    begin
        r=a+b;
        temp=a+b;//????????
        if(temp[32]==1)
            carry=1;
        else
            carry=0;
    end
    4'b0010:
    begin
        r=$signed(a)+$signed(b);//ADD
        if((a[31]==1&&b[31]==1&&r[31]==0)||(a[31]==0&&b[31]==0&&r[31]==1))
            overflow=1;
        else
            overflow=0;
    end
    4'b0001://SUBU
    begin
        r=a-b;
        if(a<b)
        begin
            carry=1;
            //negative=1;
        end
        else
        begin
            carry=0;
            //negative=0;
            end
    end
    4'b0011:
    begin
        r=$signed(a)-$signed(b);//SUB
        if((a[31]==1&&b[31]==0&&r[31]==0)||(a[31]==0&&b[31]==1&&r[31]==1))
            overflow=1;
        else
            overflow=0;
        if($signed(a)<$signed(b))
                   begin
                       carry=1;
                       //negative=1;
                   end
       else
                   begin
                       carry=0;
                       //negative=0;
                       end     
    end
    4'b0100:r=a&b;//AND
    4'b0101:r=a|b;//OR
    4'b0110:r=a^b;//XOR
    4'b0111:r=~(a|b);//NOR
    4'b1000:r={b[15:0],16'b0};//LUI
    4'b1001:r={b[15:0],16'b0};//LUI
    4'b1011:
    begin
        r=($signed(a)<$signed(b))?1:0;//SLT
        if($signed(a)<$signed(b))
            negative=1;
        else
            negative=0;
    end
    4'b1010://SLTU
    begin
        r=(a<b)?1:0;
        if(a<b)
            carry=1;
        else
            carry=0;
    end
    4'b1100://SRA
    begin
        if(a==0)
            carry=0;
        else if(a<=32)
            carry=b[a-1];
        else
            carry=b[31];
        r=$signed(b)>>>a;
    end
    4'b1110://SLL/SLR
    begin
        if(a==0)
            carry=0;
        else if(a<=32)
            carry=b[32-a];
        else
            carry=0;
        r=b<<a;
    end
    4'b1111://SLL/SLR
    begin
        if(a==0)
            carry=0;
        else if(a<=32)
            carry=b[32-a];
        else
            carry=0;
        r=b<<a;
    end
    4'b1101://SRL
    begin
        if(a==0)
            carry=0;
        else if(a<=32)
            carry=b[a-1];
        else
            carry=0;
        r=b>>a;
    end
    default:r=0;
    endcase

    if(aluc!=4'b1011)
    begin
        if(r[31]==1) negative=1;
        else         negative=0;
    end
    end
endmodule
/*module alu(a,b,aluc,r,zero,carry,negative,overflow);
input [31:0]a;
input [31:0]b;
input [3:0]aluc;
output reg [31:0]r;
output reg zero;
output reg carry;
output reg negative;
output reg overflow;//只有有符号加法减法影响
always@(*)
begin
    case(aluc)
    4'b0000:begin//addu
    {carry,r}=a+b;
    zero=(r==0)?1:0;
    overflow=0;
    negative=(r[31]==1)?1:0;
     end
    4'b0001:begin//无符号减法
    {carry,r}=a-b;
    zero=(r==0)?1:0;
    overflow=0;
    negative=(r[31]==1)?1:0;
    end
    4'b0010:begin//有符号加法
    r=a+b;
    overflow=((a[31]==b[31])&&(~r[31]==a[31]))?1:0;
    zero=(r==0)?1:0;
    carry=0;//不影响
    negative=(r[31]==1)?1:0;
    end
    4'b0011:begin//有符号减法
    r=a-b;
    overflow=((a[31]==0&&b[31]==1&&r[31]==1)||(a[31]==1&&b[31]==0&&r[31]==0));
    zero=(r==0)?1:0;
    carry=0;//不影响
    negative=(r[31]==1)?1:0;//有符号减法，看其最高位
    end
    4'b0100:begin//与
    r=a&b;
    zero=(r==0)?1:0;
    carry=0;
    negative=(r[31]==1)?1:0;
    overflow=0;
    end
    4'b0101:begin//or
    r=a|b;
    zero=(r==0)?1:0;
    carry=0;
    negative=(r[31]==1)?1:0;
    overflow=0;
    end
    4'b0110:begin//xor
    r=a^b;
   zero=(r==0)?1:0;
   carry=0;
   negative=(r[31]==1)?1:0;
   overflow=0;
   end
   4'b0111:begin//nor
   r=~(a|b);
   zero=(r==0)?1:0;
   carry=0;
   negative=(r[31]==1)?1:0;
   overflow=0;
   end
   4'b1000:begin
      r={b[15:0],16'b0};
      zero=(r==0)?1:0;
      carry=0;
      negative=(r[31]==1)?1:0;
      overflow=0;
      end
   4'b1001:begin
   r={b[15:0],16'b0};
   zero=(r==0)?1:0;
   carry=0;
   negative=(r[31]==1)?1:0;
   overflow=0;
   end
   4'b1011:begin//slt有符号 r和neative 有符号的进行比较a和b谁更大
 //  r=(a-b<0)?1:0;
  zero=(a-b==0)?1:0;
  carry=0;
 // negative=(a-b<0)?1:0;
  overflow=0;
  if(a>=0&&b>=0)
  begin
  r=(a<b)?1:0;
  negative=(a-b<0)?1:0;
  end
  else if(a<0&&b<0)
  begin
  r=(a>b)?1:0;
  negative=(a>b)?1:0;
  end
  else //一正一负或者 一负一零
  begin
  if(a>=0&&b<0)
  begin r=0;
  negative=0;
  end
  else if(a<0&&b>=0)
  begin r=1;
  negative=1;
  end
  end
end
   4'b1010:begin//sltu
   r=(a<b)?1:0;
   zero=(a-b==0)?1:0;
   carry=(a<b)?1:0;
   negative=r[31];
   overflow=0;
   end
   4'b1100:begin//SRA  算术右移
   r=($signed (b))>>>a;
   zero=(r==0)?1:0;
   if(a==0)
   carry=0;
   else
   carry=b[a-1];
   negative=r[31];
   overflow=0;
   end
   4'b1110:begin//sll/sla算术左移逻辑左移
   r=b<<a;
   zero=(r==0)?1:0;
   if(a==0)
   carry=0;
   else
   carry=b[32-a];
   negative=r[31];
   overflow=0;
   end
   4'b1111:begin//sll/sla算术左移逻辑左移
      r=b<<a;
      zero=(r==0)?1:0;
      if(a==0)
      carry=0;
      else
      carry=b[32-a];
      negative=r[31];
      overflow=0;
      end
   4'b1101:begin//逻辑右移
   r=b>>a;
   zero=(r==0)?1:0;
   if(a==0)
   carry=0;
   else
   carry=b[a-1];//carry
   negative=r[31];
   overflow=0;
   end
   default:begin
   end
   endcase
    
end

endmodule*/

