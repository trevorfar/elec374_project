`timescale 1ns/1ps
// this aint a ld tb, this a master brain epic swagger tb


module datapath_ld_tb();
    reg clk, clear;
    reg [4:0] opcode;
	 reg [31:0] inport_data_in;
    reg pc_out, ZLowout, HI_out, LO_out, mar_in, pc_in, ZHighout, muxy_select, inc_pc, Rin;
    reg mdr_in, ir_in, Yin, mdr_read, HI_in, LO_in, Cout, mdr_out, rz_in, inport_out, inport_in, outport_in, Gra, Grb, Grc, wren, BAout, Rout, con_in;
	 wire [15:0] reg_in, reg_out; 
	 wire [31:0] mdr_data_out;
	 wire [31:0] bus_data, ram_data_out, ir_data_out, pc_data_out, r3_data_out, r4_data_out, r5_data_out, r6_data_out, r2_data_out, inport_data_out, z_low_data_out, z_high_data_out;
	 wire [4:0] bus_select;
	 wire [63:0] rz_data_out;
	 wire [8:0] mar_address_out;
	 wire con_out;
	 reg [2:0] test_id;
	 reg [2:0] case_num;
	 reg [7:0] pc_offset;
	 reg set_pc_flag;
	 
	 localparam LD = 3'b000; // 4 cases mem locs: 0x0, 0x1, 0x2, 0x4
	 localparam ST = 3'b001; // 2 cases mem locs: 0x8, 0x9
	 localparam ALU = 3'b010; // 3 cases mem locs: 0x10, 0x11, 0x12
	 localparam BRANCH = 3'b011; // 4 cases mem locs: 0x18, 0x19, 0x20, 0x21
	 localparam JUMP = 3'b100;
	 localparam SPECIAL = 3'b101;
	 localparam OUT = 3'b110;
	 
	 localparam CASE1 = 3'b000;
	 localparam CASE2= 3'b001;
	 localparam CASE3= 3'b010;
	 localparam CASE4= 3'b100;

	 // brzr r1, 27 -> ?
	 // brnz r1, 27
	 // brpl r1, 27
	 // brmi r1, 27

	 initial begin
      clk = 0; forever #10 clk = ~clk;
	 end
	 initial begin
		clear <= 1; 
		#1 clear <= 0;
	 end
	 
	 initial begin
		  test_id = LD; 
		  case_num = CASE1;
		   
		  reset_signals();
		  move_pc({test_id, case_num});
		  
		  case(test_id)
			LD: begin
				ld_task(case_num);
			end
			ST: begin
				st_task(case_num);
			end
			ALU: begin
				alu_task(case_num);
			end
			BRANCH: begin
				branch_task(case_num);
			end
			JUMP: begin
			end
			SPECIAL: begin
			end
			OUT: begin
			end
		 endcase
		  
    end
	 

	  task ld_task(input [2:0] ld_case_num); begin
	 
		case(ld_case_num) 
		CASE1: begin
			init_task();
			////// T3  /////
			Grb <= 1; BAout <= 1; Yin <= 1; muxy_select <= 1;
			@(posedge clk)
			Grb <= 0; BAout <= 0; Yin <= 0; muxy_select <= 0;
			////// T4  /////
			Cout <= 1; opcode <= 5'b00011; rz_in <= 1; 
			@(posedge clk)
			Cout <= 0; rz_in <= 0; 
			////// T5  /////
			ZLowout <= 1; mar_in <= 1;
			@(posedge clk)
			ZLowout <= 0; mar_in <= 0;
			////// T6  /////
			mdr_in <= 1; mdr_read <= 1;
			@(posedge clk)
			mdr_in <= 0; mdr_read <= 0;
			////// T7  /////
			Gra <= 1; Rin <= 1; mdr_out <=1;
			@(posedge clk)
			Gra <= 0; Rin <= 0; mdr_out <=0;
		end
		
		CASE2: begin
			@(posedge clk)
			load_reg(32'hB1000000, 32'h78);
			init_task();
			
			////// T3  /////
			Grb <= 1; BAout <= 1; Yin <= 1; muxy_select <= 1;
			@(posedge clk)
			Grb <= 0; BAout <= 0; Yin <= 0; muxy_select <= 0;
			////// T4  /////
			Cout <= 1; opcode <= 5'b00011; rz_in <= 1; 
			@(posedge clk)
			Cout <= 0; rz_in <= 0; 
			////// T5  /////
			ZLowout <= 1; mar_in <= 1;
			@(posedge clk)
			ZLowout <= 0; mar_in <= 0;
			////// T6  /////
			mdr_in <= 1; mdr_read <= 1;
			@(posedge clk)
			mdr_in <= 0; mdr_read <= 0;
			////// T7  /////
			Gra <= 1; Rin <= 1; mdr_out <=1;
			@(posedge clk)
			Gra <= 0; Rin <= 0; mdr_out <=0;
		end 
		
		CASE3: begin
			init_task();
			////// T3  /////
			Grb <= 1; BAout <= 1; Yin <= 1; muxy_select <= 1;
			@(posedge clk)
			Grb <= 0; BAout <= 0; Yin <= 0; muxy_select <= 0;
			////// T4  /////
			Cout <= 1; opcode <= 5'b00011; rz_in <= 1; 
			@(posedge clk)
			Cout <= 0; rz_in <= 0; 
			////// T5  /////
			ZLowout <= 1; Gra <= 1; Rin <= 1;
			@(posedge clk)
			ZLowout <= 0; Gra <= 1; Rin <= 1;
		end
		
		
		CASE4: begin
			@(posedge clk)
			load_reg(32'hB1000000, 32'h78);
			// 10110 0010 
			
			init_task();
			////// T3  /////
			Grb <= 1; BAout <= 1; Yin <= 1; muxy_select <= 1;
			@(posedge clk)
			Grb <= 0; BAout <= 0; Yin <= 0; muxy_select <= 0;
			////// T4  /////
			Cout <= 1; opcode <= 5'b00011; rz_in <= 1; 
			@(posedge clk)
			Cout <= 0; rz_in <= 0; 
			////// T5  /////
			ZLowout <= 1; Gra <= 1; Rin <= 1;
			@(posedge clk)
			ZLowout <= 0; Gra <= 1; Rin <= 1;
		end
		endcase
		end endtask
		
		
// STORE ----------------------------------------------------------------------------------- STORE

		task st_task(input [2:0] st_case_num); begin
		
			case(st_case_num)
			CASE1: begin
				@(posedge clk)
				load_reg(32'hB1800000, 32'hB6); 
				init_task();
		
				////// T3  /////
				Grb <= 1; BAout <= 1; Yin <= 1; muxy_select <= 1;
				@(posedge clk)
				Grb <= 0; BAout <= 0; Yin <= 0; muxy_select <= 0;
				
				
				Gra <= 1; BAout <= 1;
				@(posedge clk)
				Gra <= 0; BAout <= 0;
				
				
				////// T4  /////
				Cout <= 1; opcode <= 5'b00011; rz_in <= 1; 
				@(posedge clk)
				Cout <= 0; rz_in <= 0; 
				
				////// T5  /////
				ZLowout <= 1; mar_in <= 1;
				@(posedge clk)
				ZLowout <= 0; mar_in <= 0;
				
				////// T6  /////
				Gra <= 1; BAout <= 1; mdr_in <= 1;
				@(posedge clk)
				Gra <= 0; BAout <= 0; mdr_in <= 0;

				////// T7  /////
				wren <= 1;
				@(posedge clk)
				wren <= 0;
				
					
			end
			
			// instrcutnn: 11980034	   0001 0001 1001 1000        
			
			CASE2: begin 
				@(posedge clk)
				load_reg(32'hB1800000, 32'hB6);
				init_task();
				
				////// T3  /////
				Grb <= 1; BAout <= 1; Yin <= 1; muxy_select <= 1;
				@(posedge clk)
				Grb <= 0; BAout <= 0; Yin <= 0; muxy_select <= 0;
				
				
				////// T4  /////
				Cout <= 1; opcode <= 5'b00011; rz_in <= 1; 
				@(posedge clk)
				Cout <= 0; rz_in <= 0;
				
				////// T5  /////
				ZLowout <= 1; mar_in <= 1;
				@(posedge clk)
				ZLowout <= 0; mar_in <= 0;
				
				////// T6  /////
				Gra <= 1; BAout <= 1; mdr_in <= 1;
				@(posedge clk)
				Gra <= 0; BAout <= 0; mdr_in <= 0;

				////// T7  /////
				wren <= 1;
				@(posedge clk)
				wren <= 0;
			
			end
			endcase
		
		
		end endtask
		
		
// ALU ------------------------------------------------------------------------------------------ ALU
		
		task alu_task(input [2:0] case_num); begin
			case(case_num)
				CASE1: begin
					load_reg(32'hB3000000, 32'd10); // NOT SURE WHAT VALUE SHOULD BE IN R6
					//10110 0110 
					init_task();
					///////// T3 //////////
					Grb <= 1; Rout <= 1; Yin <= 1; 
					@(posedge clk)
					Grb <= 0; Rout <= 0; Yin <= 0; 
					///////// T4 //////////
					Cout <= 1; opcode <= 5'b00011; rz_in <= 1;
					@(posedge clk)
					Cout <= 0; rz_in <= 0;
					///////// T5 //////////
					ZLowout <= 1; Gra <= 1; Rin <= 1;
					@(posedge clk)
					ZLowout <= 0; Gra <= 0; Rin <= 0;
				end
				CASE2: begin
					load_reg(32'hB3000000, 32'hFFFFFFFF); // NOT SURE WHAT VALUE SHOULD BE IN R6
					init_task();
					///////// T3 //////////
					Grb <= 1; Rout <= 1; Yin <= 1; 
					@(posedge clk)
					Grb <= 0; Rout <= 0; Yin <= 0;
					///////// T4 //////////
					Cout <= 1; opcode <= 5'b00101; rz_in <= 1;
					// INSTRUCTION!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 0010 1010 1011 -> 2AB00095
					@(posedge clk)
					Cout <= 0; rz_in <= 0;
					///////// T5 //////////
					ZLowout <= 1; Gra <= 1; Rin <= 1;
					@(posedge clk)
					ZLowout <= 0; Gra <= 0; Rin <= 0;
				end
				CASE3: begin
					load_reg(32'hB3000000, 32'hFFFF0000); // NOT SURE WHAT VALUE SHOULD BE IN R6
					//10110 0110 
					init_task();
					///////// T3 //////////
					Grb <= 1; Rout <= 1; Yin <= 1; 
					@(posedge clk)
					Grb <= 0; Rout <= 0; Yin <= 0; 
					///////// T4 //////////
					Cout <= 1; opcode <= 5'b00110; rz_in <= 1;
					// INSTRUCTION!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 0011 0010 1011 -> 32B00095
					@(posedge clk)
					Cout <= 0; rz_in <= 0;
					///////// T5 //////////
					ZLowout <= 1; Gra <= 1; Rin <= 1;
					@(posedge clk)
					ZLowout <= 0; Gra <= 0; Rin <= 0;
				end
			endcase
		end endtask
		
		
// BRANCH -------------------------------------------------------------------------------------------------- BRANCH
		
		task branch_task(input [2:0] case_num); begin 
			case(case_num)
				CASE1: begin // instrcuton: 1001 1000 1000 0000000000000000 27  -> 98800027
					load_reg(32'hB0800000, 32'h0); // 1011 0000 1000 (value 0 in R1) // 1011 0000 1000
					init_task();
					// T3 //
					Gra <= 1; Rout <= 1; con_in <= 1; 
					@(posedge clk)
					Gra <= 0; Rout <= 0; con_in <= 0;
					
					// T4 //
					pc_out <= 1; Yin <= 1;
					@(posedge clk) 
					pc_out <= 0; Yin <= 0;
					
					// T5 // 
					Cout <= 1; opcode <= 5'b00011; rz_in <= 1;
					@(posedge clk)
					Cout <= 0; rz_in <= 0;
					//0x60
					// pc 15 + 0x60  
					// T6 //
					ZLowout <= 1; pc_in <= con_out;
					@(posedge clk)
					ZLowout <= 0; pc_in <= 0;
					
				end
			endcase				
		
		end endtask
		
		
// ------------------------------------------------------------------------------------------------------------------
		
		task jump_task; begin
		init_task();

		end endtask
		
		task special_task; begin 
		init_task();
		
		end endtask
		
		task out_task; begin
		init_task();

		end endtask
		
		
	
	 
	 // DEFAULT STUFF I DONT WANNA LOOK AT
	 
	 task init_task; begin
 	   ////// T0  /////
   	pc_out <= 1; mar_in <= 1; inc_pc <= 1; rz_in <= 1; 
		@(posedge clk) 
		pc_out <= 0; mar_in <= 0;  rz_in <= 0;
		////// T1  /////
		mdr_read <= 1; mdr_in <= 1; ZLowout <= 1; pc_in <= 1;
		@(posedge clk)
		mdr_read <= 0; mdr_in <= 0; ZLowout <= 0; pc_in <= 0; inc_pc <= 0;
      ////// T2  /////
		mdr_out <= 1; ir_in <= 1; 
		@(posedge clk)
		mdr_out <= 0; ir_in <= 0;
		
		@(posedge clk);
	 end endtask
	 
	 task move_pc(input [7:0] pc_off);
	 begin
		@(posedge clk)
		pc_offset <= pc_off;
		set_pc_flag <= 1;
		@(posedge clk)
		set_pc_flag <= 0;
		pc_offset <= 8'b0;
	 end endtask
	 
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
	 .con_in(con_in),
	 .con_out(con_out),
	 .inport_data_in(inport_data_in),
	 .r3_data_out(r3_data_out),
	 .r4_data_out(r4_data_out),
	 .r5_data_out(r5_data_out),
	 .r6_data_out(r6_data_out),
	 .inport_data_out(inport_data_out),
	 .r2_data_out(r2_data_out),
	 .z_high_data_out(z_high_data_out),
	 .z_low_data_out(z_low_data_out),
	 .rz_data_out(rz_data_out),
	 .wren(wren),
	 .pc_offset(pc_offset),
	 .set_pc_flag(set_pc_flag)
	);
	
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
				con_in <= 0; 
        end
    endtask

	task load_reg (input [31:0] instruction, input [31:0] value); begin
		inport_data_in <= instruction; inport_in <= 1; opcode <= instruction[31:27];
		
		@(posedge clk)
		inport_out <= 1; ir_in <= 1; 
		#5 inport_data_in <= value;  //potential improvement? look after dis done

		@(posedge clk)
		inport_data_in <= 32'b0; inport_in <= 0;
		inport_out <= 1; Gra <= 1; Rin <= 1;
		
		@(posedge clk)
		inport_out <= 0; Gra <= 0; Rin <= 0;
		
	end endtask
	

endmodule