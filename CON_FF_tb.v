`timescale 1ns / 1ps

module CON_FF_tb;
    reg [31:0] bus_data;
    reg [1:0] ir_input;
    reg clk;
    reg con_in;
    
    wire con_out;
    
    CON_FF uut (
        .bus_data(bus_data),
        .ir_input(ir_input),
			  .clk(clk),
	  .con_in(con_in),
        .con_out(con_out)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        con_in = 0;
        bus_data = 32'b0;
        ir_input = 2'b00;
        
        #10 bus_data = 32'h00000001; ir_input = 2'b00; con_in = 0;
		  
		  
        #10 bus_data = 32'hFFFFFFFF; ir_input = 2'b01; con_in = 0;
        #10 bus_data = 32'hA5A5A5A5; ir_input = 2'b10; con_in = 1;
        #10 bus_data = 32'h5A5A5A5A; ir_input = 2'b11; con_in = 0;
        
        #10 bus_data = 32'h00000001; ir_input = 2'b00; con_in = 1;
        #10 bus_data = 32'h80000000; ir_input = 2'b10; con_in = 0;
        
        #20 $stop;
    end
    
    initial begin
        $monitor("Time = %0t | bus_data = %h | ir_input = %b | con_in = %b | con_out = %b", 
                 $time, bus_data, ir_input, con_in, con_out);
    end
endmodule
