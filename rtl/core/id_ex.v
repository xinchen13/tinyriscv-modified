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

`include "../header/defines.vh"

// 将译码结果向执行模块传递
module id_ex(

    input wire clk,
    input wire rst,

    input wire[`InstBus] inst_i,            // 指令内容
    input wire[`InstAddrBus] inst_addr_i,   // 指令地址
    input wire reg_we_i,                    // 写通用寄存器标志
    input wire[`RegAddrBus] reg_waddr_i,    // 写通用寄存器地址
    input wire[`RegBus] reg1_rdata_i,       // 通用寄存器1读数据
    input wire[`RegBus] reg2_rdata_i,       // 通用寄存器2读数据
    input wire csr_we_i,                    // 写CSR寄存器标志
    input wire[`MemAddrBus] csr_waddr_i,    // 写CSR寄存器地址
    input wire[`RegBus] csr_rdata_i,        // CSR寄存器读数据
    input wire[`MemAddrBus] op1_i,
    input wire[`MemAddrBus] op2_i,
    input wire[`MemAddrBus] op1_jump_i,
    input wire[`MemAddrBus] op2_jump_i,
    input wire prdt_taken_i,

    input wire[`Hold_Flag_Bus] hold_flag_i, // 流水线暂停标志

    input wire stall_flag_i,

    output reg prdt_taken_o,
    output reg [`MemAddrBus] op1_o,
    output reg [`MemAddrBus] op2_o,
    output reg [`MemAddrBus] op1_jump_o,
    output reg [`MemAddrBus] op2_jump_o,
    output reg [`InstBus] inst_o,            // 指令内容
    output reg [`InstAddrBus] inst_addr_o,   // 指令地址
    output reg  reg_we_o,                    // 写通用寄存器标志
    output reg [`RegAddrBus] reg_waddr_o,    // 写通用寄存器地址
    output reg [`RegBus] reg1_rdata_o,       // 通用寄存器1读数据
    output reg [`RegBus] reg2_rdata_o,       // 通用寄存器2读数据
    output reg  csr_we_o,                    // 写CSR寄存器标志
    output reg [`MemAddrBus] csr_waddr_o,    // 写CSR寄存器地址
    output reg [`RegBus] csr_rdata_o         // CSR寄存器读数据

    );

    wire hold_en = (hold_flag_i >= `Hold_Id);

    always @ (posedge clk) begin
        if (!rst) begin
            op1_jump_o <= `ZeroWord;
            op2_jump_o <= `ZeroWord;
            op2_o      <= `ZeroWord;
            op1_o      <= `ZeroWord;
            csr_rdata_o<= `ZeroWord;
            csr_waddr_o<= `ZeroWord;
            csr_we_o   <= `WriteDisable;
            reg_we_o   <= `WriteDisable;
            reg_waddr_o<= `ZeroReg;
            reg1_rdata_o<= `ZeroWord;
            reg2_rdata_o<= `ZeroWord;
            inst_addr_o <= `ZeroWord;
            inst_o      <= `INST_NOP;
            prdt_taken_o <= 1'b0;
        end else if(stall_flag_i) begin
            op1_o      <= op1_o;
            op2_o      <= op2_o;
            op1_jump_o <= op1_jump_o;
            op2_jump_o <= op2_jump_o;
            csr_rdata_o<= csr_rdata_o;
            csr_waddr_o<= csr_waddr_o;
            csr_we_o   <= csr_we_o;
            reg_we_o   <= reg_we_o;
            reg_waddr_o <= reg_waddr_o;
            reg1_rdata_o<= reg1_rdata_o;
            reg2_rdata_o<= reg2_rdata_o;
            inst_addr_o <= inst_addr_o;
            inst_o      <= inst_o;
            prdt_taken_o <= prdt_taken_o;
        end else if(hold_en) begin
            op1_jump_o <= `ZeroWord;
            op2_jump_o <= `ZeroWord;
            op2_o      <= `ZeroWord;
            op1_o      <= `ZeroWord;
            csr_rdata_o<= `ZeroWord;
            csr_waddr_o<= `ZeroWord;
            csr_we_o   <= `WriteDisable;
            reg_we_o   <= `WriteDisable;
            reg_waddr_o<= `ZeroReg;
            reg1_rdata_o<= `ZeroWord;
            reg2_rdata_o<= `ZeroWord;
            inst_addr_o <= `ZeroWord;
            inst_o      <= `INST_NOP;
            prdt_taken_o <= 1'b0;
        end else begin
            op1_o      <= op1_i;
            op2_o      <= op2_i;
            op1_jump_o <= op1_jump_i;
            op2_jump_o <= op2_jump_i;
            csr_rdata_o<= csr_rdata_i;
            csr_waddr_o<= csr_waddr_i;
            csr_we_o   <= csr_we_i;
            reg_we_o   <= reg_we_i;
            reg_waddr_o <= reg_waddr_i;
            reg1_rdata_o<= reg1_rdata_i;
            reg2_rdata_o<= reg2_rdata_i;
            inst_addr_o <= inst_addr_i;
            inst_o      <= inst_i;
            prdt_taken_o <= prdt_taken_i;
        end
    end

endmodule
