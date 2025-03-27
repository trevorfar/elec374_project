module notALU(
	input [31:0] A, //32 bit input
	output [31:0] Result //64 bit result

); 

	assign Result = ~A; 
	
endmodule
