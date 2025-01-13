module booth_mul_32(
	input signed [31:0] M_input,
	input signed [31:0] Q_input,
	output reg signed [63:0] Z // output of 2 32 bit multiplications will be 32*2-1:0
);
	reg signed [31:0] A, M, Q;
	reg Q_1;
	reg [5:0] count;
	
	always @(*)
	begin
		A = 32'b0;
		M = M_input;
		Q = Q_input;
		Q_1 = 1'b0;
		Z = 64'b0;
		
		for(count = 0; count < 32; count = count+1) begin
			case ({Q[0], Q_1})
				2'b01: A = A + M; // add the multiplicand
				2'b10: A = A - M; // subtract multiplicand (same as flipping to 2's)
				default: A = A;
			endcase
			{A, Q, Q_1} = {A[31], A, Q}; // shr
		end
	   Z = {A, Q}; // combine to create final prod
	end	
endmodule