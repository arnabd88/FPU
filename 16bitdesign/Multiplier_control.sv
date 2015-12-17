typedef enum { Multiplication_Idle=0 , Multiplication_State, StoreExponent, Multiplication_StartExcCheck1, Multiplication_StartExcCheck2, Multiplication_Update, Multiplication_ExceptionChecker, Multiplication_SetOutput} Mul_cntrl_state ;

module Mul_cntrl (
  //--- Default interface ---
    CLK ,
	RSTn ,
  //--- Caller interface ---
	Datain1 , //data 1 to the multiplier
	Datain2 , //data 2 to the multiplier
	Data_valid , // input signal saying data is valid
	Dataout , // data out result 
	Dataout_valid , //signal saying output is valid
	Exc , //exceptions
	Mode , //mode of operation
	Debug , //debug signals
  //--- Multiplier callee module interface ---
    Multi_datain1 , //input 1 to the booth multiplier (the mantissa)
	Multi_datain2 , //input 2 to the multiplier (the mantissa)
	Multi_valid , // signal saying the signal to the booth multiplier is valid
	Multi_dataout , //booth multiplier data output
	Multi_ack  , //signal asserted by the booth multiplier to say valid data is available on the output
  //---- Multiplication_ExceptionChecker callee module interface ---
    	ExcCheck_valid , // Exceptions for the FPU multiplier unit
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

	output reg [7:0] Multi_datain1 ; //signals going to the booth multiplier
	output reg [7:0] Multi_datain2 ;
	output reg        Multi_valid   ;
	reg 		  Multi_valid_val;
	input      [15:0] Multi_dataout ;
	input             Multi_ack     ;
  //---- Multiplication_ExceptionChecker callee module interface ---
          output reg ExcCheck_valid ;
	output reg[15:0] ExcCheck_Datain;
	input [2:0] Exc_value;
	input Exc_Ack;



Mul_cntrl_state StateMC, next_StateMC ;

reg [15:0] Multi_dataout_val , Multi_dataout_reg ;
reg [8:0]  Final_Exponent, Final_Exponent_reg ;
reg [7:0] Op1_Exponent_reg, Op1_Exponent, Op2_Exponent, Op2_Exponent_reg ;
reg [7:0] Op1_Mantissa, Op1_Mantissa_reg, Op2_Mantissa, Op2_Mantissa_reg ;
reg [2:0]  exc_val, exc_reg ;
reg [7:0] Final_Mantissa, Final_Mantissa_reg ;
reg Final_Sign, Final_Sign_reg ;
reg G_val, G_reg, T_val, T_reg;
reg denorm, denorm_reg;
reg carry, carry_reg ;
reg [7:0] Multi_datain1_val, Multi_datain2_val;
reg ExcCheck_valid_val ;

reg[3:0] Debug_reg, Debug_val ;
reg Debug_valid_reg, Debug_valid_val ;

assign Debug[3:0] = (Mode==3'b100) ? StateMC : (Mode==3'b101 || Mode==3'b110 || Mode==3'b111) ? Debug_reg : 0;
assign Debug[4]   = (Mode==3'b100) ? 1'b1 : (Mode==3'b101 || Mode==3'b110 || Mode==3'b111) ? Debug_valid_reg : 0;

//--- xor u_xor_1( Dataout[15], Datain1[15], Datain2[15]) ;
//assign Multi_datain1 = Multi_datain1_reg;
//assign Multi_datain2 = Multi_datain2_reg;


always @(posedge CLK) begin
   	if(RSTn!=1) begin
   		StateMC <= Multiplication_Idle ;
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
		Multi_dataout_reg    <=     0 ;
		Multi_valid 	     <=     0 ;
		ExcCheck_valid       <=     0 ;
		Debug_reg            <=     0 ;
		Debug_valid_reg      <=     0 ;


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
		Multi_dataout_reg    <=     Multi_dataout_val ;
		Multi_valid 	     <=     Multi_valid_val;
		ExcCheck_valid       <=     ExcCheck_valid_val;
		Debug_reg            <=     Debug_val ;
		Debug_valid_reg      <=     Debug_valid_val ;

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
		//ExcCheck_valid  =   0                  ;
		ExcCheck_valid_val       =     ExcCheck_valid ;
		Dataout         =   0                  ;
		Dataout_valid   =   0                  ;
		Multi_datain1_val   =   Multi_datain1 ;              
		Multi_datain2_val   =   Multi_datain2 ;
		Multi_valid_val =   Multi_valid        ;
		Exc             =   0                  ;
		Multi_dataout_val   =     Multi_dataout_reg ;
		Debug_valid_val = Debug_valid_reg ;
		Debug_val  =  Debug_reg ;
	//-------------------------
   	case(StateMC)
	Multiplication_Idle     :   begin
			
						exc_val  =  0 ;
						G_val    =  0 ;
						T_val    =  0 ;
						Dataout_valid = 0 ;
						Debug_valid_val = 1'b0 ;
						next_StateMC = Multiplication_Idle ;
						if(Data_valid==1) begin // new data available for multiplication
							//---- Compare the Exponent.  Op1(higher exponent)
							next_StateMC = Multiplication_StartExcCheck1; // Go to Datain Exception check state 
							Final_Sign= Datain1[15]^Datain2[15]; //Calculating the sign 
							

						end

				end

		Multiplication_StartExcCheck1	:	begin
								Debug_valid_val = 1'b0 ;
								ExcCheck_valid_val = 1'b1 ;
								ExcCheck_Datain = Datain1; 
								if(Exc_Ack == 1) begin
									ExcCheck_valid_val = 0 ;
									exc_val = Exc_value ;
									if(Exc_value == 3'b100)
									begin
										next_StateMC = Multiplication_SetOutput;
										Final_Mantissa = Datain1[6:0];
										Final_Exponent = Datain1[14:7];
									end
									else
										next_StateMC = Multiplication_StartExcCheck2 ;
								end
								else	next_StateMC = Multiplication_StartExcCheck1;
								

							end

		Multiplication_StartExcCheck2	:	begin
								Debug_valid_val = 1'b0 ;
								ExcCheck_valid_val = 1'b1 ;
								ExcCheck_Datain = Datain2; 
								if(Exc_Ack == 1) begin
									ExcCheck_valid_val = 0 ;
									if(Exc_value == 3'b100)
									begin
										next_StateMC = Multiplication_SetOutput;
										Final_Mantissa = Datain2[6:0];
										Final_Exponent = Datain2[14:7];
										exc_val = Exc_value ;
									end									
									else if(Exc_value == 3'b011 && exc_reg == 3'b011)
									begin
										next_StateMC = Multiplication_SetOutput;
										Final_Mantissa = Datain2[6:0];
										Final_Exponent = Datain2[14:7];
										exc_val = 3'b011;
									end
									else if(Exc_value == 3'b011 && exc_reg == 3'b111 || Exc_value == 3'b111 && exc_reg == 3'b011)
									begin
										next_StateMC = Multiplication_SetOutput;
										Final_Mantissa = 1;
										Final_Exponent = 8'b11111111;
										exc_val = 3'b100;
									end
									else
									begin
										next_StateMC = StoreExponent;
										exc_val = 3'b000;
									end
								end
								else	next_StateMC = Multiplication_StartExcCheck2;
								

							end

		StoreExponent	:	begin
						Debug_valid_val = 1'b0 ;
						next_StateMC = Multiplication_State;
						Op1_Exponent = Datain1[14:7]; //Storing the inputs
						Op2_Exponent = Datain2[14:7]; //Storing the inputs
						denorm = 1;
						if(Op1_Exponent == 0) begin Op1_Mantissa = {1'b0, Datain1[6:0]}; Op2_Mantissa = {1'b1, Datain2[6:0]}; end
						else if(Op2_Exponent == 0) begin Op2_Mantissa = {1'b0, Datain2[6:0]}; Op1_Mantissa = {1'b1, Datain1[6:0]}; end
						else begin Op2_Mantissa = {1'b1, Datain2[6:0]}; Op1_Mantissa = {1'b1, Datain1[6:0]}; denorm = 0; end

						Final_Exponent = add8(Op1_Exponent, Op2_Exponent, 1'b0); //adding the two exponents
						if(denorm == 1) Final_Exponent = add8(Final_Exponent, 9'b001111110, 1'b1);
						else Final_Exponent = add8(Final_Exponent, 9'b001111111, 1'b1); // Subtracting bias from the exponents
						if(Final_Exponent[8] == 1) 
						begin 
							exc_val = 3'b010; 
							Final_Exponent[7:0] = 8'b11111111; 
							next_StateMC = Multiplication_SetOutput; 
						end //overflow in the exponent. Set to infinity 
						if(Mode==3'b110)
						begin  
							Debug_valid_val = 1'b1 ;
			  				Debug_val = {Final_Exponent[8],denorm};
						end						
						if((Op1_Exponent == 0 && Op2_Exponent == 0) || (Op1_Exponent == 0 && Op2_Exponent < 127) || (Op1_Exponent < 127 && Op2_Exponent == 0)) begin //checking for underflow in the input
							exc_val = 3'b001; 
							Final_Exponent = 0;
							Final_Mantissa = 0;
							next_StateMC = Multiplication_SetOutput;
						end
					end




		Multiplication_Update	:	begin
					Debug_valid_val = 1'b0 ;
					
					Final_Mantissa[7:0] = Final_Mantissa_reg[6:0] + (G_reg & (Final_Mantissa_reg[0] | T_reg));
					if(G_reg | T_reg) exc_val = 3'b101;
					next_StateMC = Multiplication_ExceptionChecker;
					if(Final_Mantissa[7] == 1)
					begin
						Final_Exponent = add8(Final_Exponent_reg, 8'b00000001, 1'b0);
						if(Final_Exponent[8] == 1) 
						begin 
							exc_val = 3'b010; 
							Final_Exponent[7:0] = 8'b11111111; 
							next_StateMC = Multiplication_SetOutput; 
						end
					end 
					
				end

		Multiplication_State  :  begin
						Debug_valid_val = 1'b0 ;
						next_StateMC = Multiplication_State;
						if(Multi_ack == 0) //prechecking booth status for multiplication
						begin
							Multi_valid_val = 1;
							Multi_datain1_val = Op1_Mantissa_reg;
							Multi_datain2_val = Op2_Mantissa_reg;

						end
						else if(Multi_ack == 1) //checking value received from booth multiplier
						begin
							Multi_valid_val = 0; //de-asserting the valid signal sent to booth 
							Multi_dataout_val = Multi_dataout ; 
							if(exc_val != 0) next_StateMC = Multiplication_SetOutput;
							else
								begin
									next_StateMC = Multiplication_Update;
								
									if(Multi_dataout_val[15] == 1) //this is when the mantissa result starts with 10 or 11
										begin
											Final_Mantissa[6:0] = Multi_dataout_val[14:8];
											G_val = Multi_dataout_val[7];
											T_val = Multi_dataout_val[6];
											Final_Exponent = add8(Final_Exponent, 9'b000000001, 1'b0); //incrementing exponent
											if(Final_Exponent[8] == 1) 
											begin 
												exc_val = 3'b010; 
												Final_Exponent[7:0] = 8'b11111111;
												Final_Mantissa = 0; 
												next_StateMC = Multiplication_SetOutput; 
											end //If the exponent overflows, generate exception of overflow/infinity 
										end
									else if({Multi_dataout_val[15], Multi_dataout_val[14]} == 2'b01) //this is when the mantissa result starts with 01
										begin
											Final_Mantissa[6:0] = Multi_dataout_val[13:7];
											G_val = Multi_dataout_val[6];
											T_val = Multi_dataout_val[5];						
										end
								
									else //denormal case
										begin
											/*
											while(Final_Exponent > 0 && Multi_dataout_val[12] != 1'b1)
											begin
												Multi_dataout_val = Multi_dataout << 1;
												Final_Exponent = add8(Final_Exponent, 8'b00000001, 1'b1);
											end
											*/
											Multi_dataout_val = normalize(Multi_dataout_val[13:0]);
											Final_Mantissa[6:0] = Multi_dataout_val[13:7];
											G_val = Multi_dataout_val[6];
											T_val = Multi_dataout_val[5];
										end
									
								end
								if(Mode==3'b101)
								begin
									Debug_valid_val = 1'b1 ;	
									Debug_val = {Multi_dataout_val[15:14], G_val|T_val, Final_Exponent[8]} ;
								end
						end
					end
		
		Multiplication_ExceptionChecker    :	begin
								Debug_valid_val = 1'b0 ;
								ExcCheck_valid_val = 1'b1 ;
								ExcCheck_Datain = {Final_Sign_reg, Final_Exponent_reg[7:0], Final_Mantissa_reg[6:0]}; 
								if(Exc_Ack == 1) begin
									ExcCheck_valid_val = 0 ;
									exc_val = Exc_value ;
									next_StateMC = Multiplication_SetOutput;
								end
								else	next_StateMC = Multiplication_ExceptionChecker;
								 
							end
	


			Multiplication_SetOutput   :  begin
						Debug_valid_val = 1'b0 ;
						if(exc_reg != 0)	Exc  =  exc_reg ;
						
							Dataout = {Final_Sign_reg, Final_Exponent_reg[7:0], Final_Mantissa_reg[6:0]} ;
						Dataout_valid = 1'b1 ;
						next_StateMC = Multiplication_Idle;
				       end




		endcase

	end




function bit[8:0] add8( bit[8:0] data1, bit[8:0] data2, bit op);
	bit[8:0] temp;
	if(op == 0) temp = data1 + data2;
	else temp = data1 - data2;
  	return temp ;
endfunction

 function  automatic bit[13:0] normalize( bit[13:0] data);
 	bit[3:0] index ;
 	bit first_hit ;
 	bit[0:13] temp = data;
 	for(int j=0 ; j<=13; j++) begin
 		if(first_hit==0 && temp[j]==1'b1) begin
 			first_hit = 1'b1 ;
 			index = j ;
			if(Mode==3'b111)
			begin  
				Debug_valid_val = 1'b1 ;
			  	Debug_val = index;
			end
 			if(index > Final_Exponent_reg) begin
				index = Final_Exponent_reg ;
 				Final_Exponent = 0;
 			end
 			else Final_Exponent = Final_Exponent_reg - j ;
 		end
 	end
     data = data << index ;
 	return data ;
 	
 endfunction

endmodule
