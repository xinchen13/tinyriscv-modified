layout filemerge -in $::env(RESULT_DIR)/pr/data/$::env(DESIGN_NAME).gds \
-in $::env(STDCELL_GDS) \
-topcell rvcpu_wrapper_IO \
-mode overwrite \
-out $::env(RESULT_DIR)/pv/drc/data/$::env(DESIGN_NAME).mergeSTD.gds

layout filemerge -in $::env(RESULT_DIR)/pr/data/$::env(DESIGN_NAME).mergeSTD.gds \
-in $::env(IO_GDS) \
-topcell rvcpu_wrapper_IO \
-mode overwrite \
-out $::env(RESULT_DIR)/pv/drc/data/$::env(DESIGN_NAME).mergeIO.gds

