module seven_segment_display_out(
    output reg [7:0] seven_out,
    input clk,
    input [3:0] data
);

always @(posedge clk)
begin
    case (data[3:0])
        4'b0000: seven_out <= 8'b11000000;
        4'b0001: seven_out <= 8'b11111001;
        4'b0010: seven_out <= 8'b10100100;
        4'b0011: seven_out <= 8'b10110000;
        4'b0100: seven_out <= 8'b10011001;
        4'b0101: seven_out <= 8'b10010010;
        4'b0110: seven_out <= 8'b10000010;
        4'b0111: seven_out <= 8'b11111000;
        4'b1000: seven_out <= 8'b10000000;
        4'b1001: seven_out <= 8'b10010000;
        4'b1010: seven_out <= 8'b10001000;
        4'b1011: seven_out <= 8'b10000011;
        4'b1100: seven_out <= 8'b11000110;
        4'b1101: seven_out <= 8'b10100001;
        4'b1110: seven_out <= 8'b10000110;
        4'b1111: seven_out <= 8'b10001110;
    endcase
end

endmodule