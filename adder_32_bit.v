module adder_32_bit(
	input [31:0] a,
	input [31:0] b,
	input cin,
	output [31:0] sum,
	output cout
);

wire cout1, cout2, cout3, cout4, cout5, cout6, cout7;

four_bit_cla cla0(.a(a[3:0]), .b(b[3:0]), .cin(cin), .sum(sum[3:0]), .cout(cout1));
four_bit_cla cla1(.a(a[7:4]), .b(b[7:4]), .cin(cout1), .sum(sum[7:4]), .cout(cout2));
four_bit_cla cla2(.a(a[11:8]), .b(b[11:8]), .cin(cout2), .sum(sum[11:8]), .cout(cout3));
four_bit_cla cla3(.a(a[15:12]), .b(b[15:12]), .cin(cout3), .sum(sum[15:12]), .cout(cout4));
four_bit_cla cla4(.a(a[19:16]), .b(b[19:16]), .cin(cout4), .sum(sum[19:16]), .cout(cout5));
four_bit_cla cla5(.a(a[23:20]), .b(b[23:20]), .cin(cout5), .sum(sum[23:20]), .cout(cout6));
four_bit_cla cla6(.a(a[27:24]), .b(b[27:24]), .cin(cout6), .sum(sum[27:24]), .cout(cout7));
four_bit_cla cla7(.a(a[31:28]), .b(b[31:28]), .cin(cout7), .sum(sum[31:28]), .cout(cout));

endmodule


module four_bit_cla(
	input [3:0] a,
	input [3:0] b,
	input cin,
	output [3:0] sum,
	output cout
);

wire [3:0] g, p;
wire [3:0] c;

assign g = a & b;
assign p = a ^ b;

assign c[0] = cin;
assign c[1] = g[0] | (p[0] & c[0]);
assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
assign cout = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c[0]);
assign sum [3:0] = p ^ c;

endmodule