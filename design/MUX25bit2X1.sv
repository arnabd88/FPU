module MUX25bit2X1 ( data1, data2, selectLine, enable, outdata );

  input [24:0] data1 , data2 ;
  input selectLine ;
  input enable ;
  output outdata ;

  assign outdata  =  (selectLine == 1'b0) ? data1 : data2 ;


endmodule
   





