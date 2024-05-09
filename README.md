# tinyriscv-modified

## GPIO的引出
原有的 Tinyriscv 中引出了2个 GPIO, 现在需要将其修改为16个:
- 修改 [gpio.v](./rtl/perips/gpio.v) 中的信号宽度, 为后14个引脚添加写入逻辑
- 在顶层模块 [tinyriscv_soc_top.v](./rtl/soc/tinyriscv_soc_top.v) 中修改 io_in 信号的宽度, 并将gpio模块的所有输入输出引出到 SoC 的 gpio 管脚处
- 验证程序见 [main.c](./tests/example/gpio_16/main.c), 在 `sim/` 路径下运行 `python ./sim_new_nowave.py ../tests/example/gpio_16/gpio.bin inst.data` , 之后查看波形

## Acknowledgement
https://gitee.com/liangkangnan/tinyriscv