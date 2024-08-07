define_design_lib work -path $::env(RESULT_DIR)/syn/work
set sh_command_log_file $::env(RESULT_DIR)/syn/work/command.log
set_app_var alib_library_analysis_path $::env(RESULT_DIR)/syn/work
set_svf $::env(RESULT_DIR)/syn/data/$::env(DESIGN_NAME).svf







