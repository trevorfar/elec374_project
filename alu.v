module alu(
	input wire [31:0] RA, 
	input wire [31:0] RB,
	input wire [4:0] opcode,
	output reg [63:0] RZ
);

	wire cout;

	parameter add_code = 5'b00000, sub_code = 5'b00001, mul_code = 5'b00010, div_code = 5'b00011, 
	and_code = 5'b00100, or_code = 5'b00101, shr_code = 5'b00110, shra_code = 5'b00111, shl_code = 5'b01000,
	 ror_code = 5'b01001, rol_code = 5'b01011, neg_code = 5'b01100, not_code = 5'b01101;
	 
	wire add_cout, sub_cout, div_remainder;
	wire [31:0] add_out, sub_out, mul_out, div_out, and_out, or_out, shr_out, shra_out, shl_out, ror_out, rol_out, neg_out, not_out;
	
	adder_32_bit add_mod(.a(RA), .b(RB), .cin({1'b0}), .sum(add_out), .cout(add_cout));
	subtractor_32_bit sub_mod(.a(RA), .b(RB), .cin({1'b0}), .sum(sub_out), .cout(sub_cout));
	bp_booth_mul_32 mul_mod(.a(RA), .b(RB), .z(mul_out));  
	div_32_bit div_mod(.dividend(RA), .divisor(RB), .quotient(div_out), .remainder(div_remainder));
	and_32_bit and_module(.a(RA), .b(RB), .z(and_out));
	or_32_bit or_module( .a(RA), .b(RB), .z(or_out));
	shr_32_bit shr(.a(RA), .shifts(RB), .z(shr_out));
	shra_32_bit shra_mod( .a(RA), .shifts(RB), .z(shra_out));
	shl_32_bit shl_mod(.a(RA), .shifts(RB), .z(shl_out)); //
	ror_32_bit ror_mod(.a(RA), .numRotates(RB), .z(ror_out));
	rol_32_bit rol_mod(.a(RA), .numRotates(RB), .z(rol_out));
	neg_32_bit neg_mod(.a(RA), .z(neg_out));
	not_32_bit not_module(.a(RA), .z(not_out)); //

	always @(*) begin
		case(opcode)
			add_code : begin
				RZ[63:0] <= $signed(add_out);
			end
			sub_code : begin
				RZ[63:0] <= $signed(sub_out);
			end
			mul_code : begin
				RZ[63:0] <= $signed(mul_out);
			end
			div_code : begin
				RZ[63:0] <= $signed(div_out);
			end
			and_code : begin
				RZ[63:0] <= $signed(and_out);
			end
			or_code : begin
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
		endcase 
	end
	
	
endmodule