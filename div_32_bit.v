module div_32_bit(
	input [31:0] dividend,
	input [31:0] divisor,
	output reg [31:0] quotient,
	output reg [31:0] remainder
);
	reg [63:0] remainder_reg;
	reg [5:0] counter;
	
	integer i;
	
	always @(*) begin
		remainder_reg = {32'b0, dividend};
		quotient = {32{1'b0}};
		
		for(i = 0; i < 32; i = i + 1) begin
			remainder_reg = remainder_reg << 1;
			remainder_reg[63:32] = remainder_reg[63:32] - divisor;

			if(remainder_reg[63]) begin // neg
				remainder_reg[63:32] = remainder_reg[63:32] + divisor;
				remainder_reg[0] = 1'b0;
				
			end else begin
				remainder_reg[0] = 1'b1;
			end
			
		quotient = remainder_reg[31:0];
		remainder = remainder_reg[63:32];
		end
	end
endmodule