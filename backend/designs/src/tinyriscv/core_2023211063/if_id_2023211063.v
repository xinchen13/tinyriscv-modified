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

`include "../header/defines.vh"

// 将指令向译码模块传递
module if_id_2023211063(

    input wire clk,
    input wire rst,

    input wire[`InstBus] inst_i,            // 指令内容
    input wire[`InstAddrBus] inst_addr_i,   // 指令地址
    output reg [`InstBus] inst_o,           // 指令内容
    output reg [`InstAddrBus] inst_addr_o,  // 指令地址

    input wire[`INT_BUS] int_flag_i,        // 外设中断输入信号
    output reg [`INT_BUS] int_flag_o,

    input wire prdt_taken_i,
    output reg prdt_taken_o,

    input wire[`Hold_Flag_Bus] hold_flag_i, // 流水线暂停标志
    input wire stall_flag_i
    );

    wire stall;
    wire flush;
    assign stall = stall_flag_i;
    assign flush = (hold_flag_i >= `Hold_If);

    always @ (posedge clk) begin
        if (!rst) begin
            inst_o <= `INST_NOP;
            inst_addr_o <= `ZeroWord;
            int_flag_o <= `INT_NONE;
            prdt_taken_o <= 1'b0;
        end else if(stall) begin
            inst_o <= inst_o;
            inst_addr_o <= inst_addr_o;
            int_flag_o <= int_flag_o;
            prdt_taken_o <= prdt_taken_o;
        end else if(flush) begin
            inst_o <= `INST_NOP;
            inst_addr_o <= `ZeroWord;
            int_flag_o <= `INT_NONE;
            prdt_taken_o <= 1'b0;
        end else begin
            inst_o <= inst_i;
            inst_addr_o <= inst_addr_i;
            int_flag_o <= int_flag_i;
            prdt_taken_o <= prdt_taken_i;
        end
    end

endmodule
