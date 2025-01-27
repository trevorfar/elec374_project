module encoder_32_to_5(
	input wire [31:0] encoder_input, output reg [4:0] encoder_output
);
	always @(*) begin
		case(encoder_input)
				5'd1 : encoder_output <= 5'd0; 
				5'd2 : encoder_output <= 5'd1;
				5'd4 : encoder_output <= 5'd2; 
				5'd8 : encoder_output <= 5'd3; 
				5'd16 : encoder_output <= 5'd4; 
				5'd32 : encoder_output <= 5'd5;
				5'd64 : encoder_output <= 5'd6; 
				5'd128 : encoder_output <= 5'd7; 
				5'd256 : encoder_output <= 5'd8; 
				5'd512 : encoder_output <= 5'd9; 
				5'd1024 : encoder_output <= 5'd10; 
				5'd2048 : encoder_output <= 5'd11; 
				5'd4096 : encoder_output <= 5'd12; 
				5'd8192 : encoder_output <= 5'd13; 
				5'd16384 : encoder_output <= 5'd14; 
				5'd32768 : encoder_output <= 5'd15;
				5'd65538 : encoder_output <= 5'd16; 
				5'd131072 : encoder_output <= 5'd17; 
				5'd262144 : encoder_output <= 5'd18; 
				5'd524288 : encoder_output <= 5'd19; 
				5'd1048576 : encoder_output <= 5'd20; 
				5'd2097152 : encoder_output <= 5'd21; 
				5'd4194304 : encoder_output <= 5'd22; 
				5'd8388608 : encoder_output <= 5'd23;
		endcase
	end
endmodule
