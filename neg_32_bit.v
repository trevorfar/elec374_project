module neg_32_bit(
	input signed [31:0] a,
	output wire signed [31:0] sum,
	output signed [31:0] z 
);
	subtractor_32_bit uut(.a(32'b0), .b(a), .cin(1'b0), .sum(sum), .cout(z));
endmodule