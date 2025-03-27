module shiftLeft (
    input [31:0] B,      // 32 bit input 
    input [5:0] shifts,  // shift amount 
    output [31:0] Result // 64 bit output
);
    assign Result = B << shifts; // Account for 64 bit output
endmodule
