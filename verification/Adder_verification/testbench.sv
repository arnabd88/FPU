//--------------------------------------------------------------------
//--------------- Simple testbench module with directed testcases ----
//---- Each individual tests are broken into task based templates ----
//---- These tests can be just included and executed by task calls ---
//--------------------------------------------------------------------
module testbench ;

bit [31:0] Datain1_reg, Datain2_reg ;
bit Data_valid_reg ;
bit[2:0] Mode_reg ;
bit[4:0] Debug_reg ;

reg CLK, RSTn ;

wire [31:0] Dataout_wire ;
wire Dataout_valid_wire ;
wire [2:0] Exc_wire ;
wire [23:0] Adder_datain1_wire , Adder_datain2_wire ;
wire Adder_valid_wire ;
wire [23:0] Adder_dataout_wire ;
wire [2:0] Adder_Exc_wire ;
wire Adder_carryout_wire ;
wire Adder_ack_wire ;
   bit [31:0] num1 ;
   bit [31:0] num2 ;

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


   always #5 CLK  =  ~CLK ;


   initial  begin
        CLK  =  1'b1 ;
		reset();
		@(negedge CLK) ;
		repeat(10) begin
		   addTwoRandomNumbers();
		end
		#100 $finish();
		//---- Call the tasks in sequence -----
   end

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

   task reset();
      @(negedge CLK) RSTn <= 1'b0 ;
	  @(negedge CLK) RSTn <= 1'b1 ;
   endtask


endmodule
