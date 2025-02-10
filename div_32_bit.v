module div_32_bit(
    
    input [31:0] Q,
    input [31:0] M,
    input clk, reset,
	 
    output [31:0] quotient,
    output [31:0] remainder

);
    reg [63:0] AQ_reg;
    integer count;	 

	always @(posedge clk) begin
		
		if (~reset) begin
		
			AQ_reg = 64'b0;
			count = 0;
		
		end
		
		else if (count == 0) begin
			
			count = count + 1;
			
			AQ_reg = {32'b0, Q};
			
		end
		
		else if (count >= 1 && count <= 32) begin
		
			count = count + 1;
			AQ_reg = AQ_reg << 1;
			
			if (AQ_reg[63] == 1'b0) begin
				AQ_reg[63:32] = AQ_reg[63:32] - M;
			end
			else begin
				AQ_reg[63:32] = AQ_reg[63:32] + M;
			end
			
			AQ_reg[0] = (AQ_reg[63] == 1'b0) ? 1'b1 : 1'b0;
		
		end
		
		else if (AQ_reg[63] == 1) begin
		
			AQ_reg[63:32] = AQ_reg[63:32] + M;
			
		end
		
	end

	assign quotient = AQ_reg[31:0];
   assign remainder = AQ_reg[63:32];	

endmodule






	
		
		
	
    


   

    

    

    
