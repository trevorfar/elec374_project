`include "defines.v"


module datapath(
    input wire clk, clear, stop,
	 input wire [31:0] inport_data_in,
	 output wire [31:0] bus_data,
	 output wire con_out,
	 output [15:0] reg_out, reg_in,
	 output [4:0] bus_select,
	 output reg [4:0] opcode,
	 output wire [8:0] mar_address_out,	 
	 output wire [31:0] r0_data_out, r1_data_out, r2_data_out, r3_data_out, r4_data_out, r5_data_out, r6_data_out,
	 r7_data_out, r8_data_out, r9_data_out, r10_data_out, r11_data_out, r12_data_out, r13_data_out, r14_data_out, r15_data_out, LO_data_out, inport_data_out,
	 outport_data_out, pc_data_out, ry_data_out, ram_data_out, mdr_data_out, z_high_data_out, HI_data_out, z_low_data_out, muxy_data_out,
	 ir_data_out, control_signals,
	 output wire [63:0] rz_data_out,
	 output wire [2:0] step,
	 input wire run
	 );
	 
	
	 
	 always @(*) begin
        if (control_signals[`ALU_ADD]) begin
			 opcode = `ADD;
		  end else begin
		    opcode = ir_data_out[31:27];
		  end
	end
	
	control_unit cu(.clk(clk), .clear(clear), .ir_data_out(ir_data_out), .control_signals(control_signals), .step(step), .run(run), .stop(stop));
   wire [31:0] C_sign_extended, r0_data_out_and; 
	 	
	encoder_32_to_5 bus_encoder(
	 .encoder_input({{8{1'b0}}, control_signals[`COUT],  control_signals[`INPORT_OUT], control_signals[`MDR_OUT], control_signals[`PC_OUT], 
	 control_signals[`ZLOWOUT], control_signals[`ZHIGHOUT], control_signals[`LO_OUT], control_signals[`HI_OUT], {reg_out}}),
    .encoder_output(bus_select)
	);
  

	assign r0_data_out = {32{!control_signals[`BAOUT]}} & r0_data_out_and;
	
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
   reg_32_bit HI(.clk(clk), .clear(clear), .enable(control_signals[`HI_IN]), .BusMuxOut(bus_data), .BusMuxIn(HI_data_out));
   reg_32_bit LO(.clk(clk), .clear(clear), .enable(control_signals[`LO_IN]), .BusMuxOut(bus_data), .BusMuxIn(LO_data_out));
	reg_32_bit ir(.clk(clk), .clear(clear), .enable(control_signals[`IR_IN]), .BusMuxOut(bus_data), .BusMuxIn(ir_data_out));
	
	reg_32_bit inport(.clk(clk), .clear(clear), .enable(control_signals[`INPORT_IN]), .BusMuxOut(inport_data_in), .BusMuxIn(inport_data_out));
	reg_32_bit outport(.clk(clk), .clear(clear), .enable(control_signals[`OUTPORT_IN]), .BusMuxOut(bus_data), .BusMuxIn(outport_data_out));
	 
	
	pc_32_bit PC(.clk(clk), .clear(clear), .enable(control_signals[`PC_IN]),  .immediate(bus_data), .pc(pc_data_out), .inc_pc(control_signals[`INC_PC]));
   reg_32_bit RY(.clk(clk), .clear(clear), .enable(control_signals[`YIN]), .BusMuxOut(bus_data), .BusMuxIn(ry_data_out));
	mar_32_bit MAR(.clk(clk), .clear(clear), .mar_in(control_signals[`MAR_IN]), .bus_data(bus_data), .mar_address_out(mar_address_out));
	 
	 
	 

   MDR_32_bit MDR(
       .Mdatain(ram_data_out),
       .bus_mux_out(bus_data),
       .clk(clk),
       .clear(clear),
       .mdr_in(control_signals[`MDR_IN]),
       .mdr_read(control_signals[`MDR_READ]),  // mdr_read = 1 for RAM, 0 for bus
       .mdr_data_out(mdr_data_out)
    );

    // ALU and bus mux
    mux_2_to_1 muxy(.input0(ry_data_out), .input1(C_sign_extended), .select(control_signals[`MUXY_SELECT]), .mux_output(muxy_data_out));
	 
    mux_32_bit bus(
        .R0(r0_data_out), .R1(r1_data_out), .R2(r2_data_out), .R3(r3_data_out), .R4(r4_data_out), .R5(r5_data_out), 
        .R6(r6_data_out), .R7(r7_data_out), .R8(r8_data_out), .R9(r9_data_out), .R10(r10_data_out), .R11(r11_data_out), 
        .R12(r12_data_out), .R13(r13_data_out), .R14(r14_data_out), .R15(r15_data_out), .HI(HI_data_out), .LO(LO_data_out), 
        .Z_HI(z_high_data_out), .Z_LO(z_low_data_out), .PC(pc_data_out), .MDR(mdr_data_out), .IN_PORT(inport_data_out), 
        .C_sign_extended(C_sign_extended), .select(bus_select), .BusMuxOut(bus_data)
    );
	 
	 memram ram(.address(mar_address_out), .clock(clk), .data(mdr_data_out), .wren(control_signals[`WREN]), .q(ram_data_out));
	 
	 select_and_encode sel_and_enc(.Gra(control_signals[`GRA]), .Grb(control_signals[`GRB]), .Grc(control_signals[`GRC]), .Rin(control_signals[`RIN]), 
	 .Rout(control_signals[`ROUT]), .BAout(control_signals[`BAOUT]), .instruction(ir_data_out),
	 .reg_in(reg_in), .reg_out(reg_out), .C_sign_extended(C_sign_extended));
	 
    alu ALU(.RA(muxy_data_out), .RB(bus_data), .opcode(opcode), .RZ(rz_data_out), .RY(ry_data_out), .con_out(con_out));
	 
	 z_reg RZ(.z_high_data_out(z_high_data_out), .z_low_data_out(z_low_data_out),
				 .Zdatain(rz_data_out), .clk(clk), .clear(clear), .rz_in(control_signals[`RZ_IN]));
	 
	 
	 CON_FF conff(.bus_data(bus_data), .ir_input(ir_data_out[20:19]), .clk(clk), .con_in(control_signals[`CON_IN]), .con_out(con_out));

endmodule
