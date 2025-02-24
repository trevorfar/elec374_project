module CON_FF(
input [31:0] bus_data,
input [1:0] ir_input, 
input clk,
input con_in,
output con_out
);
	wire [3:0] decoder; // 0000 = zero 0010 = not zero 0100 = gt 1000 = lt
	wire D, nor_out;
	wire Q, Q_not;
 
	assign nor_out = ~(|bus_data);
	decoder_2_to_4 decoderMod(.decoder_input(ir_input), .decoder_output(decoder));
	assign D = (decoder[0] & nor_out) | (decoder[1] & (~nor_out)) | (decoder[2] & ~bus_data[31]) | (decoder[3] & bus_data[31]);
	D_flip_flop flip(.D(D), .clk(clk), .Q(Q), .Q_not(Q_not));
	assign con_out = Q;


endmodule 
