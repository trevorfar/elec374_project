module decoder_4_to_16(input wire [3:0] decoder_input, output reg [15:0] decoder_output);
	always@(*) begin
		case(decoder_input)
         		4'b0000 : decoder_output <= 16'h0001;     
         		4'b0001 : decoder_output <= 16'h0002;   
					4'b0010 : decoder_output <= 16'h0004; 
         		4'b0011 : decoder_output <= 16'h0008;  
         		4'b0100 : decoder_output <= 16'h0010;    
         		4'b0101 : decoder_output <= 16'h0020;   
         		4'b0110 : decoder_output <= 16'h0040;
         		4'b0111 : decoder_output <= 16'h0080;    
         		4'b1000 : decoder_output <= 16'h0100;    
         		4'b1001 : decoder_output <= 16'h0200;    
         		4'b1010 : decoder_output <= 16'h0400;   
         		4'b1011 : decoder_output <= 16'h0800;  
         		4'b1100 : decoder_output <= 16'h1000;  
         		4'b1101 : decoder_output <= 16'h2000;    
         		4'b1110 : decoder_output <= 16'h4000;   
         		4'b1111 : decoder_output <= 16'h8000;   
      		endcase
   	end
endmodule
