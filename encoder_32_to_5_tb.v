`timescale 1ns / 1ps

module encoder_32_to_5_tb;
	 reg [31:0] encoder_input;
	 wire [4:0] encoder_output;
	 
    encoder_32_to_5 uut (
		.encoder_input(encoder_input), .encoder_output(encoder_output)
    );
	 

    initial begin
        #10;
		  encoder_input = 32'd2;
		  #50;
		  encoder_input = 32'd4;
		  #50;
		  encoder_input = 32'd3;
		  #50;
		  $stop;
    end

endmodule
