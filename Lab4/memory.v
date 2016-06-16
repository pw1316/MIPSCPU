`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:21:59 06/01/2015 
// Design Name: 
// Module Name:    memory 
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
module memory(
	input wire clk,
	input wire RE,
	input wire WE,
	input wire [31:0] addr,
	input wire [31:0] data_in,
	output reg [31:0] data_out
   );
	
	parameter ADDR_WIDTH=6;
	
	reg [7:0] mem [(1<<ADDR_WIDTH)-1:0];
	
	initial begin
		$readmemh("data.hex",mem);
		data_out=32'b0;
	end
	
	always@(negedge clk) begin
		if(WE&&~RE&&addr[31:ADDR_WIDTH]==0) begin
			mem[addr[ADDR_WIDTH-1:0]+3]=data_in[31:24];
			mem[addr[ADDR_WIDTH-1:0]+2]=data_in[23:16];
			mem[addr[ADDR_WIDTH-1:0]+1]=data_in[15:8];
			mem[addr[ADDR_WIDTH-1:0]+0]=data_in[7:0];
		end
	end
	
	always@(negedge clk) begin
		if(RE&&~WE&&addr[31:ADDR_WIDTH]==0) begin
			data_out={mem[addr[ADDR_WIDTH-1:0]+3],mem[addr[ADDR_WIDTH-1:0]+2],mem[addr[ADDR_WIDTH-1:0]+1],mem[addr[ADDR_WIDTH-1:0]+0]};
		end
	end
	
endmodule
