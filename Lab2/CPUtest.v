`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:57:16 04/14/2016
// Design Name:   cpu
// Module Name:   E:/CPULAB2/CPULAB2/CPUtest.v
// Project Name:  CPULAB2
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

module CPUtest;

	// Inputs
	reg debug_en;
	reg debug_step;
	reg [6:0] debug_addr;
	reg clk;
	reg rst;
	reg INT;

	// Outputs
	wire [31:0] debug_data;

	// Instantiate the Unit Under Test (UUT)
	cpu uut (
		.debug_en(debug_en), 
		.debug_step(debug_step), 
		.debug_addr(debug_addr), 
		.debug_data(debug_data), 
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

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	
	always # 100 clk=~clk;
      
endmodule

