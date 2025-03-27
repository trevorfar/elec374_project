module rotLeft(
 
	input [31:0] B, //32 bit input
	input [5:0] rotate, //rotate amount
	output [63:0] Result //64 bit output

);
	assign Result = (B<<rotate)|(B>>(64-rotate));
endmodule
