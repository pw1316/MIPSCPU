module display (
	input wire clk,
	input wire rst,
	input wire [7:0] addr,
	input wire [31:0] data,
	// character LCD interfaces
	input wire [31:0] in0,
	input wire [31:0] in1,
	input wire [31:0] in2,
	input wire [31:0] in3,
	input wire [31:0] in4,
	output wire lcd_e,
	output wire lcd_rs,
	output wire lcd_rw,
	output wire [3:0] lcd_dat
	);
	
	reg [255:0] strdata = "R00:000 00000000FD00|E00|M00|W00";
	
	function [7:0] num2str;
		input [3:0] number;
		begin
			if (number < 10)
				num2str = "0" + number;
			else
				num2str = "A" - 10 + number;
		end
	endfunction
	
	always @(posedge clk) begin
		strdata[247:232] <= {num2str(addr[4]),num2str(addr[3:0])};//reg addr
		strdata[223:200] <= {num2str(in0[11:8]),num2str(in0[7:4]),num2str(in0[3:0])};//reg data
		strdata[191:128] <= {num2str(data[31:28]),num2str(data[27:24]),num2str(data[23:20]),num2str(data[19:16]),num2str(data[15:12]),num2str(data[11:8]),num2str(data[7:4]),num2str(data[3:0])};//if inst
		strdata[111:96] <= {num2str(in1[7:4]),num2str(in1[3:0])};//ID
		strdata[79:64] <= {num2str(in2[7:4]),num2str(in2[3:0])};//EX
		strdata[47:32] <= {num2str(in3[7:4]),num2str(in3[3:0])};//ME
		strdata[15:0] <= {num2str(in4[7:4]),num2str(in4[3:0])};//WB
	end
	
	reg refresh = 0;
	reg [7:0] addr_buf;
	reg [31:0] data_buf;
	reg [31:0] in0_buf;
	reg [31:0] in1_buf;
	reg [31:0] in2_buf;
	reg [31:0] in3_buf;
	reg [31:0] in4_buf;
	
	always @(posedge clk) begin
		addr_buf <= addr;
		data_buf <= data;
		in0_buf <= in0;
		in1_buf <= in1;
		in2_buf <= in2;
		in3_buf <= in3;
		in4_buf <= in4;
		refresh <= (addr_buf != addr) || (data_buf != data) || (in0_buf != in0) || (in1_buf != in1) || (in2_buf != in2) || (in3_buf != in3) || (in4_buf != in4);
	end
	
	displcd DISPLCD (
		.CCLK(clk),
		.reset(rst | refresh),
		.strdata(strdata),
		.rslcd(lcd_rs),
		.rwlcd(lcd_rw),
		.elcd(lcd_e),
		.lcdd(lcd_dat)
		);
	
endmodule
