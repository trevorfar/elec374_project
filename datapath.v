module datapath(
    input wire clk, clear,
    input wire [31:0] InPort_data_in,
    output wire [31:0] OutPort_data_out,
	 output wire [31:0] bus_data,
	 );

	 wire pc_out, ZHighout, ZLowout, HI_out, LO_out, mar_in, mdr_out, pc_in, 
	 mdr_in, ir_in, Yin, mdr_read, HI_in, LO_in, z_hi_in, z_lo_in, Cout, InPortout, rz_in,
	 
	 reg [15:0] reg_enable; // accept data
	 reg [15:0] reg_out; // select data
	 
	 wire [31:0] Mdatain, mdr_data_out;
    wire [31:0] mar_data_out;
	 wire [31:0] HI_data_out;
	 wire [31:0] LO_data_out;
	 wire [31:0] ZHigh_data_out;
	 wire [31:0] ZLow_data_out;
	 wire [31:0] pc_data_out;
	 wire [31:0] ir_data_out; 
	 wire [31:0] ry_data_out;
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

    reg_32_bit HI(clear, clk, HI_in, bus_data, HI_out);
    reg_32_bit LO(clear, clk, LO_in, bus_data, LO_out);
	 
	 z_reg RZ(ZHigh_data_out, ZLow_data_out, rz_data_out, clk, clr, rz_in);
	 
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
     mux_2_to_1 muxy(RY_data_out, RY_immediate, muxy_select, muxy_out);



    mux_32_bit bus(
        .R0(r0_data_out), .R1(r1_data_out), .R2(r2_data_out), .R3(r3_data_out), .R4(r4_data_out), .R5(r5_data_out), 
        .R6(r6_data_out), .R7(r7_data_out), .R8(r8_data_out), .R9(r9_data_out), .R10(r10_data_out), .R11(r11_data_out), 
        .R12(r12_data_out), .R13(r13_data_out), .R14(r14_data_out), .R15(r15_data_out), .HI(HI_out), .LO(LO_out), 
        .Z_HI(ZHigh_out), .Z_LO(ZLow_out), .PC(pc_data_out), .MDR(mdr_data_out), .IN_PORT(InPort_data_in), 
        .C_sign_extended(C_sign_extended), .select(bus_select), .BusMuxOut(bus_data)
    );

    alu ALU(.RA(muxy_out), .RB(bus_data), .opcode(opcode), .RZ(RZ_data_out));        

endmodule