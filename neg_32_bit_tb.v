`timescale 1ns / 1ps

module neg_32_bit_tb;

reg [31:0] a;
wire [31:0] sum;
wire z;

neg_32_bit uut(.a(a), .sum(sum), .z(z));

initial begin
		  a = -32'd16; 
		  #50;	
		  a = 32'd16; 
		  #50
		 $stop;
end
endmodule


