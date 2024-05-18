# tinyriscv-modified

## GPIO 的引出
原有的 Tinyriscv 中引出了2个 GPIO, 现在需要将其修改为16个:
- 修改 [gpio.v](./rtl/perips/gpio.v) 中的信号宽度, 为后14个引脚添加写入逻辑
- 在顶层模块 [tinyriscv_soc_top.v](./rtl/soc/tinyriscv_soc_top.v) 中修改 io_in 信号的宽度, 并将gpio模块的所有输入输出引出到 SoC 的 gpio 管脚处
- 验证程序见 [main.c](./tests/example/gpio_16/main.c), 在 `sim/` 路径下运行 `python ./sim_new_nowave.py ../tests/example/gpio_16/gpio.bin inst.data` , 之后查看波形

## 资源的删减
原有的 uart_debug 接收的 packet 大小为131，模块内部存在 132d x 8w 的寄存器组. 现需修改为 uart_debug 接收的 packet 大小为35，模块内部存在 35d x 8w 的寄存器组
- 修改 [uart_debug.v](./rtl/debug/uart_debug.v) 中 `rx_data` 的大小; 宏 `UART_FIRST_PACKET_LEN` 和 `UART_REMAIN_PACKET_LEN` 对应的值; 包大小 `fw_file_size` 对应的 `rx_data` 位数索引
- 具体配置参数可以参考修改后的软件 [new_tinyriscv_fw_downloader.py](./tools/new_tinyriscv_fw_downloader.py)

原有的 ROM 大小为 4096d x 32w，现需修改为 256d x 32w
- 直接修改 [defines.v](./rtl/core/defines.v) 中的定义即可

原有的 RAM 大小为 4096d x 32w，现需修改为 16d x 32w
- 直接修改 [defines.v](./rtl/core/defines.v) 中的定义即可
- 在编译软件时需要修改链接脚本. 如在 [link.lds](./tests/example/link.lds) 中需要修改 MEMORY 关键词中的 ram 大小并调整 stack 大小 `__stack_size`

其他说明
- 添加了脚本文件 [sim_data_file.py](./sim/sim_data_file.py), 在 `sim/` 目录下可以使用如下命令指定转换好的 `xxx.data` 文件作为测试向量: `python sim_data_file.py path_of_the_target_mem_file.data inst.data`

## PWM 外设的添加

<img src="./figs/pwm.png"  width="520" />

- 在 [rib.v](./rtl/core/rib.v) 中给 rib 总线添加一个 slave interface, 按序号分配为 slave_6, 起始地址映射到 0x6000_0000
- `rtl/utils/` 路径下添加 [gen_pulse.v](./rtl/utils/gen_pulse.v) 模块, 实现脉冲生成; `rtl/perips/` 中添加 [pwm.v](./rtl/perips/pwm.v) 外设, 完成寄存器定义, 读写寄存器, 例化 gen_pulse 模块
- 顶层模块中添加总线子模块接口, 例化 pwm 模块, 引出 io
- 为 [compile_rtl.py](./sim/compile_rtl.py) 添加对应 `.v` 文件
- 编写软件库 [pwm.h](./tests/example/include/pwm.h), 定义寄存器地址和读写宏
- 测试用例见 [pwm/](./tests/example/pwm/), 编译后在 `sim/` 文件夹下通过 `python sim_new_nowave.py ../tests/example/pwm/pwm.bin inst.data` 运行

## I2C 外设的添加

<img src="./figs/i2c.png"  width="520" />

- I2C protocol 整理: [i2c.md](./doc/i2c.md)
- `rtl/perips/` 路径下添加 [i2c.v](./rtl/perips/i2c.v), 实现了 iic 的读功能, 默认的读取地址是 ALINX AX7035 中的 LM75 温度传感器地址 8'b10010001, 实现的功能是当 iic_en 寄存器被写入 32'h1 时, 将 iic_device_addr 处的温度寄存器值读取到 iic_read_data 的低16位, 读取 LM75 温度寄存器的时序如下:

<img src="./figs/lm75_timing.png"  width="800" />

- 在 [rib.v](./rtl/core/rib.v) 中给 rib 总线添加一个 slave interface, 按序号分配为 slave_7, 起始地址映射到 0x7000_0000
- 顶层模块中添加总线子模块接口, 例化 i2c 模块, 引出 io
- 为 [compile_rtl.py](./sim/compile_rtl.py) 添加对应 `.v` 文件
- 编写软件库 [i2c.h](./tests/example/include/i2c.h), 定义寄存器地址和读写宏
- 测试用例见 [i2c/](./tests/example/i2c/), 编译后在 `sim/` 文件夹下通过 `python sim_new_nowave.py ../tests/example/i2c/i2c.bin inst.data` 运行

## 拓展指令: Send ID

<img src="./figs/send_id.png"  width="600" />

- 为 [uart.v](./rtl/perips/uart.v) 添加一个状态机, 当寄存器 uart_ctrl[2] 和 uart_ctrl[0] 都被写入 1 时, 触发一次该状态机循环, 通过 uart 输出一次学号. 在此基础上该指令的运行过程简化一次访存: 在地址 0x30000000 处写入一次 0x00000005
- 在 [defines.v](./rtl/core/defines.v) 中添加拓展指令类型 `INST_TYPE_EXT`; 为 [id.v](./rtl/core/id.v) 与 [ex.v](./rtl/core/ex.v) 模块添加对 sID 指令的支持
- 运行指令测试: `python sim_data_file.py ../tests/test_mem/Extend_Inst_Example/sID/sID_inst.data inst.data`


## 参考资料
- 原项目地址: [liangkangnan/tinyriscv](https://gitee.com/liangkangnan/tinyriscv)
- I2C协议手册: [UM10204.pdf](https://www.nxp.com/docs/en/user-guide/UM10204.pdf)