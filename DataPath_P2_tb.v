`timescale 1ns / 1ps

module DataPath_P2_tb;
  reg clk, clear, read;
  reg [31:0] fromInPort;
  reg [4:0] opcode;
  reg [7:0] pc_offset;
  reg set_pc_flag;

  // Control signals
  reg HIin, LOin, MARin, MDRin, Yin, Zin, PCin, IRin;
  reg HIout, LOout, MARout, MDRout, Zhighout, Zlowout, PCout, Cout, Inout, Outout;
  reg IncPC, wren, muxSignal, Gra, Grb, Grc, Rin, Rout, BAout, con_in;

  // Outputs
  wire [31:0] BusLine;
  wire [31:0] R0_data, R1_data, R2_data, R3_data, R4_data,
              R5_data, R6_data, R7_data, R8_data, R9_data,
              R10_data, R11_data, R12_data, R13_data, R14_data,
              R15_data, HI_data, LO_data, MDR_data,
              Y_data, Z_data, PC_data, IR_data, Ram_data, C_data, InPort_data, OutUnit, YLine;
  wire [4:0] encoded_signal;
  wire [4:0] select_signals;
  wire [63:0] ZLine;
  wire [15:0] Result_in, Result_out;
  wire [8:0] MAR_address;
  wire con_out;

  // Clock generation
  always #5 clk = ~clk;

  // Instantiate the DUT
  DataPath UUT(
    .clk(clk), .clear(clear), .read(read), .fromInPort(fromInPort),
    .opcode(opcode), .pc_offset(pc_offset), .set_pc_flag(set_pc_flag),
    .HIin(HIin), .LOin(LOin), .MARin(MARin), .MDRin(MDRin), .Yin(Yin), .Zin(Zin),
    .PCin(PCin), .IRin(IRin),
    .HIout(HIout), .LOout(LOout), .MARout(MARout), .MDRout(MDRout),
    .Zhighout(Zhighout), .Zlowout(Zlowout), .PCout(PCout), .Cout(Cout), .Inout(Inout), .Outout(Outout),
    .IncPC(IncPC), .wren(wren), .muxSignal(muxSignal),
    .Gra(Gra), .Grb(Grb), .Grc(Grc), .Rin(Rin), .Rout(Rout), .BAout(BAout),
    .con_in(con_in), .con_out(con_out),
    .BusLine(BusLine), .R0_data(R0_data), .R1_data(R1_data), .R2_data(R2_data), .R3_data(R3_data),
    .R4_data(R4_data), .R5_data(R5_data), .R6_data(R6_data), .R7_data(R7_data), .R8_data(R8_data),
    .R9_data(R9_data), .R10_data(R10_data), .R11_data(R11_data), .R12_data(R12_data), .R13_data(R13_data),
    .R14_data(R14_data), .R15_data(R15_data), .HI_data(HI_data), .LO_data(LO_data),
    .MDR_data(MDR_data), .Y_data(Y_data), .Z_data(Z_data), .PC_data(PC_data), .IR_data(IR_data),
    .Ram_data(Ram_data), .C_data(C_data), .InPort_data(InPort_data), .OutUnit(OutUnit), .YLine(YLine),
    .encoded_signal(encoded_signal), .select_signals(select_signals), .ZLine(ZLine),
    .Result_in(Result_in), .Result_out(Result_out), .MAR_address(MAR_address)
  );

  // Initial sequence
  initial begin
    clk <= 0; clear <= 1; read <= 0;
    reset_signals();
	 #5 clear <= 0;

    // Simulate instruction fetch
    // T0
    PCout <= 1; MARin <= 1; IncPC <= 1; Zin <= 1;
    @(posedge clk); 
	 PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;

    // T1
    Zlowout <= 1; PCin <= 1; read <= 1; MDRin <= 1;
    @(posedge clk); 
	 Zlowout <= 0; PCin <= 0; read <= 0; MDRin <= 0;
    // T2
    MDRout <= 1; IRin <= 1;
    @(posedge clk); 
	 MDRout <= 0; IRin <= 0;


    Grb <= 1; BAout <= 1; Yin <= 1; muxSignal <= 1;
    @(posedge clk); 
	 Grb <= 0; BAout <= 0; Yin <= 0; muxSignal <= 0;


    Cout <= 1; opcode <= 5'b00011; Zin <= 1; // opcode for ADD
    @(posedge clk); 
    Cout <= 0; Zin <= 0;
    // T5: Store result in r3
	 
    Zlowout <= 1; Gra <= 1; Rin <= 1;
    @(posedge clk); 
    Zlowout <= 0; Gra <= 0; Rin <= 0;


  end

  task reset_signals();
    begin
		
      {HIin, LOin, MARin, MDRin, Yin, Zin, PCin, IRin} = 0;
      {HIout, LOout, MARout, MDRout, Zhighout, Zlowout, PCout, Cout, Inout, Outout} = 0;
      {IncPC, wren, muxSignal, Gra, Grb, Grc, Rin, Rout, BAout, con_in} = 0;
      read = 0;
    end
  endtask
endmodule