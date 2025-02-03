module neg_32_bit(
	input wire signed [31:0] a,
	output signed [31:0] z 
);

	assign z = ~a + 1;

endmodule
