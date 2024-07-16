source $::env(RESULT_DIR)/pr/data/cts.enc

set_interactive_constraint_modes [all_constraint_modes -active]
set_propagated_clock [all_clocks]
setOptMode -fixDrc true -fixFanoutLoad true

# -------------------------------------------------------------
# opt design after CTS
# -------------------------------------------------------------
optDesign -postCTS
optDesign -postCTS -hold

saveDesign $::env(RESULT_DIR)/pr/data/post_cts_opt.enc
timeDesign -postCTS -pathReports -drvReports -slackReports -numPaths 50 -prefix postCTS -outDir $::env(RESULT_DIR)/pr/report/cts_opt_timing

exit
