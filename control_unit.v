`timescale 1ns/10ps
`include "defines.v"



module control_unit(
input wire clk, clear,
input  [31:0] ir_data_out,
output reg [31:0] control_signals,
output reg [2:0] step,
input wire run, stop, halt
);	 

// BONUS MARK DESIGN DECISIONS: 
/*
* Converted the control unit to a LUT (look up table) approach. instructions are indexed in essentially a "rom", and are grabbed based off of bitshifting the indexed values of the specific
control signals, (this creates one hot encoding) and then or'ing them. It is then producing a string (control signals) that is passed to the datapath. Each control signal is set to 0 every step.  
*/		


	reg [31:0] code_rom [0:255]; // LUT for instructions
   reg [2:0] step_limit [0:31]; // LUT to hold how many steps (cycles) each instruction holds (better approach somewhere maybe?)
	wire [4:0] opcode = ir_data_out[31:27];

	always @(posedge clk or posedge clear) begin
    if (clear) begin
        step <= 3'b000;
    end else if (stop || halt) begin
        step <= step;
    end else if (run) begin
        if (step == step_limit[opcode]) 
            step <= 3'b000; 
        else
            step <= step + 1; 
    end
end	
		
	
	
	 initial begin
			 code_rom[{`LD, 3'b011}] = `BIT(`GRB) | `BIT(`BAOUT) | `BIT(`YIN) | `BIT(`MUXY_SELECT);
			 code_rom[{`LD, 3'b100}] = `BIT(`COUT) | `BIT(`RZ_IN) | `BIT(`ALU_ADD);
			 code_rom[{`LD, 3'b101}] = `BIT(`ZLOWOUT) | `BIT(`MAR_IN); 
			 code_rom[{`LD, 3'b110}] = `BIT(`MDR_IN) | `BIT(`MDR_READ); 
			 code_rom[{`LD, 3'b111}] = `BIT(`GRA) | `BIT(`RIN) | `BIT(`MDR_OUT); 
			 step_limit[`LD] = 3'b111; //LD NOT TESTED
			 
			 code_rom[{`LDI, 3'b011}] = `BIT(`GRB) | `BIT(`BAOUT) | `BIT(`YIN) | `BIT(`MUXY_SELECT);
			 code_rom[{`LDI, 3'b100}] = `BIT(`COUT) | `BIT(`RZ_IN) | `BIT(`ALU_ADD); 
			 code_rom[{`LDI, 3'b101}] = `BIT(`ZLOWOUT) | `BIT(`GRA) | `BIT(`RIN); 
			 step_limit[`LDI] = 3'b101; //LDI		 
			 
			 code_rom[{`ST, 3'b011}] = `BIT(`GRB) | `BIT(`BAOUT) | `BIT(`YIN) | `BIT(`MUXY_SELECT);
 			 code_rom[{`ST, 3'b100}] = `BIT(`COUT) | `BIT(`RZ_IN) | `BIT(`ALU_ADD);
  			 code_rom[{`ST, 3'b101}] = `BIT(`ZLOWOUT) | `BIT(`MAR_IN);
			 code_rom[{`ST, 3'b110}] = `BIT(`GRA) | `BIT(`BAOUT) | `BIT(`MDR_IN);
			 code_rom[{`ST, 3'b111}] = `BIT(`WREN);
			 step_limit[`ST] = 3'b111; // ST NOT TESTED
			 
			 code_rom[{`ADDI, 3'b011}] = `BIT(`GRB) | `BIT(`ROUT) | `BIT(`YIN) | `BIT(`MUXY_SELECT);
			 code_rom[{`ADDI, 3'b100}] = `BIT(`COUT) | `BIT(`RZ_IN) | `BIT(`ALU_ADD);
			 code_rom[{`ADDI, 3'b101}] = `BIT(`ZLOWOUT) | `BIT(`GRA) | `BIT(`RIN); 
			 step_limit[`ADDI] = 3'b101; // ADDI
			 
			 code_rom[{`ANDI, 3'b011}] = `BIT(`GRB) | `BIT(`ROUT) | `BIT(`YIN) | `BIT(`MUXY_SELECT);
			 code_rom[{`ANDI, 3'b100}] = `BIT(`COUT) | `BIT(`RZ_IN) | `BIT(`ALU_ADD);
			 code_rom[{`ANDI, 3'b101}] = `BIT(`ZLOWOUT) | `BIT(`GRA) | `BIT(`RIN); 
			 step_limit[`ANDI] = 3'b101; // ANDI NOT TESTED
			 
			 
			 code_rom[{`ORI, 3'b011}] = `BIT(`GRB) | `BIT(`ROUT) | `BIT(`YIN) | `BIT(`MUXY_SELECT);
			 code_rom[{`ORI, 3'b100}] = `BIT(`COUT) | `BIT(`RZ_IN) | `BIT(`ALU_ADD);
			 code_rom[{`ORI, 3'b101}] = `BIT(`ZLOWOUT) | `BIT(`GRA) | `BIT(`RIN); 
			 step_limit[`ORI] = 3'b101; // ORI NOT TESTED

			 code_rom[{`ADD, 3'b011}] = `BIT(`GRB) | `BIT(`ROUT) | `BIT(`YIN);
			 code_rom[{`ADD, 3'b100}] = `BIT(`GRC) | `BIT(`ROUT) | `BIT(`RZ_IN) | `BIT(`ALU_ADD);
			 code_rom[{`ADD, 3'b101}] = `BIT(`ZLOWOUT) | `BIT(`GRA) | `BIT(`RIN); 
			 step_limit[`ADD] = 3'b101; // ADD NOT TESTED
			 
			 code_rom[{`SUB, 3'b011}] = `BIT(`GRB) | `BIT(`ROUT) | `BIT(`YIN);
			 code_rom[{`SUB, 3'b100}] = `BIT(`GRC) | `BIT(`ROUT) | `BIT(`RZ_IN) | `BIT(`ALU_ADD);
			 code_rom[{`SUB, 3'b101}] = `BIT(`ZLOWOUT) | `BIT(`GRA) | `BIT(`RIN); 
			 step_limit[`SUB] = 3'b101; // SUB NOT TESTED
			 
			 code_rom[{`AND, 3'b011}] = `BIT(`GRB) | `BIT(`ROUT) | `BIT(`YIN);
			 code_rom[{`AND, 3'b100}] = `BIT(`GRC) | `BIT(`ROUT) | `BIT(`RZ_IN);
			 code_rom[{`AND, 3'b101}] = `BIT(`ZLOWOUT) | `BIT(`GRA) | `BIT(`RIN); 
			 step_limit[`AND] = 3'b101; // AND NOT TESTED
			 
			 code_rom[{`OR, 3'b011}] = `BIT(`GRB) | `BIT(`ROUT) | `BIT(`YIN);
			 code_rom[{`OR, 3'b100}] = `BIT(`GRC) | `BIT(`ROUT) | `BIT(`RZ_IN);
			 code_rom[{`OR, 3'b101}] = `BIT(`ZLOWOUT) | `BIT(`GRA) | `BIT(`RIN); 
			 step_limit[`OR] = 3'b101; // OR NOT TESTED
			 
			 code_rom[{`SHL, 3'b011}] = `BIT(`GRB) | `BIT(`ROUT) | `BIT(`YIN);
			 code_rom[{`SHL, 3'b100}] = `BIT(`GRC) | `BIT(`ROUT) | `BIT(`RZ_IN);
			 code_rom[{`SHL, 3'b101}] = `BIT(`ZLOWOUT) | `BIT(`GRA) | `BIT(`RIN); 
			 step_limit[`SHL] = 3'b101; // SHL NOT TESTED
			 
			 code_rom[{`SHR, 3'b011}] = `BIT(`GRB) | `BIT(`ROUT) | `BIT(`YIN);
			 code_rom[{`SHR, 3'b100}] = `BIT(`GRC) | `BIT(`ROUT) | `BIT(`RZ_IN);
			 code_rom[{`SHR, 3'b101}] = `BIT(`ZLOWOUT) | `BIT(`GRA) | `BIT(`RIN); 
			 step_limit[`SHR] = 3'b101; // SHR NOT TESTED
			 
			 code_rom[{`SHRA, 3'b011}] = `BIT(`GRB) | `BIT(`ROUT) | `BIT(`YIN);
			 code_rom[{`SHRA, 3'b100}] = `BIT(`GRC) | `BIT(`ROUT) | `BIT(`RZ_IN);
			 code_rom[{`SHRA, 3'b101}] = `BIT(`ZLOWOUT) | `BIT(`GRA) | `BIT(`RIN); 
			 step_limit[`SHRA] = 3'b101; // SHRA NOT TESTED
			 
			 code_rom[{`ROR, 3'b011}] = `BIT(`GRB) | `BIT(`ROUT) | `BIT(`YIN);
			 code_rom[{`ROR, 3'b100}] = `BIT(`GRC) | `BIT(`ROUT) | `BIT(`RZ_IN);
			 code_rom[{`ROR, 3'b101}] = `BIT(`ZLOWOUT) | `BIT(`GRA) | `BIT(`RIN); 
			 step_limit[`ROR] = 3'b101; // ROR NOT TESTED
			 
			 code_rom[{`ROL, 3'b011}] = `BIT(`GRB) | `BIT(`ROUT) | `BIT(`YIN);
			 code_rom[{`ROL, 3'b100}] = `BIT(`GRC) | `BIT(`ROUT) | `BIT(`RZ_IN);
			 code_rom[{`ROL, 3'b101}] = `BIT(`ZLOWOUT) | `BIT(`GRA) | `BIT(`RIN); 
			 step_limit[`ROL] = 3'b101; // ROL NOT TESTED
			 
			 code_rom[{`NEG, 3'b011}] = `BIT(`GRA) | `BIT(`ROUT) | `BIT(`YIN);
			 code_rom[{`NEG, 3'b100}] = `BIT(`GRB) | `BIT(`ROUT) | `BIT(`RZ_IN);
			 code_rom[{`NEG, 3'b101}] = `BIT(`ZLOWOUT) | `BIT(`GRA) | `BIT(`RIN); 
			 step_limit[`NEG] = 3'b101; // NEG NOT TESTED
			 
			 code_rom[{`NOT, 3'b011}] = `BIT(`GRA) | `BIT(`ROUT) | `BIT(`YIN);
			 code_rom[{`NOT, 3'b100}] = `BIT(`GRB) | `BIT(`ROUT) | `BIT(`RZ_IN);
			 code_rom[{`NOT, 3'b101}] = `BIT(`ZLOWOUT) | `BIT(`GRA) | `BIT(`RIN); 
			 step_limit[`NOT] = 3'b101; // NOT isnt TESTED
			 
			  
			 code_rom[{`MUL, 3'b011}] = `BIT(`GRA) | `BIT(`ROUT) | `BIT(`YIN);
			 code_rom[{`MUL, 3'b100}] = `BIT(`GRB) | `BIT(`ROUT) | `BIT(`RZ_IN);
			 code_rom[{`MUL, 3'b101}] = `BIT(`ZLOWOUT) | `BIT(`LO_IN);
			 code_rom[{`MUL, 3'b110}] = `BIT(`ZHIGHOUT)| `BIT(`HI_IN); 
			 step_limit[`MUL] = 3'b110; // MUL WORK AND IS TESTED
			 
			 
			 code_rom[{`DIV, 3'b011}] = `BIT(`GRA) | `BIT(`ROUT) | `BIT(`YIN);
			 code_rom[{`DIV, 3'b100}] = `BIT(`GRB) | `BIT(`ROUT) | `BIT(`RZ_IN);
			 code_rom[{`DIV, 3'b101}] = `BIT(`ZLOWOUT) | `BIT(`LO_IN);
			 code_rom[{`DIV, 3'b110}] = `BIT(`ZHIGHOUT)| `BIT(`HI_IN); 
			 step_limit[`DIV] = 3'b110; // DIV NOT TESTED 
			 
			 code_rom[{`BRANCH, 3'b011}] = `BIT(`GRA) | `BIT(`ROUT) | `BIT(`CON_IN);
			 code_rom[{`BRANCH, 3'b100}] = `BIT(`PC_OUT) | `BIT(`YIN) | `BIT(`MUXY_SELECT);
			 code_rom[{`BRANCH, 3'b101}] = `BIT(`COUT) | `BIT(`RZ_IN) | `BIT(`ALU_ADD);
			 code_rom[{`BRANCH, 3'b110}] = `BIT(`ZLOWOUT) | `BIT(`PC_IN);
			 step_limit[`BRANCH] = 3'b110; //BRANCH NOT TESTED
			 
			 
			 
			
//				code_rom[{`ADDI, 3'b011}] = `BIT(`GRB) | `BIT(`ROUT) | `BIT(`YIN) | `BIT(`MUXY_SELECT);
//				code_rom[{`ADDI, 3'b100}] = `BIT(`COUT) | `BIT(`RZ_IN) | `BIT(`ALU_ADD);
//				code_rom[{`ADDI, 3'b101}] = `BIT(`ZLOWOUT) | `BIT(`GRA) | `BIT(`RIN); 
//				step_limit[`ADDI] = 3'b101; // ADDI
//			
//					// T4 //
//					pc_out <= 1; Yin <= 1;
//					@(posedge clk) 
//					pc_out <= 0; Yin <= 0;
//					
//					// T5 // 
//					Cout <= 1; opcode <= 5'b00011; rz_in <= 1;
//					@(posedge clk)
//					Cout <= 0; rz_in <= 0;
//			
//					// T6 //
//					ZLowout <= 1; pc_in <= con_out;
//					@(posedge clk)
//					ZLowout <= 0; pc_in <= 0;
//				end
//	
//			 
			 

			 // 0110 0101 0001 0000 = 0x65100032 
/*//10011 0011 000 1000 0000000000 
			 //ox99880004
			 
			 step_limit[`BRANCH]
			 
			 step_limit[`JAL]
			 
			 step_limit[`JR]
			 
			 step_limit[`IN]
			 
			 step_limit[`OUT]
			 
			 step_limit[`MFLO]
			 
			 step_limit[`MFHI]
			 
			 step_limit[`NOP]
			 
			 step_limit[`HALT]
			 */
	 end
	 
	 always @(step) begin
	 control_signals = 32'b0;
		 case(step)
			3'b000: control_signals = `BIT(`PC_OUT) | `BIT(`MAR_IN) | `BIT(`RZ_IN);
			3'b001: control_signals = `BIT(`MDR_READ) | `BIT(`MDR_IN) | `BIT(`ZLOWOUT) | `BIT(`PC_IN) | `BIT(`INC_PC);													
			3'b010: control_signals = `BIT(`MDR_OUT) | `BIT(`IR_IN);
			default: begin
				if(step <= 3'b111)
					control_signals = code_rom[{opcode, step}];
			end
				
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



endmodule
*/