module reg_64_bit #(parameter DATA_WIDTH_IN = 64, DATA_WIDTH_OUT = 64, INIT = 64'h0)
(
	input clk,
	input clear,
	input enable,
	input [DATA_WIDTH_IN-1:0]BusMuxOut,
	output wire [DATA_WIDTH_OUT-1:0]BusMuxIn
);

reg [DATA_WIDTH_IN-1:0] q;	
initial q = INIT;

always @(posedge clk)
	begin
		if (clear) begin
			q <= {DATA_WIDTH_IN{1'b0}};
		end
		else if (enable) begin
			q <= BusMuxOut;
		end
	end
	assign BusMuxIn = q[DATA_WIDTH_OUT-1:0];
endmodule
