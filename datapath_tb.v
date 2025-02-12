`timescale 1ns/1ps

module datapath_tb();
//
//reg clk, clear, RZout, RAout, RBout, RAin, RBin, RZin;
//reg [31:0] AddImmediate;
//reg [31:0] RegisterAImmediate;
//reg [3:0] present_state;
//
//datapath DP(
//	clk, clear,
//	AddImmediate, 
//	RegisterAImmediate,
//	RZout, RAout, RBout,
//	RAin, RBin, RZin
//);

reg clk;
initial begin clk = 0;
forever #10 clk = ~clk;
end

initial begin
	#50;
	#50;
	#50;
	#50;
	#50;
	#50;
	#50;
	#50;
	#50;
	#50;
	$stop;
end
endmodule