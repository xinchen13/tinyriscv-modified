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
// 译码模块
// 纯组合逻辑电路
module id_yw
    import tinyriscv_pkg::*;
(
    // from if_id
    input [    InstBus - 1:0] inst_i,      // 指令内容
    input [InstAddrBus - 1:0] inst_addr_i, // 指令地址

    // from regs
    input [RegBus - 1:0] reg1_rdata_i,  // 通用寄存器1输入数据
    input [RegBus - 1:0] reg2_rdata_i,  // 通用寄存器2输入数据

    // from csr logic
    input [RegBus - 1:0] csr_rdata_i,  // CSR寄存器输入数据

    // from ex
    input ex_jump_flag_i,  // 跳转标志

    // to regs
    output logic [RegAddrBus - 1:0] reg1_raddr_o,  // 读通用寄存器1地址
    output logic [RegAddrBus - 1:0] reg2_raddr_o,  // 读通用寄存器2地址

    // to csr logic
    output logic [MemAddrBus - 1:0] csr_raddr_o,  // 读CSR寄存器地址

    // to ex
    output logic [ MemAddrBus - 1:0] op1_o,
    output logic [ MemAddrBus - 1:0] op2_o,
    output logic [    InstBus - 1:0] inst_o,       // 指令内容
    output logic [InstAddrBus - 1:0] inst_addr_o,  // 指令地址
    output logic                     reg_we_o,     // 写通用寄存器标志
    output logic [ RegAddrBus - 1:0] reg_waddr_o,  // 写通用寄存器地址
    output logic                     csr_we_o,     // 写CSR寄存器标志
    output logic [     RegBus - 1:0] csr_rdata_o,  // CSR寄存器数据
    output logic [ MemAddrBus - 1:0] csr_waddr_o,  // 写CSR寄存器地址
    output logic [              2:0] compare_o,    // [2] signed ge [1] unsigned ge [0] unsigned eq
    output logic [     RegBus - 1:0] store_data_o

);

    wire [6:0] opcode = inst_i[6:0];
    wire [2:0] funct3 = inst_i[14:12];
    wire [6:0] funct7 = inst_i[31:25];
    wire [4:0] rd = inst_i[11:7];
    wire [4:0] rs1 = inst_i[19:15];
    wire [4:0] rs2 = inst_i[24:20];

    always_comb begin : compare_logic
        compare_o[2] = $signed(reg1_rdata_i) >= $signed(reg2_rdata_i);
        compare_o[1] = reg1_rdata_i >= reg2_rdata_i;
        compare_o[0] = reg1_rdata_i == reg2_rdata_i;
    end : compare_logic


    always_comb begin
        inst_o       = inst_i;
        inst_addr_o  = inst_addr_i;

        csr_rdata_o  = csr_rdata_i;
        csr_raddr_o  = '0;
        csr_waddr_o  = '0;
        csr_we_o     = ~WriteEnable;

        op1_o        = '0;
        op2_o        = '0;

        reg_we_o     = ~WriteEnable;
        reg_waddr_o  = '0;
        reg1_raddr_o = '0;
        reg2_raddr_o = '0;

        store_data_o = '0;

        case (opcode)
            INST_ID_OPCODE: begin
                if (funct3 == INST_ID_FUN3) begin
                    // PASS
                end
                else if (funct3 == INST_TEMP_FUN3) begin
                    reg_we_o    = WriteEnable;
                    reg_waddr_o = rd;
                end
                else if (funct3 == INST_INFI_FUN3) begin
                    reg_we_o     = WriteEnable;
                    reg_waddr_o  = rd;
                    reg1_raddr_o = rs1;
                    reg2_raddr_o = 5'd31;
                    op1_o        = reg1_rdata_i;
                    if (~|inst_i[31:20]) op2_o = reg2_rdata_i;
                    else op2_o = {{20{inst_i[31]}}, inst_i[31:20]};
                end
            end
            INST_TYPE_I: begin
                case (funct3)
                    INST_ADDI, INST_SLTI, INST_SLTIU, INST_XORI, INST_ORI, INST_ANDI, INST_SLLI, INST_SRI: begin
                        reg_we_o     = WriteEnable;
                        reg_waddr_o  = rd;
                        reg1_raddr_o = rs1;
                        op1_o        = reg1_rdata_i;
                        op2_o        = {{20{inst_i[31]}}, inst_i[31:20]};
                    end
                endcase
            end
            INST_TYPE_R_M: begin
                if ((funct7 == 7'b0000000) || (funct7 == 7'b0100000)) begin
                    case (funct3)
                        INST_ADD_SUB, INST_SLL, INST_SLT, INST_SLTU, INST_XOR, INST_SR, INST_OR, INST_AND: begin
                            reg_we_o     = WriteEnable;
                            reg_waddr_o  = rd;
                            reg1_raddr_o = rs1;
                            reg2_raddr_o = rs2;
                            op1_o        = reg1_rdata_i;
                            op2_o        = reg2_rdata_i;
                        end
                    endcase
                end
                else if (funct7 == 7'b0000001) begin
                    case (funct3)
                        INST_MUL, INST_MULHU, INST_MULH, INST_MULHSU, INST_DIV, INST_DIVU, INST_REM, INST_REMU: begin
                            reg_we_o     = WriteEnable;
                            reg_waddr_o  = rd;
                            reg1_raddr_o = rs1;
                            reg2_raddr_o = rs2;
                            op1_o        = reg1_rdata_i;
                            op2_o        = reg2_rdata_i;
                        end
                    endcase
                end
            end
            INST_TYPE_L: begin
                case (funct3)
                    INST_LB, INST_LH, INST_LW, INST_LBU, INST_LHU: begin
                        reg1_raddr_o = rs1;
                        reg_we_o     = WriteEnable;
                        reg_waddr_o  = rd;
                        op1_o        = reg1_rdata_i;
                        op2_o        = {{20{inst_i[31]}}, inst_i[31:20]};
                    end
                endcase
            end
            INST_TYPE_S: begin
                case (funct3)
                    INST_SB, INST_SW, INST_SH: begin
                        reg1_raddr_o = rs1;
                        reg2_raddr_o = rs2;
                        op1_o        = reg1_rdata_i;
                        op2_o        = {{20{inst_i[31]}}, inst_i[31:25], inst_i[11:7]};
                        store_data_o = reg2_rdata_i;
                    end
                endcase
            end
            INST_TYPE_B: begin
                case (funct3)
                    INST_BEQ, INST_BNE, INST_BLT, INST_BGE, INST_BLTU, INST_BGEU: begin
                        reg1_raddr_o = rs1;
                        reg2_raddr_o = rs2;
                        op1_o        = inst_addr_i;
                        op2_o        = {{20{inst_i[31]}}, inst_i[7], inst_i[30:25], inst_i[11:8], 1'b0};
                    end
                endcase
            end
            INST_JAL: begin
                reg_we_o    = WriteEnable;
                reg_waddr_o = rd;
                op1_o       = inst_addr_i;
                op2_o       = {{12{inst_i[31]}}, inst_i[19:12], inst_i[20], inst_i[30:21], 1'b0};
            end
            INST_JALR: begin
                reg_we_o     = WriteEnable;
                reg1_raddr_o = rs1;
                reg_waddr_o  = rd;
                op1_o        = reg1_rdata_i;
                op2_o        = {{20{inst_i[31]}}, inst_i[31:20]};
            end
            INST_LUI: begin
                reg_we_o    = WriteEnable;
                reg_waddr_o = rd;
                op1_o       = {inst_i[31:12], 12'b0};
            end
            INST_AUIPC: begin
                reg_we_o    = WriteEnable;
                reg_waddr_o = rd;
                op1_o       = inst_addr_i;
                op2_o       = {inst_i[31:12], 12'b0};
            end
            INST_FENCE: begin
                // Pass
            end
            INST_CSR: begin
                csr_raddr_o = {20'h0, inst_i[31:20]};
                csr_waddr_o = {20'h0, inst_i[31:20]};
                case (funct3)
                    INST_CSRRW, INST_CSRRS, INST_CSRRC: begin
                        reg1_raddr_o = rs1;
                        op1_o        = reg1_rdata_i;
                        reg_we_o     = WriteEnable;
                        reg_waddr_o  = rd;
                        csr_we_o     = WriteEnable;
                    end
                    INST_CSRRWI, INST_CSRRSI, INST_CSRRCI: begin
                        reg_we_o    = WriteEnable;
                        reg_waddr_o = rd;
                        csr_we_o    = WriteEnable;
                    end
                endcase
            end
        endcase
    end

endmodule
