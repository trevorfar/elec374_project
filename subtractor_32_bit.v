//DOES NOT WORK, DO NOT UTILIZE
module subtractor_32_bit(
	input wire signed [31:0] a,
	input wire signed [31:0] b,
	input wire cin,
	output wire signed [31:0] sum,
	output cout
);

	wire signed [31:0] b_complement;	
	assign b_complement = ~b;
	
	
	adder_32_bit add1(
	.a(a),
	.b(b_complement),
	.cin(1'b1),
	.sum(sum),
	.cout(cout)
	);
	
endmodule