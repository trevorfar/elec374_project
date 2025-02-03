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
	
	wire [31:0] adder_sum, adder_cout;
	
	adder_32_bit adder(.a(RA), .b(RB), .cin({1'b0}), .sum(adder_sum), .cout(adder_cout));

	always @(*) begin
		case(opcode)
			add_code : begin
				RZ[31:0] <= adder_sum[31:0];
				RZ[63:32] <= 32'b0;
			end
		//	: ;
		//	: ;
		//	: ;
		//	: ;
		//	: ;
		//	: ;
		//	: ;
		//	: ;
		//	: ;
		//	: ;
		//	: ;
		//	: ;
		//	: ;
		//	: ;
		//	: ;
		// 
		endcase 
	end
	
	
endmodule