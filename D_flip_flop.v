module D_flip_flop(D,clk, con_in, Q, Q_not);

input D; 
input clk;
input con_in;
output reg Q; 
output reg Q_not;

initial begin
	Q <= 0;
	Q_not <= 1;
end

always @(posedge clk) 
	begin
	if (con_in == 1'b1) begin 
		Q <= D; 
		Q_not <= ~D;
	end 
end
endmodule 
