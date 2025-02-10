`timescale 1ns / 1ps

module alu_tb;

reg [31:0] a;
reg [31:0] b;
reg cin; 
reg clk;
reg reset;
wire [63:0] RZ;
wire cout;
reg [4:0] opcode;

alu uut(.RA(a), .RB(b), .opcode(opcode), .RZ(RZ));


initial begin 
clk = 0; 
reset = 0;
forever #10 clk = ~clk;
end

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
		  
		  opcode = 5'b00110;
		  a = 32'd6; b=32'd1; 
		  #50;
		  
		  opcode = 5'b00011;
		  a = 32'd36; b = 32'd6;
		  #50;
		  
//		  opcode = 5'b00110;
//		  a = 32'h00000001; 
		 $stop;
end
endmodule
