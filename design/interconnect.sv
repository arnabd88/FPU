//typedef enum {intIdle=0, M1_State, M2_State, M1_EndState, M2_EndState} interconnectStateType ;
typedef enum {intIdle=0, M1_State, M2_State} interconnectStateType ;
module interconnect (
    RSTn ,
	CLK ,
	//------- M1 unit interface -----
	M1_req ,
	M1_ack ,
	//------- M2 unit interface ----
	M2_req ,
	M2_ack ,
	//------ Slave unit interface ---
	S_req ,
	S_ack,
	Select

	);

    input RSTn ;
	input CLK ;
	//------- M1 unit interface -----
	input M1_req ;
	output reg M1_ack ;
	//------- M2 unit interface ----
	input M2_req ;
	output reg M2_ack ;
	//------ Slave unit interface ---
	output reg S_req ;
	input S_ack ;
	output reg Select ;

	reg M1_ack_val, M2_ack_val, S_req_val, Select_val ;


	interconnectStateType stateMC , next_stateMC ;

	wire [1:0] Request_Buffer ;
	reg priority_val, priority_reg ; //0: M1:adder ; 1: M2:Mult

	assign Request_Buffer[0] = M1_req | 1'b0 ;
	assign Request_Buffer[1] = M2_req | 1'b0 ;


	always@(posedge CLK) begin
		if(RSTn!=1) begin
			stateMC <= intIdle ;
			priority_reg <= 0;
			M1_ack <= 0 ;
			M2_ack <= 0;
			S_req  <= 0;
			Select <= 0;
		end
		else begin
			stateMC <= next_stateMC ;
			priority_reg <= priority_val ;
			M1_ack <=M1_ack_val  ;
			M2_ack <=M2_ack_val ;
			S_req  <= S_req_val  ;
			Select <=Select_val ;
		end
	end

	always@(*) begin
	//-----------------------------
	    next_stateMC = stateMC ;
		priority_val = priority_reg ;
		M1_ack_val =M1_ack  ;
		M2_ack_val =M2_ack ;
		S_req_val = 0  ;
		Select_val =Select ;
	//-----------------------------
		case(stateMC)
		intIdle :  begin
						//S_req = 0 ;
						{M1_ack_val, M2_ack_val} = 2'b00 ;
						//Select = 1'b0 ;
						case({Request_Buffer[1:0],priority_reg})
							3'b000  :  next_stateMC = intIdle ;
							3'b001  :  next_stateMC = intIdle ;
							3'b010  :  begin
										//----- Priority and req , both with M1
										priority_val = ~priority_reg ;
										next_stateMC = M1_State ;
									end
							3'b011  :  begin
										//----- Priority with M2, single req from M1
										next_stateMC = M1_State ;
									end
							3'b100  :  begin
										//----- Priority with M1, single req from M2
										next_stateMC = M2_State ;
									end
							3'b101  :  begin
										//----- Priority and request, both with M2
										priority_val = ~priority_reg ;
										next_stateMC = M2_State ;
									end
							3'b110  :  begin
										priority_val = ~priority_reg ;
										next_stateMC = M1_State ;
									end
							3'b111  :  begin
										priority_val = ~priority_reg ;
										next_stateMC = M2_State ;
									end
						endcase
					  end
		M1_State  :  begin
						if(M1_req!=1) next_stateMC = intIdle ;
						else begin
							S_req_val = 1 ;
							Select_val = 1'b0 ;
							if(S_ack==1) begin
								S_req_val = 0 ;
								M1_ack_val = 1 ;
								next_stateMC = intIdle ;
							end
							else  next_stateMC = M1_State ;
						end
					 end
		M2_State  :  begin
						if(Request_Buffer[1] != 1)  next_stateMC = intIdle ;
						else begin
							S_req_val = 1 ;
							Select_val = 1'b1 ;
							if(S_ack==1) begin
								S_req_val = 0;
								M2_ack_val = 1 ;
								next_stateMC = intIdle ;
							end
							else next_stateMC = M2_State ;
						end
					 end
	//	M1_EndState  :  begin
	//					M1_ack_val = 1'b0 ;
	//				//	M2_ack_val = 1'b0 ;
	//				    if(M1_req==0)	next_stateMC = intIdle ;
	//					else  next_stateMC = M1_EndState ;
	//				 end
		endcase
	end




endmodule


