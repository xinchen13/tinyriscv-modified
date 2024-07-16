# Process node
export PROCESS = 180

#-----------------------------------------------------
# Tech/Libs
# ----------------------------------------------------
export LEF_FILES =  /data2/class/chenh/chenh62/TSMC18_Lib_new/lib/SC_ARM/lef/tech_sage-x_tsmc_cl018g_6lm.lef \
                    /data2/class/chenh/chenh62/TSMC18_Lib_new/lib/SC_ARM/lef/sage-x_tsmc_cl018g.lef \
                    /data2/class/chenh/chenh62/TSMC18_Lib_new/lib/IO/Back_End/lef/tpd018nv_280a/mt_2/6lm/lef/tpd018nv_6lm.lef \
                    /data2/class/chenh/chenh62/TSMC18_Lib_new/lib/Bonding_PAD/Back_End/lef/tpb018v_190a/wb/6lm/lef/tpb018v_6lm.lef \
                    /data2/class/chenh/chenh62/TSMC18_Lib_new/lib/FILLCAP/lef/tsmc18_decap_6lm.lef \
                    /data2/class/chenh/chenh62/TSMC18_Lib_new/lib/FILLCAP/lef/tsmc18_decap_6lm_antenna.lef
					

export DB_FILES = /data2/class/chenh/chenh62/TSMC18_Lib_new/lib/SC_ARM/db/sage-x_tsmc_cl018g_rvt_tt_1p8v_25c.db \
				  /data2/class/chenh/chenh62/TSMC18_Lib_new/lib/IO/Front_End/timing_power_noise/NLDM/tpd018nv_280a/tpd018nvtc.db

export LIB_FILES =  /data2/class/chenh/chenh62/TSMC18_Lib_new/lib/SC_ARM/lib/sage-x_tsmc_cl018g_rvt_tt_1p8v_25c.lib \
					/data2/class/chenh/chenh62/TSMC18_Lib_new/lib/IO/Front_End/timing_power_noise/NLDM/tpd018nv_280a/tpd018nvtc.lib

export MIN_LIB_FILES =  /data2/class/chenh/chenh62/TSMC18_Lib_new/lib/SC_ARM/lib/sage-x_tsmc_cl018g_rvt_ff_1p98v_0c.lib \
						/data2/class/chenh/chenh62/TSMC18_Lib_new/lib/IO/Front_End/timing_power_noise/NLDM/tpd018nv_280a/tpd018nvbc.lib
export MAX_LIB_FILES =  /data2/class/chenh/chenh62/TSMC18_Lib_new/lib/SC_ARM/lib/sage-x_tsmc_cl018g_rvt_ss_1p62v_125c.lib \
						/data2/class/chenh/chenh62/TSMC18_Lib_new/lib/IO/Front_End/timing_power_noise/NLDM/tpd018nv_280a/tpd018nvwc.lib
# Dont use cells list
export DONT_USE_CELLS = RF1R1WX2 RF2R1WX2

# Define fill cells
export FILL_CELLS = FILL1 FILL16 FILL2 FILL32 FILL4 FILL64 FILL8 FILLCAP4 FILLCAP8 FILLCAP16 FILLCAP32 FILLCAP64
#Define tie cells
export TIEHI_CELL_AND_PORT = TIEHI HI
export TIELO_CELL_AND_PORT = TIELO LO
#Define Cap table
export CAP_TABLE = /data2/class/chenh/chenh62/TSMC18_Lib_new/t018s6ml.capTabl

#--------------------------------------------------------
# Floorplan
# -------------------------------------------------------
export PLACE_DENSITY = 0.80
export PLACE_SITE = tsmc3site
export TAP_CELL_NAME = FILL2

#--------------------------------------------------------
# IO placement
# -------------------------------------------------------
export IO_FILLER_CELLS = PFILLER0005 PFILLER05 PFILLER1 PFILLER10 PFILLER20 PFILLER5

#--------------------------------------------------------
# Power plan
# -------------------------------------------------------
export CORE_PWR_PORT = VDD
export CORE_GND_PORT = VSS
export V_STRIPE_METAL = M6
export H_STRIPE_METAL = M5
export STRIPE_WIDTH = 6
export STRIPE_SPACING = 2
export STRIPE_DISTANCE = 30
export SROUTE_MIN_LAYER = M1
export SROUTE_MAX_LAYER = M6

#---------------------------------------------------------
# Place
# --------------------------------------------------------
export MIN_GLOBAL_ROUTE_LAYER = 1
export MAX_GLOBAL_ROUTE_LAYER = 4

# --------------------------------------------------------
#  CTS
#  -------------------------------------------------------
export CTS_BUF_CELL = CLKBUFX4
export CTS_INV_CELL = CLKINVX1 CLKINVX2 CLKINVX4 CLKINVX8 CLKINVX12 CLKINVX16
#Set the routing non-default rule which are used for clk tree routing 
export CTS_ROUTING_MUL = 2
export NDR_CTS_MIN_LAYER = 2
export NDR_CTS_MAX_LAYER = 4
#Set the routing metal which are used for clk tree routing 
export CTS_ROUTING_LAYER_RANGE = 6 2

# ---------------------------------------------------------
#  Route
# ---------------------------------------------------------
export MIN_ROUTING_LAYER = 1
export MAX_ROUTING_LAYER = 6

# ---------------------------------------------------------
#  Chip Finish
# ---------------------------------------------------------
#Set the layer text num for adding PG net text when running lvs 
export LAYER_TEXT_NUM = 45
export GDS_MAP_FILE = /data2/class/chenh/chenh62/TSMC18_Lib_new/streamOut.map
export MAERGER_GDS_PATH = /data2/class/chenh/chenh62/TSMC18_Lib_new/merger_gds

# ---------------------------------------------------------
#  ExtraceRC
# ---------------------------------------------------------
#export RCX_RULES = $(DESIGN_HOME)/nangate45/pdk/rcx_patterns.rules


# ---------------------------------------------------------
#  Lvs
# ---------------------------------------------------------
export STDCELL_SPICE = /data2/class/chenh/chenh62/TSMC18_Lib_new/lib/SC_ARM/cdl/sage-x_tsmc_cl018g_rvt.cdl
export STDCELL_NETLIST =


