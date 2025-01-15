module datapath(
	input wire clk, clear,
	input wire [31:0] A,
	input wire [31:0] RegisterAImmediate,
	input wire RZout, RAout, RBout,
	input wire RAin, RBin, RZin
);

	wire [31:0] BusMuxOut, BusMuxInRZ, BusMuxInRA, BusMuxInRB;
	wire [31:0] Zregin;
	wire cout;
	wire cin;
	assign cin = 0;
	reg_32_bit RA(clear, clk, RAin, RegisterAImmediate, BusMuxInRA);
	reg_32_bit RB(clear, clk, RBin, BusMuxOUt, BusMuxInRB);
	
	adder_32_bit adder1(
	.a(A),
	.b(BusMuxOut),
	.cin(cin),
	.sum(Zregin),
	.cout(cout)
	);
	
	reg_32_bit RZ(clear, clk, RZin, Zregin, BusMuxInRZ);
	bus Bus(BusMuxInRZ, BusMuxInRA, BusMuxInRB, RZout, RAout, RBout, BusMuxOut);
	
endmodule