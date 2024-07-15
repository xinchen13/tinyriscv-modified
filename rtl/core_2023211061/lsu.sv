module lsu
    import tinyriscv_pkg::*;
(
    input clk_i,
    input rst_ni,

    tl_a_intf.master tl_a_master,
    tl_a_intf.slave  tl_a_slave,

    tl_d_intf.master tl_d_master,
    tl_d_intf.slave  tl_d_slave,


    input  ex_valid_i,
    output ex_ready_o,

    input ex_we_i,
    input ex_sign_ext_i,
    input ex_type_i,

    input  [MemAddrBus - 1:0] ex_rw_addr_i,
    input  [    MemBus - 1:0] ex_wdata_i,
    output [    MemBus - 1:0] ex_rdata_o
);

endmodule
