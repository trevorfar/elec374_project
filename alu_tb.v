`timescale 1ns / 1ps

module alu_tb;

reg [31:0] a;
reg [31:0] b;
reg cin;
wire [63:0] sum;
wire cout;

alu uut(.RA(a), .RB(b), .opcode(5'b00000), .RZ(sum));

initial begin
		  a = 32'b0100_0100_0100_0100_0100_0100_0100; b = 32'b0100_0100_0100_0100_0100_0100_0100; cin = 1'b0;
		  #50;
		  a = 32'b1000_0001_0001_0001_0001_0001_0001; b = 32'b1000_0001_0001_0001_0001_0001_0001; cin = 1'b0;
		  #50
		  a = -32'd16; b=-32'd8; cin = 1'b0;
		  #50
		  a = 32'd16; b=-32'd8; cin = 1'b0;
		  #50
		  
		 $stop;
end
endmodule
