`timescale 1 ns / 1 ps
`include "defines.vh"
`define TEST_PROG  1
`define CHIP_SEL 0

// testbench module
module tinyriscv_soc_tb;
    reg clk;
    reg rst;
    reg chip_sel;
    always #10 clk = ~clk;     // 50MHz

    wire[`RegBus] x3 = chip_sel ? tinyriscv_soc_top_0.u_tinyriscv.u_regs.regs[3] : ~tinyriscv_soc_top_0.u_tinyriscv_2023211063.u_regs_2023211063.regs[3];
    wire[`RegBus] x26 = chip_sel ? tinyriscv_soc_top_0.u_tinyriscv.u_regs.regs[26] : ~tinyriscv_soc_top_0.u_tinyriscv_2023211063.u_regs_2023211063.regs[26];
    wire[`RegBus] x27 = chip_sel ? tinyriscv_soc_top_0.u_tinyriscv.u_regs.regs[27] : ~tinyriscv_soc_top_0.u_tinyriscv_2023211063.u_regs_2023211063.regs[27];

    integer r;

    initial begin
        clk = 0;
        chip_sel = `CHIP_SEL;
        rst = `RstEnable;

        $display("test running...");
        #40
        rst = `RstDisable;
        #200

        `ifdef TEST_PROG
            wait(x26 == 32'b1)   // wait sim end, when x26 == 1
            #100
            if (x27 == 32'b1) begin
                $display("~~~~~~~~~~~~~~~~~~~ TEST_PASS ~~~~~~~~~~~~~~~~~~~");
                $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
                $display("~~~~~~~~~ #####     ##     ####    #### ~~~~~~~~~");
                $display("~~~~~~~~~ #    #   #  #   #       #     ~~~~~~~~~");
                $display("~~~~~~~~~ #    #  #    #   ####    #### ~~~~~~~~~");
                $display("~~~~~~~~~ #####   ######       #       #~~~~~~~~~");
                $display("~~~~~~~~~ #       #    #  #    #  #    #~~~~~~~~~");
                $display("~~~~~~~~~ #       #    #   ####    #### ~~~~~~~~~");
                $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
            end else begin
                $display("~~~~~~~~~~~~~~~~~~~ TEST_FAIL ~~~~~~~~~~~~~~~~~~~~");
                $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
                $display("~~~~~~~~~~######    ##       #    #     ~~~~~~~~~~");
                $display("~~~~~~~~~~#        #  #      #    #     ~~~~~~~~~~");
                $display("~~~~~~~~~~#####   #    #     #    #     ~~~~~~~~~~");
                $display("~~~~~~~~~~#       ######     #    #     ~~~~~~~~~~");
                $display("~~~~~~~~~~#       #    #     #    #     ~~~~~~~~~~");
                $display("~~~~~~~~~~#       #    #     #    ######~~~~~~~~~~");
                $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
                $display("fail testnum = %2d", x3);
                if (chip_sel == 1'b1) begin
                    for (r = 0; r < 32; r = r + 1)
                        $display("x%2d = 0x%x", r, tinyriscv_soc_top_0.u_tinyriscv.u_regs.regs[r]);
                end else begin
                    for (r = 0; r < 32; r = r + 1)
                        $display("x%2d = 0x%x", r, tinyriscv_soc_top_0.u_tinyriscv_2023211063.u_regs_2023211063.regs[r]);
                end
            end
        `endif
        $finish;
    end

    // sim timeout
    initial begin
        #1000000
        $display("Time Out.");
        $finish;
    end

    // read mem data
    initial begin
        $readmemh ("inst.data", tinyriscv_soc_top_0.u_rom._rom);
    end

    //dump fsdb
	initial begin
        $fsdbDumpfile("tinyriscv_soc.fsdb");
        $fsdbDumpvars(0, tinyriscv_soc_tb);
        $fsdbDumpon;
	end

    tinyriscv_soc_top tinyriscv_soc_top_0(
        .clk(clk),
        .rst(rst),
        .uart_debug_pin(1'b0),
        .chip_sel(chip_sel)
    );

endmodule
