module mux_2_to_1(
	input [31:0] BusMuxOut, Mdatain,
	input wire [1] select,
	output wire [31:0] mux_output
);

	always @(*) begin
		case(select)
			1'b0 : mux_output <= BusMuxOut;
			1'b1 : mux_output <= Mdatain;
		endcase
	end
	
endmodule