
#-----------------------------------------------------------------------
# output synthesis report
#-----------------------------------------------------------------------
redirect $::env(RESULT_DIR)/syn/report/check_design_after_syn.rpt {check_design}
report_timing -tran -net -input -max_paths 10000 -nworst 5 -nosplit -slack_lesser_than 0.0
redirect $::env(RESULT_DIR)/syn/report/qor.rpt {report_qor -nosplit}
redirect $::env(RESULT_DIR)/syn/report/violation.rpt {report_constraint -all_violators}

#-----------------------------------------------------------------------
# output sdf for post_syn simulation
#-----------------------------------------------------------------------
write_sdf	$::env(RESULT_DIR)/syn/data/$::env(DESIGN_NAME).syn.sdf

#-----------------------------------------------------------------------
# output netlist for P&R
#-----------------------------------------------------------------------
write -format verilog -h -output $::env(RESULT_DIR)/syn/data/$::env(DESIGN_NAME).syn.v
write -format ddc -h -output $::env(RESULT_DIR)/syn/data/$::env(DESIGN_NAME).rpt.ddc

#-----------------------------------------------------------------------
# dont touch cell list output
#-----------------------------------------------------------------------
foreach cell [get_object_name [get_cells -h -f "is_mapped == true && is_hierarchical == false && dont_touch == true"]] {
    redirect -append -file $::env(RESULT_DIR)/syn/report/dont_touch.syn.tcl {puts "set_dont_touch \[get_cells $cell\]"}
}

#-----------------------------------------------------------------------
# dont use cell list output
#-----------------------------------------------------------------------
foreach cell [get_object_name [get_lib_cells -f "dont_use == true" */*]] {
    redirect -append -file $::env(RESULT_DIR)/syn/report/dont_use.syn.tcl {puts "set_dont_use \[get_lib_cells */$cell\]"}
}
