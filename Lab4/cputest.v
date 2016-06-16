`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:28:54 05/30/2016
// Design Name:   cpu
// Module Name:   E:/CPULAB4/CPULAB4/cputest.v
// Project Name:  CPULAB4
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: cpu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module cputest;

	// Inputs
	reg debug_en;
	reg debug_step;
	reg [6:0] debug_addr;
	reg clk;
	reg rst;
	reg [1:0] INT;
	reg [31:0] cnt;

	// Outputs
	wire [31:0] debug_data;
	wire [31:0] debug_REG;
	wire [31:0] debug_ID;
	wire [31:0] debug_EX;
	wire [31:0] debug_ME;
	wire [31:0] debug_WB;

	// Instantiate the Unit Under Test (UUT)
	cpu uut (
		.debug_en(debug_en), 
		.debug_step(debug_step), 
		.debug_addr(debug_addr), 
		.debug_data(debug_data), 
		.debug_REG(debug_REG), 
		.debug_ID(debug_ID), 
		.debug_EX(debug_EX), 
		.debug_ME(debug_ME), 
		.debug_WB(debug_WB), 
		.clk(clk), 
		.rst(rst), 
		.INT(INT)
	);

	initial begin
		// Initialize Inputs
		debug_en = 0;
		debug_step = 0;
		debug_addr = 0;
		clk = 0;
		rst = 0;
		INT = 0;
		cnt = 0;
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
	always#100 begin
		clk <= ~clk;
		cnt <= cnt + 1;
		if(cnt == 11 || cnt == 16)begin
			INT <=0;
		end
		else if(cnt == 9 || cnt == 15)begin
			INT <=2;
		end
	end
endmodule

