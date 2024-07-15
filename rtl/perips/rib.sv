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
// RIB总线模块
module rib
(
    
    // master 0 interface
    input        [MemAddrBus - 1:0] m0_addr_i,  // 主设备0读、写地址
    input        [    MemBus - 1:0] m0_data_i,  // 主设备0写数据
    output logic [    MemBus - 1:0] m0_data_o,  // 主设备0读取到的数据
    input                           m0_req_i,   // 主设备0访问请求标志
    input                           m0_we_i,    // 主设备0写标志
    output logic                    m0_ready_o,

    // master 1 interface
    input        [MemAddrBus - 1:0] m1_addr_i,  // 主设备1读、写地址
    input        [    MemBus - 1:0] m1_data_i,  // 主设备1写数据
    output logic [    MemBus - 1:0] m1_data_o,  // 主设备1读取到的数据
    input                           m1_req_i,   // 主设备1访问请求标志
    input                           m1_we_i,    // 主设备1写标志
    output logic                    m1_ready_o,

    // master 2 interface
    input        [MemAddrBus - 1:0] m2_addr_i,  // 主设备2读、写地址
    input        [    MemBus - 1:0] m2_data_i,  // 主设备2写数据
    output logic [    MemBus - 1:0] m2_data_o,  // 主设备2读取到的数据
    input                           m2_req_i,   // 主设备2访问请求标志
    input                           m2_we_i,    // 主设备2写标志

    // master 3 interface
    input        [MemAddrBus - 1:0] m3_addr_i,  // 主设备3读、写地址
    input        [    MemBus - 1:0] m3_data_i,  // 主设备3写数据
    output logic [    MemBus - 1:0] m3_data_o,  // 主设备3读取到的数据
    input                           m3_req_i,   // 主设备3访问请求标志
    input                           m3_we_i,    // 主设备3写标志

    // slave 0 interface
    output logic [MemAddrBus - 1:0] s0_addr_o,  // 从设备0读、写地址
    output logic [    MemBus - 1:0] s0_data_o,  // 从设备0写数据
    input        [    MemBus - 1:0] s0_data_i,  // 从设备0读取到的数据
    output logic                    s0_we_o,    // 从设备0写标志

    // slave 1 interface
    output logic [MemAddrBus - 1:0] s1_addr_o,  // 从设备1读、写地址
    output logic [    MemBus - 1:0] s1_data_o,  // 从设备1写数据
    input        [    MemBus - 1:0] s1_data_i,  // 从设备1读取到的数据
    output logic                    s1_we_o,    // 从设备1写标志

    // slave 2 interface
    output logic [MemAddrBus - 1:0] s2_addr_o,  // 从设备2读、写地址
    output logic [    MemBus - 1:0] s2_data_o,  // 从设备2写数据
    input        [    MemBus - 1:0] s2_data_i,  // 从设备2读取到的数据
    output logic                    s2_we_o,    // 从设备2写标志

    // slave 3 interface
    output logic [MemAddrBus - 1:0] s3_addr_o,  // 从设备3读、写地址
    output logic [    MemBus - 1:0] s3_data_o,  // 从设备3写数据
    input        [    MemBus - 1:0] s3_data_i,  // 从设备3读取到的数据
    output logic                    s3_we_o,    // 从设备3写标志
    output logic                    s3_req_o,
    input                           s3_ready_i,

    // slave 4 interface
    output logic [MemAddrBus - 1:0] s4_addr_o,  // 从设备4读、写地址
    output logic [    MemBus - 1:0] s4_data_o,  // 从设备4写数据
    input        [    MemBus - 1:0] s4_data_i,  // 从设备4读取到的数据
    output logic                    s4_we_o,    // 从设备4写标志

    // slave 5 interface
    output logic [MemAddrBus - 1:0] s5_addr_o,  // 从设备5读、写地址
    output logic [    MemBus - 1:0] s5_data_o,  // 从设备5写数据
    input        [    MemBus - 1:0] s5_data_i,  // 从设备5读取到的数据
    output logic                    s5_we_o,    // 从设备5写标志
    // slave 6 interface
    output logic [MemAddrBus - 1:0] s6_addr_o,  // 从设备6读、写地址
    output logic [    MemBus - 1:0] s6_data_o,  // 从设备6写数据
    input        [    MemBus - 1:0] s6_data_i,  // 从设备6读取到的数据
    output logic                    s6_we_o,    // 从设备6写标志
    output logic                    s6_req_o,   // 从设备6请求
    input                           s6_ready_i,

    // slave 7 interface
    output logic [MemAddrBus - 1:0] s7_addr_o,  // 从设备7读、写地址
    output logic [    MemBus - 1:0] s7_data_o,  // 从设备7写数据
    input        [    MemBus - 1:0] s7_data_i,  // 从设备7读取到的数据
    output logic                    s7_we_o,    // 从设备7写标志
    output logic                    s7_req_o,   // 从设备7请求
    input                           s7_ready_i,

    output logic hold_flag_o  // 暂停流水线标志

);
    localparam int unsigned CpuResetAddr = 32'h0;

    localparam bit RstEnable = 1'b0;
    localparam bit WriteEnable = 1'b1;
    localparam bit True = 1'b1;
    localparam bit False = 1'b0;
    localparam bit JumpEnable = 1'b1;
    localparam bit DivStart = 1'b1;
    localparam bit DivStop = 1'b0;
    localparam bit HoldEnable = 1'b1;
    localparam bit HoldDisable = 1'b0;
    localparam bit RIB_REQ = 1'b1;
    localparam bit RIB_NREQ = 1'b0;
    localparam bit INT_ASSERT = 1'b1;
    localparam bit INT_DEASSERT = 1'b0;

    localparam logic [7:0] INT_BUS = 8;
    localparam logic [7:0] INT_NONE = 8'h0;
    localparam logic [7:0] INT_RET = 8'hff;
    localparam logic [7:0] INT_TIMER0 = 8'b00000001;
    localparam int unsigned INT_TIMER0_ENTRY_ADDR = 32'h4;

    localparam int unsigned Hold_Flag_Bus = 3;
    localparam logic [2:0] Pipe_Flow = 3'b000;
    localparam logic [2:0] Pipe_Pause = 3'b001;  // 不使用stall是因为此设计没有数据冲突
    localparam logic [2:0] Pipe_Clear = 3'b100;

    // I type inst
    localparam logic [6:0] INST_TYPE_I = 7'b0010011;
    localparam logic [2:0] INST_ADDI = 3'b000;
    localparam logic [2:0] INST_SLTI = 3'b010;
    localparam logic [2:0] INST_SLTIU = 3'b011;
    localparam logic [2:0] INST_XORI = 3'b100;
    localparam logic [2:0] INST_ORI = 3'b110;
    localparam logic [2:0] INST_ANDI = 3'b111;
    localparam logic [2:0] INST_SLLI = 3'b001;
    localparam logic [2:0] INST_SRI = 3'b101;
    // sID type inst
    localparam logic [6:0] INST_ID_OPCODE = 7'b0101111;
    localparam logic [2:0] INST_ID_FUN3 = 3'b000;
    localparam logic [2:0] INST_TEMP_FUN3 = 3'b001;
    localparam logic [2:0] INST_INFI_FUN3 = 3'b010;

    // L type inst
    localparam logic [6:0] INST_TYPE_L = 7'b0000011;
    localparam logic [2:0] INST_LB = 3'b000;
    localparam logic [2:0] INST_LH = 3'b001;
    localparam logic [2:0] INST_LW = 3'b010;
    localparam logic [2:0] INST_LBU = 3'b100;
    localparam logic [2:0] INST_LHU = 3'b101;

    // S type inst
    localparam logic [6:0] INST_TYPE_S = 7'b0100011;
    localparam logic [2:0] INST_SB = 3'b000;
    localparam logic [2:0] INST_SH = 3'b001;
    localparam logic [2:0] INST_SW = 3'b010;

    // R and M type inst
    localparam logic [6:0] INST_TYPE_R_M = 7'b0110011;
    // R type inst
    localparam logic [2:0] INST_ADD_SUB = 3'b000;
    localparam logic [2:0] INST_SLL = 3'b001;
    localparam logic [2:0] INST_SLT = 3'b010;
    localparam logic [2:0] INST_SLTU = 3'b011;
    localparam logic [2:0] INST_XOR = 3'b100;
    localparam logic [2:0] INST_SR = 3'b101;
    localparam logic [2:0] INST_OR = 3'b110;
    localparam logic [2:0] INST_AND = 3'b111;
    // M type inst
    localparam logic [2:0] INST_MUL = 3'b000;
    localparam logic [2:0] INST_MULH = 3'b001;
    localparam logic [2:0] INST_MULHSU = 3'b010;
    localparam logic [2:0] INST_MULHU = 3'b011;
    localparam logic [2:0] INST_DIV = 3'b100;
    localparam logic [2:0] INST_DIVU = 3'b101;
    localparam logic [2:0] INST_REM = 3'b110;
    localparam logic [2:0] INST_REMU = 3'b111;

    // J type inst
    localparam logic [6:0] INST_JAL = 7'b1101111;
    localparam logic [6:0] INST_JALR = 7'b1100111;

    localparam logic [6:0] INST_LUI = 7'b0110111;
    localparam logic [6:0] INST_AUIPC = 7'b0010111;
    localparam int unsigned INST_NOP = 32'h00000013;
    localparam int unsigned INST_MRET = 32'h30200073;
    localparam int unsigned INST_RET = 32'h00008067;

    localparam logic [6:0] INST_FENCE = 7'b0001111;
    localparam int unsigned INST_ECALL = 32'h73;
    localparam int unsigned INST_EBREAK = 32'h00100073;

    // J type inst
    localparam logic [6:0] INST_TYPE_B = 7'b1100011;
    localparam logic [2:0] INST_BEQ = 3'b000;
    localparam logic [2:0] INST_BNE = 3'b001;
    localparam logic [2:0] INST_BLT = 3'b100;
    localparam logic [2:0] INST_BGE = 3'b101;
    localparam logic [2:0] INST_BLTU = 3'b110;
    localparam logic [2:0] INST_BGEU = 3'b111;

    // CSR inst
    localparam logic [6:0] INST_CSR = 7'b1110011;
    localparam logic [2:0] INST_CSRRW = 3'b001;
    localparam logic [2:0] INST_CSRRS = 3'b010;
    localparam logic [2:0] INST_CSRRC = 3'b011;
    localparam logic [2:0] INST_CSRRWI = 3'b101;
    localparam logic [2:0] INST_CSRRSI = 3'b110;
    localparam logic [2:0] INST_CSRRCI = 3'b111;

    // CSR logic addr
    localparam logic [11:0] CSR_CYCLE = 12'hc00;
    localparam logic [11:0] CSR_CYCLEH = 12'hc80;
    localparam logic [11:0] CSR_MTVEC = 12'h305;
    localparam logic [11:0] CSR_MCAUSE = 12'h342;
    localparam logic [11:0] CSR_MEPC = 12'h341;
    localparam logic [11:0] CSR_MIE = 12'h304;
    localparam logic [11:0] CSR_MSTATUS = 12'h300;
    localparam logic [11:0] CSR_MSCRATCH = 12'h340;

    localparam int unsigned RomNum = 256;  // rom depth(how many words)

    localparam int unsigned MemNum = 16;  // memory depth(how many words)
    localparam int unsigned MemBus = 32;
    localparam int unsigned MemAddrBus = 32;

    localparam int unsigned InstBus = 32;
    localparam int unsigned InstAddrBus = 32;

    // common regs
    localparam int unsigned RegAddrBus = 5;
    localparam int unsigned RegBus = 32;
    localparam int unsigned DoubleRegBus = 64;
    localparam int unsigned RegNum = 32;  // logic num

    // 访问地址的最高4位决定要访问的是哪一个从设备
    // 因此最多支持16个从设备
    localparam [3:0] slave_0 = 4'b0000;
    localparam [3:0] slave_1 = 4'b0001;
    localparam [3:0] slave_2 = 4'b0010;
    localparam [3:0] slave_3 = 4'b0011;
    localparam [3:0] slave_4 = 4'b0100;
    localparam [3:0] slave_5 = 4'b0101;
    localparam [3:0] slave_6 = 4'b0110;
    localparam [3:0] slave_7 = 4'b0111;

    logic [3:0] req;
    logic req_t;

    // 主设备请求信号
    assign req   = {m3_req_i, m0_req_i, m2_req_i, m1_req_i};
    assign req_t = |req;

    logic [MemAddrBus - 1:0] addr_t;
    logic [MemBus - 1:0] s_data_t;
    logic we_t;
    logic ready_t;
    logic [MemBus - 1:0] m_data_t;

    assign hold_flag_o = (m3_req_i | m0_req_i | m2_req_i) ? HoldEnable : HoldDisable;

    always @ (*) begin
        m0_data_o  = '0;
        m1_data_o  = INST_NOP;
        m2_data_o  = '0;
        m3_data_o  = '0;
        m1_ready_o = '0;
        m0_ready_o = '0;
        casez (req)
            4'b1???: begin

                addr_t    = m3_addr_i;
                s_data_t  = m3_data_i;
                we_t      = m3_we_i;
                m3_data_o = m_data_t;
            end
            4'b01??: begin

                addr_t     = m0_addr_i;
                s_data_t   = m0_data_i;
                we_t       = m0_we_i;
                m0_data_o  = m_data_t;
                m0_ready_o = ready_t;
            end
            4'b001?: begin

                addr_t    = m2_addr_i;
                s_data_t  = m2_data_i;
                we_t      = m2_we_i;
                m2_data_o = m_data_t;
            end
            default: begin
                addr_t     = m1_addr_i;
                s_data_t   = m1_data_i;
                we_t       = m1_we_i;
                m1_data_o  = m_data_t;
                m1_ready_o = ready_t;
            end
        endcase
    end

    // 根据仲裁结果，选择(访问)对应的从设备
    always @ (*) begin
        s0_addr_o = '0;
        s1_addr_o = '0;
        s2_addr_o = '0;
        s3_addr_o = '0;
        s4_addr_o = '0;
        s5_addr_o = '0;
        s6_addr_o = '0;
        s7_addr_o = '0;
        s0_data_o = '0;
        s1_data_o = '0;
        s2_data_o = '0;
        s3_data_o = '0;
        s4_data_o = '0;
        s5_data_o = '0;
        s6_data_o = '0;
        s7_data_o = '0;
        s0_we_o   = '0;
        s1_we_o   = '0;
        s2_we_o   = '0;
        s3_we_o   = '0;
        s4_we_o   = '0;
        s5_we_o   = '0;
        s6_we_o   = '0;
        s7_we_o   = '0;
        m_data_t  = '0;
        s3_req_o  = '0;
        s6_req_o  = '0;
        s7_req_o  = '0;
        ready_t   = '0;
        case (addr_t[28 +: 4])
            slave_0: begin
                s0_we_o   = we_t;
                s0_addr_o = addr_t;
                s0_data_o = s_data_t;
                m_data_t  = s0_data_i;
                ready_t   = '1;
            end
            slave_1: begin
                s1_we_o   = we_t;
                s1_addr_o = addr_t;
                s1_data_o = s_data_t;
                m_data_t  = s1_data_i;
                ready_t   = '1;
            end
            slave_2: begin
                s2_we_o   = we_t;
                s2_addr_o = addr_t;
                s2_data_o = s_data_t;
                m_data_t  = s2_data_i;
                ready_t   = '1;
            end
            slave_3: begin
                s3_we_o   = we_t;
                s3_addr_o = addr_t;
                s3_data_o = s_data_t;
                m_data_t  = s3_data_i;
                ready_t   = s3_ready_i;
                s3_req_o  = req_t;
            end
            slave_4: begin
                s4_we_o   = we_t;
                s4_addr_o = addr_t;
                s4_data_o = s_data_t;
                m_data_t  = s4_data_i;
                ready_t   = '1;
            end
            slave_5: begin
                s5_we_o   = we_t;
                s5_addr_o = addr_t;
                s5_data_o = s_data_t;
                m_data_t  = s5_data_i;
                ready_t   = '1;
            end
            slave_6: begin
                s6_we_o   = we_t;
                s6_addr_o = addr_t;
                s6_data_o = s_data_t;
                m_data_t  = s6_data_i;
                s6_req_o  = req_t;
                ready_t   = s6_ready_i;
            end
            slave_7: begin
                s7_we_o   = we_t;
                s7_addr_o = addr_t;
                s7_data_o = s_data_t;
                m_data_t  = s7_data_i;
                s7_req_o  = req_t;
                ready_t   = s7_ready_i;
            end
            default: begin

            end
        endcase

    end

endmodule
