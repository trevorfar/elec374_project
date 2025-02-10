//module datapath(
//	input wire clk, clear,
//	input wire [31:0] A,
//	input wire [31:0] B,
//	input wire [31:0] RegisterAImmediate,
//	input wire [4:0] opcode, 
//	input wire RZout, RAout, RBout,
//	input wire RAin, RBin, RZin
//);
//
//	wire [31:0] BusMuxOut, BusMuxInRZ, BusMuxInRA, BusMuxInRB;
//	wire [31:0] Zregin;
//	wire cout;
//	
//	wire [31:0] r0_data_out;
//	wire [31:0] r1_data_out;
//	wire [31:0] r2_data_out;
//	wire [31:0] r3_data_out;
//	wire [31:0] r4_data_out;
//	wire [31:0] r5_data_out;
//	wire [31:0] r6_data_out;
//	wire [31:0] r7_data_out;
//	wire [31:0] r8_data_out;
//	wire [31:0] r9_data_out;
//	wire [31:0] r10_data_out;
//	wire [31:0] r11_data_out;
//	wire [31:0] r12_data_out;
//	wire [31:0] r13_data_out;
//	wire [31:0] r14_data_out;
//	wire [31:0] r15_data_out;
//	
//	reg_32_bit RA(clear, clk, RAin, RegisterAImmediate, BusMuxInRA);
//	reg_32_bit RB(clear, clk, RBin, BusMuxOut, BusMuxInRB);
//	mux_2_to_1 RY();
//	
//	
//	reg_32_bit IR();
//	reg_32_bit PC();
//	MDR_32_bit MDR(.Mdatain(), .bus_mux_out(), .clk(clk), .clear(clear), .MDRin(), .select(), .mdr_out());
//	
//	mux_32_bit bus(.R0(r0_data_out), .R1(r1_data_out), .R2(r2_data_out), .R3(r3_data_out), .R4(r4_data_out), .R5(r5_data_out), 
//						.R6(r6_data_out), .R7(r7_data_out), .R8(r8_data_out), .R9(r9_data_out), .R10(r10_data_out), .R11(r11_data_out), 
//						.R12(r12_data_out), .R13(r13_data_out), .R14(r14_data_out), .R15(r15_data_out), 
//						.HI(), .LO(), .Z_HI(), .Z_LO(), .PC(), .MDR(), .IN_PORT(), .C_sign_extended(), .select(), .BusMuxOut());
//						
//
//	alu ALU(.RA(), .RB(), .opcode(), .RZ());
//	reg_32_bit RZ(.clk(clk), .clear(clear), .enable(RZin), .BusMuxOut(Zregin), .BusMuxIn(BusMuxInRZ));
//		
//		
//endmodule 
