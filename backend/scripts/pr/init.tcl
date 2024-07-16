set defHierChar {/}
set init_gnd_net {VSS}
set init_pwr_net {VDD}
set init_verilog $::env(RESULT_DIR)/syn/data/$::env(DESIGN_NAME).syn.v
set init_top_cell $::env(DESIGN_NAME)
set init_lef_file [split $::env(LEF_FILES)]
puts $::env(SCRIPTS_DIR)/pr/mmmc.view
set init_mmmc_file $::env(SCRIPTS_DIR)/pr/mmmc.view
init_design

# -------------------------------------------------------------
# Check design after init
# -------------------------------------------------------------
checkDesign -netList -noHtml -outfile $::env(RESULT_DIR)/pr/report/check_data_init.report
timeDesign -prePlace \
    -pathReports \
    -drvReports \
    -slackReports \
    -numPaths 50 \
    -prefix prePlace \
    -outDir $::env(RESULT_DIR)/pr/report/init_data_timing

# -------------------------------------------------------------
# Save design 
# -------------------------------------------------------------
saveDesign $::env(RESULT_DIR)/pr/data/init_design.enc
exit




