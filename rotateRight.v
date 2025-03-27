module rotateRight(
 
	input [31:0] B, // 32 bit input
	input [4:0] rotate, //rotate amount 
	output [31:0] Result // 64 bit result

);
	assign Result = (B>>rotate)|(B<<(32-rotate));
endmodule
