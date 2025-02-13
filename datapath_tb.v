`timescale 1ns/1ps

module datapath_tb();

module datapath(
	input wire clk, clear,
	input wire [4:0] opcode, 
	output [31:0] bus_data

);

reg [4:0] opcode;
reg [31:0] bus_data;

reg cout, Z_enable, HI_enable, LO_enable, IR_enable, PC_enable, MAR_enable, muxy_select, RY_enable, mdr_in, mdr_select, clk, clear;


datapath DP(.clk(clk), .clear(clear), .opcode(opcode), .bus_data(bus_data));


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