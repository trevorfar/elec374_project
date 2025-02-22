module reg_32_bit 
(
	input clk,
	input clear,
	input enable,
	input [31:0]BusMuxOut,
	output reg [31:0]BusMuxIn
);

always @(posedge clk or posedge clear)
	begin
		if (clear) begin
			BusMuxIn <= {32{1'b0}};
		end
		else if (enable) begin
			BusMuxIn <= BusMuxOut;
		end
	end
endmodule
