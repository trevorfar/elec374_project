`timescale 1ns / 1ps

module alu_tb;

reg [31:0] a;
reg [31:0] b;
reg cin;
wire [63:0] sum;
wire cout;
reg [4:0] opcode;

alu uut(.RA(a), .RB(b), .opcode(opcode), .RZ(sum));

initial begin
		  opcode = 5'b00000;
		  a = 32'd8; b = 32'd8; cin = 1'b0;
		  #50;
		 
		  
		  opcode = 5'b00010;
		  a = 32'd16; b= 32'd8;
		  #50;
		  a = -32'd8; b= 32'd8;
		  #50;
		  a = 32'd8; b=-32'd8;
		  #50;
		  a = -32'd8; b=-32'd8;
		  #50;
		  
		  opcode = 5'b01101;
		  a = -32'd8; b=-32'd8;
		  #50;
		  
		  opcode = 5'b01100;
		  a = 32'd6;
		  #50;
		 $stop;
end
endmodule
