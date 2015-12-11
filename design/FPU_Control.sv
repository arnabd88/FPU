typedef enum { topIdle=0, topWaitAdderOp2, topWaitMultOp2 } FPU_COntrol_State_type ;
typedef enum {setOutput=0, MultSecondOut, AdderSecondOut} outState_type ;
typedef enum {multIdle=0, WaitForMult, MultEndState} multState_type ;
typedef enum {adderIdle=0, WaitForAdder, AddEndState} addState_type ;

module FPU_Control (
//---- DEFAULT interface ----
	CLK   ,
	RSTn  ,
	CS    ,
	DIN   ,
	DIV   ,
	DACK  ,
	DR    ,
	DOUT  ,
	DOV   ,
	DOA   ,
	ABUSY ,
	MBUSY ,
	EXC   ,
	OPT   ,
	MODE  ,
	DEBUG 
//	//---- ADDER CONTROL UNIT interface ----
//	AdderCntrl_InputData1   ,
//	AdderCntrl_InputData2   ,
//	AdderCntrl_InputValid   ,
//	AdderCntrl_OutData      ,
//	AdderCntrl_OutDataValid ,
//	AdderCntrl_Exc   ,
//	AdderCntrl_Mode  ,
//	AdderCntrl_Debug ,
//	//---- MULTIPLIER UNIT interface -----
//	MultCntrl_InputData1  ,
//	MultCntrl_InputData2  ,
//	MultCntrl_InputValid  ,
//	MultCntrl_OutData     ,
//	MultCntrl_OutDataValid ,
//	MultCntrl_Exc  ,
//	MultCntrl_Mode ,
//	MultCntrl_Debug ,
//	//---- EXCEPTION CHECKER interface ---
//	ExcChecker_Datain  ,
//	ExcChecker_valid   ,
//	ExcChecker_value   ,
//	ExcChecker_Ack  

  ) ;


 //---- Default Interface ----
 input RSTn ;
 input CLK  ;
 input     [31:0] DIN                    ;
 input            DIV                    ;
 output reg       DACK                   ;
 output reg       DR                     ;
 output reg[15:0] DOUT                   ;
 output reg       DOV                    ;
 input            DOA                    ;
 input            CS                     ;
 output reg       ABUSY                  ;
 output reg       MBUSY                  ;
 output reg[2:0]  EXC                    ;
 input            OPT                    ;
 input     [2:0]  MODE                   ;
 output reg[4:0]  DEBUG                  ;
 //---- Adder Control Unit Interface -----
 // output reg[31:0] AdderCntrl_InputData1   ;
 // output reg[31:0] AdderCntrl_InputData2   ;
 // output reg       AdderCntrl_InputValid   ;
 // input     [31:0] AdderCntrl_OutData      ;
 // input            AdderCntrl_OutDataValid ;
 // input     [2:0]  AdderCntrl_Exc          ;
 // output [2:0]  AdderCntrl_Mode         ;
 // input     [4:0]  AdderCntrl_Debug        ;
 // //---- Multiplier Unit Interface -------
 // output reg[31:0] MultCntrl_InputData1    ;
 // output reg[31:0] MultCntrl_InputData2    ;
 // output reg       MultCntrl_InputValid    ;
 // input     [31:0] MultCntrl_OutData       ;
 // input            MultCntrl_OutDataValid  ;
 // input     [2:0]  MultCntrl_Exc           ;
 // output [2:0]  MultCntrl_Mode          ;
 // input     [4:0]  MultCntrl_Debug         ;
 // //---- ExceptionChecker Interface ------
 // output reg[31:0] ExcChecker_Datain       ;
 // output reg       ExcChecker_valid        ;
 // input     [2:0]  ExcChecker_value        ;
 // input            ExcChecker_Ack          ;
 
reg [31:0]  AdderCntrl_Op1, AdderCntrl_Op1_val ;
reg [31:0]  AdderCntrl_Op2 , AdderCntrl_Op2_val  ;
reg         AdderCntrl_valid ;
wire [31:0] AdderCntrl_Dataout ;
wire        AdderCntrl_Dataout_valid ;
wire [2:0]  AdderCntrl_Exc ;
reg  [2:0]  AdderCntrl_Mode ;
wire [4:0]  AdderCntrl_Debug ;
//--- Adder callee module interface ---
wire [24:0] Add_Op1 ;
wire [24:0] Add_Op2 ;
wire        Add_valid ;
wire [2:0]  Add_Exc ;
wire [24:0] Add_dataout ;
wire        Add_carryout ;
wire        Add_ack ;
//---ExceptionChecker callee module interface ---
wire        AddCntrl_ExcCheck_valid ;
wire [31:0] AdderCntrl_ExcCheck_Datain ;
wire [2:0]  AdderCntrl_Exc_value ;
wire        AdderCntrl_Exc_Ack ;

reg [31:0] MulCntrl_Op1, MulCntrl_Op1_val ;
reg [31:0] MulCntrl_Op2, MulCntrl_Op2_val ;
reg MulCntrl_valid ;
wire [31:0] MulCntrl_Dataout ;
wire MulCntrl_Dataout_valid ;
wire [2:0] MulCntrl_Exc ;
reg [2:0] MulCntrl_Mode ;
wire [4:0] MulCntrl_Debug ;
//--- Multiplier callee module interface(Booth) ---
wire [23:0] Booth_datain1 ;
wire [23:0] Booth_datain2 ;
wire Booth_valid ;
wire [2:0] Booth_Exc ;
wire [47:0] Booth_dataout ;
wire Booth_ack ;
//---- Multiplication_ExceptionChecker callee module interface ---
reg MulCntrl_ExcCheck_valid ;
reg[31:0] MulCntrl_ExcCheck_Datain ;
wire [2:0] MulCntrl_Exc_value ;
wire MulCntrl_Exc_Ack ;

wire [31:0] ExcCheck_Data ;
wire [2:0] ExcCheck_value ;
wire ExcChecker_valid ;
wire ExcCheck_Ack ;

wire [24:0] Add_op1, Add_op2 ;
wire Add_req, Add_out_valid ;
wire excSelect ;
wire [24:0] Booth_Add_datain1, Booth_Add_datain2 ;
wire Booth_Add_valid ;
wire [2:0] Booth_Add_Exc ;
wire [24:0] Booth_Add_dataout ;
wire Booth_Add_carryout ;
wire Booth_Add_ack ;
wire AddSelect ;
wire [24:0] Adder_out ;
wire Adder_cout ;
wire [24:0] Add_Op1_wire, Add_Op2_wire ;

reg[1:0] getdataStat, getdataStat_reg ;  //0: Adder, 1: Mult
reg[1:0] Add_operandState, Add_operandState_reg ; //0: 1st operand, 2: 2nd Operand
reg[1:0] Mult_operandState, Mult_operandState_reg ; //0: 1st operand, 2: 2nd Operand
reg[1:0] outputRdy ; //0: Adder output ready, 1: Mult output ready
reg[1:0] outputRdy_reg ;
reg[31:0] AdderResult_val, AdderResult_reg ;
reg[31:0] MultResult_val, MultResult_reg ;
reg[2:0] AddExc_val, MultExc_val, AddExc_reg, MultExc_reg ;
reg DR_add, DR_mult ;



reg ABUSY_val, MBUSY_val ;
//reg [3:0] OpMode, OpMode_val ;

outState_type  outStateMC, next_outStateMC ;
multState_type multStateMC, next_multStateMC ;
addState_type  adderStateMC, next_adderStateMC ;
FPU_COntrol_State_type topStateMC, next_topStateMC ;


assign Add_dataout = Adder_out ;
assign Booth_Add_dataout = Adder_out ;
assign Add_carryout = Adder_cout ;
assign Booth_Add_carryout = Adder_cout ;
assign AdderCntrl_Mode = MODE ;
assign MulCntrl_Mode  = MODE ;


always@(posedge CLK) begin
	if(RSTn!=1) begin
		topStateMC  <=  topIdle ;
		adderStateMC <= adderIdle ;
		multStateMC  <= multIdle ;
		AdderCntrl_Op1 <= 0 ;
		AdderCntrl_Op2 <= 0 ;
		MulCntrl_Op1 <= 0 ; 
		MulCntrl_Op2 <= 0 ; 
		Add_operandState_reg <= 0 ;
		Mult_operandState_reg <= 0 ;
		getdataStat_reg <= 0 ;
		ABUSY <= 0;
		MBUSY <= 0;
		AdderResult_reg <= 0;
		MultResult_reg  <= 0;
		AddExc_reg <= 0;
		MultExc_reg <= 0;
		outputRdy_reg <= 0;
		DR <= 0 ;
	end
	else begin
		topStateMC  <=  next_topStateMC ;
		adderStateMC <= next_adderStateMC ;
		multStateMC <= next_multStateMC ;
		outStateMC  <= next_outStateMC ;
		AdderCntrl_Op1 <= AdderCntrl_Op1_val ;
		AdderCntrl_Op2 <= AdderCntrl_Op2_val ;
		MulCntrl_Op1  <=  MulCntrl_Op1_val ;
		MulCntrl_Op2  <=  MulCntrl_Op2_val ;
		Add_operandState_reg <= Add_operandState ;
		Mult_operandState_reg <= Mult_operandState ;
		getdataStat_reg <= getdataStat ;
		ABUSY  <=  ABUSY_val ;
		MBUSY  <=  MBUSY_val ;
	//	OpMode <= OpMode_val ;
		AdderResult_reg <= AdderResult_val ;
		MultResult_reg  <= MultResult_val  ;
		AddExc_reg <= AddExc_val ;
		MultExc_reg <= MultExc_val ;
		outputRdy_reg[1:0] <= outputRdy[1:0] ;
		DR <= DR_add | DR_mult ;
	end
end

//--------- Top Controller Module ----------


always@(*) begin
    next_topStateMC = topStateMC ;
	next_adderStateMC = adderStateMC ;
	next_multStateMC  = multStateMC ;
	next_outStateMC   = outStateMC ;
	Add_operandState = Add_operandState_reg ;
	Mult_operandState = Mult_operandState_reg ;
	getdataStat = getdataStat_reg ;
	AdderCntrl_Op1_val = AdderCntrl_Op1 ;
	AdderCntrl_Op2_val = AdderCntrl_Op2 ;
	MulCntrl_Op1_val   = MulCntrl_Op1 ;
	MulCntrl_Op2_val   = MulCntrl_Op2 ;
	ABUSY_val  =  ABUSY ;
	MBUSY_val  =  MBUSY ;
//	OpMode_val = OpMode ;
	AdderResult_val = AdderResult_reg ;
	MultResult_val  = MultResult_reg ;
	AddExc_val = AddExc_reg ;
	MultExc_val = MultExc_reg ;
	outputRdy = outputRdy_reg ;
	DACK = 1'b0 ;
	DR_add = 1'b0 ;
	DR_mult = 1'b0 ;
	DOUT = 0 ;
	DOV = 0 ;
	EXC = 0 ;
	MulCntrl_valid = 1'b0 ;
	AdderCntrl_valid = 1'b0 ;
	case(topStateMC)
		topIdle  :  begin
						//getdataStat = 0 ;
						if( getdataStat_reg[0] == 1'b0  && DIV == 1'b1 && OPT==1'b0 && CS==1'b1 && ABUSY==1'b0) begin
							AdderCntrl_Op1_val = DIN ;
							getdataStat[0] = 1'b1 ;
							Add_operandState[0] = 1'b1 ;
							next_topStateMC = topWaitAdderOp2 ;
						end
						else if( getdataStat_reg[1]==1'b0 && DIV==1'b1 && OPT==1'b1 && CS==1'b1 && MBUSY==1'b0) begin
							MulCntrl_Op1_val = DIN ;
							getdataStat[1] = 1'b1 ;
							Mult_operandState[0] = 1'b1 ;
							next_topStateMC = topWaitMultOp2 ;
						end
					end
 topWaitAdderOp2 :  begin
 						if( getdataStat_reg[0]==1'b0 && CS==1'b1 && ABUSY==1'b0) next_topStateMC = topIdle ;
						else if(DIV==1'b1) begin
							AdderCntrl_Op2_val = DIN ;
							getdataStat[0] = 1'b1 ;
							Add_operandState[1] = 1'b1 ;
							next_topStateMC = topIdle ;
							ABUSY_val = 1'b1 ;
							DACK = 1'b1 ;
						end
 					end
topWaitMultOp2  :  begin
						if( getdataStat_reg[1]==1'b0 && CS==1'b1) next_topStateMC = topIdle ;
						else if(DIV==1'b1) begin
							MulCntrl_Op2_val = DIN ;
							getdataStat[1] = 1'b1 ;
							Mult_operandState[1] = 1'b1 ;
							next_topStateMC = topIdle ;
							MBUSY_val = 1'b1 ;
							DACK = 1'b1 ;
						end
				   end
	endcase
	case(adderStateMC)
		adderIdle    :   begin
							next_adderStateMC = adderIdle ;
							if(Add_operandState_reg[1:0]==2'b11  &&  getdataStat_reg[0]==1'b1 && ABUSY==1'b1) begin
							ABUSY_val = 1'b1 ;
								//----- Call the adder module -------
								AdderCntrl_valid = 1'b1 ;
								next_adderStateMC = WaitForAdder ;
							end
						 end
	WaitForAdder     :   begin
							next_adderStateMC = WaitForAdder ;
							ABUSY_val = 1'b1 ;
							if(AdderCntrl_Dataout_valid == 1'b1) begin
								AdderResult_val  =  AdderCntrl_Dataout ;
								AddExc_val       =  AdderCntrl_Exc ;
								DR_add  =  1'b1 ;
								if(CS == 1'b1) begin outputRdy[0]=1'b1 ; next_adderStateMC = AddEndState ; end
							end
						 end
	AddEndState      :   begin
							if(outputRdy_reg[0]==0) begin
								next_adderStateMC = adderIdle ;
								ABUSY_val = 1'b0 ;
								getdataStat[0] = 1'b0 ;
							end
							else next_adderStateMC = AddEndState ;
						 end
	endcase
	case(multStateMC)
		multIdle  :   begin
						next_multStateMC = multIdle ;
						if(Mult_operandState_reg[1:0] == 2'b11 && getdataStat_reg[1]==1'b1 && MBUSY==1'b1) begin
							MBUSY_val = 1'b1 ;
							MulCntrl_valid = 1'b1 ;
							next_multStateMC = WaitForMult ;
						end
					  end
	WaitForMult   :   begin
							next_multStateMC = WaitForMult ;
							MBUSY_val = 1'b1 ;
							if(MulCntrl_Dataout_valid== 1'b1) begin
								MultResult_val   =   MulCntrl_Dataout ;
								MultExc_val      =   MulCntrl_Exc ;
								DR_mult = 1'b1 ;
								if(CS==1'b1) begin  outputRdy[1]=1'b1; next_multStateMC = MultEndState ; end
							end
					  end
	MultEndState  :   begin
						if(outputRdy_reg[1]==0) begin
							next_multStateMC = multIdle ;
							MBUSY_val = 1'b0 ;
							getdataStat[1] = 1'b0 ;
						end
						else    next_multStateMC = MultEndState ;
					  end
	endcase
	case(outStateMC)
		setOutput  :   begin
							DOV = 1'b0 ;
							if(outputRdy_reg[0]==1) begin
								DOUT = AdderResult_reg[31:16] ;
								DOV = 1'b1 ;
								EXC  =  AddExc_reg ;
								next_outStateMC = AdderSecondOut ;
							end
							else if(outputRdy_reg[1]==1) begin
								DOV = 1'b1 ;
								DOUT = MultResult_reg[31:16] ;
								EXC  =  MultExc_reg ;
								next_outStateMC = MultSecondOut ;
							end
					   end
	MultSecondOut  :  begin
						EXC  =  MultExc_reg ;
						DOV = 1'b1 ;
						DOUT = MultResult_reg[15:0] ;
						outputRdy[1] = 1'b0 ;
						if(DOA == 1'b1) begin
							next_outStateMC = setOutput ;
							Mult_operandState = 0;
						end
						else next_outStateMC = MultSecondOut ;
				  	  end
	AdderSecondOut :  begin
						EXC  =  AddExc_reg ;
						DOV = 1'b1 ;
						DOUT  =  AdderResult_reg[15:0] ;
						outputRdy[0] = 1'b0 ;
						if(DOA == 1'b1) begin
							next_outStateMC = setOutput ;
							Add_operandState = 0 ;
						end
						else next_outStateMC = AdderSecondOut ;
					  end
	endcase
end






Adder_cntrl u_adder_cntrl(
  //--- Default interface ---
    .CLK(CLK) ,
	.RSTn(RSTn) ,
  //--- Caller interface ---
	.Datain1(AdderCntrl_Op1) ,
	.Datain2(AdderCntrl_Op2) ,
	.Data_valid(AdderCntrl_valid) ,
	.Dataout(AdderCntrl_Dataout) ,
	.Dataout_valid(AdderCntrl_Dataout_valid) ,
	.Exc(AdderCntrl_Exc) ,
	.Mode(AdderCntrl_Mode) ,
	.Debug(AdderCntrl_Debug) ,
  //--- Adder callee module interface ---
    .Adder_datain1(Add_Op1) ,
	.Adder_datain2(Add_Op2) ,
	.Adder_valid(Add_valid) ,
//	.Adder_Exc(Add_Exc) ,
	.Adder_dataout(Add_dataout) ,
	.Adder_carryout(Adder_cout) ,
	.Adder_ack(Add_ack)  ,
  //---- ExceptionChecker callee module interface ---
    .ExcCheck_valid(AdderCntrl_ExcCheck_valid) ,
	.ExcCheck_Datain(AdderCntrl_ExcCheck_Datain),
	.Exc_value(ExcCheck_value),
	.Exc_Ack(AdderCntrl_Exc_Ack)
 ) ;






Mul_cntrl u_mul_cntrl(
  //--- Default interface ---
    .CLK (CLK),
	.RSTn (RSTn),
  //--- Caller interface ---
	.Datain1 (MulCntrl_Op1),
	.Datain2 (MulCntrl_Op2),
	.Data_valid (MulCntrl_valid),
	.Dataout (MulCntrl_Dataout),
	.Dataout_valid (MulCntrl_Dataout_valid),
	.Exc (MulCntrl_Exc),
	.Mode (MulCntrl_Mode),
	.Debug (MulCntrl_Debug),
  //--- Multiplier callee module interface(Booth) ---
    .Multi_datain1 (Booth_datain1),
	.Multi_datain2 (Booth_datain2),
	.Multi_valid (Booth_valid),
	//.Multi_Exc (Booth_Exc),
	.Multi_dataout (Booth_dataout),
	.Multi_ack  (Booth_ack),
  //---- Multiplication_ExceptionChecker callee module interface ---
   	.ExcCheck_valid (MulCntrl_ExcCheck_valid),
	.ExcCheck_Datain(MulCntrl_ExcCheck_Datain),
	.Exc_value(ExcCheck_value),
	.Exc_Ack(MulCntrl_Exc_Ack)
 ) ;



MUX32bit2X1 u_mux_exc( .data1(AdderCntrl_ExcCheck_Datain), .data2(MulCntrl_ExcCheck_Datain), .selectLine(ExcSelect), .enable(ExcCheck_valid), .outdata(ExcCheck_Data) );


exceptionChecker u_exc_check( .AEXC(ExcCheck_value), .ACK(ExcCheck_Ack), .Data(ExcCheck_Data), .Data_valid(ExcCheck_valid), .CLK(CLK), .RSTN(RSTn));


interconnect u_ExcChecker_interconnect(
    .RSTn (RSTn),
	.CLK (CLK),
	//------- M1 unit interface -----
	.M1_req (AdderCntrl_ExcCheck_valid),
	.M1_ack (AdderCntrl_Exc_Ack),
	//------- M2 unit interface ----
	.M2_req (MulCntrl_ExcCheck_valid),
	.M2_ack (MulCntrl_Exc_Ack),
	//------ Slave unit interface ---
	.S_req (ExcCheck_valid),
	.S_ack(ExcCheck_Ack),
	.Select(ExcSelect)

	);

booth u_booth (.res(Booth_dataout), .m1(Booth_datain1) , .m2(Booth_datain2), .CLK(CLK),  .BREQ(Booth_valid), .BACK(Booth_ack), .RSTK(RSTn),   
	.Adder_datain1(Booth_Add_datain1) ,
	.Adder_datain2(Booth_Add_datain2) ,
	.Adder_valid(Booth_Add_valid) ,
	//.Adder_Exc(Booth_Add_Exc) ,
	.Adder_dataout(Booth_Add_dataout) ,
	.Adder_carryout(Adder_cout) ,
	.Adder_ack(Booth_Add_ack));
	

MUX25bit2X1 u_mux1_adder( .data1(Add_Op1), .data2(Booth_Add_datain1), .selectLine(AddSelect), .enable(Add_req), .outdata(Add_Op1_wire));
MUX25bit2X1 u_mux2_adder( .data1(Add_Op2), .data2(Booth_Add_datain2), .selectLine(AddSelect), .enable(Add_req), .outdata(Add_Op2_wire));

//25bit1X2Demux u_demux_25bits( .in(Adder_out) , .sel(Add_ack) , .Out1(), .Out2()) ;
//25bit1X2Demux u_demux_3bits( .in() , .sel() , .Out1(), .Out2()) ;




adder_24b u_adder_24b( .Z(Adder_out), .COUT(Adder_cout), .ACK(Add_out_valid), .A(Add_Op1_wire), .B(Add_Op2_wire), .REQ(Add_req), .CLK(CLK), .RSTN(RSTn));


interconnect u_Adder_interconnect(
    .RSTn (RSTn),
	.CLK (CLK),
	//------- M1 unit interface -----
	.M1_req (Add_valid),
	.M1_ack (Add_ack),
	//------- M2 unit interface ----
	.M2_req (Booth_valid),
	.M2_ack (Booth_Add_ack),
	//------ Slave unit interface ---
	.S_req (Add_req),
	.S_ack(Add_out_valid),
	.Select(AddSelect)

	);



endmodule
