
module testbench ;

reg CLK , RSTn ;
reg CS_reg, DIV_reg, DOA_reg, OPT_reg ;
reg [31:0] DIN_reg ;

wire DACK_wire, DOV_wire, ABUSY_wire, MBUSY_wire ;
wire [31:0] DOUT_wire ;
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
	CS_reg  = 1'b1 ;
	DIV_reg = 1'b1 ;
	DIN_reg = $random();
	OPT_reg = 1'b0 ;
	@(negedge CLK);
	DIN_reg = $random();
	OPT_reg = 1'b1;
	@(negedge CLK);
	OPT_reg = 1'b0;
	wait(ABUSY_wire==1);
	@(negedge CLK);
	OPT_reg = 1'b1;
	DIN_reg = $random();
	DIV_reg = 1'b1 ;
	wait(DOV_wire==1) ;
	@(negedge CLK);
	@(negedge CLK);
	DOA_reg = 1'b1;
	@(negedge CLK);
	DOA_reg = 1'b0;
	wait(DOV_wire==0) ;
	wait(DOV_wire==1) ;
	@(negedge CLK);
	@(negedge CLK);
	DOA_reg = 1'b1;
	@(negedge CLK);
	DOA_reg = 1'b0;
	#200 $finish() ;
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
