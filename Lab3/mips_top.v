module mips_top (
	input wire CCLK,
	input wire [3:0] SW,
	input wire BTNN, BTNE, BTNS, BTNW,
	input wire ROTA, ROTB, ROTCTR,
	output wire [7:0] LED,
	output wire LCDE, LCDRS, LCDRW,
	output wire [3:0] LCDDAT
	);
	
	// clock generator
	wire clk_cpu, clk_disp;
	wire locked;
	
	clk_gen CLK_GEN (
		.clk_pad(CCLK),
		.clk_100m(),
		.clk_50m(clk_disp),
		.clk_25m(),
		.clk_10m(clk_cpu),
		.locked(locked)
		);
	
	// anti-jitter
	wire [3:0] switch;
	wire btn_reset, btn_step;
	wire btn_interrupt;
	wire disp_prev, disp_next;
	wire manclk;
	
	pbdebounce AJ_SW0(.clk(CCLK),.button(SW[0]),.bbutton(switch[0]));
	pbdebounce AJ_SW1(.clk(CCLK),.button(SW[1]),.bbutton(switch[1]));
	pbdebounce AJ_SW2(.clk(CCLK),.button(SW[2]),.bbutton(switch[2]));
	pbdebounce AJ_SW3(.clk(CCLK),.button(SW[3]),.bbutton(switch[3]));
	pbdebounce AJ_ROTA(.clk(CCLK),.button(ROTA),.bbutton(disp_prev));
	pbdebounce AJ_ROTB(.clk(CCLK),.button(ROTB),.bbutton(disp_next));
	pbdebounce AJ_BTNN(.clk(CCLK),.button(BTNN),.bbutton(btn_reset));
	pbdebounce AJ_BTNE(.clk(CCLK),.button(BTNE),.bbutton(btn_interrupt));
	pbdebounce AJ_BTNS(.clk(CCLK),.button(BTNS),.bbutton(btn_step));
	pbdebounce AJ_BTNW(.clk(CCLK),.button(BTNW),.bbutton());
	
	// reset
	reg rst_all;
	reg [15:0] rst_count = 16'hFFFF;
	
	always @(posedge clk_cpu) begin
		rst_all <= (rst_count != 0);
		rst_count <= {rst_count[14:0], (btn_reset | (~locked))};
	end
	
	// display
	reg [4:0] disp_addr0, disp_addr1, disp_addr2, disp_addr3;
	wire [31:0] disp_data;
	wire [31:0] debug_REG;
	wire [31:0] debug_ID;
	wire [31:0] debug_EX;
	wire [31:0] debug_ME;
	wire [31:0] debug_WB;
	
	reg disp_prev_buf, disp_next_buf;
	always @(posedge clk_cpu) begin
		disp_prev_buf <= disp_prev;
		disp_next_buf <= disp_next;
	end
	
	always @(posedge clk_cpu) begin
		if (rst_all) begin
			disp_addr0 <= 0;
			disp_addr1 <= 0;
			disp_addr2 <= 0;
			disp_addr3 <= 0;
		end
		else if (~disp_prev_buf && disp_prev && ~disp_next) case (switch[1:0])
			0: disp_addr0 <= disp_addr0 - 1'h1;
			1: disp_addr1 <= disp_addr1 - 1'h1;
			2: disp_addr2 <= disp_addr2 - 1'h1;
			3: disp_addr3 <= disp_addr3 - 1'h1;
		endcase
		else if (~disp_next_buf && disp_next && ~disp_prev) case (switch[1:0])
			0: disp_addr0 <= disp_addr0 + 1'h1;
			1: disp_addr1 <= disp_addr1 + 1'h1;
			2: disp_addr2 <= disp_addr2 + 1'h1;
			3: disp_addr3 <= disp_addr3 + 1'h1;
		endcase
	end
	
	reg [4:0] disp_addr;
	always @(*) begin
		case (switch[1:0])
			0: disp_addr = disp_addr0;
			1: disp_addr = disp_addr1;
			2: disp_addr = disp_addr2;
			3: disp_addr = disp_addr3;
		endcase
	end
	
	display DISPLAY (
		.clk(clk_disp),
		.rst(rst_all),
		.addr({1'b0, switch[1:0], disp_addr[4:0]}),
		.data(disp_data),
		.in0(debug_REG),
		.in1(debug_ID),
		.in2(debug_EX),
		.in3(debug_ME),
		.in4(debug_WB),
		.lcd_e(LCDE),
		.lcd_rs(LCDRS),
		.lcd_rw(LCDRW),
		.lcd_dat(LCDDAT)
		);
	assign LED = {4'b0, switch};
	
	cpu MIPS (
		.debug_en(switch[3]),
		.debug_step(btn_step),
		.debug_addr({switch[1:0], disp_addr[4:0]}),
		.debug_data(disp_data),
		.debug_REG(debug_REG),
		.debug_ID(debug_ID),
		.debug_EX(debug_EX),
		.debug_ME(debug_ME),
		.debug_WB(debug_WB),
		.clk(clk_cpu),
		.rst(rst_all),
		.INT(btn_interrupt)
		);
	
endmodule
