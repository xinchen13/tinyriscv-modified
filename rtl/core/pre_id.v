`include "defines.v"

module pre_id(
    input wire [`InstBus] inst_i,
    
    output wire inst_jal_o,
    output wire inst_jalr_o,
    output wire inst_bxx_o,
    output wire [`InstAddrBus] jump_and_branch_imm_o
);

    wire [6:0] opcode = inst_i[6:0];
    wire [31:0] j_imm = {{12{inst_i[31]}}, inst_i[19:12], inst_i[20], inst_i[30:21], 1'b0};
    wire [31:0] b_imm = {{20{inst_i[31]}}, inst_i[7], inst_i[30:25], inst_i[11:8], 1'b0};

    assign inst_jal_o = (opcode == `INST_JAL) ? 1'b1 : 1'b0;
    assign inst_jalr_o = (opcode == `INST_JALR) ? 1'b1 : 1'b0;
    assign inst_bxx_o = (opcode == `INST_TYPE_B) ? 1'b1 : 1'b0;

    assign jump_and_branch_imm_o = ({32{inst_jal_o}} & j_imm) | ({32{inst_bxx_o}} & b_imm);

endmodule