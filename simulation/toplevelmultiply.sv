
module testbench ;

reg CLK , RSTn ;
reg CS_reg, DIV_reg, DOA_reg, OPT_reg ;
reg [31:0] DIN_reg ;

wire DACK_wire, DOV_wire, ABUSY_wire, MBUSY_wire ;
wire [15:0] DOUT_wire ;
wire [2:0] EXC_wire ;
wire [4:0] DEBUG_wire ;

 FPU_Control u_FPU_Control(
//---- DEFAULT interface ----
	.CLK(CLK)   ,
	.RSTn(RSTn)  ,
	.CS (CS_reg)   ,
	.DIN(DIN_reg)   ,
	.DIV(DIV_reg)   ,
	.DACK(DACK_wire)  ,
	.DR(DR_wire)    ,
	.DOUT(DOUT_wire)  ,
	.DOV(DOV_wire)   ,
	.DOA(DOA_reg)   ,
	.ABUSY(ABUSY_wire) ,
	.MBUSY(MBUSY_wire) ,
	.EXC(EXC_wire)   ,
	.OPT(OPT_reg)   ,
	.MODE(0)  ,
	.DEBUG(DEBUG_wire) 
) ;


always #10 CLK = ~CLK ;


initial begin
	CLK = 1'b1 ;
	RSTn = 1'b1 ;
	reset();
	@(negedge CLK);
	OPT_reg = 1'b1;
	//DIN_reg = 32'b01000000001100000000000000000000;//2.75
	DIN_reg =32'b11000000001100000000000000000000;//-2.75
	DIV_reg = 1'b1 ;
	@(negedge CLK);
	DIN_reg = 32'b01000000101100000000000000000000;//5.5
	DIV_reg = 1'b1 ;
	@(negedge CLK);	
	DIV_reg = 1'b0 ;
	wait(DOV_wire==1) ;
	@(negedge CLK);
	$display("Output = %b", DOUT_wire);
	@(negedge CLK);
	$display("Output = %b", DOUT_wire);
	DOA_reg = 1'b1;
	@(negedge CLK);
	DOA_reg = 1'b0;
	wait(DOV_wire==0) ;
	#200 
	//$display("Output = %b", DOUT_wire);
	$finish() ;
	//res_tc1[31:0] = 32'b0100000101110010 | 0000000000000000;//15.125
	//res_tc2[31:0] = 32'b11000001011100100000000000000000;//-15.125

end



task reset();
	@(negedge CLK)
	RSTn <= 1'b0 ;
	CS_reg <= 1'b1 ;
	DIV_reg <= 1'b0 ;
	DOA_reg <= 1'b0 ;
	OPT_reg <= 1'b0 ;
	DIN_reg <= 0 ;
	@(negedge CLK);
	RSTn <= 1'b1 ;

endtask


endmodule
