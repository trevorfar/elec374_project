module neg_32_bit(
	input wire signed [31:0] a,
	output signed [31:0] z 
);
	wire cout;
	wire [31:0] not_out;
	
	not_32_bit NOT(.a(a), .z(not_out));
	adder_32_bit ADD(.a(not_out), .b(32'b0), .cin(1'b1), .sum(z), .cout(cout));
	


endmodule
