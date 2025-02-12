module datapath(
	input wire clk, clear,
	input wire [4:0] opcode, 
	output [31:0] bus_data

);
	
	wire [31:0] mar_out;
	wire [31:0] mdr_out;
	wire cout, Z_enable, HI_enable, LO_enable, IR_enable, PC_enable, MAR_enable, muxy_select, RY_enable, mdr_in, mdr_select;

	wire [4:0] select;
	
	wire [31:0] InPort_data_in, RY_out, muxy_out, m_data_in;
	wire [31:0] OutPort_data_in;
	
	wire [31:0] InPort_data_out;
	wire [31:0] OutPort_data_out;

	wire [31:0] HI_out;
	wire [31:0] LO_out;
	wire [31:0] C_sign_extended;
	
	wire [31:0] r0_data_out;
	wire [31:0] r1_data_out;
	wire [31:0] r2_data_out;
	wire [31:0] r3_data_out;
	wire [31:0] r4_data_out;
	wire [31:0] r5_data_out;
	wire [31:0] r6_data_out;
	wire [31:0] r7_data_out;
	wire [31:0] r8_data_out;
	wire [31:0] r9_data_out;
	wire [31:0] r10_data_out;
	wire [31:0] r11_data_out;
	wire [31:0] r12_data_out;
	wire [31:0] r13_data_out;
	wire [31:0] r14_data_out;
	wire [31:0] r15_data_out;
	wire [31:0] mar_data_out;
	wire [31:0] ir_data_out;
	wire [31:0] pc_data_out;
	
	wire [15:0] enable;
	
	reg_32_bit r0(clear, clk, enable[0], bus_data, r0_data_out); 
	reg_32_bit r1(clear, clk, enable[1], bus_data, r1_data_out);
	reg_32_bit r2(clear, clk, enable[2], bus_data, r2_data_out);
	reg_32_bit r3(clear, clk, enable[3], bus_data, r3_data_out);
	reg_32_bit r4(clear, clk, enable[4], bus_data, r4_data_out);
	reg_32_bit r5(clear, clk, enable[5], bus_data, r5_data_out);
	reg_32_bit r6(clear, clk, enable[6], bus_data, r6_data_out);
	reg_32_bit r7(clear, clk, enable[7], bus_data, r7_data_out);
	reg_32_bit r8(clear, clk, enable[8], bus_data, r8_data_out);
	reg_32_bit r9(clear, clk, enable[9], bus_data, r9_data_out);
	reg_32_bit r10(clear, clk, enable[10], bus_data, r10_data_out);
	reg_32_bit r11(clear, clk, enable[11], bus_data, r11_data_out);
	reg_32_bit r12(clear, clk, enable[12], bus_data, r12_data_out);
	reg_32_bit r13(clear, clk, enable[13], bus_data, r13_data_out);
	reg_32_bit r14(clear, clk, enable[14], bus_data, r14_data_out);
	reg_32_bit r15(clear, clk, enable[15], bus_data, r15_data_out);
	
	wire [63:0] RZ_data_in, RZ_data_out;
	
	
	reg_64_bit RZ(clear, clk, Z_enable, RZ_data_in, RZ_data_out);
	
	reg_32_bit HI(clear, clk, HI_enable, bus_data, HI_out);
	reg_32_bit LO(clear, clk, LO_enable, bus_data, LO_out);	
	
	reg_32_bit IR(clear, clk, IR_enable, bus_data, ir_data_out);
	pc_32_bit PC(clear, clk, PC_enable, bus_data, pc_data_out);
	reg_32_bit MAR(clear, clk, MAR_enable, bus_data, mar_data_out);
	
	reg_32_bit RY(clear, clk, RY_enable, bus_data, RY_out); 

	mux_2_to_1 muxy(RY_out, RY_immediate, muxy_select, muxy_out);
	
	
	MDR_32_bit MDR(.Mdatain(m_data_in), .bus_mux_out(bus_data), .clk(clk), .clear(clear), .MDRin(mdr_in), .select(mdr_select), .mdr_out(mdr_out));
	
	mux_32_bit bus(.R0(r0_data_out), .R1(r1_data_out), .R2(r2_data_out), .R3(r3_data_out), .R4(r4_data_out), .R5(r5_data_out), 
						.R6(r6_data_out), .R7(r7_data_out), .R8(r8_data_out), .R9(r9_data_out), .R10(r10_data_out), .R11(r11_data_out), 
						.R12(r12_data_out), .R13(r13_data_out), .R14(r14_data_out), .R15(r15_data_out), .HI(HI_out), .LO(LO_out), .Z_HI(RZ_data_out[63:32]), 
						.Z_LO(RZ_data_out[31:0]), .PC(pc_data_out), .MDR(mdr_out), .IN_PORT(InPort_data_in), .C_sign_extended(C_sign_extended), .select(select),
						.BusMuxOut(bus_data));
	
	alu ALU(.RA(muxy_out), .RB(bus_data), .opcode(opcode), .RZ(RZ_data_in));		
		
endmodule 
