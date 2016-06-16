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
	
	wire [31:0] jumpo;
	wire [31:0] condo;
	
	/*IF*/
	reg [31:0] PC = 0;
	
	wire [31:0] inst_if;
	wire [31:0] PCp4_if;
	/*IF*/
	
	/*ID*/
	reg [31:0] inst_id = 32'hFFFFFFFF;
	reg [31:0] PCp4_id = 0;
	
	wire BNE_id;
	wire [1:0] REGADDR_id;
	wire [1:0] REGDATA_id;
	wire ALUA_id;
	wire ALUB_id;
	wire [3:0] ALUOP_id;
	wire [1:0] JUMP_id;
	wire COND_id;
	wire REGW_id;
	wire MEMR_id;
	wire MEMW_id;
	wire UNSIGNED_id;
	
	wire [5:0] func_id;
	wire [31:0] imme_id;
	wire [31:0] label_id;
	wire [31:0] reg_a_id;
	wire [31:0] reg_b_id;
	
	wire [31:0] alu_a_id;
	wire [31:0] alu_b_id;
	wire [4:0] reg_dst_id;
	wire [31:0] mem_data_id;
	/*ID*/
	
	/*EXE*/
	reg [31:0] PCp4_exe = 0;
	reg [31:0] inst_exe = 32'hFFFFFFFF;
	reg [31:0] alu_a_exe = 0;
	reg [31:0] alu_b_exe = 0;
	reg [31:0] reg_dst_exe = 0;
	reg [31:0] mem_data_exe = 0;
	reg [31:0] imme_exe = 0;
	reg [5:0] func_exe = 0;
	
	reg BNE_exe = 0;
	reg [1:0] REGADDR_exe = 0;
	reg [1:0] REGDATA_exe = 0;
	reg ALUA_exe = 0;
	reg ALUB_exe = 0;
	reg [3:0] ALUOP_exe = 0;
	reg [1:0] JUMP_exe = 0;
	reg COND_exe = 0;
	reg REGW_exe = 0;
	reg MEMR_exe = 0;
	reg MEMW_exe = 0;
	reg UNSIGNED_exe = 0;
	
	wire [31:0] aluopo_exe;
	wire zf_exe,cf_exe,of_exe;
	
	wire [31:0] alu_res_exe;
	/*EXE*/
	
	/*MEM*/
	reg [31:0] PCp4_mem = 0;
	reg [31:0] inst_mem = 32'hFFFFFFFF;
	reg [31:0] mem_addr_mem = 0;
	reg [31:0] reg_dst_mem = 0;
	reg [31:0] mem_data_mem = 0;
	
	reg BNE_mem = 0;
	reg [1:0] REGADDR_mem = 0;
	reg [1:0] REGDATA_mem = 0;
	reg ALUA_mem = 0;
	reg ALUB_mem = 0;
	reg [3:0] ALUOP_mem = 0;
	reg [1:0] JUMP_mem = 0;
	reg COND_mem = 0;
	reg REGW_mem = 0;
	reg MEMR_mem = 0;
	reg MEMW_mem = 0;
	reg UNSIGNED_mem = 0;
	
	wire [31:0] mem_out_mem;
	/*MEM*/
	
	/*WB*/
	reg [31:0] PCp4_wb = 0;
	reg [4:0] reg_addr_wb = 0;
	reg [31:0] alu_out_wb = 0;
	reg [31:0] mem_out_wb = 0;
	
	reg BNE_wb = 0;
	reg [1:0] REGADDR_wb = 0;
	reg [1:0] REGDATA_wb = 0;
	reg ALUA_wb = 0;
	reg ALUB_wb = 0;
	reg [3:0] ALUOP_wb = 0;
	reg [1:0] JUMP_wb = 0;
	reg COND_wb = 0;
	reg REGW_wb = 0;
	reg MEMR_wb = 0;
	reg MEMW_wb = 0;
	reg UNSIGNED_wb = 0;
	
	wire [31:0] reg_data_wb;
	/*WB*/
	
	/*stall*/
	wire [1:0] stall_if;
	wire [1:0] stall_id;
	wire [1:0] stall_exe;
	wire [1:0] stall_mem;
	wire [1:0] stall_wb;
	reg cond_hazard = 0;
	reg rw_hazard = 0;
	reg jump_hazard = 0;
	/*stall*/
	
	/*clock*/
	wire manclk;
	/*clock*/
	
	/*debug*/
	reg [31:0] debug_data_signal = 0;
	wire [31:0] reg_debug_signal;
	/*debug*/
	
	/*IF*/
	get_inst m0(
		.addr(PC),
		.data(inst_if)
	);
	
	assign PCp4_if = PC + 4;
	/*IF*/
	
	/*ID*/
	get_ctrl m1(
		.OPCODE(inst_id[31:26]),
		.FUNC(inst_id[5:0]),
		.BNE(BNE_id),
		.REGADDR(REGADDR_id),
		.REGDATA(REGDATA_id),
		.ALUA(ALUA_id),
		.ALUB(ALUB_id),
		.ALUOP(ALUOP_id),
		.JUMP(JUMP_id),
		.COND(COND_id),
		.REGW(REGW_id),
		.MEMR(MEMR_id),
		.MEMW(MEMW_id),
		.UNSIGNED(UNSIGNED_id)
	);
	
	regfile m2(
		.clk(manclk),
		.rst(rst),
		.debug_addr(debug_addr[4:0]),
		.debug_data(reg_debug_signal),
		.addr_a(inst_id[25:21]),
		.data_a(reg_a_id),
		.addr_b(inst_id[20:16]),
		.data_b(reg_b_id),
		.WE(REGW_wb),
		.addr_w(reg_addr_wb),
		.data_w(reg_data_wb)
	);
	
	assign func_id = inst_id[5:0];
	assign imme_id[15:0] = inst_id[15:0];
	assign imme_id[31:16] = UNSIGNED_id? 16'b0:{16{inst_id[15]}};
	assign label_id = JUMP_id[1]? reg_a_id:{PCp4_id[31:28],inst_id[25:0],2'b0}; 
	assign alu_a_id = ALUA_id? {27'b0, inst_id[10:6]}:reg_a_id;
	assign alu_b_id = ALUB_id? imme_id:reg_b_id;
	assign reg_dst_id = REGADDR_id[0]? 5'h1F:(REGADDR_id[1]? inst_id[15:11]:inst_id[20:16]);
	assign mem_data_id = reg_b_id;
	/*ID*/
	
	/*EXE*/
	alu_ctrl m3(
		.func(func_exe),
		.ctr(ALUOP_exe),
		.out(aluopo_exe)
	);
	alu m4(
		.op(aluopo_exe),
		.A(alu_a_exe),
		.B(alu_b_exe),
		.S(alu_res_exe),
		.ZF(zf_exe),
		.OF(of_exe),
		.CF(cf_exe)
	);
	/*EXE*/
	
	/*MEM*/
	memory m5(
		.clk(manclk),
		.RE(MEMR_mem),
		.WE(MEMW_mem),
		.addr(mem_addr_mem),
		.data_in(mem_data_mem),
		.data_out(mem_out_mem)
	);
	/*MEM*/
	
	/*WB*/
	assign reg_data_wb = REGDATA_wb[0]? PCp4_wb:(REGDATA_wb[1]? mem_out_wb:alu_out_wb); 
	/*WB*/
	
	assign jumpo = JUMP_id[0]? label_id:PCp4_if;
	assign condo = (COND_exe&zf_exe)^BNE_exe? PCp4_exe+{imme_exe[29:0],2'b0}:jumpo;
	
	/*stall*/
	always@* begin
		if(((COND_exe&zf_exe)^BNE_exe) && (condo != PCp4_exe)) cond_hazard <= 1'b1;
		else cond_hazard <= 1'b0;
		
		if((inst_id[31:26] == 6'h0) || (inst_id[31:26] == 6'h4) || (inst_id[31:26] == 6'h5)) begin
			if(REGW_exe && ((reg_dst_exe == inst_id[25:21]) || (reg_dst_exe == inst_id[20:16]))) rw_hazard <= 1'b1;
			else if(REGW_mem && ((reg_dst_mem == inst_id[25:21]) || (reg_dst_mem == inst_id[20:16]))) rw_hazard <= 1'b1;
			else rw_hazard <= 1'b0;
		end
		else if(inst_id[31:29] == 3'h1) begin
			if(REGW_exe && (reg_dst_exe == inst_id[25:21])) rw_hazard <= 1'b1;
			else if(REGW_mem && (reg_dst_mem == inst_id[25:21])) rw_hazard <= 1'b1;
			else rw_hazard <= 1'b0;
		end
		else if(inst_id[31:26] == 6'h2B) begin
			if(REGW_exe && (reg_dst_exe == inst_id[20:16])) rw_hazard <= 1'b1;
			else if(REGW_mem && (reg_dst_mem == inst_id[20:16])) rw_hazard <= 1'b1;
			else rw_hazard <= 1'b0;
		end
		else rw_hazard <= 1'b0;
		
		if(JUMP_id[0] && jumpo != PCp4_id) jump_hazard <=1'b1;
		else jump_hazard <=1'b0;
	end
	
	assign stall_if = cond_hazard? 2'b00:(rw_hazard? 2'b11:jump_hazard? 2'b00:2'b00);
	assign stall_id = cond_hazard? 2'b10:(rw_hazard? 2'b11:jump_hazard? 2'b10:2'b00);
	assign stall_exe = cond_hazard? 2'b10:(rw_hazard? 2'b10:jump_hazard? 2'b00:2'b00);
	assign stall_mem = cond_hazard? 2'b00:(rw_hazard? 2'b00:jump_hazard? 2'b00:2'b00);
	assign stall_wb = cond_hazard? 2'b00:(rw_hazard? 2'b00:jump_hazard? 2'b00:2'b00);
	
	/*stall*/
	
	always@(posedge manclk,posedge rst) begin
		if(rst) begin
			PC <= 0;
		end
		else begin
			PC <= stall_if[1]? (stall_if[0]? PC:0):condo;
			
			inst_id <= stall_id[1]? (stall_id[0]? inst_id:32'hFFFFFFFF):inst_if;
			PCp4_id <= stall_id[1]? (stall_id[0]? PCp4_id:0):PCp4_if;
			
			PCp4_exe <= stall_exe[1]? (stall_exe[0]? PCp4_exe:0):PCp4_id;
			inst_exe <= stall_exe[1]? (stall_exe[0]? inst_exe:32'hFFFFFFFF):inst_id;
			alu_a_exe <= stall_exe[1]? (stall_exe[0]? alu_a_exe:0):alu_a_id;
			alu_b_exe <= stall_exe[1]? (stall_exe[0]? alu_b_exe:0):alu_b_id;
			reg_dst_exe <= stall_exe[1]? (stall_exe[0]? reg_dst_exe:0):reg_dst_id;
			mem_data_exe <= stall_exe[1]? (stall_exe[0]? mem_data_exe:0):mem_data_id;
			imme_exe <= stall_exe[1]? (stall_exe[0]? imme_exe:0):imme_id;
			func_exe <= stall_exe[1]? (stall_exe[0]? func_exe:0):func_id;
			BNE_exe <= stall_exe[1]? (stall_exe[0]? BNE_exe:0):BNE_id;
			REGADDR_exe <= stall_exe[1]? (stall_exe[0]? REGADDR_exe:0):REGADDR_id;
			REGDATA_exe <= stall_exe[1]? (stall_exe[0]? REGDATA_exe:0):REGDATA_id;
			ALUA_exe <= stall_exe[1]? (stall_exe[0]? ALUA_exe:0):ALUA_id;
			ALUB_exe <= stall_exe[1]? (stall_exe[0]? ALUB_exe:0):ALUB_id;
			ALUOP_exe <= stall_exe[1]? (stall_exe[0]? ALUOP_exe:0):ALUOP_id;
			JUMP_exe <= stall_exe[1]? (stall_exe[0]? JUMP_exe:0):JUMP_id;
			COND_exe <= stall_exe[1]? (stall_exe[0]? COND_exe:0):COND_id;
			REGW_exe <= stall_exe[1]? (stall_exe[0]? REGW_exe:0):REGW_id;
			MEMR_exe <= stall_exe[1]? (stall_exe[0]? MEMR_exe:0):MEMR_id;
			MEMW_exe <= stall_exe[1]? (stall_exe[0]? MEMW_exe:0):MEMW_id;
			UNSIGNED_exe <= stall_exe[1]? (stall_exe[0]? UNSIGNED_exe:0):UNSIGNED_id;
			
			PCp4_mem <= stall_mem[1]? (stall_mem[0]? PCp4_mem:0):PCp4_exe;
			inst_mem <= stall_mem[1]? (stall_mem[0]? inst_mem:32'hFFFFFFFF):inst_exe;
			mem_addr_mem <= stall_mem[1]? (stall_mem[0]? mem_addr_mem:0):alu_res_exe;
			reg_dst_mem <= stall_mem[1]? (stall_mem[0]? reg_dst_mem:0):reg_dst_exe;
			mem_data_mem <= stall_mem[1]? (stall_mem[0]? mem_data_mem:0):mem_data_exe;
			BNE_mem <= stall_mem[1]? (stall_mem[0]? BNE_mem:0):BNE_exe;
			REGADDR_mem <= stall_mem[1]? (stall_mem[0]? REGADDR_mem:0):REGADDR_exe;
			REGDATA_mem <= stall_mem[1]? (stall_mem[0]? REGDATA_mem:0):REGDATA_exe;
			ALUA_mem <= stall_mem[1]? (stall_mem[0]? ALUA_mem:0):ALUA_exe;
			ALUB_mem <= stall_mem[1]? (stall_mem[0]? ALUB_mem:0):ALUB_exe;
			ALUOP_mem <= stall_mem[1]? (stall_mem[0]? ALUOP_mem:0):ALUOP_exe;
			JUMP_mem <= stall_mem[1]? (stall_mem[0]? JUMP_mem:0):JUMP_exe;
			COND_mem <= stall_mem[1]? (stall_mem[0]? COND_mem:0):COND_exe;
			REGW_mem <= stall_mem[1]? (stall_mem[0]? REGW_mem:0):REGW_exe;
			MEMR_mem <= stall_mem[1]? (stall_mem[0]? MEMR_mem:0):MEMR_exe;
			MEMW_mem <= stall_mem[1]? (stall_mem[0]? MEMW_mem:0):MEMW_exe;
			UNSIGNED_mem <= stall_mem[1]? (stall_mem[0]? UNSIGNED_mem:0):UNSIGNED_exe;
			
			PCp4_wb <= stall_wb[1]? (stall_wb[0]? PCp4_wb:0):PCp4_mem;
			reg_addr_wb <= stall_wb[1]? (stall_wb[0]? reg_addr_wb:0):reg_dst_mem;
			alu_out_wb <= stall_wb[1]? (stall_wb[0]? alu_out_wb:0):mem_addr_mem;
			mem_out_wb <= stall_wb[1]? (stall_wb[0]? mem_out_wb:0):mem_out_mem;
			BNE_wb <= stall_wb[1]? (stall_wb[0]? BNE_wb:0):BNE_mem;
			REGADDR_wb <= stall_wb[1]? (stall_wb[0]? REGADDR_wb:0):REGADDR_mem;
			REGDATA_wb <= stall_wb[1]? (stall_wb[0]? REGDATA_wb:0):REGDATA_mem;
			ALUA_wb <= stall_wb[1]? (stall_wb[0]? ALUA_wb:0):ALUA_mem;
			ALUB_wb <= stall_wb[1]? (stall_wb[0]? ALUB_wb:0):ALUB_mem;
			ALUOP_wb <= stall_wb[1]? (stall_wb[0]? ALUOP_wb:0):ALUOP_mem;
			JUMP_wb <= stall_wb[1]? (stall_wb[0]? JUMP_wb:0):JUMP_mem;
			COND_wb <= stall_wb[1]? (stall_wb[0]? COND_wb:0):COND_mem;
			REGW_wb <= stall_wb[1]? (stall_wb[0]? REGW_wb:0):REGW_mem;
			MEMR_wb <= stall_wb[1]? (stall_wb[0]? MEMR_wb:0):MEMR_mem;
			MEMW_wb <= stall_wb[1]? (stall_wb[0]? MEMW_wb:0):MEMW_mem;
			UNSIGNED_wb <= stall_wb[1]? (stall_wb[0]? UNSIGNED_wb:0):UNSIGNED_mem;
		end
	end
	
	always@(posedge clk) begin
		case (debug_addr[4:0])
			0: debug_data_signal <= PC;
			1: debug_data_signal <= inst_if;
			2: debug_data_signal <= PCp4_id - 4;
			3: debug_data_signal <= inst_id;
			4: debug_data_signal <= PCp4_exe - 4;
			5: debug_data_signal <= 0;
			6: debug_data_signal <= PCp4_mem - 4;
			7: debug_data_signal <= 0;
			8: debug_data_signal <= {27'b0, inst_id[25:21]};
			9: debug_data_signal <= reg_a_id;
			10: debug_data_signal <= {27'b0, inst_id[20:16]};
			11: debug_data_signal <= reg_b_id;
			12: debug_data_signal <= imme_id;
			13: debug_data_signal <= alu_a_exe;
			14: debug_data_signal <= alu_b_exe;
			15: debug_data_signal <= alu_res_exe;
			16: debug_data_signal <= 0;
			17: debug_data_signal <= 0;
			18: debug_data_signal <= {19'b0, REGW_wb, 7'b0, MEMR_mem, 3'b0, MEMW_mem};
			19: debug_data_signal <= mem_addr_mem;
			20: debug_data_signal <= mem_out_mem;
			21: debug_data_signal <= mem_data_mem;
			22: debug_data_signal <= {27'b0,reg_addr_wb};
			23: debug_data_signal <= reg_data_wb;
			default: debug_data_signal <= 32'hFFFF_FFFF;
		endcase
	end
	
	assign debug_data = debug_addr[5] ? debug_data_signal : reg_debug_signal;
	assign manclk=debug_en? debug_step:clk; 
	
endmodule
