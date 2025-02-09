
module div_32_bit_tb;
    reg [31:0] Q;
    reg [31:0] M;
    reg clk, resetn;
    wire [31:0] quotient;
    wire [31:0] remainder;

    div_32_bit uut (
        .Q(Q),
        .M(M),
        .clk(clk),
		  .resetn(resetn),
        .quotient(quotient),
        .remainder(remainder)
    );
    always begin
	     clk = 0;
        forever #5 clk = ~clk;
    end

	initial begin
		  
		resetn = 0;

		@ (posedge clk)

		resetn = 1;
		Q = 32'd38;  
		M = 32'd6;   

		#340;  

		@ (posedge clk)
		
		resetn = 0;

		@ (posedge clk)

		resetn = 1;
		Q = 32'd100;
		M = 32'd25;
		#340;
		
		@ (posedge clk)
		
		resetn = 0;

		@ (posedge clk)

		resetn = 1;
		Q = {0,{31{1'b1}}};
		M = {0,{31{1'b1}}};
		#340;
		
		@ (posedge clk)
		
		resetn = 0;
		
		@ (posedge clk)

		resetn = 1;
		Q = {0,{31{1'b1}}};
		M = 32'b1;
		#340;
		
		@ (posedge clk)
		
		resetn = 0;
		
		@ (posedge clk)

		resetn = 1;
		Q = 32'b1;
		M = 32'd50;
		#340;
		
		@ (posedge clk)
		
		resetn = 0;
		
		@ (posedge clk)
		$stop;
	end
	endmodule
