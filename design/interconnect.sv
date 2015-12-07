typedef enum {intIdle=0, M1_State, M2_State, intSetOutput} interconnectStateType ;
module interconnect (
    RSTn ,
	CLK ,
	//------- M1 unit interface -----
	M1_req ,
	M1_Data1 ,
	M1_Data2 ,
	M1_Dataout ,
	M1_ack ,
	//------- M2 unit interface ----
	M2_req ,
	M2_Data1 ,
	M2_Data2 ,
	M2_Dataout ,
	M2_ack ,
	//------ Slave unit interface ---
	S_req ,
	S_Data1 ,
	S_Data2 ,
	S_Datain ,
	S_ack,
	Select

	);

    input RSTn ;
	input CLK ;
	//------- M1 unit interface -----
	input M1_req ;
	input [24:0] M1_Data1 ;
	input [24:0] M1_Data2 ;
	output reg[24:0] M1_Dataout ;
	output reg M1_ack ;
	//------- M2 unit interface ----
	input M2_req ;
	input [24:0] M2_Data1 ;
	input [24:0] M2_Data2 ;
	output reg[24:0] M2_Dataout ;
	output reg M2_ack ;
	//------ Slave unit interface ---
	output reg S_req ;
	output reg[24:0] S_Data1 ;
	output reg[24:0] S_Data2 ;
	input [24:0] S_Datain ;
	input S_ack ;
	output reg Select ;


	interconnectStateType stateMC , next_stateMC ;

	wire [1:0] Request_Buffer ;
	reg priority_val, priority_reg ; //0: M1:adder ; 1: M2:Mult

	assign Request_Buffer[0] = M1_req | 1'b0 ;
	assign Request_Buffer[1] = M2_req | 1'b0 ;


	always@(posedge CLK) begin
		if(RSTn!=1) begin
			stateMC <= intIdle ;
			priority_reg <= 0;
		end
		else begin
			stateMC <= next_stateMC ;
			priority_reg <= priority_val ;
		end
	end

	always@(*) begin
	//-----------------------------
	    next_stateMC = stateMC ;
		priority_val = priority_reg ;
	//-----------------------------
		case(stateMC)
		intIdle :  begin
						S_req = 0 ;
						{M1_ack, M2_ack} = 2'b00 ;
						Select = 1'b0 ;
						case({Request_Buffer[1:0],priority_val})
							000  :  next_stateMC = intIdle ;
							001  :  next_stateMC = intIdle ;
							010  :  begin
										//----- Priority and req , both with M1
										priority_val = ~priority_reg ;
										next_stateMC = M1_State ;
									end
							011  :  begin
										//----- Priority with M2, single req from M1
										next_stateMC = M1_State ;
									end
							100  :  begin
										//----- Priority with M1, single req from M2
										next_stateMC = M2_State ;
									end
							101  :  begin
										//----- Priority and request, both with M2
										priority_val = ~priority_reg ;
										next_stateMC = M2_State ;
									end
							110  :  begin
										priority_val = ~priority_reg ;
										next_stateMC = M1_State ;
									end
							110  :  begin
										priority_val = ~priority_reg ;
										next_stateMC = M2_State ;
									end
						endcase
					  end
		M1_State  :  begin
						if(M1_req != 1) next_stateMC = intIdle ;
						else begin
							S_req = 1 ;
							Select = 1'b0 ;
							if(S_ack==1) begin
								S_req = 0 ;
								M1_ack = 1 ;
								next_stateMC = intIdle ;
							end
							else  next_stateMC = M1_State ;
						end
					 end
		M2_State  :  begin
						if(M2_req != 1)  next_stateMC = intIdle ;
						else begin
							S_req = 1 ;
							Select = 1'b1 ;
							if(S_ack==1) begin
								S_req = 0;
								M2_ack = 1 ;
								next_stateMC = intIdle ;
							end
							else next_stateMC = M2_State ;
						end
					 end
		endcase
	end




endmodule


