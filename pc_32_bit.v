module pc_32_bit #(parameter DATA_WIDTH_IN = 32, DATA_WIDTH_OUT = 32, INIT = 32'h0)
(
	input clk,
	input clear,
	input enable,
	input [DATA_WIDTH_IN-1:0]immediate,
	output wire [DATA_WIDTH_OUT-1:0]pc
);

reg [DATA_WIDTH_IN-1:0] q;	
initial q = INIT;

always @(posedge clk)
	begin
		if(clear) begin
			q <= {DATA_WIDTH_IN{1'b0}};
		end else if (enable) begin
			q <= q + 1;
		end else begin
			q <= immediate;
		end
	end
	assign pc = q[DATA_WIDTH_OUT-1:0];
endmodule
