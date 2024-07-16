#-----------------------------------------------------------------------
# fml variable setting
#-----------------------------------------------------------------------
source $::env(SCRIPTS_DIR)/fml/fml_setup.tcl

#-----------------------------------------------------------------------
# Read db
#-----------------------------------------------------------------------
read_db -technology_library $::env(DB_FILES)

#-----------------------------------------------------------------------
# svf In
#-----------------------------------------------------------------------
set_svf $::env(RESULT_DIR)/syn/data/$::env(DESIGN_NAME).svf

#-----------------------------------------------------------------------
# Reference design
#-----------------------------------------------------------------------
foreach file $::env(VERILOG_FILES) {
  read_verilog -r $file
}
set_top r:WORK/$::env(DESIGN_NAME)

#-----------------------------------------------------------------------
# Implement design
#-----------------------------------------------------------------------
read_verilog -i $::env(RESULT_DIR)/syn/data/$::env(DESIGN_NAME).syn.v
set_top i:WORK/$::env(DESIGN_NAME)

#-----------------------------------------------------------------------
# Disable the scan port
#-----------------------------------------------------------------------
#set enble $::env(SCAN_ENABLE_PORT)
#set_constant -type pin [get_pins -hierarchical "*/$enble"] 0
#setup

current_design $::env(DESIGN_NAME)

#-----------------------------------------------------------------------
# Run match
#-----------------------------------------------------------------------
match
report_matched_points > $::env(RESULT_DIR)/fml_syn/report/matched_points.rpt
report_unmatched_points > $::env(RESULT_DIR)/fml_syn/report/unmatched_points.rpt
report_unmatched_points -status unread > $::env(RESULT_DIR)/fml_syn/report/unread.rpt

#-----------------------------------------------------------------------
# Run verify
#-----------------------------------------------------------------------
verify
report_failing_points > $::env(RESULT_DIR)/fml_syn/report/fail_points.rpt
report_aborted_points > $::env(RESULT_DIR)/fml_syn/report/aborted.rpt
save_session -replace $::env(RESULT_DIR)/fml_syn/data/rtl2syn.fss




