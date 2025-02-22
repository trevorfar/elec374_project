module datapath(
    input wire clk, clear,
	
    input wire [31:0] InPort_data_in,
    output wire [31:0] OutPort_data_out,
	 output wire [31:0] bus_data,
	 input [4:0] opcode,
	 input wire HI_out, LO_out,
	 input wire pc_out, ZHighout, ZLowout, mar_in, mdr_out, pc_in, mdr_in, ir_in, Yin, mdr_read, 
	 HI_in, LO_in, z_hi_in, z_lo_in, Cout, InPortout, rz_in, muxy_select,
	 input wire [15:0] reg_out,
	 input wire [15:0] reg_in,
	 output wire [31:0] R3_data_out, R4_data_out, R7_data_out, z_high_data_out, z_low_data_out, 
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
	
	 wire [63:0] rz_data_out;
	 	
    encoder_32_to_5 bus_encoder(
        .encoder_input({{8{1'b0}}, Cout,InPortout,mdr_out,pc_out,ZLowout,ZHighout,LO_out,HI_out, {reg_out}}),
        .encoder_output(bus_select)
    );

	reg_32_bit r0(.clk(clk), .clear(clear), .enable(reg_in[0]), .BusMuxOut(bus_data), .BusMuxIn(r0_data_out)); 
   reg_32_bit r1(.clk(clk), .clear(clear), .enable(reg_in[1]), .BusMuxOut(bus_data), .BusMuxIn(r1_data_out));
   reg_32_bit r2(.clk(clk), .clear(clear), .enable(reg_in[2]), .BusMuxOut(bus_data), .BusMuxIn(r2_data_out));
   reg_32_bit r3(.clk(clk), .clear(clear), .enable(reg_in[3]), .BusMuxOut(bus_data), .BusMuxIn(r3_data_out));
   reg_32_bit r4(.clk(clk), .clear(clear), .enable(reg_in[4]), .BusMuxOut(bus_data), .BusMuxIn(r4_data_out));
   reg_32_bit r5(.clk(clk), .clear(clear), .enable(reg_in[5]), .BusMuxOut(bus_data), .BusMuxIn(r5_data_out));
   reg_32_bit r6(.clk(clk), .clear(clear), .enable(reg_in[6]), .BusMuxOut(bus_data), .BusMuxIn(r6_data_out));
   reg_32_bit r7(.clk(clk), .clear(clear), .enable(reg_in[7]), .BusMuxOut(bus_data), .BusMuxIn(r7_data_out));
   reg_32_bit r8(.clk(clk), .clear(clear), .enable(reg_in[8]), .BusMuxOut(bus_data), .BusMuxIn(r8_data_out));
   reg_32_bit r9(.clk(clk), .clear(clear), .enable(reg_in[9]), .BusMuxOut(bus_data), .BusMuxIn(r9_data_out));
   reg_32_bit r10(.clk(clk), .clear(clear), .enable(reg_in[10]), .BusMuxOut(bus_data), .BusMuxIn(r10_data_out));
   reg_32_bit r11(.clk(clk), .clear(clear), .enable(reg_in[11]), .BusMuxOut(bus_data), .BusMuxIn(r11_data_out));
   reg_32_bit r12(.clk(clk), .clear(clear), .enable(reg_in[12]), .BusMuxOut(bus_data), .BusMuxIn(r12_data_out));
   reg_32_bit r13(.clk(clk), .clear(clear), .enable(reg_in[13]), .BusMuxOut(bus_data), .BusMuxIn(r13_data_out));
   reg_32_bit r14(.clk(clk), .clear(clear), .enable(reg_in[14]), .BusMuxOut(bus_data), .BusMuxIn(r14_data_out));
   reg_32_bit r15(.clk(clk), .clear(clear), .enable(reg_in[15]), .BusMuxOut(bus_data), .BusMuxIn(r15_data_out));
   reg_32_bit HI(.clk(clk), .clear(clear), .enable(HI_in), .BusMuxOut(bus_data), .BusMuxIn(HI_data_out));
   reg_32_bit LO(.clk(clk), .clear(clear), .enable(LO_in), .BusMuxOut(bus_data), .BusMuxIn(LO_data_out));
	 
	 
	
	 pc_32_bit PC(.clk(clk), .clear(clear), .enable(pc_in), .immediate(bus_data), .pc(pc_data_out));
	 reg_32_bit MAR(.clk(clk), .clear(clear), .enable(mar_in), .BusMuxOut(bus_data), .BusMuxIn(mar_data_otu));
	 reg_32_bit RY(.clk(clk), .clear(clear), .enable(Yin), .BusMuxOut(bus_data), .BusMuxIn(RY_data_out));
	 
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
     mux_2_to_1 muxy(.input0(RY_data_out), .input1(RY_immediate), .select(muxy_select), .mux_output(muxy_data_out));
	 
	 
    mux_32_bit bus(
        .R0(r0_data_out), .R1(r1_data_out), .R2(r2_data_out), .R3(r3_data_out), .R4(r4_data_out), .R5(r5_data_out), 
        .R6(r6_data_out), .R7(r7_data_out), .R8(r8_data_out), .R9(r9_data_out), .R10(r10_data_out), .R11(r11_data_out), 
        .R12(r12_data_out), .R13(r13_data_out), .R14(r14_data_out), .R15(r15_data_out), .HI(HI_data_out), .LO(LO_data_out), 
        .Z_HI(ZHigh_data_out), .Z_LO(ZLow_data_out), .PC(pc_data_out), .MDR(mdr_data_out), .IN_PORT(InPort_data_in), 
        .C_sign_extended(C_sign_extended), .select(bus_select), .BusMuxOut(bus_data)
    );

    alu ALU(.RA(muxy_data_out), .RB(bus_data), .opcode(opcode), .RZ(rz_data_out)); 
	 
	  z_reg RZ(.z_high_data_out(ZHigh_data_out), .z_low_data_out(ZLow_data_out),
	 .Zdatain(rz_data_out), .clk(clk), .clear(clear), .rz_in(rz_in));
	assign R3_data_out = r3_data_out;
	assign R4_data_out = r4_data_out;
	assign R7_data_out = r7_data_out;
	assign z_high_data_out = ZHigh_data_out;
	assign z_low_data_out = ZLow_data_out;
	assign MDR_data_out = mdr_data_out;	 
	
	 


endmodule
