`timescale 1ns / 1ps

module booth_mul_32_tb;
    reg signed [31:0] a, b;
    wire signed [63:0] z;

    bp_booth_mul_32 uut (
        .a(a),
        .b(b),
        .z(z)
    );

    initial begin
		  a=8'b01110011; b=8'b11110010;
		  #10
        // Test 1: Positive x Positive
        a = 32'd15; b = 32'd10;
        #10 

        // Test 2: Positive x Negative
        a = 32'd12; b = -32'd5;
        #10 
        // Test 3: Negative x Positive
        a = -32'd7; b = 32'd6;
        #10 
        // Test 4: Negative x Negative
        a = -32'd9; b = -32'd11;
        #10 
        // Test 5: Edge Case (Maximum/Minimum)
        a = 32'h7FFFFFFF; b = 32'h80000000; // Max positive x Min negative
        #10 
        $stop;
    end
endmodule
