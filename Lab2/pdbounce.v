`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:29:14 06/09/2015 
// Design Name: 
// Module Name:    pdbounce 
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
//////////////////////////////////////////////////////////////////////////////////module pbdebounce(clk,button,bbutton);
module pbdebounce(clk,button,bbutton);
    input wire clk;
    input wire button;
    output reg bbutton;
    reg [7:0] pbshift;
    wire clk_1ms;
    timer_1ms m0(clk, clk_1ms);
    always@(posedge clk_1ms) begin
        pbshift=pbshift<<1;
        pbshift[0]=button;
        if (pbshift==0)
            bbutton=0;
        if (pbshift==8'hFF)
            bbutton=1;
    end
endmodule
