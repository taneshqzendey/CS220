`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:36:51 03/24/2019 
// Design Name: 
// Module Name:    lcd_interface 
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
module lcd_interface(first_line, second_line, output_ready, clk, lcd_rs, lcd_rw, lcd_e, lcd4, lcd5, lcd6, lcd7, output_done
    );

   input output_ready;
   input [0:127] first_line;
	input [0:127] second_line;
	input clk;
	output lcd_rs, lcd_rw, lcd_e, lcd4, lcd5, lcd6, lcd7, output_done;
	reg lcd_rs, lcd_rw, lcd_e, lcd4, lcd5, lcd6, lcd7, output_done;

	reg [7:0] first_line_index;
	reg [1:0] first_line_state;
	 
	reg [7:0] second_line_index;
	reg [1:0] second_line_state;
	 
	reg [19:0] counter;
	reg [2:0] next_state;
	 
	reg [2:0] line_break_state;
	 
	reg [5:0] ROM [0:13];
	reg [3:0] ROM_index;
	 
	// Initialization code
	initial begin
	   first_line_index = 0;
		first_line_state = 3;
		second_line_index = 0;
		second_line_state = 3;
		counter = 1_000_000;
		next_state = 0;
		line_break_state = 7;
		ROM_index = 0;
		output_done = 0;
		ROM[0] = 6'h03;
		ROM[1] = 6'h03;
		ROM[2] = 6'h03;
		ROM[3] = 6'h02;
		ROM[4] = 6'h02;
		ROM[5] = 6'h08;
		ROM[6] = 6'h00;
		ROM[7] = 6'h06;
		ROM[8] = 6'h00;
		ROM[9] = 6'h0c;
		ROM[10] = 6'h00;
		ROM[11] = 6'h01;
		ROM[12] = 6'h08;
		ROM[13] = 6'h00;
	end
	
	always @ (posedge clk) begin
	   	if (output_ready == 0) begin
		   	first_line_index <= 0;
		   	first_line_state <= 3;
		   	second_line_index <= 0;
		   	second_line_state <= 3;
		   	counter <= 1000000;
		   	next_state <= 0;
		   	line_break_state <= 7;
		   	ROM_index <= 0;
			output_done <= 0;
		end
		else if (output_ready == 1) begin
	      		if (counter == 0) begin
		      		counter <= 1000000;
			
			   	// Initialization state machine
			   	if (ROM_index == 14) begin
				   	next_state <= 4;
				   	ROM_index <= 0;
				   	first_line_state <= 0;
			   	end
					
			   	if ((next_state != 4) && (ROM_index != 14)) begin
			     		case (next_state)
			      		0: begin
						lcd_e <= 0;
						next_state <= 1;
               				end
					
               				1: begin
						{lcd_rs, lcd_rw, lcd7, lcd6, lcd5, lcd4} <= ROM[ROM_index];
						next_state <= 2;
				   	end
					
				   	2: begin
				      		lcd_e <= 1;
						next_state <= 3;
					end
					
				   	3: begin
				      		lcd_e <= 0;
						next_state <= 1;
						ROM_index <= ROM_index + 1;
					end
				  	endcase
			   	end
			
			   	// First line state machine
			   	if (first_line_index == 128) begin
				   	first_line_state <= 3;
				   	first_line_index <= 0;
				   	line_break_state <= 0;
			   	end
			   	if ((first_line_state != 3) && (first_line_index != 128)) begin
				   	case (first_line_state)
					0: begin
						{lcd_rs, lcd_rw, lcd7, lcd6, lcd5, lcd4} <= {2'h2,first_line[first_line_index],first_line[first_line_index+1],first_line[first_line_index+2],first_line[first_line_index+3]};
						first_line_state <= 1;
				   	end
						
					1: begin
						lcd_e <= 1;
						first_line_state <= 2;
					end
					
					2: begin
						lcd_e <= 0;
						first_line_state <= 0;
						first_line_index <= first_line_index+4;
					end
				   	endcase
			   	end
			
			   	// Line break state machine
			   	if (line_break_state != 7) begin
				   	case (line_break_state)
					0: begin
						{lcd_rs, lcd_rw, lcd7, lcd6, lcd5, lcd4} <= 6'h0c;
						line_break_state <= 1;
					end
						
					1: begin
						lcd_e <= 1;
						line_break_state <= 2;
					end
						
					2: begin
						lcd_e <= 0;
						line_break_state <= 3;
					end
						
					3: begin
						{lcd_rs, lcd_rw, lcd7, lcd6, lcd5, lcd4} <= 6'h00;
						line_break_state <= 4;
					end
						
					4: begin
						lcd_e <= 1;
						line_break_state <= 5;
					end
						
					5: begin
						lcd_e <= 0;
						line_break_state <= 7;
						second_line_state <= 0;
					end
				   	endcase
			   	end
			
			   	// Second line state machine
			   	if (second_line_index == 128) begin
				   	second_line_state <= 3;
				   	second_line_index <= 0;
					output_done <= 1;
			   	end
			   	if ((second_line_state != 3) && (second_line_index != 128)) begin
				   	case (second_line_state)
					0: begin
						{lcd_rs, lcd_rw, lcd7, lcd6, lcd5, lcd4} <= {2'h2,second_line[second_line_index],second_line[second_line_index+1],second_line[second_line_index+2],second_line[second_line_index+3]};
						second_line_state <= 1;
					end
						
					1: begin
						lcd_e <= 1;
						second_line_state <= 2;
					end
					
					2: begin
						lcd_e <= 0;
						second_line_state <= 0;
						second_line_index <= second_line_index+4;
					end
				   	endcase
			   	end
		   	end
		   	else 
		   	begin 
		      		counter <= counter - 1;
		   	end
	   	end
	end

endmodule
