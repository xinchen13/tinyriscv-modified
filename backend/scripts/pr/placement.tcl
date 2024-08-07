source $::env(RESULT_DIR)/pr/data/powerplan.enc
# -------------------------------------------------------------
# Timing Derate setting
# -------------------------------------------------------------
set_timing_derate -delay_corner {delay_max} -early 0.97 -late 1.03 -clock
set_timing_derate -delay_corner {delay_max} -late 1.05 -data
setAnalysisMode -cppr both

# -------------------------------------------------------------
# Path group setting
# -------------------------------------------------------------
reset_path_group -all
set reg [filter_collection [all_registers] "is_integrated_clock_gating_cell != true"]
set input [all_inputs]
set output [all_outputs]
set ckgating [filter_collection [all_registers] "is_integrated_clock_gating_cell == true"]
set ignore_path_groups [list inp2reg reg2out reg2out feedthr]

#Group Path setting
group_path -name reg2reg -from $reg -to $reg
group_path -name reg2cg -from $reg -to $ckgating
group_path -name in2reg -from $input
group_path -name reg2out -to $output
group_path -name feedthr -from $input -to $output

setPathGroupOptions reg2reg -effortLevel high
setPathGroupOptions reg2cg -effortLevel high
setPathGroupOptions in2reg -effortLevel low
setPathGroupOptions reg2out -effortLevel low
setPathGroupOptions feedthr -effortLevel low
setOptMode -ignorePathGroupsForHold $ignore_path_groups

# -------------------------------------------------------------
# PlaceMode setting
# -------------------------------------------------------------
setPlaceMode -reset
setPlaceMode -place_global_place_io_pins false
setPlaceMode -place_detail_legalization_inst_gap 2

# -------------------------------------------------------------
# global route layer setting
# -------------------------------------------------------------
setRouteMode -earlyGlobalMinRouteLayer $::env(MIN_GLOBAL_ROUTE_LAYER) -earlyGlobalMaxRouteLayer $::env(MAX_GLOBAL_ROUTE_LAYER)
setDesignMode -process $::env(PROCESS)

# -------------------------------------------------------------
# place the design & report congestion
# -------------------------------------------------------------
place_opt_design
reportCongestion -overflow

# -------------------------------------------------------------
# Add Tie cells TODO
# -------------------------------------------------------------
setTieHiLoMode -prefix Tie -maxFanout 8 -cell {TIEHI TIELO}
setTieHiLoMode -maxDistance 30
addTieHiLo

# -------------------------------------------------------------
# Output the time report
# -------------------------------------------------------------
set report_timing_format [list timing_point arc net cell fanout load slew incr_delay delay arrival total_derate ]
setOptMode -timeDesignNumPaths 100
set_table_style -no_frame_fix_width -nosplit
timeDesign -preCTS \
    -idealClock \
    -pathReports \
    -drvReports \
    -slackReports \
    -numPaths 50 \
    -prefix preCTS \
    -outDir $::env(RESULT_DIR)/pr/report/placement_timing

# -------------------------------------------------------------
# Save design
# -------------------------------------------------------------
saveDesign $::env(RESULT_DIR)/pr/data/placement.enc
exit
