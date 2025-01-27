`timescale 1ns / 1ps

module mdr_32_bit_tb;

    reg [31:0] Mdatain;
    reg [31:0] bus_mux_out;
    reg clk;
    reg clear;
    reg MDRin;
    reg select;

    wire [31:0] mdr_out;

    mdr_32_bit uut (
        .Mdatain(Mdatain),
        .bus_mux_out(bus_mux_out),
        .clk(clk),
        .clear(clear),
        .MDRin(MDRin),
        .select(select),
        .mdr_out(mdr_out)
    );

    always #5 clk = ~clk;

    initial begin
        Mdatain = 32'h00000000;
        bus_mux_out = 32'h00000000;
        clk = 0;
        clear = 0;
        MDRin = 0;
        select = 0;

        #10;

        // t1 load Mdatain into MDR
        Mdatain = 32'd256;
        bus_mux_out = 32'd512;
        select = 1; 
        MDRin = 1;
        #10;
        MDRin = 0;
        #10;

		  //t2 bus_mux_out into MDR
        select = 0; //bus
        MDRin = 1;
        #10;
        MDRin = 0;
        #10;

        // clear mdr
        clear = 1;
        #10;
        clear = 0;
        #10;
        $stop;
    end

endmodule
