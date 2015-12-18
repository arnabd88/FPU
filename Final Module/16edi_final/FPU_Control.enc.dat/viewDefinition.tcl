if {![namespace exists ::IMEX]} { namespace eval ::IMEX {} }
set ::IMEX::dataVar [file dirname [file normalize [info script]]]
set ::IMEX::libVar ${::IMEX::dataVar}/libs

create_library_set -name 6710_typical\
   -timing\
    [list ${::IMEX::libVar}/mmmc/Lib6710_05.lib]
create_rc_corner -name typical\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0
create_delay_corner -name typical\
   -library_set 6710_typical\
   -rc_corner typical
create_constraint_mode -name typical\
   -sdc_files\
    [list ${::IMEX::libVar}/mmmc/typical.sdc]
create_analysis_view -name typical -constraint_mode typical -delay_corner typical
set_analysis_view -setup [list typical] -hold [list typical]
