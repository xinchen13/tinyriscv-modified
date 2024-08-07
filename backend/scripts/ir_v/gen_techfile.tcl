set_pg_library_mode \
    -celltype                   techonly \
    -ground_pins                VSS \
    -power_pins                 "VDD $::env(PWR_NETS_VOLTAGES)" \
    -default_area_cap           0.01 \
    -extraction_tech_file       "$::env(QRC_FILE)" 
    #-decap_cells                "$decap_cell_name" \
    #-filler_cells               "$filler_name" \
    #-cell_decap_file            ../data/voltus/decap.cmd 

generate_pg_library \
    -output                     ./result/ir_v/data/tech_pgv

#-----------------------------------------------------------------------
# Standard cells pgv generation ToDo
#-----------------------------------------------------------------------
#set_pg_library_mode \
#    -ground_pins                VSS \
#    -power_pins                 {VDD 0.9} \
#    -decap_cells                {DECAP8 DECAP64 DECAP4 DECAP32 DECAP2 DECAP16 DECAP1} \
#    -filler_cells               { FILL8  FILL64  FILL4  FILL32  FILL2  FILL16  FILL1} \
#    -celltype                   stdcells \
#    -cell_decap_file            ../data/voltus/decap.cmd \
#    -cell_list_file 		../data/voltus/cell.list \
#    -spice_subckts { \
#        ../data/netlists/gsclib090.sp \
#        ../data/netlists/pso_header.spi \
#       ../data/netlists/pso_ring.spi \
#    } \
#    -current_distribution       propagation \
#    -spice_models               ../data/netlists/spectre_load.sp \
#    -extraction_tech_file       ../data/qrc/gpdk090_9l.tch 

#generate_pg_library \
#    -output                      ./result/ir_v/data/stdcell_pgv
