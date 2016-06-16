module mux2to1_5bit(in_0,in_1,ctr,out);
	input wire [4:0] in_0;
	input wire [4:0] in_1;
	input wire ctr;
	output wire [4:0]out;
	assign out=ctr? in_1:in_0;
endmodule
