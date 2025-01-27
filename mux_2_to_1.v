module mux_2_to_1(
	input [31:0] input0, input1,
	input  select,
	output reg [31:0] mux_output
);
	always @(*) begin
		case(select)
			1'b0 : mux_output <= input0;
			1'b1 : mux_output <= input1;
			default: mux_output <= 32'b0; 
		endcase
	end
endmodule
