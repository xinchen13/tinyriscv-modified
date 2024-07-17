/*
 Copyright 2019 Blue Liang, liangkangnan@163.com

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

// 通用寄存器模块
module regs_yw
    import tinyriscv_pkg::*;
(

    input clk_i,
    input rst_ni,

    // from ex
    input                    we_i,     // 写寄存器标志
    input [RegAddrBus - 1:0] waddr_i,  // 写寄存器地址
    input [    RegBus - 1:0] wdata_i,  // 写寄存器数据

    // from jtag
    input                    jtag_we_i,    // 写寄存器标志
    input [RegAddrBus - 1:0] jtag_addr_i,  // 读、写寄存器地址
    input [    RegBus - 1:0] jtag_data_i,  // 写寄存器数据

    // from id
    input [RegAddrBus - 1:0] raddr1_i,  // 读寄存器1地址

    // to id
    output logic [RegBus - 1:0] rdata1_o,  // 读寄存器1数据

    // from id
    input [RegAddrBus - 1:0] raddr2_i,  // 读寄存器2地址

    // to id
    output logic [RegBus - 1:0] rdata2_o,  // 读寄存器2数据

    // to jtag
    output logic [RegBus - 1:0] jtag_data_o,  // 读寄存器数据

    output logic succ,
    output logic over
);
    integer i;
    logic [RegBus - 1:0] regs[RegNum];

    always_comb begin : judgesignal
        succ = ~regs[27][0];
        over = ~regs[26][0];
    end : judgesignal

    // 写寄存器
    always_ff @(posedge clk_i) begin
        if (rst_ni == ~RstEnable) begin
            // 优先ex模块写操作
            if ((we_i == WriteEnable) && (waddr_i != '0)) begin
                regs[waddr_i] <= wdata_i;
            end
            else if ((jtag_we_i == WriteEnable) && (jtag_addr_i != '0)) begin
                regs[jtag_addr_i] <= jtag_data_i;
            end
        end
        else
            for (i = 0; i < 32; i = i + 1) begin
                regs[i] <= 32'h0;
            end
    end

    // 读寄存器1
    always_comb begin
        if (raddr1_i == '0) begin
            rdata1_o = '0;
            // 如果读地址等于写地址，并且正在写操作，则直接返回写数据
        end
        else if (raddr1_i == waddr_i && we_i == WriteEnable) begin
            rdata1_o = wdata_i;
        end
        else begin
            rdata1_o = regs[raddr1_i];
        end
    end

    // 读寄存器2
    always_comb begin
        if (raddr2_i == '0) begin
            rdata2_o = '0;
            // 如果读地址等于写地址，并且正在写操作，则直接返回写数据
        end
        else if (raddr2_i == waddr_i && we_i == WriteEnable) begin
            rdata2_o = wdata_i;
        end
        else begin
            rdata2_o = regs[raddr2_i];
        end
    end

    // jtag读寄存器
    always_comb begin
        if (jtag_addr_i == '0) begin
            jtag_data_o = '0;
        end
        else begin
            jtag_data_o = regs[jtag_addr_i];
        end
    end

endmodule
