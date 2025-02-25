module select_and_encode(
input wire Gra, Grb, Grc, Rin, Rout, BAout,
input [31:0] instruction, 
output wire [15:0] reg_in, reg_out,
output wire [31:0] C_sign_extended,
output [4:0] opcode

);
wire [3:0] decoder_input;

assign decoder_input = (instruction[26:23] & {4{Gra}}) | (instruction[22:19] & {4{Grb}}) | (instruction[18:15] & {4{Grc}});
assign opcode = instruction [31:27];
decoder_4_to_16 decode(.decoder_input(decoder_input), .decoder_output(decoder_output));
assign reg_in = (decoder_output & {16{Rin}}); // theoretically should be fine? It'd be like saying 000....001 & 111.....111 = 000....001 which would be r0
assign reg_out = decoder_output & ({16{Rout}} | {16{BAout}});
assign C_sign_extended = {{13{instruction[18]}},instruction[18:0]};

endmodule