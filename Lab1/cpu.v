`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:20:15 05/26/2015 
// Design Name: 
// Module Name:    cpu 
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
module cpu(
	input wire debug_en,  // debug enable
	input wire debug_step,  // debug step clock
	input wire [6:0] debug_addr,  // debug address
	output wire [31:0] debug_data,  // debug data
	input wire clk,
	input wire rst,
	input wire INT
   );
	
	reg zero=1'b0;
	
	//*control*//
	wire BNE;
	wire [1:0] REGADDR;
	wire [1:0] REGDATA;
	wire ALUA;
	wire ALUB;
	wire [3:0] ALUOP;
	wire [1:0] JUMP;
	wire COND;
	wire REGW;
	wire MEMR;
	wire MEMW;
	wire UNSIGNED;
	wire [31:0] regaddr;
	wire [31:0] regdata;
	wire [31:0] alua;
	wire [31:0] alub;
	wire [3:0] aluop;
	wire [31:0] jump;
	wire [31:0] cond;
	//*control*//
	
	//*instruction*//
	reg [31:0] PC=32'h0;
	wire [31:0] PCp4;
	wire [31:0] inst;
	wire [31:0] imme;
	assign PCp4=PC+4;
	//*instruction*//
	
	//*register*//
	wire [31:0] regdataa;
	wire [31:0] regdatab;
	//*register*//
	
	//*ALU*//
	wire zf;
	wire of;
	wire cf;
	wire [31:0] alures;
	//*ALU*//
	
	//*memory*//
	wire [31:0] memout;
	//*memory*//
	
	//*clock*//
	wire manclk;
	//*clock*//
	
	//*debug*//
	reg [31:0] debug_data_signal=32'h0;
	wire [31:0] reg_debug_signal;
	//*debug*//
	
	get_inst m0(
		.addr(PC),
		.data(inst)
	);
	get_ctrl m1(
		.OPCODE(inst[31:26]),
		.FUNC(inst[5:0]),
		.BNE(BNE),
		.REGADDR(REGADDR),
		.REGDATA(REGDATA),
		.ALUA(ALUA),
		.ALUB(ALUB),
		.ALUOP(ALUOP),
		.JUMP(JUMP),
		.COND(COND),
		.REGW(REGW),
		.MEMR(MEMR),
		.MEMW(MEMW),
		.UNSIGNED(UNSIGNED)
	);
	regfile m2(
		.clk(manclk),
		.rst(rst),
		.debug_addr(debug_addr[4:0]),
		.debug_data(reg_debug_signal),
		.addr_a(inst[25:21]),
		.data_a(regdataa),
		.addr_b(inst[20:16]),
		.data_b(regdatab),
		.WE(REGW),
		.addr_w(regaddr),
		.data_w(regdata)
	);
	alu_ctrl m3(
		.func(inst[5:0]),
		.ctr(ALUOP),
		.out(aluop)
	);
	alu m4(
		.op(aluop),
		.A(alua),
		.B(alub),
		.S(alures),
		.ZF(zf),
		.OF(of),
		.CF(cf)
	);
	memory m5(
		.clk(manclk),
		.RE(MEMR),
		.WE(MEMW),
		.addr(alures),
		.data_in(regdatab),
		.data_out(memout)
	);
	mux4to1_5bit mux0(
		.in_00(inst[20:16]),
		.in_01(31),
		.in_10(inst[15:11]),
		.in_11(31),
		.ctr(REGADDR),
		.out(regaddr)
	);
	mux4to1_32bit mux1(
		.in_00(alures),
		.in_01(PCp4),
		.in_10(memout),
		.in_11(PCp4),
		.ctr(REGDATA),
		.out(regdata)
	);
	mux2to1_32bit mux3(
		.in_0(regdataa),
		.in_1({27'b0,inst[10:6]}),
		.ctr(ALUA),
		.out(alua)
	);
	mux2to1_32bit mux4(
		.in_0(regdatab),
		.in_1(imme),
		.ctr(ALUB),
		.out(alub)
	);
	mux4to1_32bit mux5(
		.in_00(cond),
		.in_01({PCp4[31:28],inst[25:0],2'b0}),
		.in_10(cond),
		.in_11(regdataa),
		.ctr(JUMP),
		.out(jump)
	);
	mux2to1_32bit mux6(
		.in_0(PCp4),
		.in_1(PCp4+{imme[29:0],2'b0}),
		.ctr((COND&zf)^BNE),
		.out(cond)
	);
	extend16to32 ex0(
		.u(UNSIGNED),
		.in(inst[15:0]),
		.out(imme)
	);
	always@(posedge manclk,posedge rst) begin
		if(rst) begin
			PC=0;
		end
		else begin
			PC=jump;
		end
	end
	
	always@(posedge clk) begin
		case (debug_addr[4:0])
			0: debug_data_signal <= PC;
			1: debug_data_signal <= inst;
			2: debug_data_signal <= 0;
			3: debug_data_signal <= 0;
			4: debug_data_signal <= 0;
			5: debug_data_signal <= 0;
			6: debug_data_signal <= 0;
			7: debug_data_signal <= 0;
			8: debug_data_signal <= {27'b0, inst[25:21]};
			9: debug_data_signal <= regdataa;
			10: debug_data_signal <= {27'b0, inst[20:16]};
			11: debug_data_signal <= regdatab;
			12: debug_data_signal <= imme;
			13: debug_data_signal <= alua;
			14: debug_data_signal <= alub;
			15: debug_data_signal <= alures;
			16: debug_data_signal <= 0;
			17: debug_data_signal <= 0;
			18: debug_data_signal <= {19'b0, REGW, 7'b0, MEMR, 3'b0, MEMW};
			19: debug_data_signal <= alures;
			20: debug_data_signal <= regdatab;
			21: debug_data_signal <= memout;
			22: debug_data_signal <= {27'b0,regaddr};
			23: debug_data_signal <= regdata;
			default: debug_data_signal <= 32'hFFFF_FFFF;
		endcase
	end
	
	assign debug_data = debug_addr[5] ? debug_data_signal : reg_debug_signal;
	//assign debug_data = inst;
	
	assign manclk=debug_en? debug_step:clk; 
	
endmodule
