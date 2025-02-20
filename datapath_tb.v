`timescale 1ns/1ps

module datapath_tb();

    reg clk, clear;
    reg [4:0] opcode;
    reg [15:0] enable;
    reg PCout, ZLowout, HIout, LOout, MAR_enable, PC_enable, ZHighout;
    reg mdr_in, IR_enable, Yin, mdr_read, HIin, LOin, ZLow_enable, Cout, bus_data, OutPort_data_out;
    reg [31:0] InPort_data_in, RY_immediate, Mdatain, mdr_out;
    reg r3out, r7out;

    parameter Default = 4'b0000, load_regA1 = 4'b0001, load_regA2 = 4'b0010, load_regB1 = 4'b0011, 
	 load_regB2 = 4'b0100, load_regC1 = 4'b0101, load_regC2 = 4'b0110, T0 = 4'b0111, T1 = 4'b1000, T2 = 4'b1001,
	 T3 = 4'b1010, T4 = 4'b1011, T5 = 4'b1100;

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
        .MDRin(mdr_in),
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
		  .r3out(r3out),
		  .r4out(r4out),
		  .r7out(r7out)
    );

    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial begin
        clear = 1;
        #10 clear = 0;
    end

    always @(posedge clk) begin
        case (present_state)
				Default : present_state <= load_regA1;
				load_regA1 : present_state <= load_regA2;
				load_regA2 : present_state <= load_regB1;
				load_regB1 : present_state <= load_regB2;
				load_regB2 : present_state <= load_regC1;
				load_regC1 : present_state <= load_regC2;
				load_regC2 : present_state <= T0;
            T0 : present_state <= T1;
            T1 : present_state <= T2;
            T2 : present_state <= T3;
            T3 : present_state <= T4;
            T4 : present_state <= T5;
        endcase
    end

    always @(present_state) begin

        case (present_state)
            Default: begin
                 enable <= 16'b0;
					  PC_enable <= 0;
					  clear <= 0;
					  MAR_enable <= 0;
					  ZLow_enable <= 0;
					  HIin <= 0;
					  LOin <= 0;
					  IR_enable <= 0;
					  mdr_in <= 0;
					  mdr_read <= 0;
					  Mdatain <= 32'b0;
					  opcode <= 5'b0;
					  Yin <= 0;
					  InPort_data_in <= 0;
					  RY_immediate <= 0;
					  PCout <= 0; HIout <= 0; LOout <= 0; ZHighout <= 0; ZLowout <= 0;
            end
				//read = 
				load_regA1: begin
					Mdatain <= 32'h00000022;
					mdr_read <= 0; mdr_in <= 0;
					mdr_read <= 1; mdr_in <= 1;
					#15 mdr_read <= 0; mdr_in <= 0;
				end
				
				load_regA2: begin	
					mdr_out <= 1; enable[2] <= 1;
					#15 mdr_out <= 0; enable[2] <= 0;
				
				end
				
				load_regB1: begin
					Mdatain <= 32'h0000024;
					mdr_read <= 1; mdr_in <= 1;
					#15 mdr_read <= 0; mdr_in <= 0;
				end
				
				load_regB2: begin
					mdr_out <= 1; enable[6] <= 1;
					#15 mdr_out <= 0; enable[6] <= 0;
				end
				
				load_regC1: begin
					Mdatain <= 32'h0000028;
					mdr_read <= 1; mdr_in <= 1;
					#15 mdr_read <= 0; mdr_in <= 0;
				end
				
				load_regC2: begin
					mdr_out <= 1; enable[3] <= 1;
					#15 mdr_out <= 0; enable[3] <= 0;
				end

            T0: begin
                PC_enable = 1;   
                MAR_enable = 1; 
					 
            end
            T1: begin
                ZLowout = 1; 
					 PC_enable <= 1;
                mdr_read = 1; 
					 mdr_in <= 1;
                Mdatain = 32'h2A2B8000; 
            end

            T2: begin
					 mdr_out <= 1; IR_enable <= 1;  
            end

            T3: begin
                r3out <= 1;   
                Yin = 1;
            end

            T4: begin
                ZLow_enable <= 1;
					 r7out <= 1;
					 opcode = 5'b00100;
            end
				T5: begin
					  ZLowout <= 1; enable[3] <= 1;
				end
        endcase
    end

endmodule