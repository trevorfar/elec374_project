`timescale 1ns/1ps
// AND TB

module datapath_ld_tb();

    reg clk, clear;
    reg [4:0] opcode;
	 reg [31:0] inport_data_in;
    reg pc_out, ZLowout, HI_out, LO_out, mar_in, pc_in, ZHighout, muxy_select, inc_pc, Rin;
    reg mdr_in, ir_in, Yin, mdr_read, HI_in, LO_in, Cout, mdr_out, rz_in, inport_out, inport_in, outport_in, Gra, Grb, Grc, wren, BAout, Rout;
	 wire [15:0] reg_in, reg_out; 
	 wire [31:0] mdr_data_out;
	 wire [31:0] bus_data, ram_data_out, ir_data_out, pc_data_out, r4_data_out, r6_data_out, r2_data_out, inport_data_out, z_low_data_out, z_high_data_out;
	 wire [4:0] bus_select;
	 wire [63:0] rz_data_out;
	 wire [8:0] mar_address_out;
	 
	 /*
	 
	 0000 1001 0000 0000 0000 0000 0111 1000
	 00001 0010 0000 0000 0000 0000
	 0000 1001 
	 =0x09000078
	 
	 
	 ldi r2, 0x78 = 0000 1001 0000 0000 0000 0000 0000001111000
	 ld R4, 0x54 ; (0x54) = 0x97 - 0000 0010 0000 0000 0000 0000 0101 0100 = 0x02000054
	 ld R6, 0x63(R2) ; R2 = 0x78, and (0xDB) = 0x46 - 0000 0011 0001 0000 0000 0000 0100 0110 = 0x03100046
	 ldi R4, 0x54
	 ldi R6, 0x63(R2) ; R2 = 0x78
	 */

	 datapath DUT 	(
    .clk(clk),
    .clear(clear),
    .outport_data_out(),  
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
    .Cout(Cout),
    .inport_out(inport_out),
    .rz_in(rz_in),
    .muxy_select(muxy_select),
	 .BAout(BAout),
	 .reg_out(reg_out),
	 .reg_in(reg_in),
	 .bus_select(bus_select),
	 .mdr_data_out(mdr_data_out),
	 .mar_address_out(mar_address_out),
	 .Rin(Rin),
	 .pc_data_out(pc_data_out),
	 .Rout(Rout),
	 .inport_data_in(inport_data_in),
	 .r4_data_out(r4_data_out),
	 .r6_data_out(r6_data_out),
	 .inport_data_out(inport_data_out),
	 .r2_data_out(r2_data_out),
	 .z_high_data_out(z_high_data_out),
	 .z_low_data_out(z_low_data_out),
	 .rz_data_out(rz_data_out),
	 .wren(wren)
	);
	
	 initial begin
		  clear = 1;
        #1 clear = 0;
	 end
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

	 
	 task reset_signals();
        begin
            pc_in <= 0;
            mar_in <= 0;
         
            HI_in <= 0;
            LO_in <= 0;
            ir_in <= 0;
            mdr_in <= 0;
            mdr_read <= 0;
            rz_in <= 0;
				Rin <= 0;
            Yin <= 0;
				inport_in <= 0;
				outport_in <= 0;
				Rout <= 0;
				
				inc_pc <= 0;
				muxy_select <= 0;

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

	task load_reg (input [31:0] instruction, input [31:0] value); begin
		inport_data_in <= instruction; inport_in <= 1; opcode <= 5'b00001;
		
		@(posedge clk)
		inport_out <= 1; ir_in <= 1; 
		#5 inport_data_in <= value; 

		
		@(posedge clk)
		inport_data_in <= 32'b0; inport_in <= 0;
		inport_out <= 1; Gra <= 1; Rin <= 1;
		
		@(posedge clk)
		inport_out <= 0; Gra <= 0; Rin <= 0;
	
	end
	endtask
//	 	 
//	 task T0(); begin
//		mar_in <= 1; pc_in <= 1; inc_pc <= 1; pc_out <= 1; 
//		@(posedge clk) 
//		mar_in <= 0; pc_in <= 0; inc_pc <= 0; pc_out <= 0; 
//	 end
//	 endtask
//	 
//	 task T1(); begin
//		mdr_read <= 1; mdr_in <= 1; 
//		@(posedge clk)
//		mdr_read <= 0; mdr_in <= 0; 
//	 end
//	 endtask
//	 
//	 task T2(); begin
//		mdr_out <= 1; ir_in <= 1; 
//		@(posedge clk)
//		mdr_out <= 0; ir_in <= 0;
//	 end
//	 endtask
//	 
//	 task T3(); begin
//		
//	 
//	 end
//	 endtask
//
//	 task T4(); begin
//	 
//	 end
//	 endtask
//	 
//	 task T5(); begin
//	 
//	 end
//	 endtask
//	 
//	 task T6(); begin
//	 
//	 end
//	 endtask
//	 
//	 task T7(); begin
//	 
//	 end
//	 endtask
//	 

	 
	 
	 task case_2T0(); begin
		pc_out <= 1; mar_in <= 1; inc_pc <= 1; pc_in <= 1; rz_in <= 1; 

		@(posedge clk) 
		pc_out <= 0; mar_in <= 0; inc_pc <= 0; pc_in <= 0; rz_in <= 0;
	 end
	 endtask
	 
	 task case_2T1(); begin
		mdr_read <= 1; mdr_in <= 1; ZLowout <= 1; //pc_in <= 1;// wren <= 1;
		@(posedge clk)
		mdr_read <= 0; mdr_in <= 0; ZLowout <= 0; //pc_in <= 0;// wren <= 0;
	 end
	 endtask
	 
	 task case_2T2(); begin
		mdr_out <= 1; ir_in <= 1; 
		@(posedge clk)
		mdr_out <= 0; ir_in <= 0;
	 end
	 endtask
	 
	 task case_2T3(); begin
	 Grb <= 1; BAout <= 1; Yin <= 1;
	 @(posedge clk)
	 Grb <= 0; BAout <= 0; Yin <= 0;
	 end
	 endtask

	 task case_2T4(); begin
	 Cout <= 1; opcode <= 5'b00011; rz_in <= 1; muxy_select <= 1; 
	 @(posedge clk)
	 Cout <= 0; rz_in <= 0; muxy_select <= 0;

	 end
	 endtask
	 
	 task case_2T5(); begin
	 ZLowout <= 1; mar_in <= 1;
	 @(posedge clk)
	 ZLowout <= 0; mar_in <= 0;
	 end
	 endtask
	 
	 task case_2T6(); begin
	 mdr_in <= 1; mdr_read <= 1;
	 @(posedge clk)
	 mdr_in <= 0; mdr_read <= 0;
	 end
	 endtask
	 
	 task case_2T7(); begin
	 Gra <= 1; Rin <= 1; mdr_out <=1;
	 @(posedge clk)
	 Gra <= 0; Rin <= 0; mdr_out <=0;
	 end
	 endtask
	

	 initial begin
		reset_signals();
		
		//CASE 1
//		@(posedge clk)
//		T0();
//		T1();
//		T2();		
//		T3();
//		T4();
//		T5();
//		T6();
//		T7();
		
		//CASE 2
		@(posedge clk)
		load_reg(32'h090000, 32'h78);
		
		// R6, 0x63(R2) = 0x03100063
		
		case_2T0();
		case_2T1();
		case_2T2();		
		case_2T3();
		case_2T4();
		case_2T5();
		case_2T6();
		case_2T7();
	 end

	 
endmodule