`timescale 1ns/10ps

module datapath_tb();

reg clk, clear, RZout, RAout, RBout, RAin, RBin, RZin;
reg [31:0] AddImmediate;
reg [31:0] RegisterAImmediate;
reg [3:0] present_state;

datapath DP(
	clk, clear,
	AddImmediate, 
	RegisterAImmediate,
	RZout, RAout, RBout,
	RAin, RBin, RZin
);

parameter init = 4'd1, T0 = 4'd2, T1 = 4'd3, T2 = 4'd4;

initial begin clk = 0; present_state = 4'd0; end
always #10 clk = ~clk;
always @ (negedge clk) present_state = present_state + 1;

always @(present_state) begin
	case(present_state)
		init: begin
			clear <= 1;
			AddImmediate <= 32'h00; RegisterAImmediate <= 32'h00;
			RZout <= 0;	RAout <= 0;	RBout <= 0;	RAin <= 0;	RBin <= 0;	RZin <= 0; 
			#15 clear <= 0;
		end
		
		T0: begin
			RegisterAImmediate <= 32'h5; RAin <= 1;
			#15 RegisterAImmediate <= 32'h00; RAin <= 0;
		end
		
		T1: begin
			RAout <= 1; AddImmediate <= 32'h5; RZin <= 1;
			#15 RAout <= 0; RZin <= 0;
		end
		
		T2: begin
			RZout <= 1; RBin <= 1;
			#15 RZout <= 0; RBin <= 0;
		end
	endcase
end
endmodule