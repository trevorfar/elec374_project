module sra (
    input signed [31:0] B,   // 32-bit signed input 
    input [5:0] shifts,      // Shift amount
    output [63:0] Result     // 64-bit output
);
    wire signed [63:0] extended_B; // Extend B to 64 bits while preserving sign

    assign extended_B = {{32{B[31]}}, B};  // Extend B to 64 bits with sign extension
    assign Result = extended_B >>> shifts;

endmodule
