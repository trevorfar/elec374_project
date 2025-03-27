module register_64( output reg[31:0] z_high_data_out,
		  output reg[31:0] z_low_data_out, 
		  input [63:0] Zdatain, 
		  input clk, 
		  input clear, 
		  input rz_in);


	always@(posedge clk or posedge clear)
		begin 
		if (clear) begin
			z_high_data_out = 32'b0;
			z_low_data_out = 32'b0;
		end else if (rz_in) begin
			z_high_data_out = Zdatain[63:32];
			z_low_data_out = Zdatain[31:0];
		end
		end
		
endmodule