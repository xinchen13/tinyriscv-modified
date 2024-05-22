# 时钟约束50MHz
set_property -dict { PACKAGE_PIN Y18 IOSTANDARD LVCMOS33 } [get_ports {clk}]; 
create_clock -add -name sys_clk_pin -period 20.00 -waveform {0 10} [get_ports {clk}];

# 时钟引脚
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property PACKAGE_PIN Y18 [get_ports clk]

# 复位引脚
set_property IOSTANDARD LVCMOS33 [get_ports rst]
set_property PACKAGE_PIN F20 [get_ports rst]

# 程序执行成功指示引脚
set_property IOSTANDARD LVCMOS33 [get_ports succ]
set_property PACKAGE_PIN F19 [get_ports succ]

# 串口发送引脚
set_property IOSTANDARD LVCMOS33 [get_ports uart_tx_pin]
set_property PACKAGE_PIN G16 [get_ports uart_tx_pin]

# 串口接收引脚
set_property IOSTANDARD LVCMOS33 [get_ports uart_rx_pin]
set_property PACKAGE_PIN G15 [get_ports uart_rx_pin]

# PWM 引脚
set_property IOSTANDARD LVCMOS33 [get_ports PWM_o[0]]
set_property PACKAGE_PIN E21 [get_ports PWM_o[0]]

set_property IOSTANDARD LVCMOS33 [get_ports PWM_o[1]]
set_property PACKAGE_PIN D20 [get_ports PWM_o[1]]

set_property IOSTANDARD LVCMOS33 [get_ports PWM_o[2]]
set_property PACKAGE_PIN C20 [get_ports PWM_o[2]]

# GPIO引脚
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_out[*]}]
set_property PACKAGE_PIN J5 [get_ports {gpio_out[0]}]
set_property PACKAGE_PIN M3 [get_ports {gpio_out[1]}]
set_property PACKAGE_PIN J6 [get_ports {gpio_out[2]}]
set_property PACKAGE_PIN H5 [get_ports {gpio_out[3]}]
set_property PACKAGE_PIN G4 [get_ports {gpio_out[4]}]
set_property PACKAGE_PIN K6 [get_ports {gpio_out[5]}]
set_property PACKAGE_PIN K3 [get_ports {gpio_out[6]}]
set_property PACKAGE_PIN H4 [get_ports {gpio_out[7]}]
set_property PACKAGE_PIN M2 [get_ports {gpio_out[8]}]
set_property PACKAGE_PIN N4 [get_ports {gpio_out[9]}]
set_property PACKAGE_PIN L5 [get_ports {gpio_out[10]}]
set_property PACKAGE_PIN L4 [get_ports {gpio_out[11]}]
set_property PACKAGE_PIN M16 [get_ports {gpio_out[12]}]
set_property PACKAGE_PIN M17 [get_ports {gpio_out[13]}]
set_property PACKAGE_PIN B20 [get_ports {gpio_out[14]}]
set_property PACKAGE_PIN D17 [get_ports {gpio_out[15]}]

# I2C 引脚
set_property IOSTANDARD LVCMOS33 [get_ports io_scl]
set_property PACKAGE_PIN M22 [get_ports io_scl]

set_property IOSTANDARD LVCMOS33 [get_ports io_sda]
set_property PACKAGE_PIN N22 [get_ports io_sda]

# Debug 引脚
set_property IOSTANDARD LVCMOS33 [get_ports uart_debug_pin]
set_property PACKAGE_PIN M13 [get_ports uart_debug_pin]

