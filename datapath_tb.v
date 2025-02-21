`timescale 1ns/1ps

module datapath_tb();

    reg clk, clear;
    reg [4:0] opcode;
    reg pc_out, ZLowout, HI_out, LO_out, mar_in, pc_in, ZHighout;
    reg mdr_in, ir_in, Yin, mdr_read, HI_in, LO_in, z_lo_in, Cout, mdr_out, rz_in, InPortout;
	 reg [15:0] reg_in, reg_out;
	 reg [31:0] Mdatain;
	 wire [31:0] mdr_data_out;
	 wire [31:0] bus_data, r3_data_out, r4_data_out, r7_data_out;
	 wire [4:0] bus_select;
	 
    parameter Default = 4'b0000, load_regA1 = 4'b0001, load_regA2 = 4'b0010, load_regB1 = 4'b0011, 
	 load_regB2 = 4'b0100, load_regC1 = 4'b0101, load_regC2 = 4'b0110, T0 = 4'b0111, T1 = 4'b1000, T2 = 4'b1001,
	 T3 = 4'b1010, T4 = 4'b1011, T5 = 4'b1100;

    reg [3:0] present_state = Default;
	 
	 datapath DUT (
    .clk(clk),
    .clear(clear),
    .InPort_data_in(32'b0),  
    .OutPort_data_out(),  // Unconnected output
    .bus_data(bus_data),  // Unconnected output
    
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
	 .reg_out(reg_out),
	 .reg_in(reg_in),
	 .R3_data_out(r3_data_out),
	 .R4_data_out(r4_data_out),
	 .R7_data_out(r7_data_out),
	 .bus_select(bus_select),
	 .MDR_data_out(mdr_data_out)
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
					  pc_in <= 0;
					  mar_in <= 0;
					  z_lo_in <= 0;
					  HI_in <= 0;
					  LO_in <= 0;
					  ir_in <= 0;
					  mdr_in <= 0;
					  mdr_read <= 0;
					  mdr_out <= 0;
					  Mdatain <= 32'b0;
					  InPortout <= 0;
					  opcode <= 5'b0;
					  Cout <= 0;
					  rz_in <= 0;
					  Yin <= 0;
					  pc_out <= 0; HI_out <= 0; LO_out <= 0; ZHighout <= 0; ZLowout <= 0;
					  reg_out <= 16'b0;
					  reg_in <= 16'b0;					  $display("Default: Encoder Input: %b", DUT.encoder_input_debug);

            end
				//read = 
				load_regA1: begin
				$display("Time: %t | Mdatain: %h | MDR In: %b | MDR Read: %b | MDR Data Out: %h", 
				$time, Mdatain, mdr_in, mdr_read, mdr_data_out);
				Mdatain <= 32'h00000022;
				#10
				mdr_read <= 1; #5 mdr_in <= 1;
				#15 mdr_read <= 0; mdr_in <= 0;					  
				$display("A1 Encoder Input: %b", DUT.encoder_input_debug);

				end
				
				load_regA2: begin	
					mdr_out <= 1; reg_in[2] <= 1;
					#15 mdr_out <= 0; reg_in[2] <= 0;
									  $display("A2 Encoder Input: %b", DUT.encoder_input_debug);

				end
				
				load_regB1: begin
					mdr_read <= 1; mdr_in <= 1;
					#10 Mdatain <= 32'h0000024;

					#35 mdr_read <= 0; mdr_in <= 0;					  $display("B1 Encoder Input: %b", DUT.encoder_input_debug);

				end
				
				load_regB2: begin
					mdr_out <= 1; reg_in[6] <= 1;
					#15 mdr_out <= 0; reg_in[6] <= 0;					  $display("B2 Encoder Input: %b", DUT.encoder_input_debug);

				end
				
				load_regC1: begin
					Mdatain <= 32'h0000028;
					mdr_read <= 1; mdr_in <= 1;
					#15 mdr_read <= 0; mdr_in <= 0;					  $display("C1 Encoder Input: %b", DUT.encoder_input_debug);

				end
				
				load_regC2: begin
					mdr_out <= 1; reg_in[3] <= 1;
					#15 mdr_out <= 0; reg_in[3] <= 0;					  $display("C2 Encoder Input: %b", DUT.encoder_input_debug);

				end

            T0: begin
                pc_out <= 1; mar_in <= 1;
					 #15 pc_out <= 0; mar_in <= 0;					  $display("T0 Encoder Input: %b", DUT.encoder_input_debug);

					 
            end
            T1: begin
                mdr_in <= 1; mdr_read <= 1; Mdatain <= 32'h2A2B8000; pc_in <= 1;
					// ZLowout <= 1; pc_in <= 1; mdr_read <= 1; mdr_in <= 1; 					
					$display("T1 Encoder Input: %b", DUT.encoder_input_debug);

            end

            T2: begin
					 mdr_out <= 1; ir_in <= 1;  
					 #15 mdr_out <= 0; 
					 					  $display("T2 Encoder Input: %b", DUT.encoder_input_debug);

            end

            T3: begin
				Yin = 1; reg_out[2] <= 1; 
				#15 reg_out[2] <= 0; Yin <= 0;
									  $display("T3 Encoder Input: %b", DUT.encoder_input_debug);

            end

            T4: begin
               // z_lo_in <= 1; 
					rz_in <= 1; reg_out[6] <= 1; opcode = 5'b00100;
					 #15 reg_out[6] <= 0;
					 $display("T4 Encoder Input: %b", DUT.encoder_input_debug);

            end
				T5: begin
					  rz_in <= 0; ZLowout <= 1; reg_in[3] <= 1;
					  #15 ZLowout <= 0; reg_in[3] <= 0;
					  $display("T5 Encoder Input: %b", DUT.encoder_input_debug);

				end
        endcase
    end


endmodule
