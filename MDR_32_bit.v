module MDR_32_bit(
	input [31:0] Mdatain,
	input [31:0] bus_mux_out,
	input wire clk, clear, MDRin, mdr_read,
	output reg [31:0] mdr_out
);
	wire [31:0] D;
	
	mux_2_to_1 MDRmux(.input0(bus_mux_out), .input1(Mdatain), .select(mdr_read), .mux_output(D));
	
	always @(posedge clk) begin
		if(clear) begin
			mdr_out <= 32'b0;
		end else if (MDRin) begin
			mdr_out <= D;
		end

	end 
	
endmodule
