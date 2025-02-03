module shl_32_bit(
	input wire [31:0] a,
	input wire [31:0] shifts,
	output wire [31:0] z
);

assign z[31:0] = a << shifts;

endmodule
