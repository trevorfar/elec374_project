module PC_register #(
    parameter DATA_WIDTH_IN = 32, 
    parameter DATA_WIDTH_OUT = 32, 
    parameter INIT = 32'd1
)(
    input clear, clock, Rin, Inc,
    input [DATA_WIDTH_IN-1:0] BusMuxOut,
    output wire [DATA_WIDTH_OUT-1:0] BusMuxIn
);

    reg [DATA_WIDTH_IN-1:0] q;

    initial q = INIT;

    always @(posedge clock) begin
        if (clear) begin
            q <= {DATA_WIDTH_IN{1'b0}};
        end 
        else if (Inc && Rin) begin
            q <= q + 1;       // Increment PC when Inc is high
        end
		  else if (Rin) begin
            q <= BusMuxOut;   // Load new value into PC
        end
    end
	 assign BusMuxIn = q;


endmodule
