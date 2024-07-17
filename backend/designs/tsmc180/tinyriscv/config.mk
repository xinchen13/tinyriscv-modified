export DESIGN_NICKNAME = tinyriscv
export DESIGN_NAME = tinyriscv_soc_top
export PLATFORM    = tsmc180

export VERILOG_FILES = ./designs/src/header/tinyriscv_pkg.sv \
                       ./designs/src/core_2023211061/csr_reg.sv \
                       ./designs/src/core_2023211061/clint.sv \
                       ./designs/src/core_2023211061/ctrl.sv \
                       ./designs/src/core_2023211061/div.sv \
                       ./designs/src/core_2023211061/ex.sv \
		               ./designs/src/core_2023211061/instr_fetch.sv \
	    	           ./designs/src/core_2023211061/compress.sv \
                       ./designs/src/core_2023211061/id.sv \
                       ./designs/src/core_2023211061/id_ex.sv \
                       ./designs/src/core_2023211061/if_id.sv \
                       ./designs/src/core_2023211061/regs.sv \
                       ./designs/src/header/defines.vh \
                       ./designs/src/core_2023211061/tinyriscv.sv \
                       ./designs/src/core_2023211063/bpu_2023211063.v \
                       ./designs/src/core_2023211063/clint_2023211063.v \
                       ./designs/src/core_2023211063/csr_reg_2023211063.v \
                       ./designs/src/core_2023211063/ctrl_2023211063.v \
                       ./designs/src/core_2023211063/div_2023211063.v \
                       ./designs/src/core_2023211063/ex_2023211063.v \
                       ./designs/src/core_2023211063/ex_wb_2023211063.v \
                       ./designs/src/core_2023211063/hazard_ctrl_2023211063.v \
                       ./designs/src/core_2023211063/id_2023211063.v \
                       ./designs/src/core_2023211063/id_ex_2023211063.v \
                       ./designs/src/core_2023211063/if_id_2023211063.v \
                       ./designs/src/core_2023211063/ifu_2023211063.v \
                       ./designs/src/core_2023211063/pc_reg_2023211063.v \
                       ./designs/src/core_2023211063/pre_id_2023211063.v \
                       ./designs/src/core_2023211063/regs_2023211063.v \
                       ./designs/src/core_2023211063/tinyriscv_2023211063.v \
                       ./designs/src/debug/jtag_dm.v \
                       ./designs/src/debug/jtag_driver.v \
                       ./designs/src/debug/jtag_top.v \
                       ./designs/src/debug/uart_debug.v \
                       ./designs/src/perips/gpio.v \
                       ./designs/src/perips/i2c.v \
                       ./designs/src/perips/pwm.v \
                       ./designs/src/perips/ram.v \
                       ./designs/src/perips/rom.v \
                       ./designs/src/perips/spi.v \
                       ./designs/src/perips/timer.v \
                       ./designs/src/perips/uart.v \
                       ./designs/src/perips/rib.sv \
                       ./designs/src/utils/full_handshake_rx.v \
                       ./designs/src/utils/full_handshake_tx.v \
                       ./designs/src/utils/gen_pulse.v \
                       ./designs/src/utils/debounce.sv \
                       ./designs/src/utils/gen_en_dff.sv \
                       ./designs/src/utils/fifo.sv \
                       ./designs/src/soc/tinyriscv_soc_top.v

export PR_SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint_for_pr.sdc
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc
export IO_FILE = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/io.file

