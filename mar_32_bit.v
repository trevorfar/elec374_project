module mar_32_bit 
(
	input clk,
	input clear,
	input enable, 
	input [31:0] BusMuxOut,
	output reg [8:0] mar_address_out
);

always @(posedge clk or posedge clear)
	begin
		if (clear) begin
			mar_address_out <= {9{1'b0}};
		end
		else if (enable) begin
			mar_address_out <= BusMuxOut[8:0];
		end
	end
endmodule
