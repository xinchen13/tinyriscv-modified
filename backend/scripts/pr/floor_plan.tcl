set begin [clock format [clock seconds] -format %Y%m%d_%I:%M_%p]
puts "The FloorPlan Start: $begin"
source $::env(RESULT_DIR)/pr/data/init_design.enc

# -------------------------------------------------------------
# Define the block die area
# -------------------------------------------------------------
#floorPlan -site $::env(PLACE_SITE) -su 1 $::env(PLACE_DENSITY) 35 35 35 35
floorPlan -site $::env(PLACE_SITE) -d {2370 1270 50 50 50 50}

# -------------------------------------------------------------
# Place the block port
# -------------------------------------------------------------
addInst -cell PCORNER 		-inst CornerCellN
addInst -cell PCORNER 		-inst CornerCellS
addInst -cell PCORNER 		-inst CornerCellE
addInst -cell PCORNER 		-inst CornerCellW

addInst -cell PVDD1CDG 		-inst POWER_VDDN
addInst -cell PVDD1CDG 		-inst POWER_VDDS
addInst -cell PVDD1CDG 		-inst POWER_VDDE
addInst -cell PVDD1CDG 		-inst POWER_VDDW

addInst -cell PVSS1CDG 		-inst POWER_VSSN
addInst -cell PVSS1CDG 		-inst POWER_VSSS
addInst -cell PVSS1CDG 		-inst POWER_VSSE
addInst -cell PVSS1CDG 		-inst POWER_VSSW

addInst -cell PVDD2CDG 		-inst POWER_VDDION0
addInst -cell PVDD2CDG 		-inst POWER_VDDION1
addInst -cell PVDD2CDG 		-inst POWER_VDDIOS0
addInst -cell PVDD2CDG 		-inst POWER_VDDIOS1
addInst -cell PVDD2CDG 		-inst POWER_VDDIOE0
addInst -cell PVDD2CDG 		-inst POWER_VDDIOE1
addInst -cell PVDD2CDG 		-inst POWER_VDDIOW0
addInst -cell PVDD2POC 		-inst PowerOnControl

addInst -cell PVSS2CDG 		-inst POWER_VSSION0
addInst -cell PVSS2CDG 		-inst POWER_VSSION1
addInst -cell PVSS2CDG 		-inst POWER_VSSIOS0
addInst -cell PVSS2CDG 		-inst POWER_VSSIOS1
addInst -cell PVSS2CDG 		-inst POWER_VSSIOE0
addInst -cell PVSS2CDG 		-inst POWER_VSSIOE1
addInst -cell PVSS2CDG 		-inst POWER_VSSIOW0
addInst -cell PVSS2CDG 		-inst POWER_VSSIOW1

loadIoFile $::env(IO_FILE)

# -------------------------------------------------------------
# Add IO Filler
# -------------------------------------------------------------
addIoFiller -cell $::env(IO_FILLER_CELLS) -prefix FILLER -side n
addIoFiller -cell $::env(IO_FILLER_CELLS) -prefix FILLER -side e
addIoFiller -cell $::env(IO_FILLER_CELLS) -prefix FILLER -side w
addIoFiller -cell $::env(IO_FILLER_CELLS) -prefix FILLER -side s

# -------------------------------------------------------------
# Set the dont use cell
# -------------------------------------------------------------
foreach cell [split $::env(DONT_USE_CELLS)] {
    get_lib_cell  */$cell
    set_dont_use [get_lib_cells */$cell] true
}

# -------------------------------------------------------------
# Add endcap cell ToDo
# -------------------------------------------------------------
set endcap_right $::env(TAP_CELL_NAME)
set endcap_left $::env(TAP_CELL_NAME)
set endcap_top $::env(TAP_CELL_NAME)
set endcap_bottom $::env(TAP_CELL_NAME)
setEndCapMode -reset
setEndCapMode -leftEdge $endcap_left -rightEdge $endcap_right -topEdge $endcap_top -bottomEdge $endcap_bottom -prefix ENDCAP
addEndCap

# -------------------------------------------------------------
# save Design
# -------------------------------------------------------------
saveDesign $::env(RESULT_DIR)/pr/data/floor_plan.enc
defOut -floorplan -noStdCells $::env(RESULT_DIR)/pr/data/tinyriscv_io_top.floorplan.def

set end [clock format [clock seconds] -format %Y%m%d_%I:%M_%p]
puts "The FloorPlan End: $end"
exit
