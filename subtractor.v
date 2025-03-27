module subtractor(A, B, Result);
    input [31:0] A, B; 
    output [31:0] Result;

    wire [31:0] temp1;
    wire [31:0] temp2;
    wire [31:0] sub_result; // 64 bit subtraction result

    assign temp2 = ~{32'b0, B}; // Sign-extend B

    // Add 1 to get -B
    adder add1 (.A(temp2), .B(32'd1), .Result(temp1)); 

    // Perform A + (-B) = A - B
    adder add2 (.A(A), .B(temp1), .Result(sub_result)); 

    // 64-bit result
    assign Result = sub_result;
endmodule
