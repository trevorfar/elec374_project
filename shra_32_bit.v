module shra_32_bit(
	input signed [31:0] a,
	input [31:0] shifts,
	output signed [31:0] z
);
	assign z = $signed(a) >>> shifts;

endmodule