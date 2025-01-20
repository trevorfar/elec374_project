`timescale 1ns/1ps

module ror_32_bit_tb();
reg [31:0] a;
reg [4:0] numRotates;
wire [31:0] z;

ror_32_bit uut(.a(a), .numRotates(numRotates), .z(z));
initial begin
	a=32'b0000_0000_0000_0000_0000_0000_1111; numRotates=4'b0100;
	#50
	a=32'b0000_0000_0000_0000_0000_0000_0100; numRotates=4'b0011;
	#50
//	a=32'b8; numRotates=4'd1;
//	#50
//	a=32'b32; numRotates=4'd3;
//	#50
	$stop;
end
endmodule

