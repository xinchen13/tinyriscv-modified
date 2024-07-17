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
// 执行模块
// 纯组合逻辑电路
module ex_yw
    import tinyriscv_pkg::*;
(
    input clk_i,
    input rst_ni,

    // from id
    input [    InstBus - 1:0] inst_i,            // 指令内容
    input [InstAddrBus - 1:0] inst_addr_i,       // 指令地址
    input [InstAddrBus - 1:0] inst_addr_next_i,
    input                     reg_we_i,          // 是否写通用寄存器
    input [ RegAddrBus - 1:0] reg_waddr_i,       // 写通用寄存器地址
    input                     csr_we_i,          // 是否写CSR寄存器
    input [ MemAddrBus - 1:0] csr_waddr_i,       // 写CSR寄存器地址
    input [     RegBus - 1:0] csr_rdata_i,       // CSR寄存器输入数据
    input                     int_assert_i,      // 中断发生标志
    input [InstAddrBus - 1:0] int_addr_i,        // 中断跳转地址
    input [ MemAddrBus - 1:0] op1_i,
    input [ MemAddrBus - 1:0] op2_i,
    input [              2:0] compare_i,
    input [     RegBus - 1:0] store_data_i,

    // from mem
    input [MemBus - 1:0] mem_rdata_i,  // 内存输入数据

    // to mem
    output logic [    MemBus - 1:0] mem_wdata_o,  // 写内存数据
    output logic [MemAddrBus - 1:0] mem_addr_o,   // 读内存地址
    output logic                    mem_we_o,     // 是否要写内存
    output logic                    mem_req_o,    // 请求访问内存标志
    input  logic                    mem_ready_i,

    // to regs
    output logic [    RegBus - 1:0] reg_wdata_o,  // 写寄存器数据
    output logic                    reg_we_o,     // 是否要写通用寄存器
    output logic [RegAddrBus - 1:0] reg_waddr_o,  // 写通用寄存器地址

    // to csr logic
    output logic [    RegBus - 1:0] csr_wdata_o,  // 写CSR寄存器数据
    output logic                    csr_we_o,     // 是否要写CSR寄存器
    output logic [MemAddrBus - 1:0] csr_waddr_o,  // 写CSR寄存器地址

    // to ctrl
    output logic                     ready_o,      // 是否暂停标志
    output logic                     jump_flag_o,  // 是否跳转标志
    output logic [InstAddrBus - 1:0] jump_addr_o   // 跳转目的地址

);

    logic [1:0] mem_addr_index;
    logic [DoubleRegBus - 1:0] mul_temp;
    logic [DoubleRegBus - 1:0] mul_temp_invert;
    logic [31:0] sr_shift;
    logic [31:0] sri_shift;
    logic [31:0] sr_shift_mask;
    logic [31:0] sri_shift_mask;
    logic [31:0] op1_add_op2_res;
    logic [31:0] mul_op1_invert;
    logic [31:0] mul_op2_invert;

    logic [RegBus - 1:0] mul_op1;
    logic [RegBus - 1:0] mul_op2;
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic [4:0] rd;
    logic [4:0] uimm;
    logic [RegBus - 1:0] reg_wdata;
    logic reg_we;
    logic [RegAddrBus - 1:0] reg_waddr;
    logic hold_flag;
    logic jump_flag;
    logic [InstAddrBus - 1:0] jump_addr;


    logic mem_we;
    logic mem_req;
    logic mem_hold;

    logic [RegBus - 1:0] div_data;
    logic div_valid, div_ready;
    logic div_hold;

    always_comb begin
        opcode = inst_i[6:0];
        funct3 = inst_i[14:12];
        funct7 = inst_i[31:25];
        rd     = inst_i[11:7];
        uimm   = inst_i[19:15];
    end

    always_comb begin
        sr_shift       = op1_i >> op2_i[4:0];
        sri_shift      = op1_i >> inst_i[24:20];
        sr_shift_mask  = 32'hffffffff >> op2_i[4:0];
        sri_shift_mask = 32'hffffffff >> inst_i[24:20];
    end

    assign op1_add_op2_res = op1_i + op2_i;

    always_comb begin
        mul_op1_invert  = ~op1_i + 1;
        mul_op2_invert  = ~op2_i + 1;

        mul_temp        = mul_op1 * mul_op2;
        mul_temp_invert = ~mul_temp + 1;
    end

    always_comb begin
        mem_addr_index = op1_add_op2_res[1:0] & 2'b11;

        reg_wdata_o    = reg_wdata;
        // 响应中断时不写通用寄存器
        reg_we_o       = (int_assert_i == INT_ASSERT) ? ~WriteEnable : reg_we;
        reg_waddr_o    = reg_waddr;

        // 响应中断时不写内存
        mem_we_o       = (int_assert_i == INT_ASSERT) ? ~WriteEnable : mem_we;

        // 响应中断时不向总线请求访问内存
        mem_req_o      = (int_assert_i == INT_ASSERT) ? RIB_NREQ : mem_req;
    end

    always_comb begin
        ready_o     = ~(div_hold | mem_hold);
        jump_flag_o = jump_flag || ((int_assert_i == INT_ASSERT) ? JumpEnable : ~JumpEnable);
        jump_addr_o = (int_assert_i == INT_ASSERT) ? int_addr_i : jump_addr;
    end

    always_comb begin
        // 响应中断时不写CSR寄存器
        csr_we_o    = (int_assert_i == INT_ASSERT) ? ~WriteEnable : csr_we_i;
        csr_waddr_o = csr_waddr_i;
    end

    // 处理乘法指令
    always_comb begin
        if ((opcode == INST_TYPE_R_M) && (funct7 == 7'b0000001)) begin
            case (funct3)
                INST_MUL, INST_MULHU: begin
                    mul_op1 = op1_i;
                    mul_op2 = op2_i;
                end
                INST_MULHSU: begin
                    mul_op1 = (op1_i[31] == 1'b1) ? (mul_op1_invert) : op1_i;
                    mul_op2 = op2_i;
                end
                INST_MULH: begin
                    mul_op1 = (op1_i[31] == 1'b1) ? (mul_op1_invert) : op1_i;
                    mul_op2 = (op2_i[31] == 1'b1) ? (mul_op2_invert) : op2_i;
                end
                default: begin
                    mul_op1 = op1_i;
                    mul_op2 = op2_i;
                end
            endcase
        end
        else begin
            mul_op1 = op1_i;
            mul_op2 = op2_i;
        end
    end

    // 处理除法指令
    always_comb begin
        div_valid = '0;
        div_hold  = '0;
        if ((opcode == INST_TYPE_R_M) && (funct7 == 7'b0000001)) begin
            case (funct3)
                INST_DIV, INST_DIVU, INST_REM, INST_REMU: begin
                    div_valid = (int_assert_i == INT_ASSERT) ? '0 : '1;
                    div_hold  = div_valid ^ div_ready;
                end
            endcase
        end
    end

    always_comb begin
        mem_hold = mem_req & ~mem_ready_i;
    end

    // 单周期代码
    always_comb begin
        reg_we      = reg_we_i;
        reg_waddr   = reg_waddr_i;
        mem_req     = RIB_NREQ;
        csr_wdata_o = '0;

        jump_flag   = '0;
        jump_addr   = '0;
        mem_addr_o  = '0;
        mem_wdata_o = '0;
        mem_we      = ~WriteEnable;
        reg_wdata   = '0;

        case (opcode)
            INST_ID_OPCODE: begin
                if (funct3 == INST_ID_FUN3) begin
                    mem_we      = WriteEnable;
                    mem_req     = RIB_REQ;
                    mem_addr_o  = 32'h30000000;
                    mem_wdata_o = 32'h5;
                end
                if (funct3 == INST_TEMP_FUN3) begin
                    mem_req    = RIB_REQ;
                    mem_addr_o = 32'h70030000;
                    reg_wdata  = mem_rdata_i;
                end
                if (funct3 == INST_INFI_FUN3) begin
                    if (~|inst_i[31:20]) begin
                        if (compare_i[1]) begin
                            reg_wdata   = '0;
                            mem_wdata_o = {24'b0, op1_i[7:0]};
                            mem_addr_o  = 32'h3000000c;
                            mem_we      = WriteEnable;
                            mem_req     = RIB_REQ;
                        end
                        else reg_wdata = op1_i;
                    end
                    else begin
                        reg_wdata = op1_add_op2_res;
                    end
                end
            end
            INST_TYPE_I: begin
                case (funct3)
                    INST_ADDI:  reg_wdata = op1_add_op2_res;
                    INST_SLTI:  reg_wdata = {32{(~compare_i[2])}} & 32'h1;
                    INST_SLTIU: reg_wdata = {32{(~compare_i[1])}} & 32'h1;
                    INST_XORI:  reg_wdata = op1_i ^ op2_i;
                    INST_ORI:   reg_wdata = op1_i | op2_i;
                    INST_ANDI:  reg_wdata = op1_i & op2_i;
                    INST_SLLI:  reg_wdata = op1_i << inst_i[24:20];
                    INST_SRI: begin
                        if (inst_i[30] == 1'b1)
                            reg_wdata = (sri_shift & sri_shift_mask) | ({32{op1_i[31]}} & (~sri_shift_mask));
                        else reg_wdata = op1_i >> inst_i[24:20];
                    end
                    default:    reg_wdata = '0;
                endcase
            end
            INST_TYPE_R_M: begin
                // I
                if ((funct7 == 7'b0000000) || (funct7 == 7'b0100000)) begin
                    case (funct3)
                        INST_ADD_SUB: begin
                            if (inst_i[30] == 1'b0) reg_wdata = op1_add_op2_res;
                            else reg_wdata = op1_i - op2_i;
                        end
                        INST_SLL:  reg_wdata = op1_i << op2_i[4:0];
                        INST_SLT:  reg_wdata = {32{(~compare_i[2])}} & 32'h1;
                        INST_SLTU: reg_wdata = {32{(~compare_i[1])}} & 32'h1;
                        INST_XOR:  reg_wdata = op1_i ^ op2_i;
                        INST_SR: begin
                            if (inst_i[30] == 1'b1)
                                reg_wdata = (sr_shift & sr_shift_mask) | ({32{op1_i[31]}} & (~sr_shift_mask));
                            else reg_wdata = op1_i >> op2_i[4:0];
                        end
                        INST_OR:   reg_wdata = op1_i | op2_i;
                        INST_AND:  reg_wdata = op1_i & op2_i;
                        default: begin
                            reg_wdata = '0;
                        end
                    endcase
                end
                // M
                else if (funct7 == 7'b0000001) begin
                    case (funct3)
                        INST_MUL:   reg_wdata = mul_temp[31:0];
                        INST_MULHU: reg_wdata = mul_temp[63:32];
                        INST_MULH: begin
                            case ({
                                op1_i[31], op2_i[31]
                            })
                                2'b00:   reg_wdata = mul_temp[63:32];
                                2'b11:   reg_wdata = mul_temp[63:32];
                                2'b10:   reg_wdata = mul_temp_invert[63:32];
                                default: reg_wdata = mul_temp_invert[63:32];
                            endcase
                        end
                        INST_MULHSU: begin
                            if (op1_i[31] == 1'b1) reg_wdata = mul_temp_invert[63:32];
                            else reg_wdata = mul_temp[63:32];
                        end
                        INST_DIV, INST_DIVU, INST_REM, INST_REMU: begin
                            reg_we    = div_ready & div_valid;
                            reg_wdata = div_data;
                        end
                        default:    reg_wdata = '0;
                    endcase
                end
            end
            INST_TYPE_L: begin
                mem_req    = RIB_REQ;
                mem_addr_o = op1_add_op2_res;
                case (funct3)
                    INST_LB: begin
                        case (mem_addr_index)
                            2'b00:   reg_wdata = {{24{mem_rdata_i[7]}}, mem_rdata_i[7:0]};
                            2'b01:   reg_wdata = {{24{mem_rdata_i[15]}}, mem_rdata_i[15:8]};
                            2'b10:   reg_wdata = {{24{mem_rdata_i[23]}}, mem_rdata_i[23:16]};
                            default: reg_wdata = {{24{mem_rdata_i[31]}}, mem_rdata_i[31:24]};
                        endcase
                    end
                    INST_LH: begin
                        if (mem_addr_index == 2'b0) reg_wdata = {{16{mem_rdata_i[15]}}, mem_rdata_i[15:0]};
                        else reg_wdata = {{16{mem_rdata_i[31]}}, mem_rdata_i[31:16]};
                    end
                    INST_LW: reg_wdata = mem_rdata_i;
                    INST_LBU: begin
                        case (mem_addr_index)
                            2'b00:   reg_wdata = {24'h0, mem_rdata_i[7:0]};
                            2'b01:   reg_wdata = {24'h0, mem_rdata_i[15:8]};
                            2'b10:   reg_wdata = {24'h0, mem_rdata_i[23:16]};
                            default: reg_wdata = {24'h0, mem_rdata_i[31:24]};
                        endcase
                    end
                    INST_LHU: begin
                        if (mem_addr_index == 2'b0) reg_wdata = {16'h0, mem_rdata_i[15:0]};
                        else reg_wdata = {16'h0, mem_rdata_i[31:16]};
                    end
                endcase
            end
            INST_TYPE_S: begin
                mem_req    = RIB_REQ;
                mem_we     = WriteEnable;
                mem_addr_o = op1_add_op2_res;
                case (funct3)
                    INST_SB: begin
                        case (mem_addr_index)
                            2'b00:   mem_wdata_o = {mem_rdata_i[31:8], store_data_i[7:0]};
                            2'b01:   mem_wdata_o = {mem_rdata_i[31:16], store_data_i[7:0], mem_rdata_i[7:0]};
                            2'b10:   mem_wdata_o = {mem_rdata_i[31:24], store_data_i[7:0], mem_rdata_i[15:0]};
                            default: mem_wdata_o = {store_data_i[7:0], mem_rdata_i[23:0]};
                        endcase
                    end
                    INST_SH: begin
                        if (mem_addr_index == 2'b00) mem_wdata_o = {mem_rdata_i[31:16], store_data_i[15:0]};
                        else mem_wdata_o = {store_data_i[15:0], mem_rdata_i[15:0]};
                    end
                    INST_SW: mem_wdata_o = store_data_i;
                endcase
            end
            INST_TYPE_B: begin
                case (funct3)
                    INST_BEQ: begin
                        jump_flag = compare_i[0];
                        jump_addr = {32{compare_i[0]}} & op1_add_op2_res;
                    end
                    INST_BNE: begin
                        jump_flag = (~compare_i[0]);
                        jump_addr = {32{(~compare_i[0])}} & op1_add_op2_res;
                    end
                    INST_BLT: begin
                        jump_flag = (~compare_i[2]);
                        jump_addr = {32{(~compare_i[2])}} & op1_add_op2_res;
                    end
                    INST_BGE: begin
                        jump_flag = (compare_i[2]);
                        jump_addr = {32{(compare_i[2])}} & op1_add_op2_res;
                    end
                    INST_BLTU: begin
                        jump_flag = (~compare_i[1]);
                        jump_addr = {32{(~compare_i[1])}} & op1_add_op2_res;
                    end
                    INST_BGEU: begin
                        jump_flag = (compare_i[1]);
                        jump_addr = {32{(compare_i[1])}} & op1_add_op2_res;
                    end
                endcase
            end
            INST_JAL, INST_JALR: begin
                jump_flag = '1;
                jump_addr = op1_add_op2_res;
                reg_wdata = inst_addr_next_i;
            end
            INST_LUI, INST_AUIPC: begin
                reg_wdata = op1_add_op2_res;
            end
            INST_FENCE: begin
                jump_flag = '1;
                jump_addr = inst_addr_next_i;
            end
            INST_CSR: begin
                case (funct3)
                    INST_CSRRW: begin
                        csr_wdata_o = op1_i;
                        reg_wdata   = csr_rdata_i;
                    end
                    INST_CSRRS: begin
                        csr_wdata_o = op1_i | csr_rdata_i;
                        reg_wdata   = csr_rdata_i;
                    end
                    INST_CSRRC: begin
                        csr_wdata_o = csr_rdata_i & (~op1_i);
                        reg_wdata   = csr_rdata_i;
                    end
                    INST_CSRRWI: begin
                        csr_wdata_o = {27'h0, uimm};
                        reg_wdata   = csr_rdata_i;
                    end
                    INST_CSRRSI: begin
                        csr_wdata_o = {27'h0, uimm} | csr_rdata_i;
                        reg_wdata   = csr_rdata_i;
                    end
                    INST_CSRRCI: begin
                        csr_wdata_o = (~{27'h0, uimm}) & csr_rdata_i;
                        reg_wdata   = csr_rdata_i;
                    end
                endcase
            end
        endcase
    end


    div_yw i_div (
        .clk_i,
        .rst_ni,
        .valid_i   (div_valid),
        .dividend_i(op1_i),
        .divisor_i (op2_i),
        .op_i      (funct3),
        .data_o    (div_data),
        .ready_o   (div_ready)
    );
endmodule
