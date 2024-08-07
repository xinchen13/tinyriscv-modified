current_design tinyriscv_io_top

set clk_name  core_clock
set clk_port_name clk
set clk_period 10
set clk_io_pct 0.2

set clk_port [get_ports $clk_port_name]

create_clock -name $clk_name -period $clk_period $clk_port
create_clock -name jtag_clk -period 300 [get_ports jtag_TCK]

set_clock_uncertainty 0.3 [all_clocks]

#input_delay 和transtion 按周期的5% / fanout 40 /max cap foundary给建议
set_input_delay  [expr $clk_period * $clk_io_pct] -clock $clk_name [lsearch -inline -all -not -exact [all_inputs] $clk_port]
set_output_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [all_outputs]
