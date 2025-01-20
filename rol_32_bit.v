module rol_32_bit(
	input [31:0] a, 
	input [4:0] numRotates,
	output [31:0] z
);

    assign z = (a << numRotates) | (a >> (32 - numRotates));
endmodule

