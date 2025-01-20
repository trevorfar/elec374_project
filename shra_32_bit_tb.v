`timescale 1ns/1ps

module shra_32_bit_tb();
reg [31:0] a, numShifts;
wire [31:0] z;

shra_32_bit uut(.a(a), .numShifts(numShifts), .z(z));
initial begin
	a=32'd8; numShifts=32'd1;
	#50
	a=32'd16; numShifts=32'd2;
	#50
	a=-32'd8; numShifts=32'd1;
	#50
	a=32'd32; numShifts=32'd3;
	#50
	$stop;
end
endmodule

