`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:11:33 06/01/2015 
// Design Name: 
// Module Name:    regfile 
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
module regfile(
	input wire clk,
	input wire rst,
	input wire [4:0] debug_addr,
	output wire [31:0] debug_data,
	input wire [4:0] addr_a,
	output wire [31:0] data_a,
	input wire [4:0] addr_b,
	output wire [31:0] data_b,
	input wire WE,
	input wire [4:0] addr_w,
	input wire [31:0] data_w
   );
	
	reg [31:0] regfile [31:1];
	initial begin
		regfile[1]=32'h1;
		regfile[2]=32'h2;
		regfile[3]=32'h3;
		regfile[4]=32'h4;
		regfile[5]=32'h5;
		regfile[6]=32'h6;
		regfile[7]=32'h7;
		regfile[8]=32'h8;
		regfile[9]=32'h9;
		regfile[10]=32'hA;
		regfile[11]=32'hB;
		regfile[12]=32'hC;
		regfile[13]=32'hD;
		regfile[14]=32'hE;
		regfile[15]=32'hF;
		regfile[16]=32'h10;
		regfile[17]=32'h11;
		regfile[18]=32'h12;
		regfile[19]=32'h13;
		regfile[20]=32'h14;
		regfile[21]=32'h15;
		regfile[22]=32'h16;
		regfile[23]=32'h17;
		regfile[24]=32'h18;
		regfile[25]=32'h19;
		regfile[26]=32'h1A;
		regfile[27]=32'h1B;
		regfile[28]=32'h1C;
		regfile[29]=32'h1D;
		regfile[30]=32'h1E;
		regfile[31]=32'h1F;
	end
	
	always@(posedge clk) begin
		if(rst) begin
			regfile[1]=32'h1;
			regfile[2]=32'h2;
			regfile[3]=32'h3;
			regfile[4]=32'h4;
			regfile[5]=32'h5;
			regfile[6]=32'h6;
			regfile[7]=32'h7;
			regfile[8]=32'h8;
			regfile[9]=32'h9;
			regfile[10]=32'hA;
			regfile[11]=32'hB;
			regfile[12]=32'hC;
			regfile[13]=32'hD;
			regfile[14]=32'hE;
			regfile[15]=32'hF;
			regfile[16]=32'h10;
			regfile[17]=32'h11;
			regfile[18]=32'h12;
			regfile[19]=32'h13;
			regfile[20]=32'h14;
			regfile[21]=32'h15;
			regfile[22]=32'h16;
			regfile[23]=32'h17;
			regfile[24]=32'h18;
			regfile[25]=32'h19;
			regfile[26]=32'h1A;
			regfile[27]=32'h1B;
			regfile[28]=32'h1C;
			regfile[29]=32'h1D;
			regfile[30]=32'h1E;
			regfile[31]=32'h1F;
		end
		else begin
			if(WE && addr_w!=0) begin
				regfile[addr_w]=data_w;
			end
		end
	end
	assign data_a=(addr_a==0)? 0:regfile[addr_a];
	assign data_b=(addr_b==0)? 0:regfile[addr_b];
	assign debug_data=(debug_addr==0)? 0:regfile[debug_addr];
	
endmodule
