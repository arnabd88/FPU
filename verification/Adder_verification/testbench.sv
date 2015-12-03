//--------------------------------------------------------------------
//--------------- Simple testbench module with directed testcases ----
//---- Each individual tests are broken into task based templates ----
//---- These tests can be just included and executed by task calls ---
//--------------------------------------------------------------------
//`timescale 1ns / 100ps
//`include "../../design/adder_24b.sv"
//`include "../../design/Adder_cntrl.sv"

module testbench ;

bit [31:0] Datain1_reg, Datain2_reg ;
bit Data_valid_reg ;
bit[2:0] Mode_reg ;
bit[4:0] Debug_reg ;

reg CLK, RSTn ;

wire [31:0] Dataout_wire ;
wire Dataout_valid_wire ;
wire [2:0] Exc_wire ;
wire [24:0] Adder_datain1_wire , Adder_datain2_wire ;
wire Adder_valid_wire ;
wire [24:0] Adder_dataout_wire ;
wire [2:0] Adder_Exc_wire ;
wire Adder_carryout_wire ;
wire Adder_ack_wire ;

bit [31:0] num1, num2, n1_tc1,n2_tc1,res_tc1,res_tc2,res_tc3,res_tc4,res_tc5;

 Adder_cntrl u_adder_cntrl(
  //--- Default interface ---
    .CLK (CLK),
	.RSTn(RSTn) ,
  //--- Caller interface ---
	.Datain1(Datain1_reg) ,
	.Datain2(Datain2_reg) ,
	.Data_valid(Data_valid_reg) ,
	.Dataout(Dataout_wire) ,
	.Dataout_valid(Dataout_valid_wire) ,
	.Exc(Exc_wire) ,
	.Mode(Mode_reg) ,
	.Debug(Debug_reg) ,
  //--- Adder callee module interface ---
    .Adder_datain1(Adder_datain1_wire) ,
	.Adder_datain2(Adder_datain2_wire) ,
	.Adder_valid(Adder_valid_wire) ,
	.Adder_Exc(Adder_Exc_wire) ,
	.Adder_dataout(Adder_dataout_wire) ,
	.Adder_carryout(Adder_carryout_wire) ,
	.Adder_ack(Adder_ack_wire)  ,
  //---- ExceptionChecker callee module interface ---
    .ExcCheck_valid(ExcCheck_valid_wire) ,
	.ExcCheck_Datain(ExcCheck_Datain_wire),
	.Exc_value(Exc_value_wire),
	.Exc_Ack(Exc_Ack_wire)
 ) ;


adder_24b u_adder_24b( .Z(Adder_dataout_wire), .COUT(Adder_carryout_wire), .ACK(Adder_ack_wire), .A(Adder_datain1_wire), .B(Adder_datain2_wire), .REQ(Adder_valid_wire), .CLK(CLK), .RSTN(RSTn));
exceptionChecker u_exc_chk( .Exc(Exc_value_wire), .ACK(Exc_Ack_wire), .Data(ExcCheck_Datain_wire), .Data_valid(ExcCheck_valid_wire), .CLK(CLK), .RSTN(RSTn));

   always #5 CLK  =  ~CLK ;


   initial  begin

   // Input numbers for test cases
	//n1_tc1[31:0] = 32'b01000000001100000000000000000000;
        //n2_tc1[31:0] = 32'b01000000101100000000000000000000; 

	/*n1_tc2 = 32'100000000111111111111111111111110;
	n2_tc2 = 32'b00000000111111111111111111111001;
	res_tc2 = 

	n1_tc3 = 32'100000000111111111111111111111110;
	n2_tc3 = 32'100000000111111111111111111111001;
	res_tc3 = 
	*/
	//Adder_valid_wire = 1;
        
	CLK  =  1'b1 ;
		reset();
		@(negedge CLK) ;
		begin
		   //addTwoRandomNumbers();
		   //addTestCase0();// Check for exceptions in Input numbers
		   addTestCase1();//Same sign
		   addTestCase2();//Opposite signs, Negative number smaller magnitude
		   addTestCase3();//Opposite signs, Negative number larger magnitude
		   addTestCase4();//Opposite signs, Negative number very large magnitude, Active GRS bits	
	           addTestCase5();
		end
		#100 $finish();
		//---- Call the tasks in sequence -----

	$display("Input Data: Num1 = %b, Num2 = %b", num1, num2);

   end

   /*
   task addTwoRandomNumbers();
   num1 =  $random();
   num2 =  $random();
   //---- Provide the data at the posedge of CLK -----
   wait(Dataout_valid_wire==1'b0);
   @(negedge CLK);
       Datain1_reg <= num1 ;
	   Datain2_reg <= num2 ;
	   Data_valid_reg <= 1'b1 ;
   wait(Dataout_valid_wire==1'b1)
   	   Data_valid_reg <= 1'b0 ;
	$display("Input Data: Num1 = %b, Num2 = %b", num1, num2);
	$display("Computed Data : %b @", Dataout_wire, $time);
   endtask
   */

   task addTestCase1();begin

   //num1 = n1;
   //num2 = n2;

   num1 = 32'b01000000001100000000000000000000;//2.75
   num2 = 32'b01000000101100000000000000000000;//5.5
   res_tc1[31:0] = 32'b01000001000001000000000000000000;//8.25

   //$display("Num1 = %b, n1_tc1 = %b", 32'b00000000100101110000101000111101, n1_tc1);

   //---- Provide the data at the posedge of CLK -----
   wait(Dataout_valid_wire==1'b0);
   @(negedge CLK);
       Datain1_reg <= num1 ;
       Datain2_reg <= num2 ;
       Data_valid_reg <= 1'b1 ;
   wait(Dataout_valid_wire==1'b1)
   	   Data_valid_reg <= 1'b0 ;
	$display("\n");
	$display("Test Case 1: Same Sign NUmbers");
	$display("Input Data: Num1 = %b, Num2 = %b", num1, num2);
	
	/*
	exceptionChecker( Exc_value_wire, Exc_Ack_wire, Adder_datain1_wire, Data_valid_reg, CLK, RSTn);
        $display("Exception Code for Num1: %b", Exc_value_wire);
	
	exceptionChecker( Exc_value_wire, Exc_Ack_wire, Adder_datain2_wire, Data_valid_reg, CLK, RSTn);
        $display("Exception Code for Num2: %b", Exc_value_wire);
	*/
	
	$display("Datain1_reg = %b, Datain2_reg = %b", Datain1_reg, Datain2_reg);
	//$display("Adder_datain1_wire = %b, Adder_datain2_wire = %b", Adder_datain1_wire, Adder_datain2_wire);
	$display("Computed Data : %b @", Dataout_wire, $time);

        $display("Exception Code for Computed Data: %b", Exc_value_wire);
	
	$display("Ideal Sum : %b @", res_tc1, $time);
	
	if(Dataout_wire == res_tc1)
		$display("Match... Yayyy");
        else
		$display("NO Match :(");
	end
	$display("\n");
   endtask

   task addTestCase2();begin

   //num1 = n1;
   //num2 = n2;

   num1 = 32'b11000000001100000000000000000000;//-2.75
   num2 = 32'b01000000101100000000000000000000;//5.5
   res_tc2[31:0] = 32'b01000000001100000000000000000000;//2.75

   //$display("Num1 = %b, n1_tc1 = %b", 32'b00000000100101110000101000111101, n1_tc1);

   //---- Provide the data at the posedge of CLK -----
   wait(Dataout_valid_wire==1'b0);
   @(negedge CLK);
       Datain1_reg <= num1 ;
       Datain2_reg <= num2 ;
       Data_valid_reg <= 1'b1 ;
   wait(Dataout_valid_wire==1'b1)
   	   Data_valid_reg <= 1'b0 ;
	$display("\n");
	$display("Test Case 2: Different Signs, Smaller number NEGATIVE-> Final result POSITIVE");
	$display("Input Data: Num1 = %b, Num2 = %b", num1, num2);
	$display("Datain1_reg = %b, Datain2_reg = %b", Datain1_reg, Datain2_reg);
	//$display("Adder_datain1_wire = %b, Adder_datain2_wire = %b", Adder_datain1_wire, Adder_datain2_wire);
	$display("Computed Data : %b @", Dataout_wire, $time);
	$display("Ideal Sum : %b @", res_tc2, $time);
	
	if(Dataout_wire == res_tc2)
		$display("Match... Yayyy");
        else
		$display("NO Match :(");
	end
	$display("\n");
   endtask
   
   task addTestCase3();begin

   //num1 = n1;
   //num2 = n2;

   num1 = 32'b01000000001100000000000000000000;//2.75
   num2 = 32'b11000000101100000000000000000000;//-5.5
   res_tc3[31:0] = 32'b11000000001100000000000000000000;//-2.75

   //$display("Num1 = %b, n1_tc1 = %b", 32'b00000000100101110000101000111101, n1_tc1);

   //---- Provide the data at the posedge of CLK -----
   wait(Dataout_valid_wire==1'b0);
   @(negedge CLK);
       Datain1_reg <= num1 ;
       Datain2_reg <= num2 ;
       Data_valid_reg <= 1'b1 ;
   wait(Dataout_valid_wire==1'b1)
   	   Data_valid_reg <= 1'b0 ;
	$display("\n");
	$display("Test Case 3: Different Signs, Smaller number POSITIVE-> Final result NEGATIVE");
	$display("Input Data: Num1 = %b, Num2 = %b", num1, num2);
	$display("Datain1_reg = %b, Datain2_reg = %b", Datain1_reg, Datain2_reg);
	//$display("Adder_datain1_wire = %b, Adder_datain2_wire = %b", Adder_datain1_wire, Adder_datain2_wire);
	$display("Computed Data : %b @", Dataout_wire, $time);
	$display("Ideal Sum : %b @", res_tc3, $time);
	
	if(Dataout_wire == res_tc3)
		$display("Match... Yayyy");
        else
		$display("NO Match :(");
	end
	$display("\n");
   endtask

   task addTestCase4();begin

   //num1 = n1;
   //num2 = n2;

   num1 = 32'b01000000001000000001001111010011;//2.50121
   num2 = 32'b11000111010101101101100000000000;//-55000
   res_tc4[31:0] = 32'b11000111010101101101010110000000;//-54997.5

   //$display("Num1 = %b, n1_tc1 = %b", 32'b00000000100101110000101000111101, n1_tc1);

   //---- Provide the data at the posedge of CLK -----
   wait(Dataout_valid_wire==1'b0);
   @(negedge CLK);
       Datain1_reg <= num1 ;
       Datain2_reg <= num2 ;
       Data_valid_reg <= 1'b1 ;
   wait(Dataout_valid_wire==1'b1)
   	   Data_valid_reg <= 1'b0 ;
	$display("\n");
	$display("Test Case 4: Different Signs, Smaller number VERY SMALL & POSITIVE-> Final result NEGATIVE");
	$display("Input Data: Num1 = %b, Num2 = %b", num1, num2);
	$display("Datain1_reg = %b, Datain2_reg = %b", Datain1_reg, Datain2_reg);
	//$display("Adder_datain1_wire = %b, Adder_datain2_wire = %b", Adder_datain1_wire, Adder_datain2_wire);
	$display("Computed Data : %b @", Dataout_wire, $time);
	$display("Ideal Sum : %b @", res_tc4, $time);
	
	if(Dataout_wire == res_tc4)
		$display("Match... Yayyy");
        else
		$display("NO Match :(");
	end
	$display("\n");
   endtask

   task addTestCase5();begin

   //num1 = n1;
   //num2 = n2;

   num2 = {1'b1, 8'b10000100, 23'b10010000000000000000000};//-50
   num1 = {1'b0, 8'b10000100, 23'b00101000000000000000000};//37
   res_tc5[31:0] = {1'b1, 8'b10000010, 23'b10100000000000000000000};//-13

   //$display("Num1 = %b, n1_tc1 = %b", 32'b00000000100101110000101000111101, n1_tc1);

   //---- Provide the data at the posedge of CLK -----
   wait(Dataout_valid_wire==1'b0);
   @(negedge CLK);
       Datain1_reg <= num1 ;
       Datain2_reg <= num2 ;
       Data_valid_reg <= 1'b1 ;
   wait(Dataout_valid_wire==1'b1)
   	   Data_valid_reg <= 1'b0 ;
	$display("\n");
	$display("Test Case 5: 37, -50 -> Different Signs, Smaller number POSITIVE-> Final result NEGATIVE");
	$display("Input Data: Num1 = %b, Num2 = %b", num1, num2);
	$display("Datain1_reg = %b, Datain2_reg = %b", Datain1_reg, Datain2_reg);
	//$display("Adder_datain1_wire = %b, Adder_datain2_wire = %b", Adder_datain1_wire, Adder_datain2_wire);
	$display("Computed Data : %b @", Dataout_wire, $time);
	$display("Ideal Sum : %b @", res_tc5, $time);
	
	if(Dataout_wire == res_tc5)
		$display("Match... Yayyy");
        else
		$display("NO Match :(");
	end
	$display("\n");
   endtask


   task reset();
      @(negedge CLK) RSTn <= 1'b0 ;
	  @(negedge CLK) RSTn <= 1'b1 ;
   endtask


endmodule
