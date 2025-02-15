module datapath(
    // Clock, reset, and ALU opcode
    input wire clk, clear,
    input wire [4:0] opcode,
    
    // Control signals (encoder inputs)
    input wire PCout, ZHighout, ZLowout, HIout, LOout, 
    input wire MAR_enable, PC_enable, MDRin, IR_enable, Yin, 
    input wire mdr_read, HIin, LOin, ZHigh_enable, ZLow_enable,
    input wire Cout, 
    input wire [15:0] enable,  // Register enables (R0-R15)
    
    // Data inputs/outputs
    input wire [31:0] InPort_data_in,
    input wire [31:0] RY_immediate,  // Immediate value for RY mux
    output wire [31:0] bus_data,
    output wire [31:0] OutPort_data_out,
	 output wire [31:0] r3_debug, r4_debug, r7_debug, pc_debug, ZHigh_debug, ZLow_debug,
	 output wire r3in, r4in, r7in
);
	 wire [31:0] m_data_in;
	 wire [63:0] RZ_data_in;
    // Internal signals
	 
	 
	 
    wire [31:0] mar_data_out, mdr_out, HI_out, LO_out, ZHigh_out, ZLow_out;
    wire [31:0] ir_data_out, pc_data_out, RY_out, muxy_out;
    wire [31:0] r0_data_out, r1_data_out, r2_data_out, r3_data_out, r4_data_out, r5_data_out;
    wire [31:0] r6_data_out, r7_data_out, r8_data_out, r9_data_out, r10_data_out, r11_data_out;
    wire [31:0] r12_data_out, r13_data_out, r14_data_out, r15_data_out;
    wire [31:0] C_sign_extended;  
	 
	 
	 assign r3_debug = r3_data_out;
    assign r7_debug = r7_data_out;
    assign r4_debug = r4_data_out;
    assign pc_debug = pc_data_out;
    assign ZHigh_debug = ZHigh_out;
    assign ZLow_debug = ZLow_out;
	 assign r3in = enable[2];
	 assign r4in = enable[3];
	 assign r7in = enable[6];

    // Encoder input (32 control signals)
    wire [31:0] encoder_input;
    assign encoder_input = {
        // Map control signals to encoder inputs (adjust order as needed)
        8'b0,  // Unused
        PCout, ZHighout, ZLowout, HIout, LOout, 
        1'b0, 1'b0, 
        enable[15:0]  
    };

    // Encoder to select bus source
    wire [4:0] bus_select;
    encoder_32_to_5 bus_encoder(
        .encoder_input(encoder_input),
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

    reg_32_bit HI(clear, clk, HIin, bus_data, HI_out);
    reg_32_bit LO(clear, clk, LOin, bus_data, LO_out);
    reg_32_bit ZHigh(clear, clk, ZHigh_enable, RZ_data_in[63:32], ZHigh_out);
    reg_32_bit ZLow(clear, clk, ZLow_enable, RZ_data_in[31:0], ZLow_out);
    pc_32_bit PC(clear, clk, PC_enable, bus_data, pc_data_out);
    reg_32_bit MAR(clear, clk, MAR_enable, bus_data, mar_data_out);
    reg_32_bit RY(clear, clk, Yin, bus_data, RY_out);

    // MDR with RAM interface
    MDR_32_bit MDR(
        .Mdatain(m_data_in),
        .bus_mux_out(bus_data),
        .clk(clk),
        .clear(clear),
        .MDRin(MDRin),
        .mdr_read(mdr_read),  // mdr_read = 1 for RAM, 0 for bus
        .mdr_out(mdr_out)
    );

    // ALU and bus mux
     mux_2_to_1 muxy(RY_out, RY_immediate, muxy_select, muxy_out);



    mux_32_bit bus(
        .R0(r0_data_out), .R1(r1_data_out), .R2(r2_data_out), .R3(r3_data_out), .R4(r4_data_out), .R5(r5_data_out), 
        .R6(r6_data_out), .R7(r7_data_out), .R8(r8_data_out), .R9(r9_data_out), .R10(r10_data_out), .R11(r11_data_out), 
        .R12(r12_data_out), .R13(r13_data_out), .R14(r14_data_out), .R15(r15_data_out), .HI(HI_out), .LO(LO_out), 
        .Z_HI(ZHigh_out), .Z_LO(ZLow_out), .PC(pc_data_out), .MDR(mdr_out), .IN_PORT(InPort_data_in), 
        .C_sign_extended(C_sign_extended), .select(bus_select), .BusMuxOut(bus_data)
    );

    alu ALU(.RA(muxy_out), .RB(bus_data), .opcode(opcode), .RZ(RZ_data_in));        

endmodule