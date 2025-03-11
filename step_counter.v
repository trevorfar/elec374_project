module step_counter (
    input wire clk,
    input wire clear,
    output reg [2:0] step
);
	


    always @(posedge clk or posedge clear) begin
        if (clear)
            step <= 3'b000;
        else if (step < 3'b111)
            step <= step + 1;
    end
endmodule