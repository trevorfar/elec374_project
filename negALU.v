module negALU(
    input [31:0] A, //32 bit input
    output [31:0] Result //64 bit output
);
    assign Result = ~A + 1; 
endmodule
