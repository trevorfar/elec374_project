`timescale 1ns/1ps
// AND TB

module datapath_ld_tb();

    reg clk, clear;
    wire [4:0] opcode;
    reg pc_out, ZLowout, HI_out, LO_out, mar_in, pc_in, ZHighout, muxy_select, inc_pc, Rin;
    reg mdr_in, ir_in, Yin, mdr_read, HI_in, LO_in, z_lo_in, z_hi_in, Cout, mdr_out, rz_in, inport_out, inport_in, outport_in, Gra, Grb, Grc, wren, BAout;
	 wire [15:0] reg_in, reg_out; 
	 wire [31:0] mdr_data_out, Mdatain;
	 wire [31:0] bus_data, ram_data_out, ir_data_out, pc_data_out;
	 wire [4:0] bus_select;
	 wire [8:0] mar_address_out;
	 
	 /*
	 ld R4, 0x54 ; (0x54) = 0x97 - 0000 0010 0000 0000 0000 0000 0101 0100 = 0x02000054
	 ld R6, 0x63(R2) ; R2 = 0x78, and (0xDB) = 0x46 - 0000 0011 0001 0000 0000 0000 0100 0110 = 0x03100046
	 ldi R4, 0x54
	 ldi R6, 0x63(R2) ; R2 = 0x78
	 */
	 
    parameter Default = 4'b0000, load_regA1 = 4'b0001, load_regA2 = 4'b0010, T0 = 4'b0011, T1 = 4'b0100, T2 = 4'b0101, T3 = 4'b0110,
				  T4 = 4'b0111, T5 = 4'b1000, T6 = 4'b1001, T7 = 4'b1010;
				  
    reg [3:0] present_state, next_state;
	 
	 datapath DUT 	(
    .clk(clk),
    .clear(clear),
    .inport_data_in(),  
    .outport_data_out(),  // Unconnected output
    .bus_data(bus_data), 
	 .ram_data_out(ram_data_out),
	 .ir_data_out(ir_data_out),
	 .opcode(opcode),
    .pc_out(pc_out),
    .ZHighout(ZHighout),
    .ZLowout(ZLowout),
    .HI_out(HI_out),
    .LO_out(LO_out),
    .mar_in(mar_in),
    .mdr_out(mdr_out),
    .pc_in(pc_in),
	 .inc_pc(inc_pc),
    .mdr_in(mdr_in),
	 .inport_in(inport_in),
	 .outport_in(outport_in),
    .ir_in(ir_in),
    .Yin(Yin),
    .mdr_read(mdr_read),
	 .Gra(Gra),
	 .Grb(Grb),
	 .Grc(Grc),
    .HI_in(HI_in),
    .LO_in(LO_in),
    .z_hi_in(z_hi_in),
    .z_lo_in(z_lo_in),
    .Cout(Cout),
    .inport_out(inport_out),
    .rz_in(rz_in),
    .muxy_select(muxy_select),
	 .wren(wren),
	 .BAout(BAout),
	 .reg_out(reg_out),
	 .reg_in(reg_in),
	 .bus_select(bus_select),
	 .mdr_data_out(mdr_data_out),
	 .mar_address_out(mar_address_out),
	 .Rin(Rin),
	 .pc_data_out(pc_data_out),
	 .Mdatain(Mdatain)
	);
	
	 initial begin
		  clear = 1;
        #1 clear = 0;
	 end
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

	 
	 task reset_signals;
        begin
            pc_in <= 0;
            mar_in <= 0;
            z_lo_in <= 0;
				z_hi_in <= 0;
            HI_in <= 0;
            LO_in <= 0;
            ir_in <= 0;
            mdr_in <= 0;
            mdr_read <= 0;
            rz_in <= 0;
				Rin <= 0;
            Yin <= 0;

				mdr_out <= 0;
				inport_out <= 0;
            Cout <= 0; 
            pc_out <= 0; 
				HI_out <= 0; 
				LO_out <= 0; 
				ZHighout <= 0; 
				ZLowout <= 0;
				
				Gra <= 0; Grb <= 0; Grc <= 0; wren <= 0; BAout <= 0;
		
        end
    endtask

	 initial begin 
		present_state <= Default;
	 end
	 
	 always @(next_state) begin
		present_state <= next_state;
	 end
    always @(present_state) begin
        case (present_state)
            Default: begin
					reset_signals();
					@(posedge clk)
						next_state <= load_regA1;
            end
				load_regA1: begin
						muxy_select <= 0;
						mdr_read <= 1; mdr_in <= 1;
					@(posedge clk) 
						mdr_read <= 0; mdr_in <= 0;
						next_state <= load_regA2;
				end
	
				load_regA2: begin
						mdr_out <= 1; 
					@(posedge clk)
						mdr_out <= 0;
						next_state <= T0;
				end
				
				T0: begin
						pc_out <= 1; mar_in <= 1; inc_pc <= 1; rz_in <= 1;
					@(posedge clk) 
						pc_out <= 0; mar_in <= 0; inc_pc <= 0; rz_in <= 0;
						next_state <= T1;
					
				end
				
				T1: begin
						
					@(posedge clk)
					next_state <= T2;

				end
				
				T2: begin
						
					@(posedge clk)
					next_state <= T3;
				end
				
				T3: begin
						
					@(posedge clk)
					next_state <= T4;
				end
				
				T4: begin
					@(posedge clk)
						
					next_state <= T5;
				end
				
				T5: begin
					@(posedge clk)
						
					next_state <= T6;
				end
				
				T6: begin
					@(posedge clk)
						
					next_state <= T7;
				end
				
				T7: begin
					@(posedge clk)
					$stop;
					
				end
				
        endcase
    end
endmodule
