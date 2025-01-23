`timescale 1ns / 1ps

module mux_2_to_1_tb; 

    reg [31:0] BusMuxOut;
    reg [31:0] Mdatain; 
    reg select;

    wire [31:0] mux_output;

    mux_2_to_1 uut(
        .BusMuxOut(BusMuxOut), 
        .Mdatain(Mdatain), 
        .select(select), 
        .mux_output(mux_output)
    );

    initial begin
	
        BusMuxOut = 32'd16; 
        Mdatain = 32'd32; 
        select = 0;
        #50;
        select = 1;
        #50;
		  
		  $stop;
    end
endmodule
