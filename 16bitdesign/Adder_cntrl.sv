typedef enum { Idle=0 , StartExcCheck1, StartExcCheck2, AdderState, EvaluateRes, RoundOff, ExceptionChecker, SetOutput} Adder_cntrl_state ;

module Adder_cntrl (
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
  //--- Adder callee module interface ---
    Adder_datain1 ,
	Adder_datain2 ,
	Adder_valid ,
	//Adder_Exc ,
	Adder_dataout ,
	Adder_carryout ,
	Adder_ack  ,
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
	input      [15:0] Datain1       ;
	input      [15:0] Datain2       ;
	input             Data_valid    ;
	output reg [15:0] Dataout       ;
	output reg        Dataout_valid ;
	output reg [2:0]  Exc           ;
	input      [2:0]  Mode          ;
	output reg [4:0]  Debug         ;
  //--- Adder callee module interface ---
    output reg [8:0] Adder_datain1 ;
	output reg [8:0] Adder_datain2 ;
	output reg        Adder_valid     ;
//	input      [1:0]  Adder_Exc       ;
	input      [8:0] Adder_dataout   ;
	input             Adder_carryout  ;
	input             Adder_ack       ;
  //---- ExceptionChecker callee module interface ---
    output reg ExcCheck_valid ;
	output reg[15:0] ExcCheck_Datain;
	input [2:0] Exc_value;
	input Exc_Ack;

	reg ExcCheck_valid_val ;



Adder_cntrl_state StateMC, next_StateMC ;

reg        Op1_Sign, Op1_Sign_reg, Op2_Sign, Op2_Sign_reg ;
reg [7:0]  Final_Exponent, Final_Exponent_reg ;
reg [7:0] Op1_Mantissa, Op1_Mantissa_reg, Op2_Mantissa, Op2_Mantissa_reg ;
reg [7:0]  diff, diff_reg ;
reg [2:0]  exc_val, exc_reg ;
reg [10:0] Final_Mantissa, Final_Mantissa_reg ;
reg        Add_sign, Add_sign_reg;
reg Final_Sign, Final_Sign_reg ;
reg carry, carry_reg ;
reg G_val, G_reg, R_val, R_reg, S_val, S_reg ;
reg Adder_valid_val ;
reg [8:0] Adder_datain1_val , Adder_datain2_val ;

xor u_xor_1( EOP, Op1_Sign_reg, Op2_Sign_reg) ;

  //--- Synchronous Block ---
   always @(posedge CLK) begin
   	if(RSTn!=1) begin
   		StateMC <= Idle ;
		//---- Reset All -----
		Op1_Sign_reg         <=     0 ;
		Final_Exponent_reg   <=     0 ;
		Op1_Mantissa_reg     <=     0 ;
		Op2_Sign_reg         <=     0 ;
		Op2_Mantissa_reg     <=     0 ;
		diff_reg             <=     0 ;
		exc_reg              <=     0 ;
		Final_Mantissa_reg   <=     0 ;
		Final_Sign_reg       <=     0 ;
		carry_reg            <=     0 ;
		G_reg                <=     0 ;
		R_reg                <=     0 ;
		S_reg                <=     0 ;
		Adder_valid          <=     0 ;
		Adder_datain1        <=     0 ;
		Adder_datain2        <=     0 ;
		Add_sign_reg         <=     0 ;
		ExcCheck_valid       <=     0 ;

   	end
   	else begin
   		StateMC              <=     next_StateMC   ;
		Op1_Sign_reg         <=     Op1_Sign       ;
		Final_Exponent_reg   <=     Final_Exponent ;
		Op1_Mantissa_reg     <=     Op1_Mantissa   ;
		Op2_Sign_reg         <=     Op2_Sign       ;
		Op2_Mantissa_reg     <=     Op2_Mantissa   ;
		diff_reg             <=     diff           ;
		exc_reg              <=     exc_val        ;
		Final_Mantissa_reg   <=     Final_Mantissa ;
		Final_Sign_reg       <=     Final_Sign     ;
		carry_reg            <=     carry          ;
		G_reg                <=     G_val          ;
		R_reg                <=     R_val          ;
		S_reg                <=     S_val          ;
		Adder_valid          <=     Adder_valid_val    ;
		Adder_datain1        <=     Adder_datain1_val ;
		Adder_datain2        <=     Adder_datain2_val ;
		Add_sign_reg         <=     Add_sign       ;
		ExcCheck_valid       <=     ExcCheck_valid_val ;
   	end
   end


  //--- Combinational Block ---
   always@(*) begin
    //---- Remove Latches -----
	    next_StateMC    =   StateMC            ;
		Op1_Sign        =   Op1_Sign_reg       ;
		Final_Exponent  =   Final_Exponent_reg ;
		Op1_Mantissa    =   Op1_Mantissa_reg   ;
		Op2_Sign        =   Op2_Sign_reg       ;
		Op2_Mantissa    =   Op2_Mantissa_reg   ;
		diff            =   diff_reg           ;
		exc_val         =   exc_reg            ;
		Final_Mantissa  =   Final_Mantissa_reg ;
		Final_Sign      =   Final_Sign_reg     ;
		carry           =   carry_reg          ;
		G_val           =   G_reg              ;
		R_val           =   R_reg              ;
		S_val           =   S_reg              ;
		ExcCheck_Datain =   0                  ;
		ExcCheck_valid_val  =   0                  ;
		Dataout         =   0                  ;
		Dataout_valid   =   0                  ;
		Adder_datain1_val   =   0                  ;
		Adder_datain2_val   =   0                  ;
		Adder_valid_val = Adder_valid ;
		Add_sign        = Add_sign_reg ;
		//if(StateMC==AdderState && Adder_valid==1) Adder_valid     =   1    ;
		//else                                      Adder_valid     =   0    ;
		Exc             =   0                  ;
		ExcCheck_valid_val       =     0 ;
	//-------------------------
	Debug = StateMC ;
   	case(StateMC)
		Idle     :   begin
						exc_val  =  0 ;
						G_val    =  0 ;
						R_val    =  0 ;
						S_val    =  0 ;
						Dataout_valid = 0 ;
						if(Data_valid==1) begin // new data available for addition
							//---- Compare the Exponent.  Op1(higher exponent)
							if(Datain1[14:7] >= Datain2[14:7]) begin
								diff           =   Datain1[14:7] - Datain2[14:7]  ;
								Op1_Sign       =   Datain1[15] ;
								Final_Exponent =   Datain1[14:7] ;
								if(Datain1[14:7] == 8'h00)
									Op1_Mantissa = {1'b0, Datain1[6:0]} ;
								else
									Op1_Mantissa   =   {1'b1, Datain1[6:0]} ;
								Op2_Sign       =   Datain2[15] ;
								if(diff !=0) G_val          =   Datain2[diff-1];
								if(diff > 1)	R_val          =   Datain2[diff-2] ;
								if(diff > 2)    S_val          =   Datain2[diff-3] ;
								if(Datain2[14:7]== 8'h00)
									Op2_Mantissa = {1'b0, Datain2[6:0]} >> diff ;
								else
									Op2_Mantissa   =   {1'b1, Datain2[6:0]} >> diff ;
							end
							else begin
								diff           =   Datain2[14:7] - Datain1[14:7] ;
								Final_Exponent =   Datain2[14:7] ;
								Op1_Sign       =   Datain2[15] ;
								if(Datain2[14:7] == 8'h00)	Op1_Mantissa   = {1'b0, Datain2[6:0]} ;
								else						Op1_Mantissa   =   {1'b1, Datain2[6:0]} ;
								Op2_Sign       =   Datain1[15] ;
								G_val          =   Datain1[diff-1];
								if(diff != 1)	R_val          =   Datain1[diff-2] ;
								if(diff > 2)    S_val          =   Datain1[diff-3] ;
								if(Datain1[14:7] == 8'h00)	Op2_Mantissa   = {1'b0, Datain1[6:0]} >> diff;
								else                    	Op2_Mantissa   =   {1'b1, Datain1[6:0]} >> diff ;
							end
							next_StateMC = StartExcCheck1 ; // Go to AdderState to drive the adderunit
						end
						else next_StateMC = Idle ;
					 end
   StartExcCheck1 : begin
   						ExcCheck_valid_val = 1'b1 ;
						ExcCheck_Datain = {Final_Sign_reg, Final_Exponent_reg, Op2_Mantissa_reg};
						if(Exc_Ack == 1) begin
							ExcCheck_valid_val = 0 ;
							exc_val = Exc_value ;
							if(exc_val == 0)
								next_StateMC = AdderState ;   						
							else next_StateMC = SetOutput ;
						end
						//else next_StateMC = StartExcCheck ;
   					  end
	AdderState   :	begin
						if(Adder_ack == 0 ) begin
						    Adder_valid_val  =  1 ;
						    Adder_datain1_val = {1'b0,Op1_Mantissa_reg} ;
						    if(EOP == 1)	{Adder_datain2_val,G_val,R_val,S_val} = (~{{1'b0,Op2_Mantissa_reg},G_reg,R_reg,S_reg}) + 1'b1 ;
						    else            Adder_datain2_val =  {1'b0,Op2_Mantissa_reg} ;
						end
						else if(Adder_ack == 1 ) begin
							//---- Receive the data sent by the adder circuit ----
							Adder_valid_val = 1'b0 ;
					//		exc_val = Adder_Exc ;
							Add_sign       = Adder_dataout[8] ;
							Final_Mantissa = {Adder_dataout[7:0],G_val, R_val, S_val} ;
							carry          = Adder_carryout ;
							//---- Disable the adder call and reset the drive lines ----
							if ( exc_val != 0 ) next_StateMC = SetOutput ;
							else                next_StateMC = EvaluateRes ;
						end
						else                    next_StateMC = AdderState ;
					end
  EvaluateRes    :  begin
  					   //--- Find out the cases ---
					   case({EOP,carry_reg^Add_sign_reg,Final_Mantissa_reg[10]})
					   		3'b101   :   begin
											//--- Different signs, noCarry, MSB 1 --> Sum is negative
											Final_Sign = 1'b1 ;
											Final_Mantissa = ~(Final_Mantissa_reg) + 1'b1 ;
										 end
							3'b010   :   begin
											//-- Same sign, carry generated
											Final_Sign     = Op1_Sign_reg ;
											Final_Mantissa = {carry_reg, Final_Mantissa_reg[10:1]} ;
											if(Final_Exponent_reg == 8'hFF) exc_val = 3'b010 ;
											else Final_Exponent = Final_Exponent_reg + 1'b1 ;
										 end
							3'b011   :   begin
											//-- Same sign, carry generated
											Final_Sign     = Op1_Sign_reg ;
											Final_Mantissa = {carry_reg, Final_Mantissa_reg[10:1]} ;
											if(Final_Exponent_reg == 8'hFF) exc_val = 3'b010 ;
											else Final_Exponent = Final_Exponent_reg + 1'b1 ;
										 end
							3'b000   :   begin
											Final_Sign     = Op1_Sign_reg ;
											Final_Mantissa = normalize(Final_Mantissa_reg);
										 end
							3'b001   :   begin
											Final_Sign     = Op1_Sign_reg ;
											Final_Mantissa = normalize(Final_Mantissa_reg);
										 end
							// 3'b111   :   begin //--- Ignore carry if generated for different sign ----
							// 				if(carry_reg==1) begin
							// 					Final_Sign     = Op1_Sign_reg ;
							// 					Final_Mantissa = normalize(Final_Mantissa_reg) ;
							// 				end
							// 				else begin
							// 					Final_Sign     = Add_sign_reg ;
							// 					Final_Mantissa = normalize(~Final_Mantissa_reg + 1) ;
							// 				end
							// 			 end
							// 3'b110   :   begin //--- Ignore carry if generated for different sign ----
							// 				if(carry_reg==1) begin
							// 					Final_Sign     = Op1_Sign_reg ;
							// 					Final_Mantissa = normalize(Final_Mantissa_reg) ;
							// 				end
							// 				else begin
							// 					Final_Sign     = Add_sign_reg ;
							// 					Final_Mantissa = normalize(~Final_Mantissa_reg + 1) ;
							// 				end
							// 			 end
							default :    begin
											if(carry_reg==1) begin
												Final_Sign  =  Op1_Sign_reg ;
												Final_Mantissa = normalize(Final_Mantissa_reg);
											end
											else begin
												Final_Sign = Add_sign_reg ;
												Final_Mantissa = normalize(~Final_Mantissa_reg + 1);
											end
										 end
					   endcase
					   if(exc_val != 0) next_StateMC = SetOutput ;
					   else             next_StateMC = RoundOff  ;
                    end
	RoundOff    :  begin
						carry = 0 ;
					//	case({Final_Mantissa_reg[2:0]})
					//		3'b110   :  {carry,Final_Mantissa[26:3]} = Final_Mantissa_reg[26:3] + 1'b1 ;
					//		3'b111   :  {carry,Final_Mantissa[26:3]} = Final_Mantissa_reg[26:3] + 1'b1 ;
					//		3'b101   :  {carry,Final_Mantissa[26:3]} = Final_Mantissa_reg[26:3] + 1'b1 ;
					//		3'b100   :  begin
					//						if(Final_Mantissa_reg[3]==1) {carry,Final_Mantissa[26:3]} = Final_Mantissa_reg[26:3] + 1'b1 ;
					//					end
					//	endcase
						case({Final_Mantissa_reg[2:1]})
							2'b11    :  {carry, Final_Mantissa[10:3]} = Final_Mantissa_reg[10:3] + 1'b1 ;
							2'b10    :  begin
											if(Final_Mantissa_reg[0]==1) {carry,Final_Mantissa[10:3]} = Final_Mantissa_reg[10:3] + 1'b1 ;
									    	else if(Final_Mantissa_reg[3]==1) {carry,Final_Mantissa[10:3]} = Final_Mantissa_reg[10:3] + 1'b1 ;
										end
						endcase
						if(carry == 1) next_StateMC = EvaluateRes ;
						else next_StateMC = ExceptionChecker ;
				   end
   ExceptionChecker : begin
   						ExcCheck_valid_val = 1'b1 ;
						ExcCheck_Datain = {Final_Sign_reg, Final_Exponent_reg, Final_Mantissa_reg[9:3]};
						if(Exc_Ack == 1) begin
							ExcCheck_valid_val = 0 ;
							exc_val = Exc_value ;
							next_StateMC = SetOutput ;   						
						end
						else next_StateMC = ExceptionChecker ;
   					  end
	SetOutput   :  begin
						if(exc_reg != 0)	Exc  =  exc_reg ;
						Dataout = {Final_Sign_reg, Final_Exponent_reg, Final_Mantissa_reg[9:3]} ;
						Dataout_valid = 1'b1 ;
						next_StateMC = Idle ;
				   end
	//EndState    :  begin
	//					Dataout_valid = 1'b0 ;
	//					next_StateMC  = Idle ;
	//			   end
		
	endcase
   end


//------- functionally correct with lot of slack -------------
// function automatic bit[26:0] normalize( bit[26:0] data);
// bit[26:0] temp = data ;
//   for( int i=0; i<27; i++) begin
//   	if(temp[26]==1) begin
// 	    if(i > Final_Exponent_reg) begin 
// 			exc_val = 3'b001 ;
// 			return temp[26:0] ;
// 		end
// 		else begin
// 			Final_Exponent = Final_Exponent_reg - i ;
// 			return temp[26:0] ;
// 		end
// 	end
// 	else  temp[26:0] = {temp[25:0],1'b0};
//   end
//   return temp ;
// endfunction


//----- Under Experiment with no parallel shifting ------
// function  automatic bit[26:0] normalize( bit[26:0] data);
// 	bit[4:0] index ;
// 	bit first_hit ;
// 	bit[0:26] temp = data;
// 	bit [26:0] data_final ;
// 	for(int j=0 ; j<=26; j++) begin
// 		if(first_hit==0 && temp[j]==1'b1) begin
// 			first_hit = 1'b1 ;
// 			index = j ;
// 			if(index > Final_Exponent_reg) begin
// 				exc_val = 3'b001 ;
// 			end
// 			else Final_Exponent = Final_Exponent_reg - j ;
// 		end
// 	end
// 	index = 26 - index ;
// 	for(int i=0; i<= index; i++) begin
// 		data_final[26-i] = data[index-i];
// 	end
// 	index = 26 - index ;
// 	for(int i=0; i<index ;i++)  data_final[i]=1'b0;
// //   data = data << index ;
// //	return data ;
//     return data_final ;
// 	
// endfunction


//----- Under Experiment with  parallel shifting ------
// function  automatic bit[26:0] normalize( bit[26:0] data);
// 	bit[4:0] index ;
// 	bit first_hit ;
// 	bit[0:26] temp = data;
// 	//bit [26:0] data_final ;
// 	bit[13:0] arr1=data[26:13] ;
// 	bit[12:0] arr2=data[12:0] ;
// 	for(int j=0 ; j<=26; j++) begin
// 		if(first_hit==0 && temp[j]==1'b1) begin
// 			first_hit = 1'b1 ;
// 			index = j ;
// 			if(index > Final_Exponent_reg) begin
// 				exc_val = 3'b001 ;
// 			end
// 			else Final_Exponent = Final_Exponent_reg - j ;
// 		end
// 	end
// 
// 
//     for(int i=0; i< index; i++) begin
// 		if(index >= 13) begin
// 			arr2 = 0 ;
// 			if(i<=12) arr1 = {arr1[12:0], data[12-i]} ;
// 			else     arr1 = {arr1[12:0],1'b0} ;
// 		end
// 		else begin
// 			arr1 = {arr1[12:0], data[12-i]};
// 			arr2 = {arr2[11:0], 1'b0} ;
// 		end
// 	end
// 
// 
// 
// 
//     data = {arr1, arr2};
// 	return data ;
// 	
// endfunction



//---- Closest working model as of now -----

 function  automatic bit[10:0] normalize( bit[10:0] data);
 	bit[4:0] index ;
 	bit first_hit ;
 	bit[0:10] temp = data;
 	for(int j=0 ; j<=10; j++) begin
 		if(first_hit==0 && temp[j]==1'b1) begin
 			first_hit = 1'b1 ;
 			index = j ;
 			if(index > Final_Exponent_reg) begin
 				exc_val = 3'b001 ;
 			end
 			else Final_Exponent = Final_Exponent_reg - j ;
 		end
 	end
     data = data << index ;
 	return data ;
 	
 endfunction


endmodule
