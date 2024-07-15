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

// 控制模块
// 发出跳转、暂停流水线信号
module ctrl_yw
    import tinyriscv_pkg::*;
(

    input rst_ni,

    // from ex
    input                     jump_flag_i,
    input [InstAddrBus - 1:0] jump_addr_i,
    input                     hold_flag_ex_i,

    // from rib
    input hold_flag_rib_i,

    // from jtag
    input jtag_halt_flag_i,

    // from clint
    input hold_flag_clint_i,

    output logic [Hold_Flag_Bus - 1:0] hold_flag_o,

    // to pc_reg
    output logic                     jump_flag_o,
    output logic [InstAddrBus - 1:0] jump_addr_o

);


    always_comb begin
        jump_addr_o = jump_addr_i;
        jump_flag_o = jump_flag_i;
        // 默认不暂停
        hold_flag_o = Pipe_Flow;
        // 按优先级处理不同模块的请求
        if (jump_flag_i || hold_flag_clint_i == HoldEnable || jtag_halt_flag_i == HoldEnable) begin
            // 清空整条流水线
            hold_flag_o = Pipe_Clear;
        end
        else begin
            hold_flag_o = Pipe_Flow;
        end
    end

endmodule
