`timescale 1ns/10ps
`include "defines.v"

module control_unit(
input wire clk, clear,
input  [31:0] ir_data_out,
output reg [31:0] control_signals
);	 
	
	
	reg [2:0] step;
	step_counter steps(.clk(clk), .clear(clear), .step(step));
	
	
	
	
	 reg [31:0] code_rom [0:127]; // 16 steparooni's

	 initial begin
			//this represents a load instruction
			 code_rom[{`LD, 3'b011}] = `GRB | `BAOUT | `YIN | `MUXY_SELECT;
			 code_rom[{`LD, 3'b100}] = `COUT | `RZ_IN | `ALU_ADD; // NEED TO SET 1 BIT TO SPECIFY AN ADD OPCODE 
			 code_rom[{`LD, 3'b101}] = `ZLOWOUT | `MAR_IN;
			 code_rom[{`LD, 3'b110}] = `MDR_IN | `MDR_READ;
			 code_rom[{`LD, 3'b111}] = `GRA | `RIN | `MDR_OUT;
	 end
	 
	 always @(*) begin
	 control_signals = 32'b0;
		 case(step) 
			3'b000: control_signals = `PC_OUT | `MAR_IN | `INC_PC | `RZ_IN; 
			3'b001: control_signals = `MDR_READ | `MDR_IN | `ZLOWOUT | `PC_IN;													
			3'b010: control_signals = `MDR_OUT | `IR_IN;
			default: control_signals = code_rom[{ir_data_out[31:27], step}];
		 endcase
	 end
	endmodule
	
	/*
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
			ZLowout <= 0; Gra <= 0; Rin <= 0;
		end
		
		
		CASE4: begin
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
			ZLowout <= 1; Gra <= 1; Rin <= 1;
			@(posedge clk)
			ZLowout <= 0; Gra <= 0; Rin <= 0;
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
					init_task();
					///////// T3 //////////
					Grb <= 1; Rout <= 1; Yin <= 1; 
					@(posedge clk)
					Grb <= 0; Rout <= 0; Yin <= 0;
					///////// T4 //////////
					Cout <= 1; opcode <= 5'b00101; rz_in <= 1;
					@(posedge clk)
					Cout <= 0; rz_in <= 0;
					///////// T5 //////////
					ZLowout <= 1; Gra <= 1; Rin <= 1;
					@(posedge clk)
					ZLowout <= 0; Gra <= 0; Rin <= 0;
				end
				CASE3: begin
					init_task();
					///////// T3 //////////
					Grb <= 1; Rout <= 1; Yin <= 1; 
					@(posedge clk)
					Grb <= 0; Rout <= 0; Yin <= 0; 
					///////// T4 //////////
					Cout <= 1; opcode <= 5'b00110; rz_in <= 1;
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
				CASE1: begin 
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
			
					// T6 //
					ZLowout <= 1; pc_in <= con_out;
					@(posedge clk)
					ZLowout <= 0; pc_in <= 0;
				end
			CASE2: begin      
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
		
				// T6 //
				ZLowout <= 1; pc_in <= con_out;
				@(posedge clk)
				ZLowout <= 0; pc_in <= 0;
			
			end
			
			CASE3: begin
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
		
				// T6 //
				ZLowout <= 1; pc_in <= con_out;
				@(posedge clk)
				ZLowout <= 0; pc_in <= 0;
			end
			
			CASE4: begin 
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
		
				// T6 //
				ZLowout <= 1; pc_in <= con_out;
				@(posedge clk)
				ZLowout <= 0; pc_in <= 0;
			end

			endcase				
		
		end endtask
		
		
// -------------------------------------------j--------------------------u-----------mp--------------------------------------------
		
		task jump_task(input [2:0] case_num); begin
			case(case_num)
				CASE1: begin // this is jr r8 (1010 1100 = 0xAC000000)
					init_task();
				
					// T3 //
					Gra <= 1; Rout <= 1; pc_in <= 1;
					@(posedge clk)
					Gra <= 0; Rout <= 0; pc_in <= 0;
					
				
				end
				CASE2: begin 
					init_task();
					// T3 //
					Gra <= 1; Rout <= 1; pc_in <= 1;
					@(posedge clk)
					Gra <= 0; Rout <= 0; pc_in <= 0;				
				end
			endcase
		end endtask
		
		
// SPECIAL ------------------------------------------------------------------------------------ SPECIAL
		
		task special_task(input [2:0] case_num); begin
			case(case_num)
				CASE1: begin  // this is mfhi r3 (11001 0011 1000-> C9C00000) was c9800000
					init_task();
				
					Grb <= 1; Rout <= 1; HI_in <= 1;
					@(posedge clk)
					Grb <= 0; Rout <= 0; HI_in <= 0;
					
					Gra <= 1; Rin <= 1; HI_out <= 1; 
					@(posedge clk)
					Gra <= 0; Rin <= 0; HI_out <= 0; 
					
					
				
				end
				CASE2: begin     // was c1000000 but now its C1400000 to have r8 as grb
					init_task(); 
					Grb <= 1; Rout <= 1; LO_in <= 1;
					@(posedge clk)
					Grb <= 0; Rout <= 0; LO_in <= 0;
					
					Gra <= 1; Rin <= 1; LO_out <= 1; 
					@(posedge clk)
					Gra <= 0; Rin <= 0; LO_out <= 0; 
					
				end				
			endcase		
		end endtask 
		
		
// OUT ------------------------------------------------------------------------------------------- OUT
		
		task out_task; begin
		load_reg(32'hB3000000, 32'd12);
		init_task();
		
		Gra <= 1; Rout <= 1; outport_in <= 1;
		@(posedge clk)
		Gra <= 0; Rout <= 0; outport_in <= 0;
		end endtask
		

// INITS, ETC ----------------------------------------------------------------------------- INITS, ETC
	
	 
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
		inport_out <= 0; Gra <= 0; Rin <= 0; ir_in <= 0;
		
	end endtask
endmodule

*/

