module datapath(
    input wire clk, clear,
    input wire [31:0] InPort_data_in,
    output wire [31:0] OutPort_data_out,
	 output wire [31:0] bus_data,
	 input [4:0] opcode,
	 output wire HI_out, LO_out,
	 input wire pc_out, ZHighout, ZLowout, mar_in, mdr_out, pc_in, 
	 mdr_in, ir_in, Yin, mdr_read, HI_in, LO_in, z_hi_in, z_lo_in, Cout, InPortout, rz_in, muxy_select,
	 input wire R0_out, R1_out, R2_out, R3_out, R4_out, R5_out,
    input wire R6_out, R7_out, R8_out, R9_out, R10_out, R11_out, R12_out, R13_out, R14_out, R15_out,
	 input wire R0_enable, R1_enable, R2_enable, R3_enable, R4_enable, R5_enable,
    input wire R6_enable, R7_enable, R8_enable, R9_enable, R10_enable, R11_enable,
    input wire R12_enable, R13_enable, R14_enable, R15_enable
	 );

	 
	 
	 reg [15:0] reg_enable; // accept data
	 reg [15:0] reg_out; // select data
	 
	 always @(*) begin
    reg_enable = {R15_enable, R14_enable, R13_enable, R12_enable, R11_enable, R10_enable, R9_enable, R8_enable,
                  R7_enable, R6_enable, R5_enable, R4_enable, R3_enable, R2_enable, R1_enable, R0_enable};
    reg_out = {R15_out, R14_out, R13_out, R12_out, R11_out, R10_out, R9_out, R8_out,
               R7_out, R6_out, R5_out, R4_out, R3_out, R2_out, R1_out, R0_out};
	 end
	 
	 wire [31:0] Mdatain, mdr_data_out;
    wire [31:0] mar_data_out, RY_immediate;
	 wire [31:0] HI_data_out;
	 wire [31:0] LO_data_out;
	 wire [31:0] ZHigh_data_out;
	 wire [31:0] ZLow_data_out;
	 wire [31:0] pc_data_out;
	 wire [31:0] ir_data_out; 
	 wire [31:0] RY_data_out;
	 wire [31:0] muxy_data_out;
	 wire [31:0] InPort_data_out;
	 wire [31:0] r0_data_out, r1_data_out, r2_data_out, r3_data_out, r4_data_out, r5_data_out;
    wire [31:0] r6_data_out, r7_data_out, r8_data_out, r9_data_out, r10_data_out, r11_data_out;
    wire [31:0] r12_data_out, r13_data_out, r14_data_out, r15_data_out;
    wire [31:0] C_sign_extended; 
	
	
	 wire [63:0] rz_data_out;
	 
	 wire [4:0] bus_select;
	
    encoder_32_to_5 bus_encoder(
        .encoder_input({{8{1'b0}}, Cout,InPortout,mdr_out,pc_out,ZLowout,ZHighout,LO_out,HI_out, 
		  reg_out[0], reg_out[1], reg_out[2], reg_out[3], reg_out[4], reg_out[5], reg_out[6], reg_out[7], 
		  reg_out[8], reg_out[9], reg_out[10], reg_out[11], reg_out[12], reg_out[13], reg_out[14], reg_out[15]}),
        .encoder_output(bus_select)
    );

    reg_32_bit r0(clear, clk, reg_enable[0], bus_data, r0_data_out); 
    reg_32_bit r1(clear, clk, reg_enable[1], bus_data, r1_data_out);
    reg_32_bit r2(clear, clk, reg_enable[2], bus_data, r2_data_out);
    reg_32_bit r3(clear, clk, reg_enable[3], bus_data, r3_data_out);
    reg_32_bit r4(clear, clk, reg_enable[4], bus_data, r4_data_out);
    reg_32_bit r5(clear, clk, reg_enable[5], bus_data, r5_data_out);
    reg_32_bit r6(clear, clk, reg_enable[6], bus_data, r6_data_out);
    reg_32_bit r7(clear, clk, reg_enable[7], bus_data, r7_data_out);
    reg_32_bit r8(clear, clk, reg_enable[8], bus_data, r8_data_out);
    reg_32_bit r9(clear, clk, reg_enable[9], bus_data, r9_data_out);
    reg_32_bit r10(clear, clk, reg_enable[10], bus_data, r10_data_out);
    reg_32_bit r11(clear, clk, reg_enable[11], bus_data, r11_data_out);
    reg_32_bit r12(clear, clk, reg_enable[12], bus_data, r12_data_out);
    reg_32_bit r13(clear, clk, reg_enable[13], bus_data, r13_data_out);
    reg_32_bit r14(clear, clk, reg_enable[14], bus_data, r14_data_out);
    reg_32_bit r15(clear, clk, reg_enable[15], bus_data, r15_data_out);

    reg_32_bit HI(clear, clk, HI_in, bus_data, HI_data_out);
    reg_32_bit LO(clear, clk, LO_in, bus_data, LO_data_out);
	 
	 z_reg RZ(ZHigh_data_out, ZLow_data_out, rz_data_out, clk, clear, rz_in);
	 
    pc_32_bit PC(clear, clk, pc_in, bus_data, pc_data_out);
    reg_32_bit MAR(clear, clk, mar_in, bus_data, mar_data_out);
    reg_32_bit RY(clear, clk, Yin, bus_data, RY_data_out);

    MDR_32_bit MDR(
        .Mdatain(Mdatain),
        .bus_mux_out(bus_data),
        .clk(clk),
        .clear(clear),
        .mdr_in(mdr_in),
        .mdr_read(mdr_read),  // mdr_read = 1 for RAM, 0 for bus
        .mdr_out(mdr_data_out)
    );

    // ALU and bus mux
     mux_2_to_1 muxy(RY_data_out, RY_immediate, muxy_select, muxy_data_out);



    mux_32_bit bus(
        .R0(r0_data_out), .R1(r1_data_out), .R2(r2_data_out), .R3(r3_data_out), .R4(r4_data_out), .R5(r5_data_out), 
        .R6(r6_data_out), .R7(r7_data_out), .R8(r8_data_out), .R9(r9_data_out), .R10(r10_data_out), .R11(r11_data_out), 
        .R12(r12_data_out), .R13(r13_data_out), .R14(r14_data_out), .R15(r15_data_out), .HI(HI_data_out), .LO(LO_data_out), 
        .Z_HI(ZHigh_out), .Z_LO(ZLow_out), .PC(pc_data_out), .MDR(mdr_data_out), .IN_PORT(InPort_data_in), 
        .C_sign_extended(C_sign_extended), .select(bus_select), .BusMuxOut(bus_data)
    );

    alu ALU(.RA(muxy_out), .RB(bus_data), .opcode(opcode), .RZ(RZ_data_out));        

endmodule