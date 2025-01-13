module subtractor_32_bit(
	input wire [31:0] a,
	input wire [31:0] b,
	input wire cin,
	output wire [31:0] sum,
	output cout
);

	wire [31:0] b_complement;	
	assign b_complement = ~b + 1;
	adder_32_bit add1(
	.a(a),
	.b(b_complement),
	.cin(cin),
	.sum(sum),
	.cout(cout)
	);
	
endmodule