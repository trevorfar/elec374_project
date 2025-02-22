`timescale 1ns/1ps
// AND TB

module datapath_shr_tb();

    reg clk, clear;
    reg [4:0] opcode;
    reg pc_out, ZLowout, HI_out, LO_out, mar_in, pc_in, ZHighout, muxy_select;
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
	 .opcode(opcode),
    
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
	 .MDR_data_out(mdr_data_out),
	 .Mdatain(Mdatain)
	);
		 
	 initial begin
		  clear = 1;
        #1 clear = 0;
	 end
    initial begin
        clk = 0;
        forever #9 clk = ~clk;
    end
	 
	 task reset_signals;
        begin
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
            reg_in <= 16'b0;
        end
    endtask

    always @(posedge clk) begin

        case (present_state)
            Default: begin
					reset_signals();
					present_state <= load_regA1;
            end
				load_regA1: begin
					Mdatain <= 32'h00000008;
					muxy_select <= 0;
					#10 mdr_read <= 1; mdr_in <= 1;
					#10 mdr_read <= 0; mdr_in <= 0;	
					present_state <= load_regA2;
					
				end
				
				load_regA2: begin	
					#10 mdr_out <= 1; reg_in[3] <= 1;
					#15 mdr_out <= 0; reg_in[3] <= 0;
					present_state <= load_regB1;
					
				end
				
				load_regB1: begin

					Mdatain <= 32'h00000001;
					#10 mdr_read <= 1; mdr_in <= 1; 
					#10 mdr_read <= 0; mdr_in <= 0;					
					present_state <= load_regB2;
				end
				
				load_regB2: begin
					#10 mdr_out <= 1; reg_in[7] <= 1;
					#10 mdr_out <= 0; reg_in[7] <= 0;					
					present_state <= load_regC1;
				end
				
				load_regC1: begin
					Mdatain <= 32'h00000000;
					#10 mdr_read <= 1; mdr_in <= 1;
					#10 mdr_read <= 0; mdr_in <= 0;				
					present_state <= load_regC2;
				end
				
				load_regC2: begin
					#10 mdr_out <= 1; reg_in[4] <= 1;
					#10 mdr_out <= 0; reg_in[4] <= 0;					  
					present_state <= T0;
				end

            T0: begin
               #10 pc_out <= 1; mar_in <= 1;
					#10 pc_out <= 0; mar_in <= 0;		
					present_state <= T1;					
            end
            T1: begin
                Mdatain <= 32'h2A2B8000;
					 #10 mdr_in <= 1; mdr_read <= 1;  pc_in <= 1;
					 present_state <= T2;
            end
            T2: begin
					 #10 mdr_out <= 1; ir_in <= 1;  
					 #10 mdr_out <= 0; 
					 present_state <= T3;

            end

            T3: begin
					#10 Yin = 1; reg_out[3] <= 1; 
					#10 reg_out[3] <= 0; Yin <= 0;
					present_state <= T4;
            end

            T4: begin
					opcode = 5'b00111;
					#10 rz_in <= 1; reg_out[7] <= 1;  //rz_in, reg_out, bus_select, 
					#10 reg_out[7] <= 0; rz_in <= 0;
					present_state <= T5;
            end
				T5: begin
					#10 ZLowout <= 1; reg_in[4] <= 1;
					#10 ZLowout <= 0; reg_in[4] <= 0;
					#20 // a lil wiggle room so they can see it 
					$stop; // delete if i want to show full cycles
				end
        endcase
    end


endmodule
