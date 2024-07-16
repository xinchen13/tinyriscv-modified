export DESIGN_NICKNAME = tinyriscv
export DESIGN_NAME = tinyriscv_soc_top
export PLATFORM    = tsmc180

export VERILOG_FILES = ./designs/src/$(DESIGN_NICKNAME)/core/clint.v \
            ./designs/src/$(DESIGN_NICKNAME)/core/csr_reg.v \
            ./designs/src/$(DESIGN_NICKNAME)/core/ctrl.v \
            ./designs/src/$(DESIGN_NICKNAME)/core/defines.v \
            ./designs/src/$(DESIGN_NICKNAME)/core/div.v \
            ./designs/src/$(DESIGN_NICKNAME)/core/ex.v \
            ./designs/src/$(DESIGN_NICKNAME)/core/id.v \
            ./designs/src/$(DESIGN_NICKNAME)/core/id_ex.v \
            ./designs/src/$(DESIGN_NICKNAME)/core/if_id.v \
            ./designs/src/$(DESIGN_NICKNAME)/core/pc_reg.v \
            ./designs/src/$(DESIGN_NICKNAME)/core/regs.v \
            ./designs/src/$(DESIGN_NICKNAME)/core/rib.v \
            ./designs/src/$(DESIGN_NICKNAME)/core/tinyriscv.v \
            ./designs/src/$(DESIGN_NICKNAME)/debug/jtag_dm.v \
            ./designs/src/$(DESIGN_NICKNAME)/debug/jtag_driver.v \
            ./designs/src/$(DESIGN_NICKNAME)/debug/jtag_top.v \
            ./designs/src/$(DESIGN_NICKNAME)/debug/uart_debug.v \
            ./designs/src/$(DESIGN_NICKNAME)/perips/gpio.v \
            ./designs/src/$(DESIGN_NICKNAME)/perips/ram.v \
            ./designs/src/$(DESIGN_NICKNAME)/perips/rom.v \
            ./designs/src/$(DESIGN_NICKNAME)/perips/spi.v \
            ./designs/src/$(DESIGN_NICKNAME)/perips/timer.v \
            ./designs/src/$(DESIGN_NICKNAME)/perips/uart.v \
            ./designs/src/$(DESIGN_NICKNAME)/utils/full_handshake_rx.v \
            ./designs/src/$(DESIGN_NICKNAME)/utils/full_handshake_tx.v \
            ./designs/src/$(DESIGN_NICKNAME)/utils/gen_buf.v \
            ./designs/src/$(DESIGN_NICKNAME)/utils/gen_dff.v \
            ./designs/src/$(DESIGN_NICKNAME)/soc/tinyriscv_soc_top.v

export PR_SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint_for_pr.sdc
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc
export IO_FILE = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/io.file
