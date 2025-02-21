module datapath(
    input wire clk, clear,
	
    input wire [31:0] InPort_data_in,
    output wire [31:0] OutPort_data_out,
	 output wire [31:0] bus_data,
	 input [4:0] opcode,
	 input wire HI_out, LO_out,
	 input wire pc_out, ZHighout, ZLowout, mar_in, mdr_out, pc_in, mdr_in, ir_in, Yin, mdr_read, HI_in, LO_in, z_hi_in, z_lo_in, Cout, InPortout, rz_in, muxy_select,
	 input wire [15:0] reg_out,
	 input wire [15:0] reg_in,
	 output wire [31:0] R3_data_out, R4_data_out, R7_data_out, 
	 output [4:0] bus_select,
	 output wire [31:0] MDR_data_out,
	 input wire [31:0] Mdatain
	 );

	 wire [31:0] mdr_data_out;
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
	
	//JUST FOR TB
	// I THINK REG IN IS MESSED UP ? SHOULD EB SELECTING 3rd but its on 2 I THINKY POO <3

	 wire [63:0] rz_data_out;
	 	
    encoder_32_to_5 bus_encoder(
        .encoder_input({{8{1'b0}}, Cout,InPortout,mdr_out,pc_out,ZLowout,ZHighout,LO_out,HI_out, {reg_out}}),
        .encoder_output(bus_select)
    );
wire [31:0] encoder_input_debug = {{8{1'b0}}, Cout, InPortout, mdr_out, pc_out, ZLowout, ZHighout, LO_out, HI_out, {reg_out}};

    reg_32_bit r0(clear, clk, reg_in[0], bus_data, r0_data_out); 
    reg_32_bit r1(clear, clk, reg_in[1], bus_data, r1_data_out);
    reg_32_bit r2(clear, clk, reg_in[2], bus_data, r2_data_out);
    reg_32_bit r3(clear, clk, reg_in[3], bus_data, r3_data_out);
    reg_32_bit r4(clear, clk, reg_in[4], bus_data, r4_data_out);
    reg_32_bit r5(clear, clk, reg_in[5], bus_data, r5_data_out);
    reg_32_bit r6(clear, clk, reg_in[6], bus_data, r6_data_out);
    reg_32_bit r7(clear, clk, reg_in[7], bus_data, r7_data_out);
    reg_32_bit r8(clear, clk, reg_in[8], bus_data, r8_data_out);
    reg_32_bit r9(clear, clk, reg_in[9], bus_data, r9_data_out);
    reg_32_bit r10(clear, clk, reg_in[10], bus_data, r10_data_out);
    reg_32_bit r11(clear, clk, reg_in[11], bus_data, r11_data_out);
    reg_32_bit r12(clear, clk, reg_in[12], bus_data, r12_data_out);
    reg_32_bit r13(clear, clk, reg_in[13], bus_data, r13_data_out);
    reg_32_bit r14(clear, clk, reg_in[14], bus_data, r14_data_out);
    reg_32_bit r15(clear, clk, reg_in[15], bus_data, r15_data_out);

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
        .mdr_data_out(mdr_data_out)
    );

    // ALU and bus mux
     mux_2_to_1 muxy(RY_data_out, RY_immediate, muxy_select, muxy_data_out);



    mux_32_bit bus(
        .R0(r0_data_out), .R1(r1_data_out), .R2(r2_data_out), .R3(r3_data_out), .R4(r4_data_out), .R5(r5_data_out), 
        .R6(r6_data_out), .R7(r7_data_out), .R8(r8_data_out), .R9(r9_data_out), .R10(r10_data_out), .R11(r11_data_out), 
        .R12(r12_data_out), .R13(r13_data_out), .R14(r14_data_out), .R15(r15_data_out), .HI(HI_data_out), .LO(LO_data_out), 
        .Z_HI(ZHigh_data_out), .Z_LO(ZLow_data_out), .PC(pc_data_out), .MDR(mdr_data_out), .IN_PORT(InPort_data_in), 
        .C_sign_extended(C_sign_extended), .select(bus_select), .BusMuxOut(bus_data)
    );

    alu ALU(.RA(muxy_out), .RB(bus_data), .opcode(opcode), .RZ(RZ_data_out));  
	assign R3_data_out = r3_data_out;
	assign R4_data_out = r4_data_out;
	assign R7_data_out = r7_data_out;
	assign MDR_data_out = mdr_data_out;	 
	
	 


endmodule
