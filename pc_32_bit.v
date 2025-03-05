module pc_32_bit #(parameter DATA_WIDTH_IN = 32, DATA_WIDTH_OUT = 32, INIT = 32'h0)
(
	input clk,
	input clear,
	input enable, inc_pc,
	
	input set_pc_flag,//del after
	input [3:0] pc_offset,//del after
	
	input [DATA_WIDTH_IN-1:0]immediate,
	output reg [DATA_WIDTH_OUT-1:0] pc
);

reg [DATA_WIDTH_IN-1:0] q;	
initial q = INIT;

always @(posedge clk)
	begin
		if(clear) begin
			q <= {DATA_WIDTH_IN{1'b0}};
		end else if (enable == 1'b1 && inc_pc == 1'b1) begin
			q <= q + 1;
		end else if (enable ==1'b1) begin
			q <= immediate;
		end else if (set_pc_flag) begin//del after
			q <= q + pc_offset; //del after
		end
		pc <= q[DATA_WIDTH_OUT-1:0];
	end
endmodule
