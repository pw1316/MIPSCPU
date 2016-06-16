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
	output wire [31:0] debug_REG,
	output wire [31:0] debug_ID,
	output wire [31:0] debug_EX,
	output wire [31:0] debug_ME,
	output wire [31:0] debug_WB,
	input wire clk,
	input wire rst,
	input wire [1:0] INT
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
	reg [31:0] cregs [0:31];
	
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
	wire cREG_id;
	
	wire [5:0] func_id;
	wire [31:0] imme_id;
	wire [31:0] label_id;
	wire [31:0] rs_id_for;
	wire [31:0] rt_id_for;
	wire [31:0] reg_a_id;
	wire [31:0] reg_b_id;
	wire [31:0] creg_id;
	
	wire [31:0] alu_a_id;
	wire [31:0] alu_b_id;
	wire [4:0] reg_dst_id;
	wire [31:0] mem_data_id;
	/*ID*/
	
	/*EXE*/
	reg [31:0] PCp4_exe = 0;
	reg [31:0] inst_exe = 32'hFFFFFFFF;
	reg [31:0] creg_exe = 0;
	reg [31:0] alu_a_exe = 0;
	reg [31:0] alu_b_exe = 0;
	reg [31:0] reg_dst_exe = 0;
	reg [31:0] mem_data_exe = 0;
	reg [31:0] imme_exe = 0;
	reg [5:0] func_exe = 0;
	
	reg BNE_exe = 0;
	reg [1:0] REGDATA_exe = 0;
	reg [3:0] ALUOP_exe = 0;
	reg COND_exe = 0;
	reg REGW_exe = 0;
	reg MEMR_exe = 0;
	reg MEMW_exe = 0;
	
	wire [31:0] aluopo_exe;
	wire zf_exe,cf_exe,of_exe;
	wire [31:0] mem_data_for;
	wire isERET;
	
	wire [31:0] alu_res_exe;
	/*EXE*/
	
	/*MEM*/
	reg [31:0] PCp4_mem = 0;
	reg [31:0] inst_mem = 32'hFFFFFFFF;
	reg [31:0] creg_mem = 0;
	reg [31:0] mem_addr_mem = 0;
	reg [31:0] reg_dst_mem = 0;
	reg [31:0] mem_data_mem = 0;
	
	reg [1:0] REGDATA_mem = 0;
	reg REGW_mem = 0;
	reg MEMR_mem = 0;
	reg MEMW_mem = 0;
	
	wire [31:0] mem_out_mem;
	/*MEM*/
	
	/*WB*/
	reg [31:0] PCp4_wb = 0;
	reg [31:0] inst_wb = 32'hFFFFFFFF;
	reg [4:0] reg_addr_wb = 0;
	reg [31:0] alu_out_wb = 0;
	reg [31:0] mem_out_wb = 0;
	reg [31:0] creg_wb = 0;
	
	reg [1:0] REGDATA_wb = 0;
	reg REGW_wb = 0;
	
	wire [31:0] reg_data_wb;
	/*WB*/
	
	/*INT*/
	wire doINT;
	reg [31:0] CAUSE = 0;
	reg [31:0] STAT = 0;
	reg [31:0] EPC = 0;
	/*INT*/
	
	/*stall*/
	wire [1:0] stall_if;
	wire [1:0] stall_id;
	wire [1:0] stall_exe;
	wire [1:0] stall_mem;
	wire [1:0] stall_wb;
	wire read_rs;
	wire read_rt;
	wire loadstore;
	reg cond_hazard = 0;
	reg rs_rw_hazard = 0;
	reg rt_rw_hazard = 0;
	wire rw_hazard;
	reg jump_hazard = 0;
	reg [2:0] rs_forwarding = 0;
	reg [2:0] rt_forwarding = 0;
	reg mem_forwarding_exe = 0;
	reg mem_forwarding_mem = 0;
	/*	000 no forwarding
	 *	001 alu_res_exe
	 *	010 mem_addr_mem
	 *	011 PCp4_exe
	 *	100 PCp4_mem
	 *	101 mem_out_mem
	 * 110 creg_out_exe
	 * 111 creg_out_mem
	 */
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
		.RS(inst_id[25:21]),
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
		.UNSIGNED(UNSIGNED_id),
		.cREGW(cREGW_id)
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
	assign label_id = JUMP_id[1]? (JUMP_id[0]? rs_id_for:EPC):{PCp4_id[31:28],inst_id[25:0],2'b0}; 
	assign alu_a_id = ALUA_id? {27'b0, inst_id[10:6]}:rs_id_for;
	assign alu_b_id = ALUB_id? imme_id:rt_id_for;
	assign reg_dst_id = REGADDR_id[0]? 5'h1F:(REGADDR_id[1]? inst_id[15:11]:inst_id[20:16]);
	assign mem_data_id = rt_id_for;
	assign creg_id = cregs[inst_id[15:11]];
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
	assign isERET = ((inst_exe[31:21] == 11'h210) && (inst_exe[5:0] == 6'h18))? 1:0;
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
	assign reg_data_wb = REGDATA_wb[0]? (REGDATA_wb[1]? creg_wb:PCp4_wb):(REGDATA_wb[1]? mem_out_wb:alu_out_wb); 
	/*WB*/
	
	assign jumpo = (JUMP_id[0]|JUMP_id[1])? label_id:PCp4_if;
	assign condo = doINT? cregs[3]:((COND_exe&zf_exe)^BNE_exe? PCp4_exe+{imme_exe[29:0],2'b0}:jumpo);
	assign doINT = (INT[0] | INT[1]) & ~STAT[0];
	
	/*stall*/
	always@* begin
		if(((COND_exe&zf_exe)^BNE_exe) && (condo != PCp4_exe)) cond_hazard <= 1'b1;
		else cond_hazard <= 1'b0;
		
		/*rs*/
		if(read_rs && inst_id[25:21] != 0)begin
			if(REGW_exe && reg_dst_exe == inst_id[25:21])begin
				if(inst_exe[31:26] == 0 || inst_exe[31:29] == 1)begin
					rs_forwarding <= 1;
					rs_rw_hazard <= 0;
				end
				else if(inst_exe[31:26] == 3)begin
					rs_forwarding <= 3;
					rs_rw_hazard <= 0;
				end
				else if(inst_exe[31:26] == 6'h23)begin
					rs_forwarding <= 0;
					rs_rw_hazard <= 1;
				end
				else begin
					rs_forwarding <= 6;
					rs_rw_hazard <= 0;
				end
			end
			else if(REGW_mem && reg_dst_mem == inst_id[25:21])begin
				if(inst_mem[31:26] == 0 || inst_mem[31:29] == 1)begin
					rs_forwarding <= 2;
					rs_rw_hazard <= 0;
				end
				else if(inst_mem[31:26] == 3)begin
					rs_forwarding <= 4;
					rs_rw_hazard <= 0;
				end
				else if(inst_exe[31:26] == 6'h23)begin
					rs_forwarding <= 5;
					rs_rw_hazard <= 0;
				end
				else begin
					rs_forwarding <= 7;
					rs_rw_hazard <= 0;
				end
			end
			else begin
				rs_forwarding <= 0;
				rs_rw_hazard <= 0;
			end
		end
		else begin
			rs_forwarding <= 0;
			rs_rw_hazard <= 0;
		end
		
		/*rt*/
		if(read_rt && inst_id[20:16] != 0)begin
			if(REGW_exe && reg_dst_exe == inst_id[20:16])begin
				if(inst_exe[31:26] == 0 || inst_exe[31:29] == 1)begin
					rt_forwarding <= 1;
					rt_rw_hazard <= 0;
				end
				else if(inst_exe[31:26] == 3)begin
					rt_forwarding <= 3;
					rt_rw_hazard <= 0;
				end
				else if(inst_exe[31:26] == 6'h23)begin
					if(loadstore)begin
						rt_forwarding <= 0;
						rt_rw_hazard <= 0;
					end
					else begin
						rt_forwarding <= 0;
						rt_rw_hazard <= 1;
					end
				end
				else begin
					rt_forwarding <= 6;
					rt_rw_hazard <= 0;
				end
			end
			else if(REGW_mem && reg_dst_mem == inst_id[20:16])begin
				if(inst_mem[31:26] == 0 || inst_mem[31:29] == 1)begin
					rt_forwarding <= 2;
					rt_rw_hazard <= 0;
				end
				else if(inst_mem[31:26] == 3)begin
					rt_forwarding <= 4;
					rt_rw_hazard <= 0;
				end
				else if(inst_exe[31:26] == 6'h23)begin
					rt_forwarding <= 5;
					rt_rw_hazard <= 0;
				end
				else begin
					rt_forwarding <= 7;
					rt_rw_hazard <= 0;
				end
			end
			else begin
				rt_forwarding <= 0;
				rt_rw_hazard <= 0;
			end
		end
		else begin
			rt_forwarding <= 0;
			rt_rw_hazard <= 0;
		end
		
		if(loadstore && inst_id[20:16] == reg_dst_exe)begin
			mem_forwarding_exe <= 1;
		end
		else begin
			mem_forwarding_exe <= 0;
		end
		
		if((JUMP_id[0]|JUMP_id[1]) && (jumpo != PCp4_id)) jump_hazard <=1'b1;
		else jump_hazard <=1'b0;
	end
	
	assign read_rs = ((inst_id[31:26] == 6'h0 && ~ALUA_id) || (COND_id) || (inst_id[31:29] == 3'h1 && inst_id[28:26] != 3'h7) || (inst_id[31:30] == 2'h3))? 1:0;
	assign read_rt = ((inst_id[31:26] == 6'h0 && REGW_id) || (COND_id) || (inst_id[31:26] == 6'h2B) || (inst_id[31:21] == 11'h204))? 1:0;
	assign loadstore = ((inst_id[31:26] == 6'h2B) && (inst_exe[31:26] == 6'h23))? 1:0;
	
	assign rw_hazard = rs_rw_hazard | rt_rw_hazard;
	assign stall_if = doINT? 2'b00:(cond_hazard? 2'b00:(rw_hazard? 2'b11:jump_hazard? 2'b00:2'b00));
	assign stall_id = doINT? 2'b10:(cond_hazard? 2'b10:(rw_hazard? 2'b11:jump_hazard? 2'b10:2'b00));
	assign stall_exe = doINT? 2'b10:(cond_hazard? 2'b10:(rw_hazard? 2'b10:jump_hazard? 2'b00:2'b00));
	assign stall_mem = doINT? 2'b10:(cond_hazard? 2'b00:(rw_hazard? 2'b00:jump_hazard? 2'b00:2'b00));
	assign stall_wb = doINT? 2'b00:(cond_hazard? 2'b00:(rw_hazard? 2'b00:jump_hazard? 2'b00:2'b00));
	assign rs_id_for = rs_forwarding[2]? (rs_forwarding[1]? (rs_forwarding[0]? (creg_mem):(creg_exe)):(rs_forwarding[0]? (mem_out_mem):(PCp4_mem))):(rs_forwarding[1]? (rs_forwarding[0]? (PCp4_exe):(mem_addr_mem)):(rs_forwarding[0]? (alu_res_exe):(reg_a_id)));
	assign rt_id_for = rt_forwarding[2]? (rt_forwarding[1]? (rt_forwarding[0]? (creg_mem):(creg_exe)):(rt_forwarding[0]? (mem_out_mem):(PCp4_mem))):(rt_forwarding[1]? (rt_forwarding[0]? (PCp4_exe):(mem_addr_mem)):(rt_forwarding[0]? (alu_res_exe):(reg_b_id)));
	assign mem_data_for = mem_forwarding_mem? mem_out_mem:mem_data_exe;
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
			creg_exe <= stall_exe[1]? (stall_exe[0]? creg_exe:0):creg_id;
			alu_a_exe <= stall_exe[1]? (stall_exe[0]? alu_a_exe:0):alu_a_id;
			alu_b_exe <= stall_exe[1]? (stall_exe[0]? alu_b_exe:0):alu_b_id;
			reg_dst_exe <= stall_exe[1]? (stall_exe[0]? reg_dst_exe:0):reg_dst_id;
			mem_data_exe <= stall_exe[1]? (stall_exe[0]? mem_data_exe:0):mem_data_id;
			imme_exe <= stall_exe[1]? (stall_exe[0]? imme_exe:0):imme_id;
			func_exe <= stall_exe[1]? (stall_exe[0]? func_exe:0):func_id;
			BNE_exe <= stall_exe[1]? (stall_exe[0]? BNE_exe:0):BNE_id;
			REGDATA_exe <= stall_exe[1]? (stall_exe[0]? REGDATA_exe:0):REGDATA_id;
			ALUOP_exe <= stall_exe[1]? (stall_exe[0]? ALUOP_exe:0):ALUOP_id;
			COND_exe <= stall_exe[1]? (stall_exe[0]? COND_exe:0):COND_id;
			REGW_exe <= stall_exe[1]? (stall_exe[0]? REGW_exe:0):REGW_id;
			MEMR_exe <= stall_exe[1]? (stall_exe[0]? MEMR_exe:0):MEMR_id;
			MEMW_exe <= stall_exe[1]? (stall_exe[0]? MEMW_exe:0):MEMW_id;
			
			PCp4_mem <= stall_mem[1]? (stall_mem[0]? PCp4_mem:0):PCp4_exe;
			inst_mem <= stall_mem[1]? (stall_mem[0]? inst_mem:32'hFFFFFFFF):inst_exe;
			creg_mem <= stall_mem[1]? (stall_mem[0]? creg_mem:0):creg_exe;
			mem_addr_mem <= stall_mem[1]? (stall_mem[0]? mem_addr_mem:0):alu_res_exe;
			reg_dst_mem <= stall_mem[1]? (stall_mem[0]? reg_dst_mem:0):reg_dst_exe;
			mem_data_mem <= stall_mem[1]? (stall_mem[0]? mem_data_mem:0):mem_data_for;
			REGDATA_mem <= stall_mem[1]? (stall_mem[0]? REGDATA_mem:0):REGDATA_exe;
			REGW_mem <= stall_mem[1]? (stall_mem[0]? REGW_mem:0):REGW_exe;
			MEMR_mem <= stall_mem[1]? (stall_mem[0]? MEMR_mem:0):MEMR_exe;
			MEMW_mem <= stall_mem[1]? (stall_mem[0]? MEMW_mem:0):MEMW_exe;
			mem_forwarding_mem <= stall_mem[1]? (stall_mem[0]? mem_forwarding_mem:0):mem_forwarding_exe;
			
			PCp4_wb <= stall_wb[1]? (stall_wb[0]? PCp4_wb:0):PCp4_mem;
			inst_wb <= stall_wb[1]? (stall_wb[0]? inst_wb:32'hFFFFFFFF):inst_mem;
			reg_addr_wb <= stall_wb[1]? (stall_wb[0]? reg_addr_wb:0):reg_dst_mem;
			alu_out_wb <= stall_wb[1]? (stall_wb[0]? alu_out_wb:0):mem_addr_mem;
			mem_out_wb <= stall_wb[1]? (stall_wb[0]? mem_out_wb:0):mem_out_mem;
			creg_wb <= stall_wb[1]? (stall_wb[0]? creg_wb:0):creg_mem;
			REGDATA_wb <= stall_wb[1]? (stall_wb[0]? REGDATA_wb:0):REGDATA_mem;
			REGW_wb <= stall_wb[1]? (stall_wb[0]? REGW_wb:0):REGW_mem;
			
			if(doINT) begin
				EPC <= (PCp4_exe != 32'h0)? (PCp4_exe-4):((PCp4_id != 32'h0)? (PCp4_id-4):(PCp4_if-4));
				CAUSE <= INT;
				STAT <= STAT | 32'h1;
			end
			
			if(isERET) begin
				CAUSE <= 32'h0;
				STAT <= STAT & 32'hFFFFFFFE;
			end
		end
	end
	
	always@(negedge manclk) begin
		if(cREGW_id) cregs[inst_id[15:11]] <= rt_id_for;
	end
	
	assign debug_data = inst_if;
	assign debug_REG = reg_debug_signal;
	assign manclk=debug_en? debug_step:clk; 
	assign debug_ID = (inst_id == 32'hFFFFFFFF)? 32'hFFFFFFFF:PCp4_id - 4;
	assign debug_EX = (inst_exe == 32'hFFFFFFFF)? 32'hFFFFFFFF:PCp4_exe - 4;
	assign debug_ME = (inst_mem == 32'hFFFFFFFF)? 32'hFFFFFFFF:PCp4_mem - 4;
	assign debug_WB = (inst_wb == 32'hFFFFFFFF)? 32'hFFFFFFFF:PCp4_wb - 4;
	
endmodule
