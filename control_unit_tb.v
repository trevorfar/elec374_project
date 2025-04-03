`timescale 1ns/1ps

module control_unit_tb;
	 reg clk, clear, stop;
    reg [31:0] inport_data_in;
    wire [31:0] bus_data;
    wire con_out;
    wire [15:0] reg_out, reg_in;
    wire [4:0] bus_select, opcode;
    wire [8:0] mar_address_out;
    wire [31:0] r0_data_out, r1_data_out, r2_data_out, r3_data_out, r4_data_out, r5_data_out, r6_data_out,
                r7_data_out, r8_data_out, r9_data_out, r10_data_out, r11_data_out, r12_data_out, r13_data_out, r14_data_out, r15_data_out,
                LO_data_out, inport_data_out, outport_data_out, pc_data_out, ry_data_out, ram_data_out, mdr_data_out, 
                z_high_data_out, HI_data_out, z_low_data_out, muxy_data_out, ir_data_out, control_signals, C_sign_extended;//, inport_data_in;
    wire [63:0] rz_data_out;
	 wire [2:0] step;
	 wire run;
	 wire [7:0] LEDS_1, LEDS_2;
	 
	 initial begin
		inport_data_in[31:0] = {24'd0, 8'hC0};
	 end
    
		  datapath DUT (
        .clk(clk), 
        .clear(clear), 
        .inport_data_in(inport_data_in),
        .bus_data(bus_data),
        .con_out(con_out),
        .reg_out(reg_out),
        .reg_in(reg_in),
        .bus_select(bus_select),
        .opcode(opcode),
        .mar_address_out(mar_address_out),
		  .C_sign_extended(C_sign_extended),
        .r0_data_out(r0_data_out), 
        .r1_data_out(r1_data_out), 
        .r2_data_out(r2_data_out), 
        .r3_data_out(r3_data_out), 
        .r4_data_out(r4_data_out), 
        .r5_data_out(r5_data_out), 
        .r6_data_out(r6_data_out),
        .r7_data_out(r7_data_out), 
        .r8_data_out(r8_data_out), 
        .r9_data_out(r9_data_out), 
        .r10_data_out(r10_data_out), 
        .r11_data_out(r11_data_out), 
        .r12_data_out(r12_data_out), 
        .r13_data_out(r13_data_out), 
        .r14_data_out(r14_data_out), 
        .r15_data_out(r15_data_out),
        .LO_data_out(LO_data_out), 
        .inport_data_out(inport_data_out),
        .outport_data_out(outport_data_out), 
        .pc_data_out(pc_data_out), 
        .ry_data_out(ry_data_out), 
        .ram_data_out(ram_data_out), 
        .mdr_data_out(mdr_data_out),
        .z_high_data_out(z_high_data_out), 
        .rz_data_out(rz_data_out), 
        .HI_data_out(HI_data_out), 
        .z_low_data_out(z_low_data_out), 
        .muxy_data_out(muxy_data_out), 
        .ir_data_out(ir_data_out),
		  .control_signals(control_signals),
		  .step(step),
		  .run(run),
		  .stop(stop),
		  .LEDS_1(LEDS_1),
		  .LEDS_2(LEDS_2)
    );

always #10 clk <= ~clk;

always @(opcode) begin
    if (opcode == 5'b11010)
        $display("Time %0t: opcode hit nop!", $time);
	 else if(opcode == 5'b11011)
		  $display("Time %0t: opcode hit halt!", $time);
	 else if(opcode == 5'b10011)
		  $display("Time %0t: opcode hit branch!", $time);
	 else if(opcode == 5'b10111)
		  $display("Time %0t: opcode hit OUT!", $time);
    else if(opcode == 5'b10100)
		  $display("Time %0t: opcode hit JAL!", $time);
	 	 
end

//always @(*) begin
//	if(opcode == 5'b10011 && step == 3'b111) begin
//		$display("ZLO: %0t, Y: %0t" $z_low_data_out, $ry_data_out);
//	end
//end


initial begin
	clk = 0;
	clear = 1;
	stop <= 0; 
	#5 clear = 0;
end


endmodule


