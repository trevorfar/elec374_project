`timescale 1ns/10ps

module z_reg( output reg[31:0] z_high_data_out,
		  output reg[31:0] z_low_data_out, 
		  input [63:0] Zdatain, 
		  input clk, 
		  input clear, 
		  input rz_in);

	wire [63:0] temp_z_out;
	reg_64_bit reg_64(.clk(clk), .clear(clear), .enable(rz_in), .BusMuxOut(Zdatain), .BusMuxIn(temp_z_out));

	always@(*)
begin
	 z_high_data_out = temp_z_out[63:32];
	 z_low_data_out = temp_z_out[31:0];
end
endmodule