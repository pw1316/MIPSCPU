`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:31:50 06/09/2015 
// Design Name: 
// Module Name:    timer_1ms 
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
module timer_1ms(clk,clk_1ms);
    input wire clk;
    output reg clk_1ms;
    reg [15:0] cnt;
    initial begin
        cnt [15:0] <=0;
        clk_1ms <= 0;
    end
    always@(posedge clk)
        if(cnt>=25000) begin
            cnt<=0;
            clk_1ms <= ~clk_1ms;
        end
        else begin
        cnt<=cnt+1;
        end
endmodule
