//Verilog Module for 24-bit Adder

typedef enum {Add_Compute=0, Add_ResetOutput} AddState ;

module adder_24b ( Z, COUT, ACK, A, B, REQ, CLK, RSTN);

  input [24:0] A,B;
  input REQ, CLK, RSTN;
  output reg [24:0] Z;
  output reg COUT;
  output reg ACK;
  reg [24:0] Z_val;
  reg COUT_val;

  AddState  StateMC, next_StateMC;

always@(posedge CLK) begin
	if(RSTN!=1) begin
		StateMC <= Add_Compute ;
	end
	else begin
		StateMC <= next_StateMC ;		
	end
end

always @(*) 
begin  
   next_StateMC = StateMC ;
  case(StateMC)
                Add_Compute :   begin
				                COUT = 0;
								Z    = 0;
								ACK  = 0;
	           		            if(REQ==1) begin
	           			             {COUT, Z} = A + B ;
	           			             next_StateMC = Add_ResetOutput ;
	           			             ACK = 1'b1 ;
	           		            end
								else next_StateMC = Add_Compute ;
	           	                end
             Add_ResetOutput:   begin
			                       ACK = 1'b0 ;
			                       next_StateMC = Add_Compute ;			
		                        end
  endcase

end

endmodule
