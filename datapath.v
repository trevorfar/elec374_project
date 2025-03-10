module datapath(
    input wire clk, clear,
	
    input wire [31:0] inport_data_in,
	 output wire [31:0] inport_data_out,
    output wire [31:0] outport_data_out,
	 output wire [31:0] bus_data, ram_data_out, HI_data_out, LO_data_out, ir_data_out, mdr_data_out, pc_data_out, r1_data_out, r3_data_out, r4_data_out, r5_data_out, r6_data_out, r8_data_out, r2_data_out, z_low_data_out, z_high_data_out,
	 input wire HI_out, LO_out, inc_pc, wren,
	 input wire pc_out, ZHighout, ZLowout, mar_in, mdr_out, pc_in, inport_in, outport_in, mdr_in, ir_in, Yin, mdr_read, Gra, Grb, Grc,
	 HI_in, LO_in, Cout, inport_out, rz_in, muxy_select, BAout, Rin, Rout, con_in,
	 output wire con_out,
	 output [4:0] bus_select,
	 output wire [8:0] mar_address_out,
	 output [15:0] reg_out, reg_in,
	 output wire [63:0] rz_data_out
	 input wire [31:0] control_signals;
	 );
	 
	 

	 input wire [31:0] control_signals;
	 reg [4:0] opcode;
	 
	 always @(*) begin
		 if (control_signals[`ALU_ADD]) begin
			  opcode = `ADD;  
		 end else begin
				opcode = ir_data_out[31:27];
		 end
	end
	
	control_unit cu(.clk(clk), .clear(clear), .ir_data_out(ir_data_out), .control_signals(control_signals));
 
	 //wire [31:0] HI_data_out, 
	 //wire [31:0] LO_data_out;
//	 wire [31:0] z_high_data_out;
//	 wire [31:0] z_low_data_out;
	 wire [31:0] ry_data_out;
	 wire [31:0] muxy_data_out, RY_immediate;
	 wire [31:0] r0_data_out; //, r1_data_out;
    wire [31:0] r7_data_out, r9_data_out, r10_data_out, r11_data_out;
    wire [31:0] r12_data_out, r13_data_out, r14_data_out, r15_data_out; //r4_data_out, r6_data_out, r2_data_out;
    wire [31:0] C_sign_extended, r0_data_out_and; 
	 	
    encoder_32_to_5 bus_encoder(
        .encoder_input({{8{1'b0}}, Cout,inport_out,mdr_out,pc_out,ZLowout,ZHighout,LO_out,HI_out, {reg_out}}),
        .encoder_output(bus_select)
    );

	assign r0_data_out = {32{!BAout}} & r0_data_out_and;
	
	reg_32_bit r0(.clk(clk), .clear(clear), .enable(reg_in[0]), .BusMuxOut(bus_data), .BusMuxIn(r0_data_out_and)); 
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
	reg_32_bit ir(.clk(clk), .clear(clear), .enable(ir_in), .BusMuxOut(bus_data), .BusMuxIn(ir_data_out));
	
	reg_32_bit inport(.clk(clk), .clear(clear), .enable(inport_in), .BusMuxOut(inport_data_in), .BusMuxIn(inport_data_out));
	reg_32_bit outport(.clk(clk), .clear(clear), .enable(outport_in), .BusMuxOut(bus_data), .BusMuxIn(outport_data_out));
	 
	
	pc_32_bit PC(.clk(clk), .clear(clear), .enable(pc_in), .immediate(bus_data), .pc(pc_data_out), .inc_pc(inc_pc));
   reg_32_bit RY(.clk(clk), .clear(clear), .enable(Yin), .BusMuxOut(bus_data), .BusMuxIn(ry_data_out));
	mar_32_bit MAR(.clk(clk), .clear(clear), .mar_in(mar_in), .bus_data(bus_data), .mar_address_out(mar_address_out));
	 
	 
	 

   MDR_32_bit MDR(
       .Mdatain(ram_data_out),
       .bus_mux_out(bus_data),
       .clk(clk),
       .clear(clear),
       .mdr_in(mdr_in),
       .mdr_read(mdr_read),  // mdr_read = 1 for RAM, 0 for bus
       .mdr_data_out(mdr_data_out)
    );

    // ALU and bus mux
    mux_2_to_1 muxy(.input0(ry_data_out), .input1(RY_immediate), .select(muxy_select), .mux_output(muxy_data_out));
	 
    mux_32_bit bus(
        .R0(r0_data_out), .R1(r1_data_out), .R2(r2_data_out), .R3(r3_data_out), .R4(r4_data_out), .R5(r5_data_out), 
        .R6(r6_data_out), .R7(r7_data_out), .R8(r8_data_out), .R9(r9_data_out), .R10(r10_data_out), .R11(r11_data_out), 
        .R12(r12_data_out), .R13(r13_data_out), .R14(r14_data_out), .R15(r15_data_out), .HI(HI_data_out), .LO(LO_data_out), 
        .Z_HI(z_high_data_out), .Z_LO(z_low_data_out), .PC(pc_data_out), .MDR(mdr_data_out), .IN_PORT(inport_data_out), 
        .C_sign_extended(C_sign_extended), .select(bus_select), .BusMuxOut(bus_data)
    );
	 
	 memram ram(.address(mar_address_out), .clock(clk), .data(mdr_data_out), .wren(wren), .q(ram_data_out));
	 
	 select_and_encode sel_and_enc(.Gra(Gra), .Grb(Grb), .Grc(Grc), .Rin(Rin), .Rout(Rout), .BAout(BAout), .instruction(ir_data_out),
	 .reg_in(reg_in), .reg_out(reg_out), .C_sign_extended(C_sign_extended));
	 
    alu ALU(.RA(muxy_data_out), .RB(bus_data), .opcode(opcode), .RZ(rz_data_out), .RY(ry_data_out)); 
	 
	  z_reg RZ(.z_high_data_out(z_high_data_out), .z_low_data_out(z_low_data_out),
	 .Zdatain(rz_data_out), .clk(clk), .clear(clear), .rz_in(rz_in));
	 
	 CON_FF conff(.bus_data(bus_data), .ir_input(ir_data_out[20:19]), .clk(clk), .con_in(con_in), .con_out(con_out));

endmodule
