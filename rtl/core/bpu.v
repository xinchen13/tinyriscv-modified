// `include "defines.v"

module bpu(
    input wire [`InstAddrBus] pc_i,
    input wire inst_jal_i,
    input wire inst_jalr_i,
    input wire inst_bxx_i,
    input wire [`InstAddrBus] jump_and_branch_imm_i,
    output wire prdt_taken_o,
    output wire [`InstAddrBus] prdt_addr_o
);

    assign prdt_taken_o = inst_jal_i | (inst_bxx_i & jump_and_branch_imm_i[31]);
    assign prdt_addr_o = pc_i + jump_and_branch_imm_i;

endmodule