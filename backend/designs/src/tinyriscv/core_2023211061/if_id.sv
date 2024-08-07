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

// 将指令向译码模块传递
module if_id_yw
    import tinyriscv_pkg::*;
(

    input clk_i ,
    input rst_ni,

    input [    InstBus - 1:0] inst_i,           // 指令内容
    input [InstAddrBus - 1:0] inst_addr_i,      // 指令地址
    input inst_addr_next_type_i, // 下一指令地址

    input [Hold_Flag_Bus - 1:0] hold_flag_i,  // 流水线暂停标志

    input        [INT_BUS - 1:0] int_flag_i,  // 外设中断输入信号
    output logic [INT_BUS - 1:0] int_flag_o,

    output logic [    InstBus - 1:0] inst_o,           // 指令内容
    output logic [InstAddrBus - 1:0] inst_addr_o,      // 指令地址
    output logic inst_addr_next_type_o, // 下一指令地址

    input        instr_ready_i,
    output logic instr_req_o,

    input        ready_from_id_ex_i,
    output logic valid_to_id_ex_o
);

    logic clear;
    logic full;
    logic empty;

    assign clear            = hold_flag_i == Pipe_Clear;
    assign instr_req_o      = ~full;
    assign valid_to_id_ex_o = ~empty;


    fifo_v3 #(
        .FALL_THROUGH(1'b1),
        .DATA_WIDTH  (73),
        .DEPTH       (1)
    ) if_id_fifo (
        .clk_i,
        .rst_ni,

        .flush_i   (clear),
        .testmode_i(),

        .full_o (full),
        .empty_o(empty),
        .usage_o(),

        .data_i({inst_i, inst_addr_i, inst_addr_next_type_i, int_flag_i}),
        .push_i(instr_req_o & instr_ready_i),

        .data_o({inst_o, inst_addr_o, inst_addr_next_type_o, int_flag_o}),
        .pop_i (ready_from_id_ex_i & valid_to_id_ex_o)
    );
endmodule
