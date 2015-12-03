//Verilog Module for ExceptionChecker

typedef enum {Exc_Compute=0, Exc_ResetOutput} ExcChkState ;

module exceptionChecker ( Data, Data_valid, Exc, ACK, CLK, RSTN);


  input [31:0] Data;
  input Data_valid, CLK, RSTN;
  output reg [2:0] Exc;
  output reg ACK;

  ExcChkState  StateMC, next_StateMC;

always@(posedge CLK or negedge RSTN) begin
	if(RSTN!=1) begin
		ACK  <= 0;
		StateMC <= Exc_Compute ;
	end
	else begin
		StateMC <= next_StateMC ;		
	end
end

always @(*) 
begin  
  case(StateMC)
     Exc_Compute :   begin
			if(Data_valid==1 && ACK==0) begin
				if(Data[30:23]==8'hFF && Data[22:0]==0)
				  Exc[2:0] = 3'b011;// Infinity condition
				else if(Data[30:23]==8'hFF && Data[22]!=0)
				  Exc[2:0] = 3'b100;// NaN condition	
				next_StateMC = Exc_ResetOutput ;
				ACK = 1'b1 ;
			end
		 end
 Exc_ResetOutput:   begin
			ACK = 1'b0 ;
			next_StateMC = Exc_Compute ;			
		 end
  endcase

end

endmodule
