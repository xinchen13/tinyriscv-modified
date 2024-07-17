
module tinyriscv_io_top (
    input wire clk,
    input wire rst,

    output wire over,         // 测试是否完成信号
    output wire succ,         // 测试是否成功信号

    output wire halted_ind,  // jtag是否已经halt住CPU信号

    input wire baud_update_en,
    input wire uart_debug_pin, // 串口下载使能引脚

    output wire uart_tx_pin, // UART发送引脚
    input wire uart_rx_pin,  // UART接收引脚

    inout wire[15:0] gpio,    // GPIO引脚
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
    output wire spi_clk,     // SPI CLK引脚
	
	input wire	chip_sel
);

	wire	clk_core, rst_core, over_core, succ_core, halted_ind_core, uart_debug_pin_core;
	wire	uart_rx_pin_core, uart_tx_pin_core;
	wire	jtag_TCK_core, jtag_TMS_core, jtag_TDI_core, jtag_TDO_core;
	wire	spi_miso_core, spi_mosi_core, spi_ss_core, spi_clk_core;
	wire	[15:0]	gpio_out_core, gpio_in_core;
	wire	[31:0]	gpio_io_ctrl;
	reg		OEN_inout, IE_inout, DS_inout;

// Input Ports	
PDDW0204CDG 	mclk		(.OEN(1'b1),.I(1'b0),.PAD(clk),				.C(clk_core),				.DS(1'b0),.PE(1'b0),.IE(1'b1));
PDDW0204CDG 	mrst		(.OEN(1'b1),.I(1'b0),.PAD(rst),				.C(rst_core),				.DS(1'b0),.PE(1'b0),.IE(1'b1));
PDDW0204CDG 	muart_d		(.OEN(1'b1),.I(1'b0),.PAD(uart_debug_pin),	.C(uart_debug_pin_core),	.DS(1'b0),.PE(1'b0),.IE(1'b1));
PDDW0204CDG 	muart_rx	(.OEN(1'b1),.I(1'b0),.PAD(uart_rx_pin),		.C(uart_rx_pin_core),		.DS(1'b0),.PE(1'b0),.IE(1'b1));
PDDW0204CDG 	mjtag_TCK	(.OEN(1'b1),.I(1'b0),.PAD(jtag_TCK),		.C(jtag_TCK_core),			.DS(1'b0),.PE(1'b0),.IE(1'b1));
PDDW0204CDG 	mjtag_TMS	(.OEN(1'b1),.I(1'b0),.PAD(jtag_TMS),		.C(jtag_TMS_core),			.DS(1'b0),.PE(1'b0),.IE(1'b1));
PDDW0204CDG 	mjtag_TDI	(.OEN(1'b1),.I(1'b0),.PAD(jtag_TDI),		.C(jtag_TDI_core),			.DS(1'b0),.PE(1'b0),.IE(1'b1));
PDDW0204CDG 	mspi_miso	(.OEN(1'b1),.I(1'b0),.PAD(spi_miso),		.C(spi_miso_core),			.DS(1'b0),.PE(1'b0),.IE(1'b1));
PDDW0204CDG 	mchip_sel	(.OEN(1'b1),.I(1'b0),.PAD(chip_sel),		.C(chip_sel_core),			.DS(1'b0),.PE(1'b0),.IE(1'b1));

// Output Ports	
PDDW0204CDG 	mover		(.OEN(1'b0),.I(over_core),			.PAD(over),			.C(),.DS(1'b1),.PE(1'b0),.IE(1'b0));
PDDW0204CDG 	msucc		(.OEN(1'b0),.I(succ_core),			.PAD(succ),			.C(),.DS(1'b1),.PE(1'b0),.IE(1'b0));
PDDW0204CDG 	mhalt		(.OEN(1'b0),.I(halted_ind_core),	.PAD(halted_ind),	.C(),.DS(1'b1),.PE(1'b0),.IE(1'b0));
PDDW0204CDG 	muart_tx	(.OEN(1'b0),.I(uart_tx_pin_core),	.PAD(uart_tx_pin),	.C(),.DS(1'b1),.PE(1'b0),.IE(1'b0));
PDDW0204CDG 	mjtag_TDO	(.OEN(1'b0),.I(jtag_TDO_core),		.PAD(jtag_TDO),		.C(),.DS(1'b1),.PE(1'b0),.IE(1'b0));
PDDW0204CDG 	mspi_mosi	(.OEN(1'b0),.I(spi_mosi_core),		.PAD(spi_mosi),		.C(),.DS(1'b1),.PE(1'b0),.IE(1'b0));
PDDW0204CDG 	mspi_ss		(.OEN(1'b0),.I(spi_ss_core),		.PAD(spi_ss),		.C(),.DS(1'b1),.PE(1'b0),.IE(1'b0));
PDDW0204CDG 	mspi_clk	(.OEN(1'b0),.I(spi_clk_core),		.PAD(spi_clk),		.C(),.DS(1'b1),.PE(1'b0),.IE(1'b0));

// InOut Ports	
	always@ (*) begin
	case(gpio_io_ctrl)
		2'b00:	begin //高阻
				OEN_inout = 1;
				IE_inout  = 0;
				DS_inout  = 1;
				end
		2'b01:	begin //输出
				OEN_inout = 0;
				IE_inout  = 0;
				DS_inout  = 1;
				end
		2'b10:	begin //输入
				OEN_inout = 1;
				IE_inout  = 1;
				DS_inout  = 0;
				end
		2'b11:	begin //无效(高阻)
				OEN_inout = 1;
				IE_inout  = 0;
				DS_inout  = 1;
				end
	endcase
	end
PDDW0204CDG 	mgpio0 	(.OEN(OEN_inout), .I(gpio_out_core[0 ]), .PAD(gpio[0 ]), .C(gpio_in_core[0 ]),.DS(DS_inout),.PE(1'b0),.IE(IE_inout));
PDDW0204CDG 	mgpio1 	(.OEN(OEN_inout), .I(gpio_out_core[1 ]), .PAD(gpio[1 ]), .C(gpio_in_core[1 ]),.DS(DS_inout),.PE(1'b0),.IE(IE_inout));
PDDW0204CDG 	mgpio2 	(.OEN(OEN_inout), .I(gpio_out_core[2 ]), .PAD(gpio[2 ]), .C(gpio_in_core[2 ]),.DS(DS_inout),.PE(1'b0),.IE(IE_inout));
PDDW0204CDG 	mgpio3 	(.OEN(OEN_inout), .I(gpio_out_core[3 ]), .PAD(gpio[3 ]), .C(gpio_in_core[3 ]),.DS(DS_inout),.PE(1'b0),.IE(IE_inout));
PDDW0204CDG 	mgpio4 	(.OEN(OEN_inout), .I(gpio_out_core[4 ]), .PAD(gpio[4 ]), .C(gpio_in_core[4 ]),.DS(DS_inout),.PE(1'b0),.IE(IE_inout));
PDDW0204CDG 	mgpio5 	(.OEN(OEN_inout), .I(gpio_out_core[5 ]), .PAD(gpio[5 ]), .C(gpio_in_core[5 ]),.DS(DS_inout),.PE(1'b0),.IE(IE_inout));
PDDW0204CDG 	mgpio6 	(.OEN(OEN_inout), .I(gpio_out_core[6 ]), .PAD(gpio[6 ]), .C(gpio_in_core[6 ]),.DS(DS_inout),.PE(1'b0),.IE(IE_inout));
PDDW0204CDG 	mgpio7 	(.OEN(OEN_inout), .I(gpio_out_core[7 ]), .PAD(gpio[7 ]), .C(gpio_in_core[7 ]),.DS(DS_inout),.PE(1'b0),.IE(IE_inout));
PDDW0204CDG 	mgpio8 	(.OEN(OEN_inout), .I(gpio_out_core[8 ]), .PAD(gpio[8 ]), .C(gpio_in_core[8 ]),.DS(DS_inout),.PE(1'b0),.IE(IE_inout));
PDDW0204CDG 	mgpio9 	(.OEN(OEN_inout), .I(gpio_out_core[9 ]), .PAD(gpio[9 ]), .C(gpio_in_core[9 ]),.DS(DS_inout),.PE(1'b0),.IE(IE_inout));
PDDW0204CDG 	mgpioA 	(.OEN(OEN_inout), .I(gpio_out_core[10]), .PAD(gpio[10]), .C(gpio_in_core[10]),.DS(DS_inout),.PE(1'b0),.IE(IE_inout));
PDDW0204CDG 	mgpioB 	(.OEN(OEN_inout), .I(gpio_out_core[11]), .PAD(gpio[11]), .C(gpio_in_core[11]),.DS(DS_inout),.PE(1'b0),.IE(IE_inout));
PDDW0204CDG 	mgpioC 	(.OEN(OEN_inout), .I(gpio_out_core[12]), .PAD(gpio[12]), .C(gpio_in_core[12]),.DS(DS_inout),.PE(1'b0),.IE(IE_inout));
PDDW0204CDG 	mgpioD 	(.OEN(OEN_inout), .I(gpio_out_core[13]), .PAD(gpio[13]), .C(gpio_in_core[13]),.DS(DS_inout),.PE(1'b0),.IE(IE_inout));
PDDW0204CDG 	mgpioE 	(.OEN(OEN_inout), .I(gpio_out_core[14]), .PAD(gpio[14]), .C(gpio_in_core[14]),.DS(DS_inout),.PE(1'b0),.IE(IE_inout));
PDDW0204CDG 	mgpioF 	(.OEN(OEN_inout), .I(gpio_out_core[15]), .PAD(gpio[15]), .C(gpio_in_core[15]),.DS(DS_inout),.PE(1'b0),.IE(IE_inout));


tinyriscv_soc_top		tinyriscv(
    .clk(clk_core),
    .rst(rst_core),

    .over(over_core),         // 测试是否完成信号
    .succ(succ_core),         // 测试是否成功信号

    .halted_ind(halted_ind_core),  // jtag是否已经halt住CPU信号

    .uart_debug_pin(uart_debug_pin_core), // 串口下载使能引脚

    .uart_tx_pin(uart_tx_pin_core), // UART发送引脚
    .uart_rx_pin(uart_rx_pin_core),  // UART接收引脚
    .gpio_io_ctrl(gpio_io_ctrl),    // GPIO引脚控制，每2位控制1个IO的模式，0: 高阻，1：输出，2：输入
    .gpio_out(gpio_out_core),    // GPIO引脚输出数据
    .gpio_in(gpio_in_core),    // GPIO引脚输入数据

    .jtag_TCK(jtag_TCK_core),     // JTAG TCK引脚
    .jtag_TMS(jtag_TMS_core),     // JTAG TMS引脚
    .jtag_TDI(jtag_TDI_core),     // JTAG TDI引脚
    .jtag_TDO(jtag_TDO_core),    // JTAG TDO引脚

    .spi_miso(spi_miso_core),     // SPI MISO引脚
    .spi_mosi(spi_mosi_core),    // SPI MOSI引脚
    .spi_ss(spi_ss_core),      // SPI SS引脚
    .spi_clk(spi_clk_core),      // SPI CLK引脚
    
	.chip_sel(chip_sel_core)
);

endmodule