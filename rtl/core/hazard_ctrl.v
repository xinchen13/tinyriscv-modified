`include "../header/defines.vh"

// 流水线冒险解决
module hazard_ctrl (
    input wire [`RegAddrBus] id_reg1_raddr_i,
    input wire [`RegAddrBus] id_reg2_raddr_i,
    input wire [`RegAddrBus] ex_reg_waddr_i,
    input wire ex_reg_we_i,

    output reg fwd_reg1_o,
    output reg fwd_reg2_o
);

    always @ (*) begin
        if((id_reg1_raddr_i == ex_reg_waddr_i) && (ex_reg_we_i == 1'b1 ))
            fwd_reg1_o = 1'b1;
        else
            fwd_reg1_o = 1'b0;
    end

    always @ (*) begin
        if((id_reg2_raddr_i == ex_reg_waddr_i) && (ex_reg_we_i == 1'b1 ))
            fwd_reg2_o = 1'b1;
        else
            fwd_reg2_o = 1'b0;
    end

endmodule