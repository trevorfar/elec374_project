`timescale 1ns / 1ps

module subtractor_32_bit_tb;

reg [31:0] a;
reg [31:0] b;
reg cin;
wire [31:0] sum;
wire cout;

subtractor_32_bit uut(.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

initial begin
		  a = 32'sb0100_0100_0100_0100_0100_0100_0100; b = 32'sb0100_0100_0100_0100_0100_0100_0100; cin = 1'b0;
		  #50;	
		  a = 32'sb0100; b = 32'sb0010; cin = 1'b0;
		  #50
		  a=-32'd8; b=-32'd4;
		  #50
		  a=-32'd16; b=32'd8; 
		  #50
		 $stop;
end
endmodule


