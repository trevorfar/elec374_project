`timescale 1ns / 1ps

module div_32_bit_tb;

    reg [31:0] dividend;
    reg [31:0] divisor;
    wire [31:0] quotient;
    wire [31:0] remainder;

    div_32_bit uut (
        .dividend(dividend),
        .divisor(divisor),
        .quotient(quotient),
        .remainder(remainder)
    );

    initial begin
        dividend = 32'b1000_0000_0000_0000_0000_0000_0000; 
        divisor = 32'b0000_1000_0000_0000_0000_0000_0000; 
        #50;

        dividend = 32'd250; 
        divisor = 32'd25; 
        #50;

        dividend = 32'd100; 
        divisor = 32'd30; 
        #50;

        dividend = 32'd5; 
        divisor = 32'd10; 
        #50;

        dividend = 32'd12345; 
        divisor = 32'd1; 
        #50;

        $stop; 
    end
endmodule
