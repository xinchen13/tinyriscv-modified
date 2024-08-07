source $::env(RESULT_DIR)/pr/data/routing_opt.enc
# -------------------------------------------------------------
# Remove the unused net&module
# -------------------------------------------------------------
# remove_assigns -buffering -buffer CLKBUFX4
deleteDanglingNet
deleteEmptyModule

# -------------------------------------------------------------
# Re-connect the PG net after add physical cell
# -------------------------------------------------------------
globalNetConnect VDD -type net -net VDD
globalNetConnect VSS -type net -net VSS
verifyConnectivity -type all -error 1000 -warning 50

# -----------------------------------------------------------------
# output the hcell list for lvs & ir-drop analysis
# -----------------------------------------------------------------
set hcell_file [open $::env(SCRIPTS_DIR)/pv/hcell_list w]
set hcell_list_ir [open $::env(SCRIPTS_DIR)/ir_v/cell_list w]
set cells [dbGet [dbGet top.insts.isPhysOnly 0 -p].cell.name]
set cells [lsort -u $cells]
foreach cell $cells {
    puts $hcell_file "$cell $cell"
    puts $hcell_list_ir "$cell"
}
close $hcell_file
close $hcell_list_ir

saveNetlist -excludeLeafCell -includePowerGround -includePhysicalCell {FILLCAP4 FILLCAP5 FILLCAP8 FILLCAP16 FILLCAP32 FILLCAP64} -flattenBus $::env(RESULT_DIR)/pr/data/Design_lvs.vg

# -----------------------------------------------------------------------
#  output netlist&sdf for post_pr simulation
# -----------------------------------------------------------------------
saveNetlist $::env(RESULT_DIR)/sim/post_pr/$::env(DESIGN_NAME).pr.v
write_sdf	$::env(RESULT_DIR)/sim/post_pr/$::env(DESIGN_NAME).syn.sdf

# ----------------------------------------------------------------
# Write out the routing def
# ----------------------------------------------------------------
set lefDefOutVersion 5.8
defOut -floorplan -netlist -routing $::env(RESULT_DIR)/pr/data/$::env(DESIGN_NAME)_routing.def

# -----------------------------------------------------------------
# Gds streamOut
# -----------------------------------------------------------------

setStreamOutMode -textSize 5
setStreamOutMode -virtualConnection true
setStreamOutMode -uniquifyCellNamesPrefix true

streamOut \
	$::env(RESULT_DIR)/pr/data/$::env(DESIGN_NAME).gds \
	-mapFile $::env(GDS_MAP_FILE) \
	-merge  $::env(MAERGER_GDS_PATH)/*.gds* \
	-libName DesignLib  \
	-units 1000 \
	-mode ALL

streamOut \
	$::env(RESULT_DIR)/pr/data/$::env(DESIGN_NAME)_nomerge.gds \
	-mapFile $::env(GDS_MAP_FILE) \
	-libName DesignLib  \
	-units 1000 \
	-mode ALL

saveDesign $::env(RESULT_DIR)/pr/data/chip_done.enc
exit
