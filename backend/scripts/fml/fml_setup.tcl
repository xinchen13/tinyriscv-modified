set sh_command_log_file "$::env(RESULT_DIR)/fml_syn/work/fm_shell_command.log"
set formality_log_name "$::env(RESULT_DIR)/fml_syn/work/formality.log"
define_design_lib -r -path "$::env(RESULT_DIR)/fml_syn/work" work
set verification_set_undriven_signals 0
set hdlin_vhdl_auto_file_order false
set hdlin_warn_on_mismatch_message {FMR_ELAB-147}
