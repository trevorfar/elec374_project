module MDR_register(
	input [31:0] Mdatain,
	input [31:0] bus_mux_out,
	input wire clk, clear, mdr_in, mdr_read,
	output reg [31:0] mdr_data_out
);
	wire [31:0] D;
//	always @(*) begin 
//	mdr_data_out <= 32'h00000018;
//	end
	///*
	
	mux_2_to_1 MDRmux(.input0(bus_mux_out), .input1(Mdatain), .select(mdr_read), .mux_output(D));
	//assign D = mdr_read ? Mdatain : bus_mux_out;
	//assign D = Mdatain;
	//assign D = 32'h00000012;

	always @(posedge clk or posedge clear) begin
		if(clear) 
			mdr_data_out <= 32'b0;
		else if (mdr_in)
			mdr_data_out <= D;
	end 
	//*/
endmodule