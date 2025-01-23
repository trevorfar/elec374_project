module mux_2_to_1(
	input [31:0] BusMuxOut, Mdatain,
	input  select,
	output reg [31:0] mux_output
);
	always @(*) begin
		case(select)
			1'b0 : mux_output <= BusMuxOut;
			1'b1 : mux_output <= Mdatain;
			default: mux_output <= 32'b0; 
		endcase
	end
endmodule
