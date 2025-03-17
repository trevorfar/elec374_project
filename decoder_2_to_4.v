module decoder_2_to_4(input wire [1:0] decoder_input, output reg [3:0] decoder_output);
	always@(*) begin
		case(decoder_input)
					2'b00 : decoder_output <= 4'h1;
					2'b01 : decoder_output <= 4'h2;
					2'b10 : decoder_output <= 4'h4;
					2'b11 : decoder_output <= 4'h8;
      		endcase
   	end
endmodule
