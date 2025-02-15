`timescale 1ns/1ps

module datapath_tb();

    reg clk, clear;
    reg [4:0] opcode;
    reg [15:0] enable;
    reg PCout, ZHighout, ZLowout, HIout, LOout, MAR_enable, PC_enable;
    reg MDRin, IR_enable, Yin, mdr_read, HIin, LOin, ZHigh_enable, ZLow_enable, Cout;
    reg [31:0] InPort_data_in, RY_immediate, m_data_in;
    wire [31:0] r3_debug, r7_debug, r4_debug, pc_debug, ZHigh_debug, ZLow_debug;
	 wire r3in, r4in, r7in;

    wire [31:0] bus_data, OutPort_data_out;

    parameter Default = 4'b0000, T0 = 4'b0001, T1 = 4'b0010, T2 = 4'b0011, T3 = 4'b0100, T4 = 4'b0101, T5 = 4'b0000;
    reg [3:0] present_state = Default;

    datapath UUT (
        .clk(clk),
        .clear(clear),
        .opcode(opcode),
        .PCout(PCout),
        .ZHighout(ZHighout),
        .ZLowout(ZLowout),
        .HIout(HIout),
        .LOout(LOout),
        .MAR_enable(MAR_enable),
        .PC_enable(PC_enable),
        .MDRin(MDRin),
        .IR_enable(IR_enable),
        .Yin(Yin),
        .mdr_read(mdr_read),
        .HIin(HIin),
        .LOin(LOin),
        .ZHigh_enable(ZHigh_enable),
        .ZLow_enable(ZLow_enable),
        .Cout(Cout),
        .enable(enable),
        .InPort_data_in(InPort_data_in),
        .RY_immediate(RY_immediate),
        .bus_data(bus_data),
        .OutPort_data_out(OutPort_data_out),
		  .r3_debug(r3_debug),
		  .r4_debug(r4_debug),
		  .r7_debug(r7_debug),
		  .pc_debug(pc_debug),
		  .ZHigh_debug(ZHigh_debug),
		  .ZLow_debug(ZLow_debug),
		  .r3in(r3in),
		  .r4in(r4in),
		  .r7in(r7in)
    );

    initial begin
        clk = 0;
        forever #50 clk = ~clk;
    end

    initial begin
        clear = 1;
        #20 clear = 0;
    end

    always @(posedge clk) begin
        case (present_state)
				Default: present_state <= Default;
            T0: present_state <= T1;
            T1: present_state <= T2;
            T2: present_state <= T3;
            T3: present_state <= T4;
            T4: present_state <= T5;
        endcase
    end

    always @(present_state) begin

        case (present_state)
            Default: begin
                 enable = 16'b0;
                 clear = 1;
					  enable = 16'b0;
					  PC_enable = 0;
					  MAR_enable = 0;
					  ZHigh_enable = 0;
					  ZLow_enable = 0;
					  HIin = 0;
					  LOin = 0;
					  IR_enable = 0;
					  MDRin = 0;
					  mdr_read = 0;
					  m_data_in = 32'b0;
					  opcode = 5'b0;
					  Yin = 0;
					  InPort_data_in = 0;
					  RY_immediate = 0;
					  PCout = 0; HIout = 0; LOout = 0; ZHighout = 0; ZLowout = 0;
					  present_state <= T0;
            end

            T0: begin
                PC_enable = 1;   
                MAR_enable = 1; 
            end

            T1: begin
                ZLow_enable = 1; 
                mdr_read = 1; 
                m_data_in = 32'h2A2B8000; 
            end

            T2: begin
                IR_enable = 1;  
            end

            T3: begin
                enable[2] = 1;   
                enable[6] = 1;  
                Yin = 1;
                opcode = 5'b00100;
            end

            T4: begin
                ZHigh_enable = 1; 
                enable[3] = 1; 
            end
				T5: begin
					  enable = 16'b0;
                 clear = 1;
					  enable = 16'b0;
					  PC_enable = 0;
					  MAR_enable = 0;
					  ZHigh_enable = 0;
					  ZLow_enable = 0;
					  HIin = 0;
					  LOin = 0;
					  IR_enable = 0;
					  MDRin = 0;
					  mdr_read = 0;
					  m_data_in = 32'b0;
					  opcode = 5'b0;
					  Yin = 0;
					  InPort_data_in = 0;
					  RY_immediate = 0;
					  PCout = 0; HIout = 0; LOout = 0; ZHighout = 0; ZLowout = 0;
				end
        endcase
    end

endmodule