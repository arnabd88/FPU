module MUX32bit2X1 ( data1, data2, selectLine, enable, outdata );

  input [31:0] data1 , data2 ;
  input selectLine ;
  input enable ;
  output [31:0] outdata ;

  assign outdata  =  (selectLine == 1'b0 && enable==1'b1) ? data1 : (selectLine==1'b1 && enable==1'b1) ?   data2 : 0 ;


endmodule
   





