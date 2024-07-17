 /*                                                                      
 Copyright 2020 Blue Liang, liangkangnan@163.com
                                                                         
 Licensed under the Apache License, Version 2.0 (the "License");         
 you may not use this file except in compliance with the License.        
 You may obtain a copy of the License at                                 
                                                                         
     http://www.apache.org/licenses/LICENSE-2.0                          
                                                                         
 Unless required by applicable law or agreed to in writing, software    
 distributed under the License is distributed on an "AS IS" BASIS,       
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and     
 limitations under the License.                                          
 */

`include "../header/defines.vh"

// master0: core            2
// master1: pc              4
// master2: jtag            3
// master3: uart_debug      1

// tinyriscv soc顶层模块
module tinyriscv_soc_top(
    input wire clk,
    input wire rst,

    input wire chip_sel,
    output wire over,
    output wire succ,         // 测试是否成功信号

    input wire baud_update_en,
    input wire uart_debug_pin, // 串口下载使能引脚
    output wire uart_tx_pin, // UART发送引脚
    input wire uart_rx_pin,  // UART接收引脚

    inout wire[15:0] gpio,          // GPIO引脚
    output wire [3:0] pwm_o,        // pwm 输出

    output wire io_scl,
    inout wire io_sda,

    input wire jtag_TCK,     // JTAG TCK引脚
    input wire jtag_TMS,     // JTAG TMS引脚
    input wire jtag_TDI,     // JTAG TDI引脚
    output wire jtag_TDO,    // JTAG TDO引脚

    input wire spi_miso,     // SPI MISO引脚
    output wire spi_mosi,    // SPI MOSI引脚
    output wire spi_ss,      // SPI SS引脚
    output wire spi_clk      // SPI CLK引脚
    );

    // 按键消抖
    wire rst_nid;

    // master 0 interface
    wire[`MemAddrBus] m0_addr_i;
    wire[`MemBus] m0_data_i;
    wire[`MemBus] m0_data_o;
    wire m0_req_i;
    wire m0_we_i;
    wire m0_ack_o;

    // master 1 interface
    wire[`MemAddrBus] m1_addr_i;
    wire[`MemBus] m1_data_i;
    wire[`MemBus] m1_data_o;
    wire m1_req_i;
    wire m1_we_i;
    wire m1_ready;

    // master 2 interface
    wire[`MemAddrBus] m2_addr_i;
    wire[`MemBus] m2_data_i;
    wire[`MemBus] m2_data_o;
    wire m2_req_i;
    wire m2_we_i;

    // master 3 interface
    wire[`MemAddrBus] m3_addr_i;
    wire[`MemBus] m3_data_i;
    wire[`MemBus] m3_data_o;
    wire m3_req_i;
    wire m3_we_i;

    // slave 0 interface
    wire[`MemAddrBus] s0_addr_o;
    wire[`MemBus] s0_data_o;
    wire[`MemBus] s0_data_i;
    wire s0_we_o;

    // slave 1 interface
    wire[`MemAddrBus] s1_addr_o;
    wire[`MemBus] s1_data_o;
    wire[`MemBus] s1_data_i;
    wire s1_we_o;

    // slave 2 interface
    wire[`MemAddrBus] s2_addr_o;
    wire[`MemBus] s2_data_o;
    wire[`MemBus] s2_data_i;
    wire s2_we_o;

    // slave 3 interface
    wire[`MemAddrBus] s3_addr_o;
    wire[`MemBus] s3_data_o;
    wire[`MemBus] s3_data_i;
    wire s3_we_o;

    // slave 4 interface
    wire[`MemAddrBus] s4_addr_o;
    wire[`MemBus] s4_data_o;
    wire[`MemBus] s4_data_i;
    wire s4_we_o;

    // slave 5 interface
    wire[`MemAddrBus] s5_addr_o;
    wire[`MemBus] s5_data_o;
    wire[`MemBus] s5_data_i;
    wire s5_we_o;

    // slave 6 interface: pwm
    wire[`MemAddrBus] s6_addr_o;
    wire[`MemBus] s6_data_o;
    wire[`MemBus] s6_data_i;
    wire s6_we_o;

    // slave 7 interface: i2c
    wire[`MemAddrBus] s7_addr_o;
    wire[`MemBus] s7_data_o;
    wire[`MemBus] s7_data_i;
    wire s7_we_o;
    wire s7_ack_i;
    wire s7_req_o;

    // rib
    wire rib_hold_flag_o;

    // jtag
    wire jtag_halt_req_o;
    wire jtag_reset_req_o;
    wire[`RegAddrBus] jtag_reg_addr_o;
    wire[`RegBus] jtag_reg_data_o;
    wire jtag_reg_we_o;
    wire[`RegBus] jtag_reg_data_i;

    // tinyriscv
    wire[`INT_BUS] int_flag;

    // timer0
    wire timer0_int;

    // gpio
    wire[15:0] io_in;
    wire[31:0] gpio_ctrl;
    wire[31:0] gpio_data;

    assign int_flag = {7'h0, timer0_int};

    // 低电平点亮LED
    // 低电平表示已经halt住CPU
    assign halted_ind = ~jtag_halt_req_o;

    // 拉出寄存器
    wire over_2023211063;
    wire succ_2023211063;
    wire over_yw;
    wire succ_yw;
    assign over_temp = chip_sel ? over_yw : over_2023211063;
    assign succ_temp = chip_sel ? succ_yw : succ_2023211063;
    assign over = rst ? over_temp : 1'b1;
    assign succ = rst ? succ_temp : 1'b1;

    wire [`MemAddrBus] m0_addr_i_2023211063;
    wire [`MemBus] m0_data_i_2023211063;
    wire m0_req_i_2023211063;
    wire m0_we_i_2023211063;
    wire [`MemAddrBus] m1_addr_i_2023211063;
    wire[`RegBus] jtag_reg_data_i_2023211063;
    wire [`MemAddrBus] m0_addr_i_yw;
    wire [`MemBus] m0_data_i_yw;
    wire m0_req_i_yw;
    wire m0_we_i_yw;
    wire [`MemAddrBus] m1_addr_i_yw;
    wire[`RegBus] jtag_reg_data_i_yw;
    assign m0_addr_i = chip_sel ? m0_addr_i_yw : m0_addr_i_2023211063;
    assign m0_data_i = chip_sel ? m0_data_i_yw : m0_data_i_2023211063;
    assign m0_req_i = chip_sel ? m0_req_i_yw : m0_req_i_2023211063;
    assign m0_we_i = chip_sel ? m0_we_i_yw : m0_we_i_2023211063;
    assign m1_addr_i = chip_sel ? m1_addr_i_yw : m1_addr_i_2023211063;
    assign jtag_reg_data_i = chip_sel ? jtag_reg_data_i_yw : jtag_reg_data_i_2023211063;

    // tinyriscv 处理器核模块例化: xinchen - chip_sel = 1'b0
    tinyriscv_2023211063 u_tinyriscv_2023211063(
        .clk(clk),
        .rst(rst & (~chip_sel)),
        .rib_ex_addr_o(m0_addr_i_2023211063),
        .rib_ex_data_i(m0_data_o),
        .rib_ex_data_o(m0_data_i_2023211063),
        .rib_ex_req_o(m0_req_i_2023211063),
        .rib_ex_we_o(m0_we_i_2023211063),
        .rib_ex_ack_i(m0_ack_o),

        .rib_pc_addr_o(m1_addr_i_2023211063),
        .rib_pc_data_i(m1_data_o),

        .jtag_reg_addr_i(jtag_reg_addr_o),
        .jtag_reg_data_i(jtag_reg_data_o),
        .jtag_reg_we_i(jtag_reg_we_o),
        .jtag_reg_data_o(jtag_reg_data_i_2023211063),

        .rib_hold_flag_i(rib_hold_flag_o),
        .jtag_halt_flag_i(jtag_halt_req_o),
        .jtag_reset_flag_i(jtag_reset_req_o),

        .int_i(int_flag),

        .over(over_2023211063),
        .succ(succ_2023211063)
    );

    debounce u_debounce_rst (
        .clk_i(clk),   // Clock input
        .button_in (rst),   // Raw button input
        .button_out(rst_nid)   // Debounced button output
    );

    // tinyriscv 处理器核模块例化: yw - chip_sel = 1'b1
    tinyriscv_yw u_tinyriscv (
        .clk_i         (clk),
        .rst_ni        (rst_nid & chip_sel),
        .rib_ex_addr_o (m0_addr_i_yw),
        .rib_ex_data_i (m0_data_o),
        .rib_ex_data_o (m0_data_i_yw),
        .rib_ex_req_o  (m0_req_i_yw),
        .rib_ex_we_o   (m0_we_i_yw),
        .rib_ex_ready_i(m0_ack_o),

        .rib_pc_addr_o (m1_addr_i_yw),
        .rib_pc_data_i (m1_data_o),
        .rib_pc_ready_i(m1_ready),

        .jtag_reg_addr_i(jtag_reg_addr_o),
        .jtag_reg_data_i(jtag_reg_data_o),
        .jtag_reg_we_i  (jtag_reg_we_o),
        .jtag_reg_data_o(jtag_reg_data_i_yw),

        .rib_hold_flag_i  (rib_hold_flag_o),
        .jtag_halt_flag_i (jtag_halt_req_o),
        .jtag_reset_flag_i(jtag_reset_req_o),

        .int_i(int_flag),

        .over(over_yw),
        .succ(succ_yw)
    );


    // rom模块例化
    rom u_rom(
        .clk(clk),
        .rst(rst),
        .we_i(s0_we_o),
        .addr_i(s0_addr_o),
        .data_i(s0_data_o),
        .data_o(s0_data_i)
    );

    // ram模块例化
    ram u_ram(
        .clk(clk),
        .rst(rst),
        .we_i(s1_we_o),
        .addr_i(s1_addr_o),
        .data_i(s1_data_o),
        .data_o(s1_data_i)
    );

    // timer模块例化
    timer timer_0(
        .clk(clk),
        .rst(rst),
        .data_i(s2_data_o),
        .addr_i(s2_addr_o),
        .we_i(s2_we_o),
        .data_o(s2_data_i),
        .int_sig_o(timer0_int)
    );

    // uart模块例化
    uart uart_0(
        .clk(clk),
        .rst(rst),
        .baud_update_en(~baud_update_en),
        .chip_sel(chip_sel),
        .we_i(s3_we_o),
        .addr_i(s3_addr_o),
        .data_i(s3_data_o),
        .data_o(s3_data_i),
        .tx_pin(uart_tx_pin),
        .rx_pin(uart_rx_pin)
    );

    // io0
    assign gpio[0] = (gpio_ctrl[1:0] == 2'b01)? gpio_data[0]: 1'bz;
    assign io_in[0] = gpio[0];
    // io1
    assign gpio[1] = (gpio_ctrl[3:2] == 2'b01)? gpio_data[1]: 1'bz;
    assign io_in[1] = gpio[1];
    // io2~15
    assign gpio[2] = (gpio_ctrl[5:4] == 2'b01)? gpio_data[2]: 1'bz;
    assign io_in[2] = gpio[2];
    assign gpio[3] = (gpio_ctrl[7:6] == 2'b01)? gpio_data[3]: 1'bz;
    assign io_in[3] = gpio[3];
    assign gpio[4] = (gpio_ctrl[9:8] == 2'b01)? gpio_data[4]: 1'bz;
    assign io_in[4] = gpio[4];
    assign gpio[5] = (gpio_ctrl[11:10] == 2'b01)? gpio_data[5]: 1'bz;
    assign io_in[5] = gpio[5];
    assign gpio[6] = (gpio_ctrl[13:12] == 2'b01)? gpio_data[6]: 1'bz;
    assign io_in[6] = gpio[6];
    assign gpio[7] = (gpio_ctrl[15:14] == 2'b01)? gpio_data[7]: 1'bz;
    assign io_in[7] = gpio[7];
    assign gpio[8] = (gpio_ctrl[17:16] == 2'b01)? gpio_data[8]: 1'bz;
    assign io_in[8] = gpio[8];
    assign gpio[9] = (gpio_ctrl[19:18] == 2'b01)? gpio_data[9]: 1'bz;
    assign io_in[9] = gpio[9];
    assign gpio[10] = (gpio_ctrl[21:20] == 2'b01)? gpio_data[10]: 1'bz;
    assign io_in[10] = gpio[10];
    assign gpio[11] = (gpio_ctrl[23:22] == 2'b01)? gpio_data[11]: 1'bz;
    assign io_in[11] = gpio[11];
    assign gpio[12] = (gpio_ctrl[25:24] == 2'b01)? gpio_data[12]: 1'bz;
    assign io_in[12] = gpio[12];
    assign gpio[13] = (gpio_ctrl[27:26] == 2'b01)? gpio_data[13]: 1'bz;
    assign io_in[13] = gpio[13];
    assign gpio[14] = (gpio_ctrl[29:28] == 2'b01)? gpio_data[14]: 1'bz;
    assign io_in[14] = gpio[14];
    assign gpio[15] = (gpio_ctrl[31:30] == 2'b01)? gpio_data[15]: 1'bz;
    assign io_in[15] = gpio[15];

    // gpio模块例化
    gpio gpio_0(
        .clk(clk),
        .rst(rst),
        .we_i(s4_we_o),
        .addr_i(s4_addr_o),
        .data_i(s4_data_o),
        .data_o(s4_data_i),
        .io_pin_i(io_in),
        .reg_ctrl(gpio_ctrl),
        .reg_data(gpio_data)
    );

    // spi模块例化
    spi spi_0(
        .clk(clk),
        .rst(rst),
        .data_i(s5_data_o),
        .addr_i(s5_addr_o),
        .we_i(s5_we_o),
        .data_o(s5_data_i),
        .spi_mosi(spi_mosi),
        .spi_miso(spi_miso),
        .spi_ss(spi_ss),
        .spi_clk(spi_clk)
    );

    // pwm模块例化
    pwm pwm_0(
        .clk(clk),
        .rst(rst),
        .data_i(s6_data_o),
        .addr_i(s6_addr_o),
        .we_i(s6_we_o),
        .data_o(s6_data_i),
        .pwm_o(pwm_o)
    );

    // i2c模块例化
    i2c i2c_0(
        .clk(clk),
        .rst_n(rst),
        .data_i(s7_data_o),
        .addr_i(s7_addr_o),
        .we_i(s7_we_o),
        .data_o(s7_data_i),
        .scl(io_scl),
        .sda(io_sda),
        .read_data_ready_o(s7_ack_i),
        .req_i(s7_req_o)
    );

    // rib 模块例化
    rib u_rib(
        // master 0 interface
        .m0_addr_i(m0_addr_i),
        .m0_data_i(m0_data_i),
        .m0_data_o(m0_data_o),
        .m0_req_i(m0_req_i),
        .m0_we_i(m0_we_i),
        .m0_ready_o(m0_ack_o),

        // master 1 interface
        .m1_addr_i(m1_addr_i),
        .m1_data_i(`ZeroWord),
        .m1_data_o(m1_data_o),
        .m1_req_i(`RIB_REQ),
        .m1_we_i(`WriteDisable),
        .m1_ready_o(m1_ready),

        // master 2 interface
        .m2_addr_i(m2_addr_i),
        .m2_data_i(m2_data_i),
        .m2_data_o(m2_data_o),
        .m2_req_i(m2_req_i),
        .m2_we_i(m2_we_i),

        // master 3 interface
        .m3_addr_i(m3_addr_i),
        .m3_data_i(m3_data_i),
        .m3_data_o(m3_data_o),
        .m3_req_i(m3_req_i),
        .m3_we_i(m3_we_i),

        // slave 0 interface
        .s0_addr_o(s0_addr_o),
        .s0_data_o(s0_data_o),
        .s0_data_i(s0_data_i),
        .s0_we_o(s0_we_o),

        // slave 1 interface
        .s1_addr_o(s1_addr_o),
        .s1_data_o(s1_data_o),
        .s1_data_i(s1_data_i),
        .s1_we_o(s1_we_o),

        // slave 2 interface
        .s2_addr_o(s2_addr_o),
        .s2_data_o(s2_data_o),
        .s2_data_i(s2_data_i),
        .s2_we_o(s2_we_o),

        // slave 3 interface
        .s3_addr_o(s3_addr_o),
        .s3_data_o(s3_data_o),
        .s3_data_i(s3_data_i),
        .s3_we_o(s3_we_o),
        .s3_ready_i(1'b1),
        .s3_req_o(),

        // slave 4 interface
        .s4_addr_o(s4_addr_o),
        .s4_data_o(s4_data_o),
        .s4_data_i(s4_data_i),
        .s4_we_o(s4_we_o),

        // slave 5 interface
        .s5_addr_o(s5_addr_o),
        .s5_data_o(s5_data_o),
        .s5_data_i(s5_data_i),
        .s5_we_o(s5_we_o),

        // slave 6 interface
        .s6_addr_o(s6_addr_o),
        .s6_data_o(s6_data_o),
        .s6_data_i(s6_data_i),
        .s6_we_o(s6_we_o),
        .s6_ready_i(1'b1),
        .s6_req_o(),

        // slave 7 interface
        .s7_addr_o(s7_addr_o),
        .s7_data_o(s7_data_o),
        .s7_data_i(s7_data_i),
        .s7_we_o(s7_we_o),
        .s7_req_o(s7_req_o),
        .s7_ready_i(s7_ack_i),

        .hold_flag_o(rib_hold_flag_o)
    );

    // 串口下载模块例化
    uart_debug u_uart_debug(
        .clk(clk),
        .rst(rst),
        .debug_en_i(uart_debug_pin),
        .req_o(m3_req_i),
        .mem_we_o(m3_we_i),
        .mem_addr_o(m3_addr_i),
        .mem_wdata_o(m3_data_i),
        .mem_rdata_i(m3_data_o)
    );

    // jtag模块例化
    jtag_top #(
        .DMI_ADDR_BITS(6),
        .DMI_DATA_BITS(32),
        .DMI_OP_BITS(2)
    ) u_jtag_top(
        .clk(clk),
        .jtag_rst_n(rst),
        .jtag_pin_TCK(jtag_TCK),
        .jtag_pin_TMS(jtag_TMS),
        .jtag_pin_TDI(jtag_TDI),
        .jtag_pin_TDO(jtag_TDO),
        .reg_we_o(jtag_reg_we_o),
        .reg_addr_o(jtag_reg_addr_o),
        .reg_wdata_o(jtag_reg_data_o),
        .reg_rdata_i(jtag_reg_data_i),
        .mem_we_o(m2_we_i),
        .mem_addr_o(m2_addr_i),
        .mem_wdata_o(m2_data_i),
        .mem_rdata_i(m2_data_o),
        .op_req_o(m2_req_i),
        .halt_req_o(jtag_halt_req_o),
        .reset_req_o(jtag_reset_req_o)
    );

endmodule
