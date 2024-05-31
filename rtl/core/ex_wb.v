`include "../header/defines.vh"

module ex_wb (
    input wire clk,
    input wire rst,

    input wire [`RegAddrBus] reg_waddr_i,
    input wire [`RegBus] reg_wdata_i,
    input wire reg_we_i,
    
    output reg [`RegAddrBus] reg_waddr_o,
    output reg [`RegBus] reg_wdata_o,
    output reg reg_we_o,

    input wire stall_flag_i

);

    wire stall;
    assign stall = stall_flag_i;

    always @ (posedge clk) begin
        if (!rst) begin
            reg_waddr_o <= `INST_NOP;
            reg_wdata_o <= `ZeroWord;
            reg_we_o <= 1'b0;
        end else if(stall) begin
            reg_waddr_o <= reg_waddr_o;
            reg_wdata_o <= reg_wdata_o;
            reg_we_o <= reg_we_o;
        end else begin
            reg_waddr_o <= reg_waddr_i;
            reg_wdata_o <= reg_wdata_i;
            reg_we_o <= reg_we_i;
        end
    end

endmodule