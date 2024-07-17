export DESIGN_NICKNAME = tinyriscv
export DESIGN_NAME = tinyriscv_soc_top
export PLATFORM    = tsmc180

export VERILOG_FILES = ./designs/src/$(DESIGN_NICKNAME)/header/tinyriscv_pkg.sv \
                       ./designs/src/$(DESIGN_NICKNAME)/core_2023211061/csr_reg.sv \
                       ./designs/src/$(DESIGN_NICKNAME)/core_2023211061/clint.sv \
                       ./designs/src/$(DESIGN_NICKNAME)/core_2023211061/ctrl.sv \
                       ./designs/src/$(DESIGN_NICKNAME)/core_2023211061/div.sv \
                       ./designs/src/$(DESIGN_NICKNAME)/core_2023211061/ex.sv \
		               ./designs/src/$(DESIGN_NICKNAME)/core_2023211061/instr_fetch.sv \
	    	           ./designs/src/$(DESIGN_NICKNAME)/core_2023211061/compress.sv \
                       ./designs/src/$(DESIGN_NICKNAME)/core_2023211061/id.sv \
                       ./designs/src/$(DESIGN_NICKNAME)/core_2023211061/id_ex.sv \
                       ./designs/src/$(DESIGN_NICKNAME)/core_2023211061/if_id.sv \
                       ./designs/src/$(DESIGN_NICKNAME)/core_2023211061/regs.sv \
                       ./designs/src/$(DESIGN_NICKNAME)/header/defines.vh \
                       ./designs/src/$(DESIGN_NICKNAME)/core_2023211061/tinyriscv.sv \
                       ./designs/src/$(DESIGN_NICKNAME)/core_2023211063/bpu_2023211063.v \
                       ./designs/src/$(DESIGN_NICKNAME)/core_2023211063/clint_2023211063.v \
                       ./designs/src/$(DESIGN_NICKNAME)/core_2023211063/csr_reg_2023211063.v \
                       ./designs/src/$(DESIGN_NICKNAME)/core_2023211063/ctrl_2023211063.v \
                       ./designs/src/$(DESIGN_NICKNAME)/core_2023211063/div_2023211063.v \
                       ./designs/src/$(DESIGN_NICKNAME)/core_2023211063/ex_2023211063.v \
                       ./designs/src/$(DESIGN_NICKNAME)/core_2023211063/ex_wb_2023211063.v \
                       ./designs/src/$(DESIGN_NICKNAME)/core_2023211063/hazard_ctrl_2023211063.v \
                       ./designs/src/$(DESIGN_NICKNAME)/core_2023211063/id_2023211063.v \
                       ./designs/src/$(DESIGN_NICKNAME)/core_2023211063/id_ex_2023211063.v \
                       ./designs/src/$(DESIGN_NICKNAME)/core_2023211063/if_id_2023211063.v \
                       ./designs/src/$(DESIGN_NICKNAME)/core_2023211063/ifu_2023211063.v \
                       ./designs/src/$(DESIGN_NICKNAME)/core_2023211063/pc_reg_2023211063.v \
                       ./designs/src/$(DESIGN_NICKNAME)/core_2023211063/pre_id_2023211063.v \
                       ./designs/src/$(DESIGN_NICKNAME)/core_2023211063/regs_2023211063.v \
                       ./designs/src/$(DESIGN_NICKNAME)/core_2023211063/tinyriscv_2023211063.v \
                       ./designs/src/$(DESIGN_NICKNAME)/debug/jtag_dm.v \
                       ./designs/src/$(DESIGN_NICKNAME)/debug/jtag_driver.v \
                       ./designs/src/$(DESIGN_NICKNAME)/debug/jtag_top.v \
                       ./designs/src/$(DESIGN_NICKNAME)/debug/uart_debug.v \
                       ./designs/src/$(DESIGN_NICKNAME)/perips/gpio.v \
                       ./designs/src/$(DESIGN_NICKNAME)/perips/i2c.v \
                       ./designs/src/$(DESIGN_NICKNAME)/perips/pwm.v \
                       ./designs/src/$(DESIGN_NICKNAME)/perips/ram.v \
                       ./designs/src/$(DESIGN_NICKNAME)/perips/rom.v \
                       ./designs/src/$(DESIGN_NICKNAME)/perips/spi.v \
                       ./designs/src/$(DESIGN_NICKNAME)/perips/timer.v \
                       ./designs/src/$(DESIGN_NICKNAME)/perips/uart.v \
                       ./designs/src/$(DESIGN_NICKNAME)/perips/rib.sv \
                       ./designs/src/$(DESIGN_NICKNAME)/utils/full_handshake_rx.v \
                       ./designs/src/$(DESIGN_NICKNAME)/utils/full_handshake_tx.v \
                       ./designs/src/$(DESIGN_NICKNAME)/utils/gen_pulse.v \
                       ./designs/src/$(DESIGN_NICKNAME)/utils/debounce.sv \
                       ./designs/src/$(DESIGN_NICKNAME)/utils/gen_en_dff.sv \
                       ./designs/src/$(DESIGN_NICKNAME)/utils/fifo.sv \
                       ./designs/src/$(DESIGN_NICKNAME)/soc/tinyriscv_soc_top.v

export PR_SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint_for_pr.sdc
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc
export IO_FILE = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/io.file

