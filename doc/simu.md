# 仿真

## iverilog + GTKWave
- `target` 为 `.bin` 或 `.data` 文件, 在 `sim/` 目录下执行 `python generate_inst_data_and_sim.py target`
- 具体见 [sim/](../sim/) 目录

## Synopsys VCS + Verdi
- `target` 为 `.bin` 或 `.data` 文件, 在 `vcs/` 目录下执行 `python generate_inst_data.py target`; 之后按照 Makefile 操作
- 具体见 [vcs/](../vcs/) 目录

## FPGA