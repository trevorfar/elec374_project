module datapath(
	input wire clk, clear,
	input wire [31:0] A,
	input wire [31:0] B,

	input wire [31:0] RegisterAImmediate,
	input wire RZout, RAout, RBout,
	input wire RAin, RBin, RZin
);

	wire [31:0] BusMuxOut, BusMuxInRZ, BusMuxInRA, BusMuxInRB;
	wire [31:0] Zregin;
	wire cout;
	reg_32_bit RA(clear, clk, RAin, RegisterAImmediate, BusMuxInRA);
	reg_32_bit RB(clear, clk, RBin, BusMuxOut, BusMuxInRB);
	
	
	adder_32_bit adder1(
	.a(A),
	.b(BusMuxOut),
	.cin(1'b0),
	.sum(Zregin),
	.cout(cout)
	);
	
	mux_32_bit bus();

	reg_32_bit RZ(.clk(clk), .clear(clear), .enable(RZin), .BusMuxOut(Zregin), .BusMuxIn(BusMuxInRZ));
	



	
endmodule
