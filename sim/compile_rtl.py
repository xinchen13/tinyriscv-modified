import sys
import filecmp
import subprocess
import sys
import os


# 主函数
def main():
    rtl_dir = sys.argv[1]

    if rtl_dir != r'..':
        tb_file = r'/tb/compliance_test/tinyriscv_soc_tb.v'
    else:
        tb_file = r'/tb/tinyriscv_soc_tb.v'

    # iverilog程序
    iverilog_cmd = ['iverilog']
    # 顶层模块
    #iverilog_cmd += ['-s', r'tinyriscv_soc_tb']
    # 编译生成文件
    iverilog_cmd += ['-g2012']
    iverilog_cmd += ['-o', r'out.vvp']
    # 头文件(defines.vh)路径
    iverilog_cmd += ['-I', rtl_dir + r'/rtl/header']
    # 宏定义，仿真输出文件
    iverilog_cmd += ['-D', r'OUTPUT="signature.output"']
    # testbench文件
    iverilog_cmd.append(rtl_dir + tb_file)
    # ../rtl/core_2023211061
    iverilog_cmd.append(rtl_dir + r'/rtl/core_2023211061/clint.sv')
    iverilog_cmd.append(rtl_dir + r'/rtl/core_2023211061/compress.sv')
    iverilog_cmd.append(rtl_dir + r'/rtl/core_2023211061/csr_reg.sv')
    iverilog_cmd.append(rtl_dir + r'/rtl/core_2023211061/ctrl.sv')
    iverilog_cmd.append(rtl_dir + r'/rtl/core_2023211061/div.sv')
    iverilog_cmd.append(rtl_dir + r'/rtl/core_2023211061/ex.sv')
    iverilog_cmd.append(rtl_dir + r'/rtl/core_2023211061/gen_en_dff.sv')
    iverilog_cmd.append(rtl_dir + r'/rtl/core_2023211061/id_ex.sv')
    iverilog_cmd.append(rtl_dir + r'/rtl/core_2023211061/id.sv')
    iverilog_cmd.append(rtl_dir + r'/rtl/core_2023211061/if_id.sv')
    iverilog_cmd.append(rtl_dir + r'/rtl/core_2023211061/instr_fetch.sv')
    iverilog_cmd.append(rtl_dir + r'/rtl/core_2023211061/lsu.sv')
    iverilog_cmd.append(rtl_dir + r'/rtl/core_2023211061/pc_reg.sv')
    iverilog_cmd.append(rtl_dir + r'/rtl/core_2023211061/regs.sv')
    iverilog_cmd.append(rtl_dir + r'/rtl/core_2023211061/tinyriscv.sv')
    # ../rtl/core_2023211063
    iverilog_cmd.append(rtl_dir + r'/rtl/core_2023211063/clint_2023211063.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/core_2023211063/csr_reg_2023211063.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/core_2023211063/ctrl_2023211063.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/core_2023211063/div_2023211063.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/core_2023211063/ex_2023211063.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/core_2023211063/id_2023211063.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/core_2023211063/id_ex_2023211063.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/core_2023211063/if_id_2023211063.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/core_2023211063/pc_reg_2023211063.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/core_2023211063/regs_2023211063.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/core_2023211063/tinyriscv_2023211063.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/core_2023211063/pre_id_2023211063.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/core_2023211063/bpu_2023211063.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/core_2023211063/ifu_2023211063.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/core_2023211063/ex_wb_2023211063.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/core_2023211063/hazard_ctrl_2023211063.v')
    # ../rtl/perips
    iverilog_cmd.append(rtl_dir + r'/rtl/perips/rib.sv')
    iverilog_cmd.append(rtl_dir + r'/rtl/perips/ram.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/perips/rom.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/perips/timer.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/perips/uart.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/perips/gpio.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/perips/spi.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/perips/pwm.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/perips/i2c.v')
    # ../rtl/debug
    iverilog_cmd.append(rtl_dir + r'/rtl/debug/jtag_dm.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/debug/jtag_driver.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/debug/jtag_top.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/debug/uart_debug.v')
    # ../rtl/soc
    iverilog_cmd.append(rtl_dir + r'/rtl/soc/tinyriscv_soc_top.v')
    # ../rtl/utils
    iverilog_cmd.append(rtl_dir + r'/rtl/utils/full_handshake_rx.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/utils/full_handshake_tx.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/utils/gen_buf.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/utils/gen_dff.v')
    iverilog_cmd.append(rtl_dir + r'/rtl/utils/gen_pulse.v')

    iverilog_cmd.append(rtl_dir + r'/rtl/header/defines.vh')
    iverilog_cmd.append(rtl_dir + r'/rtl/header/tinyriscv_pkg.sv')

    # 编译
    process = subprocess.Popen(iverilog_cmd)
    process.wait(timeout=5)

if __name__ == '__main__':
    sys.exit(main())
