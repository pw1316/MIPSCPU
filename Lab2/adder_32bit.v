`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:40:18 06/01/2015 
// Design Name: 
// Module Name:    adder_32bit 
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
module adder_32bit(u,minus,A,B,S,ZF,OF,CF
    );
	input wire u;
	input wire minus;
	input wire [31:0]A;
	input wire [31:0]B;
	output wire [31:0]S;
	output wire ZF,OF,CF;
	wire [32:1] C;
	reg zero=1'b0;
	adder_1bit ad0(A[0],B[0]^minus,minus,S[0],C[1]);
	adder_1bit ad1(A[1],B[1]^minus,C[1],S[1],C[2]);
	adder_1bit ad2(A[2],B[2]^minus,C[2],S[2],C[3]);
	adder_1bit ad3(A[3],B[3]^minus,C[3],S[3],C[4]);
	adder_1bit ad4(A[4],B[4]^minus,C[4],S[4],C[5]);
	adder_1bit ad5(A[5],B[5]^minus,C[5],S[5],C[6]);
	adder_1bit ad6(A[6],B[6]^minus,C[6],S[6],C[7]);
	adder_1bit ad7(A[7],B[7]^minus,C[7],S[7],C[8]);
	adder_1bit ad8(A[8],B[8]^minus,C[8],S[8],C[9]);
	adder_1bit ad9(A[9],B[9]^minus,C[9],S[9],C[10]);
	adder_1bit ad10(A[10],B[10]^minus,C[10],S[10],C[11]);
	adder_1bit ad11(A[11],B[11]^minus,C[11],S[11],C[12]);
	adder_1bit ad12(A[12],B[12]^minus,C[12],S[12],C[13]);
	adder_1bit ad13(A[13],B[13]^minus,C[13],S[13],C[14]);
	adder_1bit ad14(A[14],B[14]^minus,C[14],S[14],C[15]);
	adder_1bit ad15(A[15],B[15]^minus,C[15],S[15],C[16]);
	adder_1bit ad16(A[16],B[16]^minus,C[16],S[16],C[17]);
	adder_1bit ad17(A[17],B[17]^minus,C[17],S[17],C[18]);
	adder_1bit ad18(A[18],B[18]^minus,C[18],S[18],C[19]);
	adder_1bit ad19(A[19],B[19]^minus,C[19],S[19],C[20]);
	adder_1bit ad20(A[20],B[20]^minus,C[20],S[20],C[21]);
	adder_1bit ad21(A[21],B[21]^minus,C[21],S[21],C[22]);
	adder_1bit ad22(A[22],B[22]^minus,C[22],S[22],C[23]);
	adder_1bit ad23(A[23],B[23]^minus,C[23],S[23],C[24]);
	adder_1bit ad24(A[24],B[24]^minus,C[24],S[24],C[25]);
	adder_1bit ad25(A[25],B[25]^minus,C[25],S[25],C[26]);
	adder_1bit ad26(A[26],B[26]^minus,C[26],S[26],C[27]);
	adder_1bit ad27(A[27],B[27]^minus,C[27],S[27],C[28]);
	adder_1bit ad28(A[28],B[28]^minus,C[28],S[28],C[29]);
	adder_1bit ad29(A[29],B[29]^minus,C[29],S[29],C[30]);
	adder_1bit ad30(A[30],B[30]^minus,C[30],S[30],C[31]);
	adder_1bit ad31(A[31],B[31]^minus,C[31],S[31],C[32]);
	assign ZF=~(|S);
	assign OF=(u)? zero:(C[32]^C[31]);
	assign CF=C[32];
endmodule
