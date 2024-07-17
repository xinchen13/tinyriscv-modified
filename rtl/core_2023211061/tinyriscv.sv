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
// tinyriscv处理器核顶层模块
module tinyriscv_yw
    import tinyriscv_pkg::*;
(

    input clk_i,
    input rst_ni,

    output logic [MemAddrBus - 1:0] rib_ex_addr_o,   // 读、写外设的地址
    input        [    MemBus - 1:0] rib_ex_data_i,   // 从外设读取的数据
    output logic [    MemBus - 1:0] rib_ex_data_o,   // 写入外设的数据
    output logic                    rib_ex_req_o,    // 访问外设请求
    input  logic                    rib_ex_ready_i,
    output logic                    rib_ex_we_o,     // 写外设标志

    output logic [MemAddrBus - 1:0] rib_pc_addr_o,  // 取指地址
    input        [    MemBus - 1:0] rib_pc_data_i,  // 取到的指令内容
    input                           rib_pc_ready_i,

    input        [RegAddrBus - 1:0] jtag_reg_addr_i,  // jtag模块读、写寄存器的地址
    input        [    RegBus - 1:0] jtag_reg_data_i,  // jtag模块写寄存器数据
    input                           jtag_reg_we_i,    // jtag模块写寄存器标志
    output logic [    RegBus - 1:0] jtag_reg_data_o,  // jtag模块读取到的寄存器数据

    input rib_hold_flag_i,   // 总线暂停标志
    input jtag_halt_flag_i,  // jtag暂停标志
    input jtag_reset_flag_i, // jtag复位PC标志

    input [INT_BUS - 1:0] int_i,  // 中断信号


    output succ,
    output over
);

    // pc_reg模块输出信号
    wire [  InstAddrBus - 1:0] pc_real;
    wire [  InstAddrBus - 1:0] pc_next_f2d;
    wire [  InstAddrBus - 1:0] pc_next_d2e;
    wire [  InstAddrBus - 1:0] pc_next_e;

    wire [      InstBus - 1:0] if_instr;
    wire                       instr_valid;
    wire                       rib_pc_req;

    // if_id模块输出信号
    wire [      InstBus - 1:0] if_inst_o;
    wire [  InstAddrBus - 1:0] if_inst_addr_o;
    wire [      INT_BUS - 1:0] if_int_flag_o;
    wire                       valid_if_id;

    // id模块输出信号
    wire [   RegAddrBus - 1:0] id_reg1_raddr_o;
    wire [   RegAddrBus - 1:0] id_reg2_raddr_o;
    wire [      InstBus - 1:0] id_inst_o;
    wire [  InstAddrBus - 1:0] id_inst_addr_o;
    wire [       RegBus - 1:0] id_reg1_rdata_o;
    wire [       RegBus - 1:0] id_reg2_rdata_o;
    wire                       id_reg_we_o;
    wire [   RegAddrBus - 1:0] id_reg_waddr_o;
    wire [   MemAddrBus - 1:0] id_csr_raddr_o;
    wire                       id_csr_we_o;
    wire [       RegBus - 1:0] id_csr_rdata_o;
    wire [   MemAddrBus - 1:0] id_csr_waddr_o;
    wire [   MemAddrBus - 1:0] id_op1_o;
    wire [   MemAddrBus - 1:0] id_op2_o;
    wire [   MemAddrBus - 1:0] id_op1_jump_o;
    wire [   MemAddrBus - 1:0] id_op2_jump_o;
    wire [                2:0] compare;
    wire [                2:0] compare_e;

    // id_ex模块输出信号
    wire [      InstBus - 1:0] ie_inst_o;
    wire [  InstAddrBus - 1:0] ie_inst_addr_o;
    wire                       ie_reg_we_o;
    wire [   RegAddrBus - 1:0] ie_reg_waddr_o;
    wire [       RegBus - 1:0] ie_reg1_rdata_o;
    wire [       RegBus - 1:0] ie_reg2_rdata_o;
    wire                       ie_csr_we_o;
    wire [   MemAddrBus - 1:0] ie_csr_waddr_o;
    wire [       RegBus - 1:0] ie_csr_rdata_o;
    wire [   MemAddrBus - 1:0] ie_op1_o;
    wire [   MemAddrBus - 1:0] ie_op2_o;
    wire [   MemAddrBus - 1:0] ie_op1_jump_o;
    wire [   MemAddrBus - 1:0] ie_op2_jump_o;
    wire [       RegBus - 1:0] store_data_i;
    wire [       RegBus - 1:0] store_data_o;
    wire                       ready_id_ex;
    // ex模块输出信号
    wire [       MemBus - 1:0] ex_mem_wdata_o;
    wire [   MemAddrBus - 1:0] ex_mem_addr_o;
    wire                       ex_mem_we_o;
    wire                       ex_mem_req_o;
    wire                       ex_mem_ready_i;
    wire [       RegBus - 1:0] ex_reg_wdata_o;
    wire                       ex_reg_we_o;
    wire [   RegAddrBus - 1:0] ex_reg_waddr_o;
    wire                       ex_hold_flag_o;
    wire                       ex_jump_flag_o;
    wire [  InstAddrBus - 1:0] ex_jump_addr_o;
    wire                       ex_div_start_o;
    wire [       RegBus - 1:0] ex_div_dividend_o;
    wire [       RegBus - 1:0] ex_div_divisor_o;
    wire [                2:0] ex_div_op_o;
    wire [   RegAddrBus - 1:0] ex_div_reg_waddr_o;
    wire [       RegBus - 1:0] ex_csr_wdata_o;
    wire                       ex_csr_we_o;
    wire [   MemAddrBus - 1:0] ex_csr_waddr_o;
    wire                       ex_ready;

    // regs模块输出信号
    wire [       RegBus - 1:0] regs_rdata1_o;
    wire [       RegBus - 1:0] regs_rdata2_o;

    // csr_reg模块输出信号
    wire [       RegBus - 1:0] csr_data_o;
    wire [       RegBus - 1:0] csr_clint_data_o;
    wire                       csr_global_int_en_o;
    wire [       RegBus - 1:0] csr_clint_csr_mtvec;
    wire [       RegBus - 1:0] csr_clint_csr_mepc;
    wire [       RegBus - 1:0] csr_clint_csr_mstatus;

    // ctrl模块输出信号
    wire [Hold_Flag_Bus - 1:0] ctrl_hold_flag_o;
    wire                       ctrl_jump_flag_o;
    wire [  InstAddrBus - 1:0] ctrl_jump_addr_o;

    // div模块输出信号
    wire [       RegBus - 1:0] div_result_o;
    wire                       div_ready_o;
    wire                       div_busy_o;
    wire [   RegAddrBus - 1:0] div_reg_waddr_o;

    // clint模块输出信号
    wire                       clint_we_o;
    wire [   MemAddrBus - 1:0] clint_waddr_o;
    wire [   MemAddrBus - 1:0] clint_raddr_o;
    wire [       RegBus - 1:0] clint_data_o;
    wire [  InstAddrBus - 1:0] clint_int_addr_o;
    wire                       clint_int_assert_o;
    wire                       clint_hold_flag_o;


    assign rib_ex_addr_o  = ex_mem_addr_o;
    assign rib_ex_data_o  = ex_mem_wdata_o;
    assign rib_ex_req_o   = ex_mem_req_o;
    assign rib_ex_we_o    = ex_mem_we_o;
    assign ex_mem_ready_i = rib_ex_ready_i;

    instr_fetch_yw instr_f (
        .clk_i,
        .rst_ni,

        .instr_ready_i(rib_pc_ready_i),
        .instr_req_i  (rib_pc_req),

        .jump_flag_i      (ctrl_jump_flag_o),
        .jump_addr_i      (ctrl_jump_addr_o),
        .jtag_reset_flag_i(jtag_reset_flag_i),
        .instr_i          (rib_pc_data_i),

        .instr_o      (if_instr),
        .instr_valid_o(instr_valid),

        .pc_o     (rib_pc_addr_o),  // PC指针
        .pc_real  (pc_real),
        .pc_next_o(pc_next_f2d)
    );

    // ctrl模块例化
    ctrl_yw u_ctrl (
        .jump_flag_i      (ex_jump_flag_o),
        .jump_addr_i      (ex_jump_addr_o),
        .hold_flag_ex_i   (ex_hold_flag_o),
        .hold_flag_rib_i  (rib_hold_flag_i),
        .hold_flag_o      (ctrl_hold_flag_o),
        .hold_flag_clint_i(clint_hold_flag_o),
        .jump_flag_o      (ctrl_jump_flag_o),
        .jump_addr_o      (ctrl_jump_addr_o),
        .jtag_halt_flag_i (jtag_halt_flag_i)
    );

    // regs模块例化
    regs_yw u_regs (
        .clk_i,
        .rst_ni,
        .we_i       (ex_reg_we_o),
        .waddr_i    (ex_reg_waddr_o),
        .wdata_i    (ex_reg_wdata_o),
        .raddr1_i   (id_reg1_raddr_o),
        .rdata1_o   (regs_rdata1_o),
        .raddr2_i   (id_reg2_raddr_o),
        .rdata2_o   (regs_rdata2_o),
        .jtag_we_i  (jtag_reg_we_i),
        .jtag_addr_i(jtag_reg_addr_i),
        .jtag_data_i(jtag_reg_data_i),
        .jtag_data_o(jtag_reg_data_o),

        .succ,
        .over
    );

    // csr_reg模块例化
    csr_reg_yw u_csr_reg (
        .clk_i,
        .rst_ni,
        .we_i             (ex_csr_we_o),
        .raddr_i          (id_csr_raddr_o),
        .waddr_i          (ex_csr_waddr_o),
        .data_i           (ex_csr_wdata_o),
        .data_o           (csr_data_o),
        .global_int_en_o  (csr_global_int_en_o),
        .clint_we_i       (clint_we_o),
        .clint_raddr_i    (clint_raddr_o),
        .clint_waddr_i    (clint_waddr_o),
        .clint_data_i     (clint_data_o),
        .clint_data_o     (csr_clint_data_o),
        .clint_csr_mtvec  (csr_clint_csr_mtvec),
        .clint_csr_mepc   (csr_clint_csr_mepc),
        .clint_csr_mstatus(csr_clint_csr_mstatus)
    );

    // if_id模块例化
    if_id_yw u_if_id (
        .clk_i (clk_i),
        .rst_ni(rst_ni),

        .ready_from_id_ex_i(ready_id_ex),

        .instr_req_o     (rib_pc_req),
        .instr_ready_i   (instr_valid),
        .valid_to_id_ex_o(valid_if_id),

        .inst_i          (if_instr),
        .inst_addr_i     (pc_real),
        .inst_addr_next_i(pc_next_f2d),
        .inst_addr_next_o(pc_next_d2e),
        .int_flag_i      (int_i),
        .int_flag_o      (if_int_flag_o),
        .hold_flag_i     (ctrl_hold_flag_o),
        .inst_o          (if_inst_o),
        .inst_addr_o     (if_inst_addr_o)
    );

    // id模块例化
    id_yw u_id (
        .inst_i        (if_inst_o),
        .inst_addr_i   (if_inst_addr_o),
        .reg1_rdata_i  (regs_rdata1_o),
        .reg2_rdata_i  (regs_rdata2_o),
        .ex_jump_flag_i(ex_jump_flag_o),
        .reg1_raddr_o  (id_reg1_raddr_o),
        .reg2_raddr_o  (id_reg2_raddr_o),
        .inst_o        (id_inst_o),
        .inst_addr_o   (id_inst_addr_o),
        .reg_we_o      (id_reg_we_o),
        .reg_waddr_o   (id_reg_waddr_o),
        .op1_o         (id_op1_o),
        .op2_o         (id_op2_o),
        .csr_rdata_i   (csr_data_o),
        .csr_raddr_o   (id_csr_raddr_o),
        .csr_we_o      (id_csr_we_o),
        .csr_rdata_o   (id_csr_rdata_o),
        .csr_waddr_o   (id_csr_waddr_o),
        .compare_o     (compare),
        .store_data_o  (store_data_i)
    );

    // id_ex模块例化
    id_ex_yw u_id_ex (
        .clk_i,
        .rst_ni,

        .ready_id_ex_o(ready_id_ex),
        .ready_ex_i   (ex_ready),
        .valid_if_id_i(valid_if_id),

        .inst_i          (id_inst_o),
        .inst_addr_i     (id_inst_addr_o),
        .reg_we_i        (id_reg_we_o),
        .reg_waddr_i     (id_reg_waddr_o),
        .hold_flag_i     (ctrl_hold_flag_o),
        .inst_addr_next_i(pc_next_d2e),
        .inst_addr_next_o(pc_next_e),
        .inst_o          (ie_inst_o),
        .inst_addr_o     (ie_inst_addr_o),
        .reg_we_o        (ie_reg_we_o),
        .reg_waddr_o     (ie_reg_waddr_o),
        .op1_i           (id_op1_o),
        .op2_i           (id_op2_o),
        .op1_o           (ie_op1_o),
        .op2_o           (ie_op2_o),
        .csr_we_i        (id_csr_we_o),
        .csr_waddr_i     (id_csr_waddr_o),
        .csr_rdata_i     (id_csr_rdata_o),
        .csr_we_o        (ie_csr_we_o),
        .csr_waddr_o     (ie_csr_waddr_o),
        .csr_rdata_o     (ie_csr_rdata_o),
        .compare_i       (compare),
        .compare_o       (compare_e),
        .store_data_i,
        .store_data_o
    );

    // ex模块例化
    ex_yw u_ex (
        .clk_i,
        .rst_ni,

        .ready_o(ex_ready),

        .inst_i          (ie_inst_o),
        .inst_addr_i     (ie_inst_addr_o),
        .inst_addr_next_i(pc_next_e),
        .reg_we_i        (ie_reg_we_o),
        .reg_waddr_i     (ie_reg_waddr_o),
        .compare_i       (compare_e),

        .op1_i(ie_op1_o),
        .op2_i(ie_op2_o),

        .mem_rdata_i(rib_ex_data_i),
        .mem_wdata_o(ex_mem_wdata_o),
        .mem_addr_o (ex_mem_addr_o),
        .mem_we_o   (ex_mem_we_o),
        .mem_req_o  (ex_mem_req_o),
        .mem_ready_i(ex_mem_ready_i),

        .reg_wdata_o(ex_reg_wdata_o),
        .reg_we_o   (ex_reg_we_o),
        .reg_waddr_o(ex_reg_waddr_o),

        .jump_flag_o (ex_jump_flag_o),
        .jump_addr_o (ex_jump_addr_o),
        .int_assert_i(clint_int_assert_o),
        .int_addr_i  (clint_int_addr_o),
        .csr_we_i    (ie_csr_we_o),
        .csr_waddr_i (ie_csr_waddr_o),
        .csr_rdata_i (ie_csr_rdata_o),
        .csr_wdata_o (ex_csr_wdata_o),
        .csr_we_o    (ex_csr_we_o),
        .csr_waddr_o (ex_csr_waddr_o),
        .store_data_i(store_data_o)
    );

    // clint模块例化
    clint_yw u_clint (
        .clk_i          (clk_i),
        .rst_ni         (rst_ni),
        .int_flag_i     (if_int_flag_o),
        .inst_i         (id_inst_o),
        .inst_addr_i    (id_inst_addr_o),
        .jump_flag_i    (ex_jump_flag_o),
        .jump_addr_i    (ex_jump_addr_o),
        .hold_flag_i    (ctrl_hold_flag_o),
        .div_started_i  (ex_div_start_o),
        .data_i         (csr_clint_data_o),
        .csr_mtvec      (csr_clint_csr_mtvec),
        .csr_mepc       (csr_clint_csr_mepc),
        .csr_mstatus    (csr_clint_csr_mstatus),
        .we_o           (clint_we_o),
        .waddr_o        (clint_waddr_o),
        .raddr_o        (clint_raddr_o),
        .data_o         (clint_data_o),
        .hold_flag_o    (clint_hold_flag_o),
        .global_int_en_i(csr_global_int_en_o),
        .int_addr_o     (clint_int_addr_o),
        .int_assert_o   (clint_int_assert_o)
    );

endmodule
