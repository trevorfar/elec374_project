module alu(
	input wire [31:0] RA, 
	input wire [31:0] RB,
	input wire [31:0] RY,
	input wire [4:0] opcode,
	output reg [63:0] RZ
);

	parameter add_code = 5'b00011, sub_code = 5'b00100, mul_code = 5'b01111, div_code = 5'b10000, 
	and_code = 5'b00101, or_code = 5'b00110, shr_code = 5'b01001, shra_code = 5'b01010, shl_code = 5'b01011,
	 ror_code = 5'b00111, rol_code = 5'b01000, neg_code = 5'b10001, not_code = 5'b10010, ld = 5'b00000, ldi = 5'b00001, st = 5'b00010,
	 addi = 5'b01101, andi = 5'b01101, ori = 5'b01110, branch = 5'b10011, jal = 5'b10100, jr = 5'b10101, in = 5'b10110, out = 5'b10111, mflo = 5'b11000,
	 mfhi = 5'b11001, nop =5'b11010, halt = 5'b11011; 
	 
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
			add_code : begin
				RZ[63:32] <= 32'b0;
				RZ[31:0] <= add_out;
			end
			sub_code : begin
				RZ[63:0] <= $signed(sub_out);
			end
			mul_code : begin
				RZ[63:0] <= $signed(mul_out);
			end
			div_code : begin
				RZ[63:32] <= (div_out_R); // FIGURE DIS OUT HERE
				RZ[31:0] <= (div_out_Q);
			end
			and_code, andi : begin
				RZ[63:32] <= 32'b0;
				RZ[31:0] <= and_out;
			end
			or_code, ori : begin
				RZ[63:0] <= $signed(or_out);
			end
			shr_code : begin
				RZ[63:0] <= $signed(shr_out);
			end
			shra_code : begin
				RZ[63:0] <= $signed(shra_out);
			end
			shl_code : begin
				RZ[63:0] <= $signed(shl_out);
			end
			ror_code : begin
				RZ[63:0] <= $signed(ror_out);
			end
			rol_code : begin
				RZ[63:0] <= $signed(rol_out);
			end
			neg_code : begin
				RZ[63:0] <= $signed(neg_out);
			end
			not_code : begin
				RZ[63:0] <= $signed(not_out);
			end
			ld, ldi, st, addi : begin
				RZ[31:0] <= (add_out);
				RZ[63:32] <= 32'b0;
			end
			branch : begin
				if(branch_flag == 1'b1) begin
					RZ[31:0] <= (add_out);
					RZ[63:32] <= 32'b0;
				end else begin
					RZ[31:0] <= RY[31:0];
					RZ[63:32] <= 32'b0;
				end
			end
			in: begin
			// NEED TO FIX THIS!!!!! JACQUIE DID SOMETHING FUNKY!!!!
			// DO WE HAVE A FUNCTION FOR THE INPORT?
				RZ[63:0] <= 64'b0;
			end
			
		endcase 
	end
endmodule

