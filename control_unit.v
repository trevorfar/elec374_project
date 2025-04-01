`timescale 1ns/10ps
`include "defines.v"



module control_unit(
input wire clk, clear,
input  [31:0] ir_data_out,
output reg [31:0] control_signals,
output reg [2:0] step,
input wire stop,
input wire con_out,
output reg run
);	 

// BONUS MARK DESIGN DECISIONS: 
/*
* Converted the control unit to a LUT (look up table) approach. instructions are indexed in essentially a "rom", and are grabbed based off of bitshifting the indexed values of the specific
control signals, (this creates one hot encoding) and then or'ing them. It is then producing a string (control signals) that is passed to the datapath. Each control signal is set to 0 every step.  
*/		
	

	reg [31:0] code_rom [0:255]; // LUT for instructions
   reg [2:0] step_limit [0:31]; // LUT to hold how many steps (cycles) each instruction holds (better approach somewhere maybe?)
	wire [4:0] opcode = ir_data_out[31:27];
	reg halt;
	
	

	always @(posedge clk or posedge clear) begin
    if (clear) begin
        step <= 3'b000;
        halt <= 0; 
		  run <= 1;    
    end else if (halt || stop) begin
        step <= step; 
    end else if (run) begin
			   code_rom[{`BRANCH, 3'b110}] = `BIT(`ZLOWOUT) | (`BIT(`PC_IN) & {32{con_out}});
        if (opcode == `HALT) begin
            halt <= 1;
        end else if (step >= step_limit[opcode]) begin
            step <= 3'b000; 
        end else begin
            step <= step + 1; 
        end
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
			 code_rom[{`ST, 3'b110}] = `BIT(`GRA) | `BIT(`ROUT) | `BIT(`MDR_IN);
			 code_rom[{`ST, 3'b111}] = `BIT(`WREN);
			 step_limit[`ST] = 3'b111; // ST NOT TESTED
			 
			 code_rom[{`ADDI, 3'b011}] = `BIT(`GRB) | `BIT(`ROUT) | `BIT(`YIN) | `BIT(`MUXY_SELECT);
			 code_rom[{`ADDI, 3'b100}] = `BIT(`COUT) | `BIT(`RZ_IN) | `BIT(`ALU_ADD);
			 code_rom[{`ADDI, 3'b101}] = `BIT(`ZLOWOUT) | `BIT(`GRA) | `BIT(`RIN); 
			 step_limit[`ADDI] = 3'b101; // ADDI
			 
			 code_rom[{`ANDI, 3'b011}] = `BIT(`GRB) | `BIT(`ROUT) | `BIT(`YIN) | `BIT(`MUXY_SELECT);
			 code_rom[{`ANDI, 3'b100}] = `BIT(`COUT) | `BIT(`RZ_IN);
			 code_rom[{`ANDI, 3'b101}] = `BIT(`ZLOWOUT) | `BIT(`GRA) | `BIT(`RIN); 
			 step_limit[`ANDI] = 3'b101; // ANDI NOT TESTED
			 
			 code_rom[{`ORI, 3'b011}] = `BIT(`GRB) | `BIT(`ROUT) | `BIT(`YIN) | `BIT(`MUXY_SELECT);
			 code_rom[{`ORI, 3'b100}] = `BIT(`COUT) | `BIT(`RZ_IN) | `BIT(`ALU_ADD);
			 code_rom[{`ORI, 3'b101}] = `BIT(`ZLOWOUT) | `BIT(`GRA) | `BIT(`RIN); 
			 step_limit[`ORI] = 3'b101; // ORI NOT TESTED

			 code_rom[{`ADD, 3'b011}] = `BIT(`GRB) | `BIT(`ROUT) | `BIT(`YIN);
			 code_rom[{`ADD, 3'b100}] = `BIT(`GRC) | `BIT(`ROUT) | `BIT(`RZ_IN);
			 code_rom[{`ADD, 3'b101}] = `BIT(`ZLOWOUT) | `BIT(`GRA) | `BIT(`RIN); 
			 step_limit[`ADD] = 3'b101; // ADD NOT TESTED
			 
			 code_rom[{`SUB, 3'b011}] = `BIT(`GRB) | `BIT(`ROUT) | `BIT(`YIN);
			 code_rom[{`SUB, 3'b100}] = `BIT(`GRC) | `BIT(`ROUT) | `BIT(`RZ_IN);
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
			 code_rom[{`BRANCH, 3'b100}] = `BIT(`PC_OUT) | `BIT(`YIN);//| `BIT(`MUXY_SELECT);
			 code_rom[{`BRANCH, 3'b101}] = `BIT(`COUT) | `BIT(`RZ_IN) | `BIT(`ALU_ADD);
			 code_rom[{`BRANCH, 3'b111}] = 32'd0;//`BIT(`ZLOWOUT) | `BIT(`PC_IN);
			 step_limit[`BRANCH] = 3'b111;//BRANCH NOT TESTED
			 
			 
			 code_rom[{`JAL, 3'b011}] = `BIT(`PC_OUT) | `BIT(`R8_IN);
			 code_rom[{`JAL, 3'b100}] = `BIT(`GRA) | `BIT(`ROUT) | `BIT(`PC_IN);
			  code_rom[{`JAL, 3'b101}] = 32'd0;
			 step_limit[`JAL] = 3'b101; //JAL NOT TESTED
			 
			
			 code_rom[{`JR, 3'b011}] = `BIT(`GRA) | `BIT(`ROUT) | `BIT(`PC_IN);
			 step_limit[`JR] = 3'b011; // JR NOT TESTED 
			 
			 code_rom[{`IN, 3'b011}] = `BIT(`GRA) | `BIT(`ROUT) | `BIT(`INPORT_OUT);
			 step_limit[`IN] = 3'b011; // IN
			 
			 code_rom[{`OUT, 3'b011}] = `BIT(`GRA) | `BIT(`ROUT) | `BIT(`OUTPORT_IN);
			 step_limit[`OUT] = 3'b011; // OUT
			 
			 code_rom[{`MFLO, 3'b011}] = `BIT(`GRA) | `BIT(`RIN) | `BIT(`LO_OUT);
			 step_limit[`MFLO] = 3'b011; // MFLO
			 
			 code_rom[{`MFHI, 3'b011}] = `BIT(`GRA) | `BIT(`RIN) | `BIT(`HI_OUT);
			 step_limit[`MFHI] = 3'b011; // MFHI
			 
			 code_rom[{`NOP, 3'b011}] = 32'b0;
			 step_limit[`NOP] = 3'b011; // NOP
			 
			 code_rom[{`HALT, 3'b011}] = 32'b0;
			 code_rom[{`HALT, 3'b100}] = 32'b0;
			 code_rom[{`HALT, 3'b101}] = 32'b0;
			 step_limit[`HALT] = 3'b101;		
	 end
	 
	 wire [7:0] rom_index = {opcode, step};
	 
	 always @(step) begin
	 control_signals = 32'b0;
		 case(step)
			3'b000: control_signals = `BIT(`PC_OUT) | `BIT(`MAR_IN) | `BIT(`RZ_IN);
			3'b001: control_signals = `BIT(`MDR_READ) | `BIT(`MDR_IN) | `BIT(`ZLOWOUT);													
			3'b010: control_signals = `BIT(`MDR_OUT) | `BIT(`IR_IN) | `BIT(`PC_IN) | `BIT(`INC_PC);
			default: begin
				if(step <= 3'b111)
					if(opcode == 5'b11111) begin
						control_signals = 32'b0;
					end
					else begin
						control_signals = code_rom[rom_index];
					end
			end
				
		 endcase
	 end
	endmodule
	
