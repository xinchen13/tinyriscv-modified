// 带使能端、复位后输出为0的触发器
module gen_en_dff
    import tinyriscv_pkg::*;
#(
    parameter int unsigned            DW      = 32,
    parameter logic        [DW - 1:0] DEFAULT = '0
) (
    input clk_i,
    input rst_ni,

    input                 en,
    input        [DW-1:0] din,
    output logic [DW-1:0] qout
);

    logic [DW-1:0] qout_r;

    always_ff @(posedge clk_i) begin
        if (~rst_ni) begin
            qout_r <= DEFAULT;
        end
        else if (en == 1'b1) begin
            qout_r <= din;
        end
    end

    assign qout = qout_r;

endmodule
