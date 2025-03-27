
`timescale 1ns / 1ps

module DataPath(
    input wire clk, clear, read,
    input wire [31:0] fromInPort,
    input wire [4:0] opcode,
    input wire [7:0] pc_offset,
    input wire set_pc_flag,

    input wire HIin, LOin, MARin, MDRin, Yin, Zin, PCin, IRin,
    input wire HIout, LOout, MARout, MDRout, Zhighout, Zlowout, PCout, Cout, Inout, Outout,
    input wire IncPC, wren, muxSignal,
    input wire Gra, Grb, Grc, Rin, Rout, BAout,
    input wire con_in,

    output wire [31:0] BusLine,
    output wire [31:0] R0_data, R1_data, R2_data, R3_data, R4_data,
    output wire [31:0] R5_data, R6_data, R7_data, R8_data, R9_data,
    output wire [31:0] R10_data, R11_data, R12_data, R13_data, R14_data,
    output wire [31:0] R15_data, HI_data, LO_data, MAR_data, MDR_data,
    output wire [31:0] Y_data, Z_data, PC_data, IR_data, Ram_data, C_data,
    output wire [31:0] InPort_data, OutUnit, YLine,
    output wire [4:0] encoded_signal,
    output wire [31:0] select_signals,
    output wire [63:0] ZLine,
    output wire [15:0] Result_in, Result_out,
    output wire [8:0] MAR_address,
    output wire con_out
);

    wire Out = (Rout | HIout | LOout | MARout | MDRout | Zhighout | Zlowout | PCout | Cout | Inout);

    // Control logic for register selection and C sign-extension
    SelectAndEncoder select_and_encoder(
        .IR(IR_data),
        .Gra(Gra), .Grb(Grb), .Grc(Grc), .Rin(Rin), .Rout(Rout), .BAout(BAout),
        .Result_in(Result_in), .Result_out(Result_out)
    );

    // Register file (R0-R15)
    register R0 (clear, clk, Result_in[0], Result_out[0], BusLine, R0_data);
    register R1 (clear, clk, Result_in[1], Result_out[1], BusLine, R1_data);
    register R2 (clear, clk, Result_in[2], Result_out[2], BusLine, R2_data);
    register R3 (clear, clk, Result_in[3], Result_out[3], BusLine, R3_data);
    register R4 (clear, clk, Result_in[4], Result_out[4], BusLine, R4_data);
    register R5 (clear, clk, Result_in[5], Result_out[5], BusLine, R5_data);
    register R6 (clear, clk, Result_in[6], Result_out[6], BusLine, R6_data);
    register R7 (clear, clk, Result_in[7], Result_out[7], BusLine, R7_data);
    register R8 (clear, clk, Result_in[8], Result_out[8], BusLine, R8_data);
    register R9 (clear, clk, Result_in[9], Result_out[9], BusLine, R9_data);
    register R10 (clear, clk, Result_in[10], Result_out[10], BusLine, R10_data);
    register R11 (clear, clk, Result_in[11], Result_out[11], BusLine, R11_data);
    register R12 (clear, clk, Result_in[12], Result_out[12], BusLine, R12_data);
    register R13 (clear, clk, Result_in[13], Result_out[13], BusLine, R13_data);
    register R14 (clear, clk, Result_in[14], Result_out[14], BusLine, R14_data);
    register R15 (clear, clk, Result_in[15], Result_out[15], BusLine, R15_data);

    // Special registers
    register HI (clear, clk, HIin, HIout, BusLine, HI_data);
    register LO (clear, clk, LOin, LOout, BusLine, LO_data);
    register IR (clear, clk, IRin, 1'b1, BusLine, IR_data);
    register Y (clear, clk, Yin, 1'b1, BusLine, Y_data);
    register InPort (clear, clk, 1'b1, Inout, fromInPort, InPort_data);
    register OutPort (clear, clk, 1'b1, Outout, BusLine, OutUnit);

    MAR_register MAR (clear, clk, MARin, MARout, BusLine, MAR_data, MAR_address);
    register_64 Z (clear, clk, Zin, Zhighout, Zlowout, ZLine, Z_data);
    PC_register PC (clear, clk, PCin, PCout, IncPC, BusLine, PC_data);

    MDR_register MDR (clear, clk, MDRin, MDRout, BusLine, Ram_data, read, MDR_data);

    // C Sign-Extend
    C_sign_extender C_sign(.clock(clk), .clear(clear), .data_in(IR_data[17:0]), .Cout(Cout), .BusLine(C_data));

    // ALU Input Mux: YLine = mux(Y_data, C_data)
    Mux_2to1 muxY (.I0(Y_data), .I1(C_data), .signal(muxSignal), .MuxOut(YLine));

    // ALU
    ALU alu(.clk(clk), .signal(opcode), .A(YLine), .B(BusLine), .Result(ZLine));

    // Bus Selector
    assign select_signals = {7'b0, Inout, Cout, PCout, Zhighout, Zlowout, MDRout, MARout, LOout, HIout, Result_out};

    Bus bus(
        .select_signals(select_signals),
        .R0_data(R0_data), .R1_data(R1_data), .R2_data(R2_data), .R3_data(R3_data), .R4_data(R4_data),
        .R5_data(R5_data), .R6_data(R6_data), .R7_data(R7_data), .R8_data(R8_data), .R9_data(R9_data),
        .R10_data(R10_data), .R11_data(R11_data), .R12_data(R12_data), .R13_data(R13_data), .R14_data(R14_data),
        .R15_data(R15_data), .HI_data(HI_data), .LO_data(LO_data), .MAR_data(MAR_data), .MDR_data(MDR_data),
        .Z_data(Z_data), .PC_data(PC_data), .clock(clk), .Rout(Out), .C_data(C_data), .InPort_data(InPort_data),
        .BusMuxOut(BusLine), .encoded_signal(encoded_signal)
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
