module D_flip_flop(D,clk, sync_reset, Q, Q_not);

input D; 
input clk;
input sync_reset;
output reg Q; 
output reg Q_not;

initial begin 
	Q <= 0;
	Q <= 1;
end

always @(posedge clk) 
	begin
	if(sync_reset==1'b1) begin
		Q <= 1'b0;
		Q_not <= 1'b1;
	end
	else begin 
		Q <= D; 
		Q_not <= ~D;
	end 
end
endmodule 
