typedef enum { Idle=0 , AdderState, EvaluateRes, RoundOff, ExceptionChecker, SetOutput} Mul_cntrl_state ;

module Mul_cntrl (
  //--- Default interface ---
    CLK ,
	RSTn ,
  //--- Caller interface ---
	Datain1 ,
	Datain2 ,
	Data_valid ,
	Dataout ,
	Dataout_valid ,
	Exc ,
	Mode ,
	Debug ,
  //--- Multiplier callee module interface ---
    Multi_datain1 ,
	Multi_datain2 ,
	Multi_valid ,
	Multi_Exc ,
	Multi_dataout ,
	Multi_ack  ,
  //---- ExceptionChecker callee module interface ---
    ExcCheck_valid ,
	ExcCheck_Datain,
	Exc_value,
	Exc_Ack
 ) ;

  //--- Default interface ---
    input             CLK           ;
	input             RSTn          ;
  //--- Caller interface ---
	input      [31:0] Datain1       ;
	input      [31:0] Datain2       ;
	input             Data_valid    ;
	output reg [31:0] Dataout       ;
	output reg        Dataout_valid ;
	output reg [2:0]  Exc           ;
	input      [2:0]  Mode          ;
	output reg [4:0]  Debug         ;
	output reg [23:0] Multi_datain1 ;
	output reg [23:0] Multi_datain2 ;
	output reg        Multi_valid   ;
	input      [2:0]  Multi_Exc     ;
	input      [47:0] Multi_dataout ;
	input             Multi_ack     ;
  //---- ExceptionChecker callee module interface ---
    output reg ExcCheck_valid ;
	output reg[31:0] ExcCheck_Datain;
	input [2:0] Exc_value;
	input Exc_Ack;



Mul_cntrl_state StateMC, next_StateMC ;


reg [8:0]  Final_Exponent, Final_Exponent_reg ;
reg [23:0] Op1_Mantissa, Op1_Mantissa_reg, Op2_Mantissa, Op2_Mantissa_reg ;
reg [5:0]  diff, diff_reg ;
reg [2:0]  exc_val, exc_reg ;
reg [26:0] Final_Mantissa, Final_Mantissa_reg ;
reg Final_Sign, Final_Sign_reg ;
reg G_val, G_reg, T_val, T_reg;
reg denorm;
reg Multi_datain1_val, Multi_datain2_val;

//--- xor u_xor_1( Dataout[31], Datain1[31], Datain2[31]) ;



always @(posedge CLK) begin
   	if(RSTn!=1) begin
   		StateMC <= Idle ;
		//---- Reset All -----
		
		Final_Exponent_reg   <=     0 ;
		Op1_Mantissa_reg     <=     0 ;
		
		Op2_Mantissa_reg     <=     0 ;
		Op1_Exponent_reg     <=     0 ;
		Op2_Exponent_reg     <=     0 ;
		exc_reg              <=     0 ;
		Final_Mantissa_reg   <=     0 ;
		Final_Sign_reg       <=     0 ;
		G_reg                <=     0 ;
		T_reg                <=     0 ;
		denorm_reg           <=     0 ;
		Multi_datain1        <=     0 ;
		Multi_datain2        <=     0 ;


   	end
   	else begin
   		StateMC              <=     next_StateMC   ;
		
		Final_Exponent_reg   <=     Final_Exponent ;
		Op1_Mantissa_reg     <=     Op1_Mantissa   ;
		
		Op2_Mantissa_reg     <=     Op2_Mantissa   ;
		Op1_Exponent_reg     <=     Op1_Exponent   ;
		Op2_Exponent_reg     <=     Op2_Exponent   ;
		exc_reg              <=     exc_val        ;
		Final_Mantissa_reg   <=     Final_Mantissa ;
		Final_Sign_reg       <=     Final_Sign     ;
		G_reg                <=     G_val          ;
		T_reg                <=     T_val          ;
		denorm_reg           <=     denorm         ;
		Multi_datain1	     <=     Multi_datain1_val;
		Multi_datain2	     <=     Multi_datain2_val;

   	end
   end


always@(*) begin
    //---- Remove Latches -----
	        next_StateMC    =   StateMC            ;
	        Final_Exponent  =   Final_Exponent_reg ;
		Op1_Mantissa    =   Op1_Mantissa_reg   ;
		Op2_Mantissa    =   Op2_Mantissa_reg   ;
		Op1_Exponent	=   Op1_Exponent_reg   ;
		Op2_Exponent	=   Op2_Exponent_reg   ;
		exc_val         =   exc_reg            ;
		Final_Mantissa  =   Final_Mantissa_reg ;
		Final_Sign      =   Final_Sign_reg     ;
		carry           =   carry_reg          ;
		G_val           =   G_reg              ;
		T_val           =   T_reg              ;
		denorm          =   denorm_reg         ;
		ExcCheck_Datain =   0                  ;
		ExcCheck_valid  =   0                  ;
		Dataout         =   0                  ;
		Dataout_valid   =   0                  ;
		Multi_valid     =   0		       ;
		Exc             =   0                  ;
	//-------------------------
   	case(StateMC)
		Idle     :   begin
			

						exc_val  =  0 ;
						G_val    =  0 ;
						T_val    =  0 ;
						Dataout_valid = 0 ;
						if(Data_valid==1) begin // new data available for addition
							//---- Compare the Exponent.  Op1(higher exponent)
							next_StateMC = MultiplicationState; // Go to AdderState to drive the adderunit
							Final_Sign= Datain1[31]^Datain2[31];
							Op1_Exponent = Datain1[30:23];
							Op2_Exponent = Datain2[30:23];
							denorm = 1;
							if(Op1_Exponent == 0 && Op2_Exponent == 0) begin
								exc_val = 001;
								next_StateMC = SetOutput;
							end
							else if(Op1_Exponent == 0) begin Op1_Mantissa = {1'b0, Datain1[30:23]}; Op2_Mantissa = {1'b1, Datain2[30:23]}; end
							else if	(Op2_Exponent == 0)begin Op2_Mantissa = {1'b0, Datain2[30:23]}; Op1_Mantissa = {1'b1, Datain1[30:23]}; end
							else begin Op2_Mantissa = {1'b1, Datain2[30:23]}; Op1_Mantissa = {1'b1, Datain1[30:23]}; denorm = 0; end

							Final_Exponent = add8(Op1_Exponent, Op2_Exponent, 1b'0);
							if(denorm_reg == 1) Final_Exponent = add8(Final_Exponent, 8b'01111110, 1b'1);
							else Final_Exponent = add8(Final_Exponent, 8b'01111111, 1b'1);
							if(Final_Exponent[8] == 1) begin exc_val = 3'b010; Final_Exponent[7:0] = 8'b11111111; next_StateMC = SetOutput; end
							

						end
						else next_StateMC = Idle ;

				end

		ExponentUpdate	:	begin
						Final_Exponent			
					end

		MultiplicationState  :  begin
						Multi_valid = 1;
						Multi_datain1 = Op1_Mantissa;
						Multi_datain2 = Op2_Mantissa;
						if(Multi_ack == 1)
						begin
							exc_val = Multi_Exc;
							if(exc_val != 0) next_StateMC = SetOutput;
							else
								begin
									if(Mult_dataout[47] == 1)
										begin
											Final_Mantissa = Multi_dataout[46:23];
											G_val = Multi_dataout[22];
											T_val = Multi_dataout[21];
											Final_Exponent = add8(Final_Exponent, 8b'00000001, 1b'0);
											if(Final_Exponent[8] == 1) begin exc_val = 3'b010; Final_Exponent[7:0] = 8'b11111111; next_StateMC = SetOutput; end
										end
									else
										begin
											Final_Mantissa = Multi_dataout[45:22];
											G_val = Multi_dataout[21];
											T_val = Multi_dataout[20];						
										end
									next_StateMC = Update;
								end
							
							end
							Multi_valid = 0;
						else	next_StateMC = MultiplicationState;
						
							

					end









function bit[8:0] add8( bit[7:0] data1, bit[7:0] data2, bit op);
	bit[8:0] temp;
	if(op == 0) temp = data1 + data2;
	else temp = data1 - data2;
  	return temp ;
endfunction
