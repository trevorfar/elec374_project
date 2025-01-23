module mux_32_to_1(
	input [31:0] R0, R1, R2, R3, R4, R5, R6, R7, 
	R8, R9, R10, R11, R12, R13, R14, R15,
	HI, LO, Z_HI, Z_LO, PC, MDR, IN_PORT, C_sign_extended,
	input wire [4:0] select,
	output wire [31:0] BusMuxOut
);

	always @(*) begin
		case(select)
			5'd0 : BusMuxOut <= R0 [31:0]; 
			5'd1 : BusMuxOut <= R1 [31:0];
			5'd2 : BusMuxOut <= R2 [31:0]; 
			5'd3 : BusMuxOut <= R3 [31:0]; 
			5'd4 : BusMuxOut <= R4 [31:0]; 
			5'd5: BusMuxOut <= R5 [31:0];
			5'd6 : BusMuxOut <= R6 [31:0]; 
			5'd7 : BusMuxOut <= R7 [31:0]; 
			5'd8 : BusMuxOut <= R8 [31:0]; 
			5'd9 : BusMuxOut <= R9 [31:0]; 
			5'd10 : BusMuxOut <= R10 [31:0]; 
			5'd11 : BusMuxOut <= R11 [31:0]; 
			5'd12 : BusMuxOut <= R12 [31:0]; 
			5'd13 : BusMuxOut <= R13 [31:0]; 
			5'd14 : BusMuxOut <= R14 [31:0]; 
			5'd15 : BusMuxOut <= R15 [31:0];
			5'd16 : BusMuxOut <= HI [31:0]; 
			5'd17 : BusMuxOut <= LO [31:0]; 
			5'd18 : BusMuxOut <= Z_HI [31:0]; 
			5'd19 : BusMuxOut <= Z_LO [31:0]; 
			5'd20 : BusMuxOut <= PC [31:0]; 
			5'd21 : BusMuxOut <= MDR [31:0]; 
			5'd22 : BusMuxOut <= IN_PORT [31:0]; 
			5'd23 : BusMuxOut <= C_sign_extended [31:0];
			default: BusMuxOut <= 32'b0;
		endcase
	end
	


endmodule