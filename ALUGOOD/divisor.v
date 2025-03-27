//module divisor (
//    input clk, reset,                 	//clock and reset input
//    input signed [31:0] M,       //32 bit Divisor (will be extended to 33-bit)
//    input signed [31:0] Q,       // 32 bit Dividend
//    output signed [63:0] Result //quotient and Remainder output
//);
//
//    reg [31:0] Q_reg;         //register to hold the quotient
//    reg signed [32:0] A;      //33 bit accumulator for remainder
//    reg signed [32:0] M_neg, M_Pos; //modified divisor values
//    reg signed [32:0] M_extended;   //33 bit sign-extended divisor
//    integer count; //counter for each iteration
//
//    initial count = 0;  
//
//    always @(posedge clk) begin
//		 
//			if (~reset) begin
//				A = 0;  
//				Q_reg = 0; 
//				count = 0;
//			end
//			
//	 
//        else if (count == 0) begin
//            count = 1;
//				M_extended = {M[31], M};
//				
//            //initialize division registers
//            A = 33'b0;    
//            Q_reg = Q;     
//
//            //handle signed division cases correctly
//            if (M_extended[32] == 1) begin
//                M_neg = M_extended;        
//                M_Pos = ~M_extended+1;
//            end else begin
//                M_neg = ~M_extended+1;       
//                M_Pos = M_extended;
//            end
//        end 
//        else if (count > 0 && count < 33) begin  //33 cycles
//            //shift Left
//            {A, Q_reg} = {A, Q_reg} << 1;
//	
//            //subtract M from A by adding negative
//            A = A + M_neg; 
//
//            //check sign and restore if necessary
//            if (A[32] == 1) begin  
//					 Q_reg[0] = 0;   //append 0 to quotient
//                A = A + M_Pos;  //restore A if it's negative
//            end else begin
//                Q_reg[0] = 1;   //append 1 to quotient
//            end
//
//            //increment count to indicate the clock cycle has completed
//            count = count + 1; 
//
//        end
//    end
//	 assign Result = {A[31:0], Q_reg};
//endmodule
