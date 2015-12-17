###################################################################

# Created by write_sdc on Wed Dec 16 22:33:36 2015

###################################################################
set sdc_version 1.9

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports CLK]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports RSTn]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports CS]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {DIN1[15]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {DIN1[14]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {DIN1[13]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {DIN1[12]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {DIN1[11]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {DIN1[10]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {DIN1[9]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {DIN1[8]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {DIN1[7]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {DIN1[6]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {DIN1[5]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {DIN1[4]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {DIN1[3]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {DIN1[2]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {DIN1[1]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {DIN1[0]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {DIN2[15]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {DIN2[14]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {DIN2[13]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {DIN2[12]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {DIN2[11]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {DIN2[10]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {DIN2[9]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {DIN2[8]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {DIN2[7]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {DIN2[6]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {DIN2[5]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {DIN2[4]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {DIN2[3]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {DIN2[2]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {DIN2[1]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {DIN2[0]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports DIV]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports DOA]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports OPT]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {MODE[2]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {MODE[1]}]
set_driving_cell -lib_cell INVX1 -library Lib6710_05 [get_ports {MODE[0]}]
set_load -pin_load 0.008788 [get_ports DACK]
set_load -pin_load 0.008788 [get_ports DR]
set_load -pin_load 0.008788 [get_ports {DOUT[15]}]
set_load -pin_load 0.008788 [get_ports {DOUT[14]}]
set_load -pin_load 0.008788 [get_ports {DOUT[13]}]
set_load -pin_load 0.008788 [get_ports {DOUT[12]}]
set_load -pin_load 0.008788 [get_ports {DOUT[11]}]
set_load -pin_load 0.008788 [get_ports {DOUT[10]}]
set_load -pin_load 0.008788 [get_ports {DOUT[9]}]
set_load -pin_load 0.008788 [get_ports {DOUT[8]}]
set_load -pin_load 0.008788 [get_ports {DOUT[7]}]
set_load -pin_load 0.008788 [get_ports {DOUT[6]}]
set_load -pin_load 0.008788 [get_ports {DOUT[5]}]
set_load -pin_load 0.008788 [get_ports {DOUT[4]}]
set_load -pin_load 0.008788 [get_ports {DOUT[3]}]
set_load -pin_load 0.008788 [get_ports {DOUT[2]}]
set_load -pin_load 0.008788 [get_ports {DOUT[1]}]
set_load -pin_load 0.008788 [get_ports {DOUT[0]}]
set_load -pin_load 0.008788 [get_ports DOV]
set_load -pin_load 0.008788 [get_ports ABUSY]
set_load -pin_load 0.008788 [get_ports MBUSY]
set_load -pin_load 0.008788 [get_ports {EXC[2]}]
set_load -pin_load 0.008788 [get_ports {EXC[1]}]
set_load -pin_load 0.008788 [get_ports {EXC[0]}]
set_load -pin_load 0.008788 [get_ports {DEBUG[4]}]
set_load -pin_load 0.008788 [get_ports {DEBUG[3]}]
set_load -pin_load 0.008788 [get_ports {DEBUG[2]}]
set_load -pin_load 0.008788 [get_ports {DEBUG[1]}]
set_load -pin_load 0.008788 [get_ports {DEBUG[0]}]
create_clock [get_ports CLK]  -period 15  -waveform {0 7.5}
set_input_delay -clock CLK  0.2  [get_ports CLK]
set_input_delay -clock CLK  0.2  [get_ports RSTn]
set_input_delay -clock CLK  0.2  [get_ports CS]
set_input_delay -clock CLK  0.2  [get_ports {DIN1[15]}]
set_input_delay -clock CLK  0.2  [get_ports {DIN1[14]}]
set_input_delay -clock CLK  0.2  [get_ports {DIN1[13]}]
set_input_delay -clock CLK  0.2  [get_ports {DIN1[12]}]
set_input_delay -clock CLK  0.2  [get_ports {DIN1[11]}]
set_input_delay -clock CLK  0.2  [get_ports {DIN1[10]}]
set_input_delay -clock CLK  0.2  [get_ports {DIN1[9]}]
set_input_delay -clock CLK  0.2  [get_ports {DIN1[8]}]
set_input_delay -clock CLK  0.2  [get_ports {DIN1[7]}]
set_input_delay -clock CLK  0.2  [get_ports {DIN1[6]}]
set_input_delay -clock CLK  0.2  [get_ports {DIN1[5]}]
set_input_delay -clock CLK  0.2  [get_ports {DIN1[4]}]
set_input_delay -clock CLK  0.2  [get_ports {DIN1[3]}]
set_input_delay -clock CLK  0.2  [get_ports {DIN1[2]}]
set_input_delay -clock CLK  0.2  [get_ports {DIN1[1]}]
set_input_delay -clock CLK  0.2  [get_ports {DIN1[0]}]
set_input_delay -clock CLK  0.2  [get_ports {DIN2[15]}]
set_input_delay -clock CLK  0.2  [get_ports {DIN2[14]}]
set_input_delay -clock CLK  0.2  [get_ports {DIN2[13]}]
set_input_delay -clock CLK  0.2  [get_ports {DIN2[12]}]
set_input_delay -clock CLK  0.2  [get_ports {DIN2[11]}]
set_input_delay -clock CLK  0.2  [get_ports {DIN2[10]}]
set_input_delay -clock CLK  0.2  [get_ports {DIN2[9]}]
set_input_delay -clock CLK  0.2  [get_ports {DIN2[8]}]
set_input_delay -clock CLK  0.2  [get_ports {DIN2[7]}]
set_input_delay -clock CLK  0.2  [get_ports {DIN2[6]}]
set_input_delay -clock CLK  0.2  [get_ports {DIN2[5]}]
set_input_delay -clock CLK  0.2  [get_ports {DIN2[4]}]
set_input_delay -clock CLK  0.2  [get_ports {DIN2[3]}]
set_input_delay -clock CLK  0.2  [get_ports {DIN2[2]}]
set_input_delay -clock CLK  0.2  [get_ports {DIN2[1]}]
set_input_delay -clock CLK  0.2  [get_ports {DIN2[0]}]
set_input_delay -clock CLK  0.2  [get_ports DIV]
set_input_delay -clock CLK  0.2  [get_ports DOA]
set_input_delay -clock CLK  0.2  [get_ports OPT]
set_input_delay -clock CLK  0.2  [get_ports {MODE[2]}]
set_input_delay -clock CLK  0.2  [get_ports {MODE[1]}]
set_input_delay -clock CLK  0.2  [get_ports {MODE[0]}]
set_output_delay -clock CLK  0.2  [get_ports DACK]
set_output_delay -clock CLK  0.2  [get_ports DR]
set_output_delay -clock CLK  0.2  [get_ports {DOUT[15]}]
set_output_delay -clock CLK  0.2  [get_ports {DOUT[14]}]
set_output_delay -clock CLK  0.2  [get_ports {DOUT[13]}]
set_output_delay -clock CLK  0.2  [get_ports {DOUT[12]}]
set_output_delay -clock CLK  0.2  [get_ports {DOUT[11]}]
set_output_delay -clock CLK  0.2  [get_ports {DOUT[10]}]
set_output_delay -clock CLK  0.2  [get_ports {DOUT[9]}]
set_output_delay -clock CLK  0.2  [get_ports {DOUT[8]}]
set_output_delay -clock CLK  0.2  [get_ports {DOUT[7]}]
set_output_delay -clock CLK  0.2  [get_ports {DOUT[6]}]
set_output_delay -clock CLK  0.2  [get_ports {DOUT[5]}]
set_output_delay -clock CLK  0.2  [get_ports {DOUT[4]}]
set_output_delay -clock CLK  0.2  [get_ports {DOUT[3]}]
set_output_delay -clock CLK  0.2  [get_ports {DOUT[2]}]
set_output_delay -clock CLK  0.2  [get_ports {DOUT[1]}]
set_output_delay -clock CLK  0.2  [get_ports {DOUT[0]}]
set_output_delay -clock CLK  0.2  [get_ports DOV]
set_output_delay -clock CLK  0.2  [get_ports ABUSY]
set_output_delay -clock CLK  0.2  [get_ports MBUSY]
set_output_delay -clock CLK  0.2  [get_ports {EXC[2]}]
set_output_delay -clock CLK  0.2  [get_ports {EXC[1]}]
set_output_delay -clock CLK  0.2  [get_ports {EXC[0]}]
set_output_delay -clock CLK  0.2  [get_ports {DEBUG[4]}]
set_output_delay -clock CLK  0.2  [get_ports {DEBUG[3]}]
set_output_delay -clock CLK  0.2  [get_ports {DEBUG[2]}]
set_output_delay -clock CLK  0.2  [get_ports {DEBUG[1]}]
set_output_delay -clock CLK  0.2  [get_ports {DEBUG[0]}]
