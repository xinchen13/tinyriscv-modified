# -------------------------------------------------------------
# Set env variable
# -------------------------------------------------------------
source $::env(SCRIPTS_DIR)/syn/dc_setup.tcl

# -------------------------------------------------------------
# Lib set up
# -------------------------------------------------------------
set target_library $::env(DB_FILES)
set link_library "* $target_library"
lappend link_library {dw_foundation.sldb}
puts $::env(VERILOG_FILES)

# -------------------------------------------------------------
# Design in
# -------------------------------------------------------------
analyze -format sverilog $::env(VERILOG_FILES)
elaborate $::env(DESIGN_NAME)
current_design $::env(DESIGN_NAME)
link
check_design

# -------------------------------------------------------------
# Read sdc
# -------------------------------------------------------------
source $::env(SDC_FILE)

# -------------------------------------------------------------
# Group setting
# -------------------------------------------------------------
set reg [filter_collection [all_registers] "is_clock_gate != true"]
set input [all_inputs]
set output [all_outputs]
group_path -name reg2reg -weight 50 -critical_range 6 -from $reg -to $reg
group_path -name in2reg -weight 10 -critical_range 0.5 -from $input -to $reg
group_path -name reg2out -weight 10 -critical_range 0.5 -from $reg -to $output

# -------------------------------------------------------------
# Setting dontuse cell 
# -------------------------------------------------------------
puts "DONTUSE"
foreach cell [split $::env(DONT_USE_CELLS)] {
    get_lib_cell  */$cell
    set_dont_use [get_lib_cell */$cell]
}
redirect $::env(RESULT_DIR)/syn/report/check_timing.rpt {check_timing}

# -------------------------------------------------------------
# Compile design
# -------------------------------------------------------------
set_fix_multiple_port_nets -all -buffer_constants [get_designs *]
compile_ultra -timing_high_effort_script

# -------------------------------------------------------------
# Compile design incremental
# -------------------------------------------------------------
compile_ultra -incremental

# -------------------------------------------------------------
# post-syn report&data out
# -------------------------------------------------------------
source $::env(SCRIPTS_DIR)/syn/dc_report.tcl
exit




