typedef enum {Booth_Idle = 0, Mult_Compute, Mul_ResetOutput} BoothState ;

module booth (res, m1 , m2, CLK,  BREQ, BACK, RSTK,   
	Adder_datain1 ,
	Adder_datain2 ,
	Adder_valid ,
	Adder_dataout ,
	Adder_carryout ,
	Adder_ack);

output reg [47:0] res;
input [23:0] m1, m2;
input CLK, BREQ, RSTK;
reg [24:0] A, A_reg, Q, Q_reg, M, M_reg, Adder_datain1_val,Adder_datain2_val;
reg Q1, Q1_reg, Adder_valid_val;
output reg BACK;
reg [4:0] count, count_reg;

//--- Adder callee module interface ---
        output reg [24:0] Adder_datain1 ;
	output reg [24:0] Adder_datain2 ;
	output reg        Adder_valid;
	input      [24:0] Adder_dataout   ;
	input             Adder_carryout  ;
	input             Adder_ack       ;


BoothState  BStateMC, Bnext_StateMC;



always@(posedge CLK) begin
	if(RSTK!=1) 
	begin
		 A_reg <= 0;
		 M_reg <= 0;
		 Q_reg <= 0;
		 Q1_reg <= 0;
		 count_reg <=0;
		 //BACK <= 0;
		 Adder_valid <=0;
		 Adder_datain1 <= 0;
    		Adder_datain2 <= 0;
		 BStateMC <= Booth_Idle;
	end
	else begin
		A_reg <= A;
		M_reg <= M;
		Q1_reg <= Q1;
		Q_reg <= Q;
		count_reg <= count;
		Adder_valid <= Adder_valid_val;
		 Adder_datain1 <= Adder_datain1_val;
    		Adder_datain2 <= Adder_datain2_val;
		BStateMC <= Bnext_StateMC ;		
	end
end

always @(*) 
begin  
   count = count_reg;  
   res =0;
   Bnext_StateMC = BStateMC ;
   Q = Q_reg ;
   Q1 = Q1_reg ;
   M = M_reg ;
   A = A_reg ;
   Adder_valid_val=Adder_valid;
   Adder_datain1_val = 0;
   Adder_datain2_val = 0;
   BACK = 0 ;

  case(BStateMC)
		Booth_Idle: begin
				BACK=0;
				Bnext_StateMC = Booth_Idle;
				if(BREQ==1)
				begin
		 		 A= 0;
				 M= m1;
				 Q= m2;
				 Q1= 0;
				 count = 0;
				 Bnext_StateMC = Mult_Compute;
				 $display("REQUEST received", $time);
				//$display("M: Num1 = %b, Q = %b", M, Q);
				//$display("Computed Data : %b | %b @", Dataout_wire[47:24], Dataout_wire[23:0], $time);
				end		


			end


                Mult_Compute :   begin
					
						

					$display("\nStep number %d", count_reg, $time);
				            BACK  = 0;
					    Bnext_StateMC = Mult_Compute;
		        
					    case ({Q_reg[0], Q1_reg})
							 
						2'b01 : 
						 begin
						     //$display("ADD OP", $time);
						     //$display("%b | %b", A_reg, Q_reg, $time);
						   if(Adder_ack == 0) begin
						    Adder_valid_val  =  1 ;
						    Adder_datain1_val = A_reg ;
						    Adder_datain2_val = M_reg ;
   
     						   end
						   if(Adder_ack == 1 )     
						begin count = count_reg + 1'b1;
							//$display("Adder_DataOut = %b", Adder_dataout, $time);
							{A,Q,Q1} = {Adder_dataout[24],Adder_dataout,Q_reg};
							Adder_valid_val = 0;
							//$display("SRES", $time);
						        //$display("%b | %b", A, Q, $time);
						end
						

						end 

						2'b10 :
						begin 
						     //$display("SUB OP", $time);
						     //$display("%b | %b", A_reg, Q_reg, $time);
						   if(Adder_ack == 0) begin
                                          
						    Adder_valid_val  =  1 ;
						    Adder_datain1_val = A_reg ;
						    Adder_datain2_val = ~M_reg + 1'b1 ;
                      				   end
						   if(Adder_ack == 1)
						begin   count = count_reg + 1'b1;
							{A,Q,Q1} = {Adder_dataout[24],Adder_dataout,Q_reg};
							Adder_valid_val = 0;
						     //$display("DRES", $time);
						     //$display("%b | %b", A, Q, $time);
						end
						end

						default: begin
							//$display("DEF", $time);
							//$display("%b | %b", A_reg, Q_reg, $time);
							{A,Q,Q1} = {A_reg[24],A_reg,Q_reg};
							//$display("ShRES", $time);
							//$display("%b | %b", A, Q, $time);
							count = count_reg + 1'b1;
							end
					    
					    endcase
							           			        
						if(count_reg>24)  
						begin 
						Bnext_StateMC = Mul_ResetOutput ; BACK = 1; res = {A_reg[23:0],Q_reg}; 
						end
					
							           			          
	           		   end


                Mul_ResetOutput:   begin	
			                       BACK = 1'b0 ;
			                       Bnext_StateMC = Booth_Idle;			
		                        end
  endcase

end

endmodule
