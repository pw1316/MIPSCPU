`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:10:37 03/19/2016 
// Design Name: 
// Module Name:    mux4to1_32bit 
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
module mux4to1_32bit(
	input wire [31:0] in_00,
	input wire [31:0] in_01,
	input wire [31:0] in_10,
	input wire [31:0] in_11,
	input wire [1:0] ctr,
	output wire [31:0] out
   );

	assign out=(ctr[1])? ((ctr[0])? in_11:in_10):((ctr[0])? in_01:in_00);
endmodule
