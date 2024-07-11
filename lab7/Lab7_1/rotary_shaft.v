`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:31:24 03/13/2019 
// Design Name: 
// Module Name:    rotary_shaft 
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
module rotary_shaft(clk, ROT_A, ROT_B, rotation_event);
input clk, ROT_A, ROT_B;
output rotation_event;
reg rotation_event;

always@(posedge clk) begin
	if(ROT_A == 1 & ROT_B == 1) begin
		rotation_event <= 1;
	end
	else if(ROT_A == 0 & ROT_B == 0) begin
		rotation_event <= 0;
	end
end

endmodule