`include "../header/defines.vh"

module ifu (
    // from pc reg
    input wire [`InstAddrBus] pc_i,

    // from rib
    input wire [`InstBus] inst_i,

    // to rib
    output wire[`MemAddrBus] rib_pc_addr_o,

    // to if_id and pc_reg
    output wire if_prdt_taken_o,
    output wire [`InstAddrBus] if_prdt_addr_o,

    // to if_id
    output wire [`InstAddrBus] if_inst_addr_o,
    output wire [`InstBus] if_inst_o
);
    // branch prediction
    wire inst_jal;
    wire inst_bxx;
    wire inst_jalr;
    wire [`InstAddrBus] jump_and_branch_imm;

    assign if_inst_addr_o = pc_i;
    assign if_inst_o = inst_i;
    assign rib_pc_addr_o = pc_i;

    pre_id u_pre_id(
        .inst_i(inst_i),
        .inst_jal_o(inst_jal),
        .inst_jalr_o(inst_jalr),
        .inst_bxx_o(inst_bxx),
        .jump_and_branch_imm_o(jump_and_branch_imm)
    );

    bpu u_bpu(
        .pc_i(pc_i),
        .inst_jal_i(inst_jal),
        .inst_jalr_i(inst_jalr),
        .inst_bxx_i(inst_bxx),
        .jump_and_branch_imm_i(jump_and_branch_imm),
        .prdt_taken_o(if_prdt_taken_o),
        .prdt_addr_o(if_prdt_addr_o)
    );

endmodule