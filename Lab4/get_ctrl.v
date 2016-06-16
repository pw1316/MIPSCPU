`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:27:52 05/28/2015 
// Design Name: 
// Module Name:    get_ctrl 
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
module get_ctrl(
	input wire [5:0] OPCODE,
	input wire [4:0] RS,
	input wire [5:0] FUNC,
	output wire BNE,
	output wire [1:0] REGADDR,
	output wire [1:0] REGDATA,
	output wire ALUA,
	output wire ALUB,
	output wire [3:0] ALUOP,
	output wire [1:0] JUMP,
	output wire COND,
	output wire REGW,
	output wire MEMR,
	output wire MEMW,
	output wire UNSIGNED,
	output wire cREGW
   );
	
	reg [17:0] tmp;
	
	initial begin
		tmp=18'h0;
	end
	
	always@* begin
		case (OPCODE)
			6'h00:begin
						case (FUNC)
							6'h00:tmp=18'b010001011110001000;//sll  000000
							6'h02:tmp=18'b010001011110001000;//srl  000010
							6'h03:tmp=18'b010001011110001000;//sra  000011
							6'h04:tmp=18'b010000011110001000;//sllv 000100
							6'h06:tmp=18'b010000011110001000;//srlv 000110
							6'h07:tmp=18'b010000011110001000;//srav 000111
							6'h08:tmp=18'b010000011111100000;//jr	001000
							6'h20:tmp=18'b010000011110001000;//add  100000
							6'h21:tmp=18'b010000011110001001;//addu 100001
							6'h22:tmp=18'b010000011110001000;//sub  100010
							6'h23:tmp=18'b010000011110001001;//subu 100011
							6'h24:tmp=18'b010000011110001000;//and  100100
							6'h25:tmp=18'b010000011110001000;//or   100101
							6'h26:tmp=18'b010000011110001000;//xor  100110
							6'h27:tmp=18'b010000011110001000;//nor  100111
							6'h2A:tmp=18'b010000011110001000;//slt  101010
							6'h2B:tmp=18'b010000011110001001;//sltu 101011
							default:tmp=18'b000000000000000000;//null
						endcase
					end
			6'h02:tmp=18'b000000000000100000;//j 	000010
			6'h03:tmp=18'b001010000000101000;//jal	000011
			6'h04:tmp=18'b000000000100010000;//beq  000100
			6'h05:tmp=18'b100000000100010000;//bne  000101
			6'h08:tmp=18'b000000100000001000;//addi 001000
			6'h09:tmp=18'b000000100010001001;//addiu001001
			6'h0A:tmp=18'b000000101000001000;//slti 001010
			6'h0B:tmp=18'b000000101010001001;//sltiu001011
			6'h0C:tmp=18'b000000101100001000;//andi 001100
			6'h0D:tmp=18'b000000101110001000;//ori  001101
			6'h0E:tmp=18'b000000110000001000;//xori 001110
			6'h0F:tmp=18'b000000110100001000;//lui  001111
			6'h10:begin
						case(RS)
							5'h00:tmp=18'b000110000000001000;//mfc0
							5'h04:tmp=18'b000000000000000000;//mtc0
							5'h10:begin
										case(FUNC)
											6'h18:tmp=18'b000000000001000000;//ERET
											default:tmp=18'b000000000000000000;
										endcase
									end
							default:tmp=18'b000000000000000000;
						endcase
					end
			6'h23:tmp=18'b000100100000001100;//lw   100011
			6'h2B:tmp=18'b000000100000000010;//sw   101011
			default:tmp=18'b000000000000000000;//null
		endcase
	end
	
	assign BNE=tmp[17];
	assign REGADDR=tmp[16:15];
	assign REGDATA=tmp[14:13];
	assign ALUA=tmp[12];
	assign ALUB=tmp[11];
	assign ALUOP=tmp[10:7];
	assign JUMP=tmp[6:5];
	assign COND=tmp[4];
	assign REGW=tmp[3];
	assign MEMR=tmp[2];
	assign MEMW=tmp[1];
	assign UNSIGNED=tmp[0];
	assign cREGW=(OPCODE==6'h10 && RS == 5'h04)? 1:0;
	//ALUop
	//+  0000
	//+u 0001
	//-  0010
	//-u 0011
	//<  0100
	//<u 0101
	//and0110
	//or 0111
	//xor1000
	//lui1010
	//cal1111
endmodule
