/*
	Title:	ALU
	Author: Garfield (Computer System and Architecture Lab, ICE, CYCU)
	Input Port
		1. ctl: ��alu_ctl�ѽX��������T��
		2. a:   inputA,�Ĥ@���n�B�z�����
		3. b:   inputB,�ĤG���n�B�z�����
	Output Port
		1. result: �̫�B�z�������G
		2. zero:   branch���O�һݭn����X
*/


module alu(ctl, a, b, result, zero, shamt);
  input [2:0] ctl;
  input [4:0] shamt;
  input [31:0] a, b;
  output [31:0] result;
  output zero;

  reg [31:0] result;
  reg zero;
  wire [31:0] ALUOut;
  wire [31:0] ShifterOut ;
  
  alu32 ALU( .SUM(ALUOut), .SEL(ctl), .A(a), .B(b) );
  shifter Shifter( .dataA(b), .dataB(b), .Signal(shamt), .dataOut(ShifterOut) );
  

  always @(a or b or ctl or ALUOut or ShifterOut )
  begin
    case (ctl)
      3'b000 : result = ALUOut; // AND
      3'b001 : result = ALUOut; // OR
      3'b010 : result = ALUOut; // ADD
      3'b110 : result = ALUOut; // SUBTRACT  
	  3'b111 : result = ALUOut; // slt
	  3'b100 : result = ShifterOut ;// sll 
      default : result = 32'hzzzzzzzz;
   endcase
   if (result == 32'd0) zero = 1;
   else zero = 0;
 end
endmodule

