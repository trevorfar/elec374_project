
module ALU(
	input wire [31:0] A, 
	input wire [31:0] B,
	//input wire [31:0] Y,
	input wire clk,
	input wire [4:0] signal,
	output reg [63:0] result
);

	parameter add_code = 5'b00011, sub_code = 5'b00100, mul_code = 5'b01111, div_code = 5'b10000, 
	and_code = 5'b00101, or_code = 5'b00110, shr_code = 5'b01001, shra_code = 5'b01010, shl_code = 5'b01011,
	 ror_code = 5'b00111, rol_code = 5'b01000, neg_code = 5'b10001, not_code = 5'b10010, ld = 5'b00000, ldi = 5'b00001, st = 5'b00010,
	 addi = 5'b01101, andi = 5'b01101, ori = 5'b01110, branch = 5'b10011, jal = 5'b10100, jr = 5'b10101, in = 5'b10110, out = 5'b10111, mflo = 5'b11000,
	 mfhi = 5'b11001, nop =5'b11010, halt = 5'b11011; 
	 
	wire add_cout, sub_cout, div_remainder, cout, branch_flag;
	wire [31:0] add_result, sub_result, and_result, or_result, shr_result, shra_result, shl_result, ror_result, rol_result, neg_result, not_result;
	wire [63:0] mul_result, div_result;

	 andALU and_op (.A(A), .B(B), .Result(and_result));
    orALU or_op (.A(A), .B(B), .Result(or_result));
    notALU not_op (.A(B), .Result(not_result));
    adder add_op (.A(A), .B(B), .Result(add_result));
    subtractor sub_op (.A(A), .B(B), .Result(sub_result));
    booth mult_op (.Q(A), .M(B), .Result(mul_result));
    shiftLeft shl_op (.B(B), .shifts(A[5:0]), .Result(shl_result));
    shiftRight shr_op (.B(B), .shifts(A[5:0]), .Result(shr_result));
    sra sra_op (.B(B), .shifts(A[5:0]), .Result(shra_result));
    rotLeft rol_op (.B(B), .rotate(A[5:0]), .Result(rol_result));
    rotateRight ror_op (.B(B), .rotate(A[5:0]), .Result(ror_result));
    negALU neg_op (.A(B), .Result(neg_result));

    // Instantiate clock-based division module
    divisor div_op (
		  .reset(signal==5'b00110),
        .clk(clk),    // Pass clock to division module
        .Q(A),
        .M(B),
        .Result(div_result)
    );

	
always @(*) begin
		case(signal)
			add_code : begin
				result[63:32] <= 32'b0;
				result[31:0] <= add_result;
			end
			sub_code : begin
				result[63:0] <= $signed(sub_result);
			end
			mul_code : begin
				result[63:0] <= $signed(mul_result);
			end
			div_code : begin
				result[63:32] <= (div_result[63:32]); // FIGURE DIS OUT HERE
				result[31:0] <= (div_result[31:0]);
			end
			and_code, andi : begin
				result[63:32] <= 32'b0;
				result[31:0] <= and_result;
			end
			or_code, ori : begin
				result[63:0] <= $signed(or_result);
			end
			shr_code : begin
				result[63:0] <= $signed(shr_result);
			end
			shra_code : begin
				result[63:0] <= $signed(shra_result);
			end
			shl_code : begin
				result[63:0] <= $signed(shl_result);
			end
			ror_code : begin
				result[63:0] <= $signed(ror_result);
			end
			rol_code : begin
				result[63:0] <= $signed(rol_result);
			end
			neg_code : begin
				result[63:0] <= $signed(neg_result);
			end
			not_code : begin
				result[63:0] <= $signed(not_result);
			end
			ld, ldi, st, addi : begin
				result[31:0] <= (add_result);
				result[63:32] <= 32'b0;
			end
//			branch : begin
//				if(branch_flag == 1'b1) begin
//					result[31:0] <= (add_result);
//					result[63:32] <= 32'b0;
//				end else begin
//					result[31:0] <= RY[31:0];
//					result[63:32] <= 32'b0;
//				end
//			end
			in: begin
				result[63:0] <= 64'b0;
			end
		endcase 
end
endmodule