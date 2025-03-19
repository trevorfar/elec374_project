module D_flip_flop(D,clk, con_in, Q, Q_not, reset);

input D; 
input clk;
input con_in;
input reset;
output reg Q; 
output Q_not;

initial begin
	Q <= 0;
end


always @(posedge clk or posedge reset) 
	begin
	 if(reset) 
		Q <= 0;
    else if (con_in) 
      Q <= D;
    end

	 assign Q_not = ~Q;
endmodule 
