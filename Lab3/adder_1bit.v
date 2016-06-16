`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:33:37 06/01/2015 
// Design Name: 
// Module Name:    adder_1bit 
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
module adder_1bit(A,B,Ci,S,Co
    );
	input wire A,B,Ci;
	output wire S,Co;
	assign S=A^B^Ci;
	assign Co=A&B|B&Ci|Ci&A;
endmodule
