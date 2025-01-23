module shl_32_bit(
	input wire [31:0] data_in,
	input wire [31:0] shifts,
	output wire [31:0] data_out
);

assign data_out[31:0] = data_in << shifts;

endmodule