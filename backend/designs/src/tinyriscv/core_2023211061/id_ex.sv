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

// 将译码结果向执行模块传递
module id_ex_yw
    import tinyriscv_pkg::*;
(

    input clk_i,
    input rst_ni,

    input ready_ex_i,
    input valid_if_id_i,

    input [    InstBus - 1:0] inst_i,                 // 指令内容
    input [InstAddrBus - 1:0] inst_addr_i,            // 指令地址
    input                     inst_addr_next_type_i,  // 指令地址
    input                     reg_we_i,               // 写通用寄存器标志
    input [ RegAddrBus - 1:0] reg_waddr_i,            // 写通用寄存器地址
    input                     csr_we_i,               // 写CSR寄存器标志
    input [ MemAddrBus - 1:0] csr_waddr_i,            // 写CSR寄存器地址
    input [     RegBus - 1:0] csr_rdata_i,            // CSR寄存器读数据
    input [ MemAddrBus - 1:0] op1_i,
    input [ MemAddrBus - 1:0] op2_i,
    input [     RegBus - 1:0] reg1_rdata_i,
    input [     RegBus - 1:0] reg2_rdata_i,
    input [     RegBus - 1:0] store_data_i,

    input [Hold_Flag_Bus - 1:0] hold_flag_i,  // 流水线暂停标志

    output logic [ MemAddrBus - 1:0] op1_o,
    output logic [ MemAddrBus - 1:0] op2_o,
    output       [     RegBus - 1:0] reg1_rdata_o,
    output       [     RegBus - 1:0] reg2_rdata_o,
    output logic [    InstBus - 1:0] inst_o,                 // 指令内容
    output logic [InstAddrBus - 1:0] inst_addr_o,            // 指令地址
    output logic                     inst_addr_next_type_o,  // 指令地址
    output logic                     reg_we_o,               // 写通用寄存器标志
    output logic [ RegAddrBus - 1:0] reg_waddr_o,            // 写通用寄存器地址
    output logic                     csr_we_o,               // 写CSR寄存器标志
    output logic [ MemAddrBus - 1:0] csr_waddr_o,            // 写CSR寄存器地址
    output logic [     RegBus - 1:0] csr_rdata_o,            // CSR寄存器读数据
    output logic [     RegBus - 1:0] store_data_o,

    output logic ready_id_ex_o
);

    logic en;
    logic clear;
    assign clear         = hold_flag_i == Pipe_Clear || ready_ex_i & ~valid_if_id_i;
    assign en            = (ready_ex_i & valid_if_id_i);
    assign ready_id_ex_o = ready_ex_i;

    logic [InstBus - 1:0] inst;
    gen_en_dff #(32, INST_NOP) inst_ff (
        .clk_i,
        .rst_ni(~clear & rst_ni),
        .en,
        .din   (inst_i),
        .qout  (inst)
    );
    assign inst_o = inst;

    logic [InstAddrBus - 1:0] inst_addr;
    gen_en_dff #(32, 0) inst_addr_ff (
        .clk_i,
        .rst_ni(~clear & rst_ni),
        .en,
        .din   (inst_addr_i),
        .qout  (inst_addr)
    );
    assign inst_addr_o = inst_addr;

    logic inst_addr_next_type;
    gen_en_dff #(1, 0) inst_addr_next_type_ff (
        .clk_i,
        .rst_ni(~clear & rst_ni),
        .en,
        .din   (inst_addr_next_type_i),
        .qout  (inst_addr_next_type)
    );
    assign inst_addr_next_type_o = inst_addr_next_type;

    logic reg_we;
    gen_en_dff #(1, 0) reg_we_ff (
        .clk_i,
        .rst_ni(~clear & rst_ni),
        .en,
        .din   (reg_we_i),
        .qout  (reg_we)
    );
    assign reg_we_o = reg_we;

    logic [RegAddrBus - 1:0] reg_waddr;
    gen_en_dff #(5, 0) reg_waddr_ff (
        .clk_i,
        .rst_ni(~clear & rst_ni),
        .en,
        .din   (reg_waddr_i),
        .qout  (reg_waddr)
    );
    assign reg_waddr_o = reg_waddr;

    logic csr_we;
    gen_en_dff #(1, 0) csr_we_ff (
        .clk_i,
        .rst_ni(~clear & rst_ni),
        .en,
        .din   (csr_we_i),
        .qout  (csr_we)
    );
    assign csr_we_o = csr_we;

    logic [MemAddrBus - 1:0] csr_waddr;
    gen_en_dff #(32, 0) csr_waddr_ff (
        .clk_i,
        .rst_ni(~clear & rst_ni),
        .en,
        .din   (csr_waddr_i),
        .qout  (csr_waddr)
    );
    assign csr_waddr_o = csr_waddr;

    logic [RegBus - 1:0] csr_rdata;
    gen_en_dff #(32, 0) csr_rdata_ff (
        .clk_i,
        .rst_ni(~clear & rst_ni),
        .en,
        .din   (csr_rdata_i),
        .qout  (csr_rdata)
    );
    assign csr_rdata_o = csr_rdata;

    logic [RegBus - 1:0] op1;
    gen_en_dff #(32, 0) op1_ff (
        .clk_i,
        .rst_ni(~clear & rst_ni),
        .en,
        .din   (op1_i),
        .qout  (op1)
    );
    assign op1_o = op1;

    logic [RegBus - 1:0] op2;
    gen_en_dff #(32, 0) op2_ff (
        .clk_i,
        .rst_ni(~clear & rst_ni),
        .en,
        .din   (op2_i),
        .qout  (op2)
    );
    assign op2_o = op2;

    logic [RegBus - 1:0] reg1_rdata;
    gen_en_dff #(32, 0) reg1_rdata_ff (
        .clk_i,
        .rst_ni(~clear & rst_ni),
        .en,
        .din   (reg1_rdata_i),
        .qout  (reg1_rdata)
    );
    assign reg1_rdata_o = reg1_rdata;

    logic [RegBus - 1:0] reg2_rdata;
    gen_en_dff #(32, 0) reg2_rdata_ff (
        .clk_i,
        .rst_ni(~clear & rst_ni),
        .en,
        .din   (reg2_rdata_i),
        .qout  (reg2_rdata)
    );
    assign reg2_rdata_o = reg2_rdata;

    logic [RegBus - 1:0] store_data;
    gen_en_dff #(RegBus, 0) store_data_ff (
        .clk_i,
        .rst_ni(~clear & rst_ni),
        .en,
        .din   (store_data_i),
        .qout  (store_data)
    );
    assign store_data_o = store_data;

endmodule
