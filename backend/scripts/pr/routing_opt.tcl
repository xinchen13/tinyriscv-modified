source $::env(RESULT_DIR)/pr/data/routing.enc
# -------------------------------------------------------------
# OptDesign after routing
# -------------------------------------------------------------
optDesign -postRoute -setup
optDesign -postRoute -hold

# -------------------------------------------------------------
# Add filler cell
# -------------------------------------------------------------
set filler_cell [split $::env(FILL_CELLS)]
setFillerMode -doDRC true -corePrefix Filler -core $filler_cell
addFiller

# -------------------------------------------------------------
# Save Design
# -------------------------------------------------------------
timeDesign -postRoute -prefix postRouteOpt -outDir $::env(RESULT_DIR)/pr/report/routing_opt_timing
saveDesign $::env(RESULT_DIR)/pr/data/routing_opt.enc

exit