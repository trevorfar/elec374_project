module sra (
    input signed [31:0] B,   // 32-bit signed input 
    input [5:0] shifts,      // Shift amount
    output [31:0] Result     // 64-bit output
);
	 assign Result = B >>> shifts;

endmodule
