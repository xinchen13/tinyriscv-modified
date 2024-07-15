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
// PC寄存器模块
module pc_reg
    import tinyriscv_pkg::*;
(

    input clk_i,
    input rst_ni,

    input                     jump_flag_i,       // 跳转标志
    input [InstAddrBus - 1:0] jump_addr_i,       // 跳转地址
    input                     jtag_reset_flag_i, // 复位标志

    input ready_i,
    input req_i,

    output logic [InstAddrBus - 1:0] pc_o,      // PC指针
    output logic [InstAddrBus - 1:0] pc_next_o
);

    assign pc_next_o = pc_o + 32'h4;

    always_ff @(posedge clk_i)
        if (rst_ni == RstEnable || jtag_reset_flag_i == 1'b1) pc_o <= CpuResetAddr;  // 复位
        else if (jump_flag_i == JumpEnable) pc_o <= jump_addr_i;  // 跳转
        else if (ready_i & req_i) pc_o <= pc_next_o;  // 地址加4
        else pc_o <= pc_o;  // 暂停

endmodule
