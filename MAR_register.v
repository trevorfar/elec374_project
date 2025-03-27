module MAR_register(
	input wire clk, 
	input wire clear,
	input wire mar_in,
	input wire [31:0] bus_data,
	output [8:0] mar_address_out
);
	wire [31:0] MAR_data_out;
	register MAR(.clk(clk), .clear(clear), .Rin(mar_in), .BusMuxOut(bus_data), .BusMuxIn(MAR_data_out));	
	assign mar_address_out = MAR_data_out[8:0];
endmodule

