module mux2to1_32bit(in_0,in_1,ctr,out);
	input wire [31:0]in_0;
	input wire [31:0]in_1;
	input wire ctr;
	output wire [31:0]out;
	assign out=ctr? in_1:in_0;
endmodule
