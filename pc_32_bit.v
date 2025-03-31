module pc_32_bit #(parameter DATA_WIDTH_IN = 32, DATA_WIDTH_OUT = 32, INIT = 32'h0)
(
	input clk,
	input clear,
	input enable, inc_pc, con_out,
	input [DATA_WIDTH_IN-1:0]immediate,
	output reg [DATA_WIDTH_OUT-1:0] pc
);

reg [DATA_WIDTH_IN-1:0] q;	
initial q = INIT;

always @(posedge clk or posedge clear) begin
		if(clear) begin
			q <= {DATA_WIDTH_IN{1'b0}};
		end else if (con_out == 1'b1 && enable) begin
			q 
		end
		else if (enable == 1'b1) begin
			if(inc_pc == 1'b1) begin
				q <= q + 1;
			end else begin
				q <= immediate;
			end
		end
		pc <= q[DATA_WIDTH_OUT-1:0];
end
endmodule
