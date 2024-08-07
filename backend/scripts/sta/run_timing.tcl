# -------------------------------------------------------------
# Set pt variable
# -------------------------------------------------------------
set read_parasitics_load_locations true
set sh_source_uses_search_path true
set sh_command_log_file $::env(RESULT_DIR)/sta/log/pt_shell_command.log
set parasitics_log_file $::env(RESULT_DIR)/sta/log/parasitics_command.log
printvar sh_eco_enabled
set EnablePTSI true
if {$EnablePTSI == "true"} {
    set si_enable_analysis true
    set si_xtalk_double_switching_mode clock_network
}

# -------------------------------------------------------------
# Read the timing lib
# -------------------------------------------------------------
source $::env(SCRIPTS_DIR)/sta/lib_setup.tcl

# -------------------------------------------------------------
# Read the post-routing netlist
# -------------------------------------------------------------
read_verilog $::env(RESULT_DIR)/pr/data/ibex_routing.vg
set DESIGN_NAME ibex_core
current_design $DESIGN_NAME
link

# -------------------------------------------------------------F
# Read the SDC
# -------------------------------------------------------------
source -e -v $::env(SDC_FILE)

# -------------------------------------------------------------
# Read the spef
# -------------------------------------------------------------
read_parasitics -keep_capacitive_coupling -format spef $::env(RESULT_DIR)/extractRC/data/ibex.spef.gz

# -------------------------------------------------------------
# Output the annotated report
# -------------------------------------------------------------
redirect $::env(RESULT_DIR)/sta/report/ibex_core_annotated_parasitics.report {report_annotated_parasitics}

# -------------------------------------------------------------
# Setting the group path
# -------------------------------------------------------------
set reg [filter_collection [all_registers] "is_integrated_clock_gating_cell != true"]
set input [all_inputs]
set output [all_outputs]
set ckgating [filter_collection [all_registers] "is_integrated_clock_gating_cell == true"]
set ignore_path_groups [list inp2reg reg2out reg2out feedthr]
#set mem [get_cells -q -hier -filter "@is_hierarchical == false && @is_macro_cell == true"]

group_path -name reg2reg -from $reg -to $reg
group_path -name reg2cg -from $reg -to $ckgating
group_path -name in2reg -from $input
group_path -name reg2out -to $output
group_path -name feedthr -from $input -to $output
#group_path -name mem2reg -from $mem -to $reg
#group_path -name mem2cg -from $mem -to $ckgating
#group_path -name reg2men -from $reg -to $men
#group_path -name mem2men -from $mem -to $men

# -------------------------------------------------------------
# Enable propagated clock 
# -------------------------------------------------------------
set_noise_parameters -enable_propagation
set_propagated_clock [all_clocks]
update_timing -full

# -------------------------------------------------------------
# output timing report
# -------------------------------------------------------------
check_timing -v > $::env(RESULT_DIR)/sta/report/ibex_core_check_timing.report
redirect $::env(RESULT_DIR)/sta/report/ibex_core_report_timing.report {report_timing \
    -crosstalk_delta \
    -delay max \
    -nosplit \
    -input \
    -net \
    -sign 4}
redirect $::env(RESULT_DIR)/sta/report/ibex_core_report_constraints.report {report_constraint \
    -significant_digit 4 \
    -all_violators \
    -nosplit}
report_design > $::env(RESULT_DIR)/sta/report/ibex_core_report_design.rpt
report_net > $::env(RESULT_DIR)/sta/report/ibex_core_report_net.rpt
report_clock -skew -attribute > $::env(RESULT_DIR)/sta/report/ibex_core_report_clock.rpt
report_analysis_coverage -status_details { untested violated } \
    -nosplit \
    -sort_by slack \
    -check_type { setup \
        hold \
        recovery \
        removal \
        nochange \
        min_period \
        min_pulse_width \
        clock_separation \
        max_skew \
        clock_gating_setup \
        clock_gating_hold \
        out_set out_hold} \
    -exclude_untested {constant_disabled \
        mode_disabled \
        user_disabled \
        no_paths \
        false_paths \
        no_endpoint_clock no_clock} \
    > $::env(RESULT_DIR)/sta/report/ibex_core_analysis_coverage.rpt

# -------------------------------------------------------------
#save pt session
# -------------------------------------------------------------
save_session $::env(RESULT_DIR)/sta/data/ibex_core_session




