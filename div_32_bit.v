//module div_32_bit(
//    
//    input [31:0] Q,
//    input [31:0] M,
//    input clk, reset,
//	 
//    output [31:0] quotient,
//    output [31:0] remainder
//
//);
//    reg [63:0] AQ_reg;
//    integer count;	 
//
//	always @(posedge clk) begin
//		
//		if (~reset) begin
//			AQ_reg = 64'b0;
//			count = 0;
//		
//		end
//		
//		else if (count == 0) begin
//			
//			count = count + 1;
//			
//			AQ_reg = {32'b0, Q};
//			
//		end
//		
//		else if (count >= 1 && count <= 32) begin
//		
//			count = count + 1;
//			AQ_reg = AQ_reg << 1;
//			
//			if (AQ_reg[63] == 1'b0) begin
//				AQ_reg[63:32] = AQ_reg[63:32] - M;
//			end
//			else begin
//				AQ_reg[63:32] = AQ_reg[63:32] + M;
//			end
//			
//			AQ_reg[0] = (AQ_reg[63] == 1'b0) ? 1'b1 : 1'b0;
//		
//		end
//		
//		else if (AQ_reg[63] == 1) begin
//		
//			AQ_reg[63:32] = AQ_reg[63:32] + M;
//			
//		end
//		
//	end
//
//	assign quotient = AQ_reg[31:0];
//   assign remainder = AQ_reg[63:32];	
//
//endmodule

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
    
