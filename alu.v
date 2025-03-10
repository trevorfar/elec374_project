module alu(
	input wire [31:0] RA, 
	input wire [31:0] RB,
	input wire [31:0] RY,
	input wire [4:0] opcode,
	output reg [63:0] RZ
);
	`define LD 5'b00000
	`define LDI 5'b00001
	`define ST 5'b00010
	`define ADD 5'b00011
	`define SUB 5'b00100
	`define AND 5'b00101
	`define OR 5'b00110
	`define ROR 5'b00111
	`define ROL 5'b01000
	`define SHR 5'b01001
	`define SHRA 5'b01010
	`define SHL 5'b01011
	`define ADDI 5'b01100
	`define ANDI 5'b01101
	`define ORI 5'b01110
	`define MUL 5'b01111
	`define DIV 5'b10000
	`define NEG 5'b10001
	`define NOT 5'b10010
	`define BRANCH 5'b10011
	`define JAL 5'b10100
	`define JR 5'b10101
	`define IN 5'b10110
	`define OUT 5'b10111
	`define MFLO 5'b11000
	`define MFHI 5'b11001
	`define NOP 5'b11010
	`define HALT 5'b11011
		

	wire add_cout, sub_cout, div_remainder, cout, branch_flag;
	wire [31:0] add_out, sub_out, div_out_Q, div_out_R, and_out, or_out, shr_out, shra_out, shl_out, ror_out, rol_out, neg_out, not_out;
	wire [63:0] mul_out;
	
	adder_32_bit add_mod(.a(RA), .b(RB), .cin({1'b0}), .sum(add_out), .cout(add_cout));
	subtractor_32_bit sub_mod(.a(RA), .b(RB), .cin({1'b0}), .sum(sub_out), .cout(sub_cout));
	bp_booth_mul_32 mul_mod(.a(RA), .b(RB), .z(mul_out));  
	div_32_bit div_mod(.dividend(RA), .divisor(RB),  .quotient(div_out_Q), .remainder(div_out_R));
	and_32_bit and_module(.a(RA), .b(RB), .z(and_out));
	or_32_bit or_module( .a(RA), .b(RB), .z(or_out));
	shr_32_bit shr(.a(RA), .shifts(RB), .z(shr_out));
	shra_32_bit shra_mod( .a(RA), .shifts(RB), .z(shra_out));
	shl_32_bit shl_mod(.a(RA), .shifts(RB), .z(shl_out)); 
	ror_32_bit ror_mod(.a(RA), .numRotates(RB[4:0]), .z(ror_out));
	rol_32_bit rol_mod(.a(RA), .numRotates(RB[4:0]), .z(rol_out));
	neg_32_bit neg_mod(.a(RA), .z(neg_out));
	not_32_bit not_module(.a(RA), .z(not_out)); 

	always @(*) begin
		case(opcode)
			case(opcode)
			`ADD : begin
				RZ[63:32] <= 32'b0;
				RZ[31:0] <= add_out;
			end
			`SUB : begin
				RZ[63:0] <= $signed(sub_out);
			end
			`MUL : begin
				RZ[63:0] <= $signed(mul_out);
			end
			`DIV : begin
				RZ[63:32] <= (div_out_R);
				RZ[31:0] <= (div_out_Q);
			end
			`AND, `ANDI : begin
				RZ[63:32] <= 32'b0;
				RZ[31:0] <= and_out;
			end
			`OR, `ORI : begin
				RZ[63:0] <= $signed(or_out);
			end
			`SHR : begin
				RZ[63:0] <= $signed(shr_out);
			end
			`SHRA : begin
				RZ[63:0] <= $signed(shra_out);
			end
			`SHL : begin
				RZ[63:0] <= $signed(shl_out);
			end
			`ROR : begin
				RZ[63:0] <= $signed(ror_out);
			end
			`ROL : begin
				RZ[63:0] <= $signed(rol_out);
			end
			`NEG : begin
				RZ[63:0] <= $signed(neg_out);
			end
			`NOT : begin
				RZ[63:0] <= $signed(not_out);
			end
			`LD, `LDI, `ST, `ADDI : begin
				RZ[31:0] <= (add_out);
				RZ[63:32] <= 32'b0;
			end
			`BRANCH : begin
				if(branch_flag == 1'b1) begin
					RZ[31:0] <= (add_out);
					RZ[63:32] <= 32'b0;
				end else begin
					RZ[31:0] <= RY[31:0];
					RZ[63:32] <= 32'b0;
				end
			end
			`IN: begin
				RZ[63:0] <= 64'b0;
			end
		endcase 
	end
endmodule

