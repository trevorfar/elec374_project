`timescale 1ns/1ps

module datapath_tb();

    reg clk, clear;
    reg [4:0] opcode;
    reg [15:0] reg_enable;
    reg pc_out, ZLowout, HI_out, LO_out, mar_in, pc_in, ZHighout;
    reg mdr_in, ir_in, Yin, mdr_read, HI_in, LO_in, z_lo_in, Cout, mdr_out;
	 reg R0_out, R1_out, R2_out, R3_out, R4_out, R5_out;
    reg R6_out, R7_out, R8_out, R9_out, R10_out, R11_out;
	 reg R0_enable, R1_enable, R2_enable, R3_enable, R4_enable, R5_enable;
    reg R6_enable, R7_enable, R8_enable, R9_enable, R10_enable, R11_enable;
    reg R12_enable, R13_enable, R14_enable, R15_enable;
	 reg [31:0] Mdatain;
	 reg [31:0] mdr_data_out;
	 
    parameter Default = 4'b0000, load_regA1 = 4'b0001, load_regA2 = 4'b0010, load_regB1 = 4'b0011, 
	 load_regB2 = 4'b0100, load_regC1 = 4'b0101, load_regC2 = 4'b0110, T0 = 4'b0111, T1 = 4'b1000, T2 = 4'b1001,
	 T3 = 4'b1010, T4 = 4'b1011, T5 = 4'b1100;

    reg [3:0] present_state = Default;
	 
	 datapath DUT (
    .clk(clk),
    .clear(clear),
    .InPort_data_in(32'b0),  // Placeholder, modify if needed
    .OutPort_data_out(),  // Unconnected output
    .bus_data(),  // Unconnected output
    
    // Control Signals
    .pc_out(pc_out),
    .ZHighout(ZHighout),
    .ZLowout(ZLowout),
    .HI_out(HI_out),
    .LO_out(LO_out),
    .mar_in(mar_in),
    .mdr_out(mdr_out),
    .pc_in(pc_in),
    .mdr_in(mdr_in),
    .ir_in(ir_in),
    .Yin(Yin),
    .mdr_read(mdr_read),
    .HI_in(HI_in),
    .LO_in(LO_in),
    .z_hi_in(z_hi_in),
    .z_lo_in(z_lo_in),
    .Cout(Cout),
    .InPortout(InPortout),
    .rz_in(rz_in),
    .muxy_select(muxy_select),

    // Register Control Signals
    .R0_out(R0_out),
    .R1_out(R1_out),
    .R2_out(R2_out),
    .R3_out(R3_out),
    .R4_out(R4_out),
    .R5_out(R5_out),
    .R6_out(R6_out),
    .R7_out(R7_out),
    .R8_out(R8_out),
    .R9_out(R9_out),
    .R10_out(R10_out),
    .R11_out(R11_out),

    .R0_enable(R0_enable),
    .R1_enable(R1_enable),
    .R2_enable(R2_enable),
    .R3_enable(R3_enable),
    .R4_enable(R4_enable),
    .R5_enable(R5_enable),
    .R6_enable(R6_enable),
    .R7_enable(R7_enable),
    .R8_enable(R8_enable),
    .R9_enable(R9_enable),
    .R10_enable(R10_enable),
    .R11_enable(R11_enable),
    .R12_enable(R12_enable),
    .R13_enable(R13_enable),
    .R14_enable(R14_enable),
    .R15_enable(R15_enable)
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
					  pc_in <= 0;
					  mar_in <= 0;
					  z_lo_in <= 0;
					  HI_in <= 0;
					  LO_in <= 0;
					  ir_in <= 0;
					  mdr_in <= 0;
					  mdr_read <= 0;
					  Mdatain <= 32'b0;
					  opcode <= 5'b0;
					  Yin <= 0;
					  pc_out <= 0; HI_out <= 0; LO_out <= 0; ZHighout <= 0; ZLowout <= 0;
					  R3_out <= 0; R7_out <= 0;
            end
				//read = 
				load_regA1: begin
					Mdatain <= 32'h00000022;
					mdr_read <= 0; mdr_in <= 0;
					mdr_read <= 1; mdr_in <= 1;
					#15 mdr_read <= 0; mdr_in <= 0;
				end
				
				load_regA2: begin	
					mdr_out <= 1; reg_enable[2] <= 1;
					#15 mdr_out <= 0; reg_enable[2] <= 0;
				
				end
				
				load_regB1: begin
					Mdatain <= 32'h0000024;
					mdr_read <= 1; mdr_in <= 1;
					#15 mdr_read <= 0; mdr_in <= 0;
				end
				
				load_regB2: begin
					mdr_out <= 1; reg_enable[6] <= 1;
					#15 mdr_out <= 0; reg_enable[6] <= 0;
				end
				
				load_regC1: begin
					Mdatain <= 32'h0000028;
					mdr_read <= 1; mdr_in <= 1;
					#15 mdr_read <= 0; mdr_in <= 0;
				end
				
				load_regC2: begin
					mdr_out <= 1; enable[3] <= 1;
					#15 mdr_out <= 0; reg_enable[3] <= 0;
				end

            T0: begin
                pc_in <= 1;   
                mar_in <= 1; 
					 
            end
            T1: begin
                ZLowout <= 1; 
					 pc_in <= 1;
                mdr_read = 1; 
					 mdr_in <= 1;
                Mdatain <= 32'h2A2B8000; 
            end

            T2: begin
					 mdr_out <= 1; ir_in <= 1;  
            end

            T3: begin
                R3_out <= 1;   
                Yin = 1;
            end

            T4: begin
                z_lo_in <= 1;
					 R7_out <= 1;
					 opcode = 5'b00100;
            end
				T5: begin
					  ZLowout <= 1; reg_enable[3] <= 1;
				end
        endcase
    end

endmodule