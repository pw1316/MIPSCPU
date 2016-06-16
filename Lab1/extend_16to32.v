module extend16to32(
	input wire u,
	input wire [15:0] in,
	output wire [31:0] out
	);
	
	assign out[15:0]=in;
	assign out[31:16]=(u)? {16{0}}:{16{in[15]}};
endmodule
