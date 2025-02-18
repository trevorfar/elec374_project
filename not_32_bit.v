
module not_32_bit(
	input wire [31:0] a,
	output wire [31:0] z
);

genvar i;

generate
	for(i = 0; i<32; i = i+1) begin : and_loop 
		assign z[i] = !a[i];
	end
	
endgenerate

endmodule