//`timescale 1ns/10ps
//
//	input clk,
//	input clear,
//	input enable,
//	input [DATA_WIDTH_IN-1:0]BusMuxOut,
//	output wire [DATA_WIDTH_OUT-1:0]BusMuxIn
//	
//	
//module reg_32_bit_tb();
//reg clk, clear, RZout, RAout, RBout, RAin, RBin, RZin;
//reg [3:0] present_state;
//
//
//
//initial begin clk = 0; present_state = 4'd0; end
//always #50 clk = ~clk;
//always @ (negedge clk) present_state = present_state + 1;
//
//
//
//always @(present_state) begin
//	4'd1: begin
//		clear <= 1;
//		RZout <= 0;	RAout <= 0;	RBout <= 0;	RAin <= 0;	RBin <= 0;	RZin <= 0; 
//		#15
//		clear <= 0;
//	end
//	
//	4'd2:
//	4'd3:
//	4'd4: stop
//	
//end
//
//endmodule
//
//

