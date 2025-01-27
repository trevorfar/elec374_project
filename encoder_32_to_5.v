module encoder_32_to_5(
	input wire [31:0] encoder_input, output reg [4:0] encoder_output
);
	always @(*) begin
		case(encoder_input)
				32'd1 : encoder_output <= 5'd0; 
				32'd2 : encoder_output <= 5'd1;
				32'd4 : encoder_output <= 5'd2; 
				32'd8 : encoder_output <= 5'd3; 
				32'd16 : encoder_output <= 5'd4; 
				32'd32 : encoder_output <= 5'd5;
				32'd64 : encoder_output <= 5'd6; 
				32'd128 : encoder_output <= 5'd7; 
				32'd256 : encoder_output <= 5'd8; 
				32'd512 : encoder_output <= 5'd9; 
				32'd1024 : encoder_output <= 5'd10; 
				32'd2048 : encoder_output <= 5'd11; 
				32'd4096 : encoder_output <= 5'd12; 
				32'd8192 : encoder_output <= 5'd13; 
				32'd16384 : encoder_output <= 5'd14; 
				32'd32768 : encoder_output <= 5'd15;
				32'd65538 : encoder_output <= 5'd16; 
				32'd131072 : encoder_output <= 5'd17; 
				32'd262144 : encoder_output <= 5'd18; 
				32'd524288 : encoder_output <= 5'd19; 
				32'd1048576 : encoder_output <= 5'd20; 
				32'd2097152 : encoder_output <= 5'd21; 
				32'd4194304 : encoder_output <= 5'd22; 
				32'd8388608 : encoder_output <= 5'd23;
				default: encoder_output <= 5'd31;
		endcase
	end
endmodule
