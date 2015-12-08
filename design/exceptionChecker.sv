//Verilog Module for ExceptionChecker

typedef enum {Compute=0, ResetOutput} ExcChkState ;

module exceptionChecker ( Exc, ACK, Data, Data_valid, CLK, RSTN);


  input [31:0] Data;
  input Data_valid, CLK, RSTN;
  output reg [2:0] Exc;
  reg [2:0] Exc_val ;
  output reg ACK;
  reg ACK_val ;

  ExcChkState  StateMC, next_StateMC;

always@(posedge CLK) begin
	if(RSTN!=1) begin
		StateMC <= Compute ;
                Exc <= 0 ;
                ACK <= 0 ;
	end
	else begin
		StateMC <= next_StateMC ;
                Exc <= Exc_val ;
                ACK <= ACK_val ;		
	end
end

always @(*) 
begin
   next_StateMC = StateMC ;  
   Exc_val = Exc ;
   ACK_val = 0;
  case(StateMC)
     Compute :   begin
                        ACK_val = 1'b0 ;
			if(Data_valid==1) begin
				if(Data[30:23]==8'hFF && Data[22:0]==0)begin
				  Exc_val[2:0] = 3'b011;// Infinity condition
				end
				else if(Data[30:23]==8'hFF && Data[22:0]!=0) begin
				  	Exc_val[2:0] = 3'b100;// NaN condition 
					end
				     else begin 
					  Exc_val[2:0] = 3'b000;
					  end
			end
				next_StateMC = ResetOutput ;
				ACK_val = 1'b1 ;
		 end
 ResetOutput:   begin
			ACK_val = 1'b0 ;
			next_StateMC = Compute ;			
		 end
  endcase

end

endmodule
