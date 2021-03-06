//Verilog Module for 24-bit Adder

typedef enum {Add_Compute=0, Add_ResetOutput, Add_EndState} AddState ;

module adder_24b ( Z, COUT, ACK, A, B, REQ, CLK, RSTN);

  input [8:0] A,B;
  input REQ, CLK, RSTN;
  output reg [8:0] Z;
  output reg COUT;
  output reg ACK;
  reg COUT_val, ACK_val;
  reg [8:0] Z_val ;

  AddState  StateMC, next_StateMC;

always@(posedge CLK) begin
	if(RSTN!=1) begin
		StateMC <= Add_Compute ;
		Z <= 0;
		COUT <= 0 ;
		ACK <= 0;
	end
	else begin
		StateMC <= next_StateMC ;		
		Z <= Z_val ;
		COUT <= COUT_val ;
		ACK <= ACK_val ;
	end
end

always @(*) 
begin  
   next_StateMC = StateMC ;
   Z_val = Z ;
   COUT_val = COUT ;
   ACK_val = 0 ;
  case(StateMC)
                Add_Compute :   begin
					COUT_val = 0;
					Z_val =0;
	           		            if(REQ==1) begin
	           			             {COUT_val, Z_val} = A + B ;
	           			             next_StateMC = Add_ResetOutput ;
	           			             ACK_val = 1'b1 ;
	           		            end
								else next_StateMC = Add_Compute ;
	           	                end
             Add_ResetOutput:   begin
			                       ACK_val = 1'b0 ;
								   if(REQ==1) next_StateMC = Add_ResetOutput ;
			                       else next_StateMC = Add_EndState ;			
		                        end
		Add_EndState :  begin	
					
					next_StateMC = Add_Compute;
				end
  endcase

end

endmodule
