//module reg_32_bit(
//	input clk,
//	input clk_r,
//	input enable,
//	input [31:0] d,
//	output [31:0] q
//);
//	inital q = 32'b0;
//	
//	always @(posedge clk)
//	begin
//		if (clkr) begin
//			q[31:0] = 32'b0;
//		end
//		else if (enable) begin
//			q[31:0] = d[31:0];
//		end
//	end
//endmodule