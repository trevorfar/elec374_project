module bp_booth_mul_32(
    input signed [31:0] a, 
    input signed [31:0] b, 
    output reg [63:0] z
);

    reg [2:0] cc[15:0];       // Booth control signals (for bit-pair encoding)
    reg [33:0] pp[15:0];      // Partial products (sign-extended)
    reg signed [63:0] spp[15:0]; // Shifted partial products
    reg signed [63:0] product;   // Final product

    integer j;
	 
    always @(*) begin
        cc[0] = {b[1], b[0], 1'b0};  // First pair includes implicit 0
        for (j = 1; j < 16; j = j + 1) begin
            cc[j] = {b[2 * j + 1], b[2 * j], b[2 * j - 1]};
        end

        for (j = 0; j < 16; j = j + 1) begin   
             case (cc[j])   
                3'b000, 3'b111: pp[j] = 32'b0;           // 0 * a
                3'b001, 3'b010: pp[j] = a;      // +1 * a
                3'b011: pp[j] = a<<1;               // +2 * a
                3'b100: pp[j] = -a<<1;           // -2 * a
                3'b101, 3'b110: pp[j] = -a;           // -1 * a
                default: pp[j] = 32'b0;                  // Default case for safety
            endcase

            spp[j] = $signed(pp[j]) << (2 * j); // Shift left by 2-bit position
        end

        product = 0; // Initialize product
		  
        for (j = 0; j < 16; j = j + 1) begin
            product = product + spp[j];
        end

        z = product;
    end
endmodule
