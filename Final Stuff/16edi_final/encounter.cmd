#######################################################
#                                                     
#  Encounter Command Logging File                     
#  Created on Wed Dec 16 22:50:48 2015                
#                                                     
#######################################################

#@(#)CDS: Encounter v14.26-s039_1 (64bit) 07/15/2015 11:34 (Linux 2.6.18-194.el5)
#@(#)CDS: NanoRoute v14.26-s022 NR150713-1956/14_26-UB (database version 2.30, 267.6.1) {superthreading v1.25}
#@(#)CDS: CeltIC v14.26-s013_1 (64bit) 07/14/2015 03:32:40 (Linux 2.6.18-194.el5)
#@(#)CDS: AAE 14.26-s007 (64bit) 07/15/2015 (Linux 2.6.18-194.el5)
#@(#)CDS: CTE 14.26-s010_1 (64bit) Jul 15 2015 01:38:12 (Linux 2.6.18-194.el5)
#@(#)CDS: CPE v14.26-s026
#@(#)CDS: IQRC/TQRC 14.2.2-s217 (64bit) Wed Apr 15 23:10:24 PDT 2015 (Linux 2.6.18-194.el5)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
win
setImportMode -treatUndefinedCellAsBbox 0 -keepEmptyModule 1
init_design
setImportMode -treatUndefinedCellAsBbox 0 -keepEmptyModule 1
init_design
fit
getIoFlowFlag
setFPlanRowSpacingAndType 30 2
setIoFlowFlag 0
floorPlan -site core -r 0.974846551932 0.5 31.2 30.0 30.0 30.0
uiSetTool select
getIoFlowFlag
fit
getIoFlowFlag
set sprCreateIeRingNets {}
set sprCreateIeRingLayers {}
set sprCreateIeRingWidth 1.0
set sprCreateIeRingSpacing 1.0
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
addRing -skip_via_on_wire_shape Noshape -skip_via_on_pin Standardcell -center 1 -stacked_via_top_layer metal3 -type core_rings -jog_distance 1.5 -threshold 1.5 -nets {gnd! vdd!} -follow core -stacked_via_bottom_layer metal1 -layer {bottom metal1 top metal1 right metal2 left metal2} -width 9.9 -spacing 1.8 -offset 1.5
set sprCreateIeStripeNets {}
set sprCreateIeStripeLayers {}
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeSpacing 2.0
set sprCreateIeStripeThreshold 1.0
addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit metal3 -max_same_layer_jog_length 3.0 -padcore_ring_bottom_layer_limit metal1 -set_to_set_distance 360 -skip_via_on_pin Standardcell -stacked_via_top_layer metal3 -padcore_ring_top_layer_limit metal3 -spacing 1.8 -xleft_offset 90 -merge_stripes_value 1.5 -layer metal2 -block_ring_bottom_layer_limit metal1 -width 4.8 -nets {gnd! vdd!} -stacked_via_bottom_layer metal1
windowSelect 70.960 1962.610 1704.890 -167.190
windowSelect 1209.200 592.500 1243.150 577.650
windowSelect 44.580 1956.740 1780.390 -123.370
deselectAll
windowSelect 68.490 2071.500 1694.320 -56.430
deleteSelectedFromFPlan
addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit metal3 -max_same_layer_jog_length 3.0 -padcore_ring_bottom_layer_limit metal1 -set_to_set_distance 360 -skip_via_on_pin Standardcell -stacked_via_top_layer metal3 -padcore_ring_top_layer_limit metal3 -spacing 1.8 -xleft_offset 360 -merge_stripes_value 1.5 -layer metal2 -block_ring_bottom_layer_limit metal1 -width 4.8 -nets {gnd! vdd!} -stacked_via_bottom_layer metal1
selectWire 1831.2000 15.9000 1836.0000 1835.1000 2 gnd!
deleteSelectedFromFPlan
selectWire 1837.8000 4.2000 1842.6000 1846.8000 2 vdd!
deleteSelectedFromFPlan
getIoFlowFlag
fit
getSrouteMode -allowWrongWayRoute -quiet
getSrouteMode -viaThruToClosestRing -quiet
getSrouteMode -extendNearestTarget -quiet
getSrouteMode -targetNumber -quiet
getSrouteMode -targetSearchDistance -quiet
getSrouteMode -jogThresholdRatio -quiet
getSrouteMode -blockPinConnectRingPinCorners -quiet
getSrouteMode -blockPinRouteWithPinWidth -quiet
getSrouteMode -padPinMinViaSize -quiet
getSrouteMode -padPinSplit -quiet
getSrouteMode -padRingLefConvention -quiet
getSrouteMode -signalPinAsPG -quiet
getSrouteMode -corePinJoinLimit -quiet
getSrouteMode -corePinLength -quiet
getSrouteMode -corePinLengthAsInstance -quiet
getSrouteMode -corePinReferenceMacro -quiet
getSrouteMode -treatEndcapAsCore -quiet
getSrouteMode -secondaryPinMaxGap -quiet
getSrouteMode -secondaryPinRailWidth -quiet
getSrouteMode -srpgAonCellPin -quiet
getSrouteMode -viaConnectToShape -quiet
getSrouteMode -layerNormalCost -quiet
getSrouteMode -layerWrongWayCost -quiet
setSrouteMode -allowWrongWayRoute false -viaThruToClosestRing false -extendNearestTarget false -blockPinConnectRingPinCorners false -blockPinRouteWithPinWidth false -padRingLefConvention true -signalPinAsPG false -corePinLengthAsInstance false -treatEndcapAsCore false -secondaryPinRailWidth 2.4
sroute -connect { blockPin padPin padRing corePin floatingStripe } -layerChangeRange { metal1 metal3 } -blockPinTarget { nearestTarget } -padPinPortConnect { allPort oneGeom } -padPinTarget { nearestTarget } -corePinTarget { firstAfterRowEnd } -floatingStripeTarget { blockring padring ring stripe ringpin blockpin followpin } -allowJogging 1 -crossoverViaLayerRange { metal1 metal3 } -nets { gnd! vdd! } -allowLayerChange 1 -blockPin useLef -targetViaLayerRange { metal1 metal3 }
setPlaceMode -fp false
placeDesign -inPlaceOpt -noPrePlaceOpt
setOptMode -fixCap true -fixTran true -fixFanoutLoad false
optDesign -preCTS
createClockTreeSpec -bufferList {BUF4X BUF8X INVX1 INVX4 INVX8} -file Clock.ctstch
clockDesign -specFile Clock.ctstch -outDir clock_report -fixedInstBeforeCTS
setCTSMode -engine ck
clockDesign -specFile Clock.ctstch -outDir clock_report -fixedInstBeforeCTS
setOptMode -fixCap true -fixTran true -fixFanoutLoad false
optDesign -postCTS
displayClockPhaseDelay -clkRouteOnly
setNanoRouteMode -quiet -timingEngine {}
setNanoRouteMode -quiet -routeWithTimingDriven 1
setNanoRouteMode -quiet -routeTdrEffort 10
setNanoRouteMode -quiet -routeWithSiPostRouteFix 0
setNanoRouteMode -quiet -routeTopRoutingLayer default
setNanoRouteMode -quiet -routeBottomRoutingLayer default
setNanoRouteMode -quiet -drouteEndIteration default
setNanoRouteMode -quiet -routeWithTimingDriven true
setNanoRouteMode -quiet -routeWithSiDriven false
routeDesign -globalDetail
setOptMode -fixCap true -fixTran true -fixFanoutLoad false
optDesign -postRoute
selectInst u_mul_cntrl/Debug_reg_reg_3_
redirect -quiet {set honorDomain [getAnalysisMode -honorClockDomains]} > /dev/null
timeDesign -postRoute -pathReports -drvReports -slackReports -numPaths 50 -prefix FPU_Control_postRoute -outDir timingReports
setAnalysisMode -analysisType onChipVariation
setOptMode -fixCap true -fixTran true -fixFanoutLoad false
optDesign -postRoute
saveDesign FPU_Control.enc
global dbgLefDefOutVersion
set dbgLefDefOutVersion 5.6
defOut -floorplan -netlist -routing FPU_Control.def
set dbgLefDefOutVersion 5.8
saveNetlist FPU_Control.v
