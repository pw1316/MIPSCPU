`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:16:28 05/28/2015 
// Design Name: 
// Module Name:    get_inst 
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
module get_inst(
	input wire [31:0] addr,
	output wire [31:0] data
   );
	
	parameter ADDR_WIDTH_IR=6;

	reg [31:0] ir [(1<<ADDR_WIDTH_IR)-1:0];
	
	initial begin
//		ir[0]=32'h20110006;
//		ir[1]=32'h20120005;
//		ir[2]=32'h0c000004;
//		ir[3]=32'h08000000;
//		ir[4]=32'hac120002;
//		ir[5]=32'hac110001;
//		ir[6]=32'h02328820;
//		ir[7]=32'h02329022;
//		ir[8]=32'h02328822;
//		ir[9]=32'hac120002;
//		ir[10]=32'hac110001;
//		ir[11]=32'h03e00008;
		$readmemh("test2.hex",ir);
	end
	
	assign data=(addr[31:ADDR_WIDTH_IR+2]==0)? ir[addr[ADDR_WIDTH_IR+1:2]]:32'b0;
endmodule
