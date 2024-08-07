source $::env(RESULT_DIR)/pr/data/placement.enc
# -------------------------------------------------------------
# ccopt property setting
# -------------------------------------------------------------
set_ccopt_property use_inverters true

# -------------------------------------------------------------
# set cts opt use cell
# -------------------------------------------------------------
set cts_inv_cells [split $::env(CTS_INV_CELL)]
foreach libraryname $cts_inv_cells {
  puts $libraryname
  echo "setDontUse $libraryname false"
  setDontUse $libraryname false
}
set_ccopt_property inverter_cells [get_lib_cells "$::env(CTS_INV_CELL)"]

# -------------------------------------------------------------
# clk net routing ndr setting
# -------------------------------------------------------------
set mul $::env(CTS_ROUTING_MUL)
set ndr_min_layer $::env(NDR_CTS_MIN_LAYER)
set ndr_max_layer $::env(NDR_CTS_MAX_LAYER)
set routing_top_layer [lindex [split $::env(CTS_ROUTING_LAYER_RANGE)] 0]
set routing_bottom_layer [lindex [split $::env(CTS_ROUTING_LAYER_RANGE)] 1] 
add_ndr -name cts_1 \
  -width_multiplier "$ndr_min_layer:$ndr_max_layer $mul" \
  -spacing_multiplier "$ndr_min_layer:$ndr_max_layer $mul"
create_route_type -name clk_net_rule \
  -non_default_rule cts_1 \
  -top_preferred_layer $ndr_max_layer \
  -bottom_preferred_layer $ndr_min_layer
set_ccopt_property  route_type clk_net_rule -net_type trunk
#setNanoRouteMode -quiet \
#  -routeTopRoutingLayer $routing_top_layer \
#  -routeBottomRouting $routing_bottom_layer

# -------------------------------------------------------------
# create the cts 
# -------------------------------------------------------------
create_ccopt_clock_tree_spec -file $::env(RESULT_DIR)/pr/data/clk.spec
source $::env(RESULT_DIR)/pr/data/clk.spec

# -------------------------------------------------------------
# run ccopt
# -------------------------------------------------------------
ccopt_design -cts
report_ccopt_skew_groups
timeDesign -postCTS \
  -pathReports \
  -drvReports \
  -slackReports \
  -numPaths 50 \
  -prefix postCTS \
  -outDir $::env(RESULT_DIR)/pr/report/cts_timing

saveDesign $::env(RESULT_DIR)/pr/data/cts.enc
exit



