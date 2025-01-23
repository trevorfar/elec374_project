`timescale 1ns / 1ps

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

module mux_2_to_1_tb; 

reg [31:0] BusMuxOut;
reg [31:0] Mdatain; 
wire [1] select;
wire [31:0] mux_output;

mux_2_to_1(.BusMuxOut(BusMuxOut), .Mdatain(Mdatain), 
.select(select), .mux_output(mux_output));

initial begin
	
	BusMuxOut = 32'd16; Mdatain = 32'd32; select = 0;
	#50
	BusMuxOut = 32'd16; Mdatain = 32'd32; select = 1;
	#50
end
endmodule