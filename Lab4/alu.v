`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:30:41 06/01/2015 
// Design Name: 
// Module Name:    alu 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module alu(op,A,B,S,ZF,OF,CF
    );
	input wire [3:0] op;
	input wire [31:0] A;
	input wire [31:0] B;
	output reg [31:0] S;
	output reg ZF,OF,CF;
	wire [31:0] SS;
	wire TZF,TOF,TCF;

	initial begin
		S=32'h0;
		ZF=1'b0;
		OF=1'b0;
		CF=1'b0;
	end

	adder_32bit AD(
		.u((op==1||op==3||op==5)? 1:0),
		.minus((op==2||op==3||op==4||op==5)? 1:0),
		.A(A),
		.B(B),
		.S(SS),
		.ZF(TZF),
		.OF(TOF),
		.CF(TCF)
	);
	
	always@* begin
		if(op==4'b0000) S=SS;//+  0000
		else if(op==4'b0001) S=SS;//+u 0001
		else if(op==4'b0010) S=SS;//-  0010
		else if(op==4'b0011) S=SS;//-u 0011
		else if(op==4'b0100) S=(A[31]^B[31])? ((A[31]==0)? 0:1):(SS[31]);//<  0100
		else if(op==4'b0101) S=(A[31]^B[31])? ((A[31]==0)? 1:0):(SS[31]);//<u 0101
		else if(op==4'b0110) S=A&B;//and0110
		else if(op==4'b0111) S=A|B;//or 0111
		else if(op==4'b1000) S=A^B;//xor1000
		else if(op==4'b1001) S=~(A|B);//nor1001
		else if(op==4'b1010) S={B[15:0],16'b0};//lui1010
		else if(op==4'b1011) S=B<<A;//sll1011
		else if(op==4'b1100) S=B>>A;//srl1100
		else if(op==4'b1101) S=B>>>A;//sra1101
		else if(op==4'b1110) S=32'h0;//jr 1110
		else                 S=32'h0;//0  1111
	end

	always@* begin
		ZF=~(|S);
		CF=(op<4)? TCF:0;
		OF=(op<4)? TOF:0;
	end
endmodule
