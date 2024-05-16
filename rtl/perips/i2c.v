// i2c

module i2c(
    input wire clk,
    input wire rst,

    // rib interface
    input wire we_i,
    input wire[31:0] addr_i,
    input wire[31:0] data_i,
    output reg[31:0] data_o,

    // device interface
    output wire scl,
    inout wire sda
);

endmodule