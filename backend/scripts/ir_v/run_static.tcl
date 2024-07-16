#------------------------------------------------------
# load design
#------------------------------------------------------
source $::env(SCRIPTS_DIR)/ir_v/load_design.tcl

#------------------------------------------------------
# gen technology file
#------------------------------------------------------
source $::env(SCRIPTS_DIR)/ir_v/gen_techfile.tcl

#------------------------------------------------------
# set multi CPU
# ------------------------------------------------------
setMultiCpuUsage -localCpu  8

#-----------------------------------------------------------------------
# Read spef file
#-----------------------------------------------------------------------
spefIn -rc_corner rc_max $::env(RESULT_DIR)/extractRC/data/ibex.spef.gz

#-----------------------------------------------------------------------
# Static Power Analysis
#-----------------------------------------------------------------------
set_power_analysis_mode \
    -reset
set_power_analysis_mode \
    -leakage_power_view 	max_view \
    -dynamic_power_view        	max_view \
    -write_static_currents      true \
    -binary_db_name             staticPower.db \
    -create_binary_db           true \
    -method                     static

#-----------------------------------------------------------------------
# set toggle rate on the rst pin and propagate activities:
#-----------------------------------------------------------------------
set_switching_activity \
    -reset

set_switching_activity \
    -input_port                 rst \
    -activity                   0.5 \
    -duty                       0.5

propagate_activity

#-----------------------------------------------------------------------
# set default activities for all nets/pins/etc for unclocked nets
#-----------------------------------------------------------------------
set_default_switching_activity \
    -input_activity             0.5 \
    -period                     4.0 \
    -clock_gates_output_ratio   0.5

#-----------------------------------------------------------------------
# define output directory
#-----------------------------------------------------------------------
set_power_output_dir            $::env(RESULT_DIR)/ir_v/data

#-----------------------------------------------------------------------
# run power analysis
#-----------------------------------------------------------------------
report_power \
    -outfile                    static.rpt

#-----------------------------------------------------------------------
# Static Rail Analysis
#-----------------------------------------------------------------------
set_rail_analysis_mode \
    -method                     static \
    -accuracy                   xd \
    -analysis_view              max_view \
    -power_grid_library         { \
        ./result/ir_v/data/tech_pgv/techonly.cl \
    } \
    -enable_rlrp_analysis       true \
    -verbosity true \
    -temperature "$::env(RAIL_ANALYSIS_TEMPERATURE)"

#-----------------------------------------------------------------------
# Define voltages and thresholds that are used by the rail analysis engine.
#-----------------------------------------------------------------------
set_pg_nets -net VDD -voltage $::env(PWR_NETS_VOLTAGES) -threshold $::env(PWR_THRESHOLD) -force
set_pg_nets -net VSS -voltage $::env(GND_NETS_VOLTAGES) -threshold $::env(GND_THRESHOLD) -force

#-----------------------------------------------------------------------
# define voltage source location
#-----------------------------------------------------------------------
set_power_pads \
    -reset

set_power_pads \
    -net                        VDD \
    -format                     xy \
    -file                       ./scripts/ir_v/VDD.pp

set_power_pads \
    -net                        VSS \
    -format                     xy \
    -file                       ./scripts/ir_v/VSS.pp

#-----------------------------------------------------------------------
#define power consumption
#-----------------------------------------------------------------------
set_power_data -reset
set_power_data \
    -format                     current \
    { \
        ./result/ir_v/data/static_VDD.ptiavg \
        ./result/ir_v/data/static_VSS.ptiavg \
    }

analyze_rail \
    -output           ./result/ir_v/report \
    -type                       net \
                                VDD
