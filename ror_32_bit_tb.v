`timescale 1ns/1ps

module ror_32_bit_tb();
reg [31:0] a;
reg [4:0] numRotates;
wire [31:0] z;

ror_32_bit uut(.a(a), .numRotates(numRotates), .z(z));
initial begin
	a=32'd8; numRotates=4'd1;
	#50
	a=32'd16; numRotates=4'd2;
	#50
	a=32'd8; numRotates=4'd1;
	#50
	a=32'd32; numRotates=4'd3;
	#50
	$stop;
end
endmodule

