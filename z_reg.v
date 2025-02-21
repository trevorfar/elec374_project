`timescale 1ns/10ps

module z_reg( output reg[31:0] z_high_out,
		  output reg[31:0] z_low_out, 
		  input [63:0] z_in, 
		  input clk, 
		  input clr, 
		  input enable);

	wire [63:0] temp_z_out;

	reg_64_bit reg_64(temp_z_out, z_in, clk, clr, enable);

	always@(*)
begin
	 z_high_out = temp_z_out[63:32];
	 z_low_out = temp_z_out[31:0];
end
endmodule