

module ram #(
	parameter depth = 9,
	parameter width = 32
	)(
	input clk, wr_en,
	input [depth-1:0] r_addr, w_addr,
	input [width-1:0] w_data,
	output [width-1:0] r_data
	);
	

	reg [width-1:0] memory_array [0:2**depth-1];
	
	
	initial $readmemh("C:/Users/21tof1/elec374_project/ram.txt", memory_array);
	assign r_data = memory_array[r_addr];
	always @(posedge clk) begin
		if (wr_en) memory_array[w_addr] <= w_data; 
	end
	
	//9A100002 - 12  021FFFFA - 10
endmodule