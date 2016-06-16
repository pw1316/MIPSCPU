`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:36:30 05/31/2015 
// Design Name: 
// Module Name:    alu_ctrl 
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
module alu_ctrl(func,ctr,out
    );
	input wire [5:0]func;
	input wire [3:0]ctr;
	output reg [3:0]out;
	//ALUop
	//+  0000
	//+u 0001
	//-  0010
	//-u 0011
	//<  0100
	//<u 0101
	//and0110
	//or 0111
	//xor1000
	//lui1010
	//cal1111
	initial begin
		out=4'hF;
	end
	always@* begin
		if     (ctr==4'b0000) out=4'b0000;//+
		else if(ctr==4'b0001) out=4'b0001;//+u
		else if(ctr==4'b0010) out=4'b0010;//-
		else if(ctr==4'b0011) out=4'b0011;//-u
		else if(ctr==4'b0100) out=4'b0100;//<
		else if(ctr==4'b0101) out=4'b0101;//<u
		else if(ctr==4'b0110) out=4'b0110;//and
		else if(ctr==4'b0111) out=4'b0111;//or
		else if(ctr==4'b1000) out=4'b1000;//xor
		else if(ctr==4'b1010) out=4'b1010;//lui
		else begin
			if		 (func==6'h00) out=4'b1011;//sll  000000
			else if(func==6'h02) out=4'b1100;//srl  000010
			else if(func==6'h03) out=4'b1101;//sra  000011
			else if(func==6'h04) out=4'b1011;//sllv 000100
			else if(func==6'h06) out=4'b1100;//srlv 000110
			else if(func==6'h07) out=4'b1101;//srav 000111
			else if(func==6'h08) out=4'b1110;//jr	 001000
			else if(func==6'h20) out=4'b0000;//add  100000
			else if(func==6'h21) out=4'b0001;//addu 100001
			else if(func==6'h22) out=4'b0010;//sub  100010
			else if(func==6'h23) out=4'b0011;//subu 100011
			else if(func==6'h24) out=4'b0110;//and  100100
			else if(func==6'h25) out=4'b0111;//or   100101
			else if(func==6'h26) out=4'b1000;//xor  100110
			else if(func==6'h27) out=4'b1001;//nor  100111
			else if(func==6'h2A) out=4'b0100;//slt  101010
			else if(func==6'h2B) out=4'b0101;//sltu 101011
			else out=3'b1111;
		end
	end
	//out
	//+  0000
	//+u 0001
	//-  0010
	//-u 0011
	//<  0100
	//<u 0101
	//and0110
	//or 0111
	//xor1000
	//nor1001
	//lui1010
	//sll1011
	//srl1100
	//sra1101
	//jr 1110
	//0  1111
endmodule
