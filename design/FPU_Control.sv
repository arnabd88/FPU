typedef enum { topIdle=0, topWaitAdderOp2, topWaitMultOp2 } FPU_COntrol_State ;

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
 
reg [31:0]  AdderCntrl_Op1 ;
reg [31:0]  AddCntrl_Op2   ;
reg         AddCntrl_valid ;
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

reg [31:0] MulCntrl_Op1 ;
reg [31:0] MulCntrl_Op2 ;
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

assign Add_dataout = Adder_out ;
assign Booth_Add_dataout = Adder_out ;
assign Add_carryout = Adder_cout ;
assign Booth_Add_carryout = Adder_cout ;


Adder_cntrl u_adder_cntrl(
  //--- Default interface ---
    .CLK(CLK) ,
	.RSTn(RSTn) ,
  //--- Caller interface ---
	.Datain1(AdderCntrl_Op1) ,
	.Datain2(AddCntrl_Op2) ,
	.Data_valid(AddCntrl_valid) ,
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
	.Adder_carryout(Add_carryout) ,
	.Adder_ack(Add_ack)  ,
  //---- ExceptionChecker callee module interface ---
    .ExcCheck_valid(AdderCntrl_ExcCheck_valid) ,
	.ExcCheck_Datain(AdderCntrl_ExcCheck_Datain),
	.Exc_value(AdderCntrl_Exc_value),
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
	.Exc_value(MulCntrl_Exc_value),
	.Exc_Ack(MulCntrl_Exc_Ack)
 ) ;



MUX32bit2X1 u_mux_exc( .data1(AdderCntrl_ExcCheck_Datain), .data2(MulCntrl_ExcCheck_Datain), .selectLine(ExcSelect), .enable(ExcCheck_valid), .outdata(ExcCheck_Data) );


exceptionChecker u_exc_check( .Exc(ExcCheck_value), .ACK(ExcCheck_Ack), .Data(ExcCheck_Data), .Data_valid(ExcCheck_valid), .CLK(CLK), .RSTN(RSTn));


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

booth u_booth (.res(), .m1(Booth_datain1) , .m2(Booth_datain2), .CLK(CLK),  .BREQ(Booth_valid), .BACK(Booth_ack), .RSTK(RSTn),   
	.Adder_datain1(Booth_Add_datain1) ,
	.Adder_datain2(Booth_Add_datain2) ,
	.Adder_valid(Booth_Add_valid) ,
	//.Adder_Exc(Booth_Add_Exc) ,
	.Adder_dataout(Booth_Add_dataout) ,
	.Adder_carryout(Booth_Add_carryout) ,
	.Adder_ack(Booth_Add_ack));
	


MUX25bit2X1 u_mux1_adder( .data1(Add_Op1), .data2(Booth_Add_datain1), .selectLine(AddSelect), .enable(Add_req), .outdata(Add_Op1_wire));
MUX25bit2X1 u_mux2_adder( .data1(Add_Op2), .data2(Booth_Add_datain2), .selectLine(AddSelect), .enable(Add_req), .outdata(Add_Op2_wire));

//25bit1X2Demux u_demux_25bits( .in(Adder_out) , .sel(Add_ack) , .Out1(), .Out2()) ;
//25bit1X2Demux u_demux_3bits( .in() , .sel() , .Out1(), .Out2()) ;




adder_24b u_adder_24b( .Z(Adder_out), .COUT(), .ACK(Add_out_valid), .A(Add_op1_wire), .B(Add_op2_wire), .REQ(Add_req), .CLK(CLK), .RSTN(CLK));


interconnect u_Adder_interconnect(
    .RSTn (RSTn),
	.CLK (CLK),
	//------- M1 unit interface -----
	.M1_req (Add_valid),
	.M1_ack (Add_ack),
	//------- M2 unit interface ----
	.M2_req (Booth_valid),
	.M2_ack (Booth_ack),
	//------ Slave unit interface ---
	.S_req (Add_req),
	.S_ack(Add_out_valid),
	.Select(AddSelect)

	);



endmodule
