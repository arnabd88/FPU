module AOI21(IN1,IN2,IN3,OUT);
	input	IN1,IN2,IN3;
	output	OUT;
	nor(OUT,IN3,_n1);
	and(_n1,IN1,IN2);
endmodule

module AOI22(IN1,IN2,IN3,IN4,OUT);
	input	IN1,IN2,IN3,IN4;
	output	OUT;
	nor(OUT,_n1,_n2);
	and(_n2,IN1,IN2);
	and(_n1,IN3,IN4);
endmodule

module BUF4X(IN,OUT);
	input	IN;
	output	OUT;
	buf(OUT,IN);
endmodule

module BUF8X(IN,OUT);
	input	IN;
	output	OUT;
	buf(OUT,IN);
endmodule

module DFFRX1(CLK,CLRB,D,Q,QB);
	input	CLK,CLRB,D;
	output	Q,QB;
	not(QB,Q);
	and(_n1,CLRB,_n2);
	and(Q,CLRB,_n3);
	mux(_n2,CLK,_n1,D);
	mux(_n3,CLK,_n1,Q);
endmodule

module INVX1(IN,OUT);
	input	IN;
	output	OUT;
	not(OUT,IN);
endmodule

module INVX4(IN,OUT);
	input	IN;
	output	OUT;
	not(OUT,IN);
endmodule

module INVX8(IN,OUT);
	input	IN;
	output	OUT;
	not(OUT,IN);
endmodule

module MUX2X1(IN1,IN2,OUT,S);
	input	IN1,IN2,S;
	output	OUT;
	mux(OUT,S,IN2,IN1);
endmodule

module NAND2X1(IN1,IN2,OUT);
	input	IN1,IN2;
	output	OUT;
	nand(OUT,IN1,IN2);
endmodule

module NAND3X1(IN1,IN2,IN3,OUT);
	input	IN1,IN2,IN3;
	output	OUT;
	nand(OUT,IN1,IN2,IN3);
endmodule

module NANDX2(IN1,IN2,OUT);
	input	IN1,IN2;
	output	OUT;
	nand(OUT,IN1,IN2);
endmodule

module NOR2X1(IN1,IN2,OUT);
	input	IN1,IN2;
	output	OUT;
	nor(OUT,IN1,IN2);
endmodule

module OAI21(IN1,IN2,IN3,OUT);
	input	IN1,IN2,IN3;
	output	OUT;
	or(_n1,IN1,IN2);
	nand(OUT,IN3,_n1);
endmodule

module TIEHI(OUT);
	output	OUT;
endmodule

module TIELO(OUT);
	output	OUT;
endmodule

primitive mux(Y,S,A,B);
	output	Y;
	input	S,A,B;
	table	1 1 ? : 1;
		1 0 ? : 0;
		0 ? 1 : 1;
		0 ? 0 : 0;
		? 1 1 : 1;
		? 0 0 : 0;
	endtable
endprimitive

