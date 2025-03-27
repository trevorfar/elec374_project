`timescale 1ns / 1ps

module DataPath (
    input wire clk, clear, read,
    input wire [4:0] opcode,
    input wire [7:0] pc_offset,
    input wire set_pc_flag,

    input wire HIin, LOin, MARin, MDRin, Yin, Zin, PCin, IRin,
    input wire HIout, LOout, MARout, MDRout, PCout, Cout, Inout, Outout,
    input wire IncPC, wren, muxSignal, zhighout, zlowout,
    input wire Gra, Grb, Grc, Rin, Rout, BAout, inport_in, outport_in,
    input wire con_in,

    output wire [31:0] BusLine,
    output wire [31:0] R0_data, R1_data, R2_data, R3_data, R4_data,
    output wire [31:0] R5_data, R6_data, R7_data, R8_data, R9_data,
    output wire [31:0] R10_data, R11_data, R12_data, R13_data, R14_data,
    output wire [31:0] R15_data, HI_data, LO_data, MDR_data,
    output wire [31:0] Y_data, PC_data, IR_data, Ram_data, C_data, z_high_data_out, z_low_data_out,
    output wire [31:0] InPort_data, OutUnit, YLine,
    output wire [4:0] select_signals,
    output wire [63:0] ZLine,
    output wire [15:0] Result_in, Result_out,
    output wire [8:0] MAR_address,
    output wire con_out
);

    select_and_encoder sel_enc(
        .instruction(IR_data),
        .Gra(Gra), .Grb(Grb), .Grc(Grc), .Rin(Rin), .Rout(Rout), .BAout(BAout),
        .Result_in(Result_in), .Result_out(Result_out), .c_sign_extended(C_data)
    );

	 wire [31:0] r0_data_out_and;
	 assign R0_data = {32{!BAout}} & r0_data_out_and;
    // Register file (R0-R15)
    register R0 (clear, clk, Result_in[0], BusLine, r0_data_out_and);
    register R1 (clear, clk, Result_in[1], BusLine, R1_data);
    register R2 (clear, clk, Result_in[2], BusLine, R2_data);
    register R3 (clear, clk, Result_in[3], BusLine, R3_data);
    register R4 (clear, clk, Result_in[4], BusLine, R4_data);
    register R5 (clear, clk, Result_in[5], BusLine, R5_data);
    register R6 (clear, clk, Result_in[6], BusLine, R6_data);
    register R7 (clear, clk, Result_in[7], BusLine, R7_data);
    register R8 (clear, clk, Result_in[8], BusLine, R8_data);
    register R9 (clear, clk, Result_in[9], BusLine, R9_data);
    register R10 (clear, clk, Result_in[10], BusLine, R10_data);
    register R11 (clear, clk, Result_in[11], BusLine, R11_data);
    register R12 (clear, clk, Result_in[12], BusLine, R12_data);
    register R13 (clear, clk, Result_in[13], BusLine, R13_data);
    register R14 (clear, clk, Result_in[14], BusLine, R14_data);
    register R15 (clear, clk, Result_in[15], BusLine, R15_data);

    // Special registers
    register HI (clear, clk, HIin, BusLine, HI_data);
    register LO (clear, clk, LOin, BusLine, LO_data);
    register IR (clear, clk, IRin, BusLine, IR_data);
    register Y (clear, clk, Yin, BusLine, Y_data);
    register InPort (clear, clk, inport_in, BusLine, InPort_data);
    register OutPort (clear, clk, outport_in, BusLine, OutUnit);

	 
    MAR_register MAR (.clear(clear), .clk(clk), .mar_in(MARin), .bus_data(BusLine), .mar_address_out(MAR_address));
	 register_64 Z(.z_high_data_out(z_high_data_out), .Zdatain(ZLine), .clear(clear), .clk(clk), .rz_in(Zin), .z_low_data_out(z_low_data_out));
	 PC_register PC (clear, clk, PCin, IncPC, BusLine, PC_data);

    MDR_register MDR (.clear(clear), .Mdatain(Ram_data), .bus_mux_out(BusLine), .clk(clk), .mdr_in(MDRin), .mdr_read(read), .mdr_data_out(MDR_data));


    Mux_2to1 muxY (.I0(Y_data), .I1(C_data), .signal(muxSignal), .MuxOut(YLine));

    // ALU
    ALU alu(.clk(clk), .signal(opcode), .A(YLine), .B(BusLine), .result(ZLine));


	 encoder_32_to_5 bus_encoder(
	 .encoder_input({{8{1'b0}}, Cout,  Inout, MDRout, PCout, 
	 zlowout, zhighout, LOout, HIout, {Result_out}}),
    .encoder_output(select_signals)
	);
	 
    Bus bus(
        .select_signals(select_signals),
        .R0_data(R0_data), .R1_data(R1_data), .R2_data(R2_data), .R3_data(R3_data), .R4_data(R4_data),
        .R5_data(R5_data), .R6_data(R6_data), .R7_data(R7_data), .R8_data(R8_data), .R9_data(R9_data),
        .R10_data(R10_data), .R11_data(R11_data), .R12_data(R12_data), .R13_data(R13_data), .R14_data(R14_data),
        .R15_data(R15_data), .HI_data(HI_data), .LO_data(LO_data), .MDR_data(MDR_data), .z_low_data_out(z_low_data_out), .z_high_data_out(z_high_data_out),
        .PC_data(PC_data), .clock(clk), .C_data(C_data), .InPort_data(InPort_data),
        .muxOut(BusLine)
    );

    // Memory
    memram ram(.address(MAR_address), .clock(clk), .data(MDR_data), .wren(wren), .q(Ram_data));

    // Conditional FF
    CON_FF con_ff(
        .bus(BusLine),
        .ir(IR_data[20:19]),
        .con_in(con_in),
        .clock(clk),
        .con_out(con_out)
    );
	 
endmodule
