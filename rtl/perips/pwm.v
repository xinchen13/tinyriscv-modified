// pwm

module pwm(
    input wire clk,
    input wire rst,

    // rib interface 
    input wire we_i,
    input wire[31:0] addr_i,
    input wire[31:0] data_i,
    output reg[31:0] data_o,

    // io
    output wire[3:0] pwm_o;
);

    // addr: 0x6000_0000, 1/freq
    reg [31:0] A_0;
    // addr: 0x6010_0000, duty
    reg [31:0] B_0;

    // addr: 0x6001_0000, 1/freq
    reg [31:0] A_1;
    // addr: 0x6011_0000, duty
    reg [31:0] B_1;

    // addr: 0x6002_0000, 1/freq
    reg [31:0] A_2;
    // addr: 0x6012_0000, duty
    reg [31:0] B_2;

    // addr: 0x6003_0000, 1/freq
    reg [31:0] A_3;
    // addr: 0x6013_0000, duty
    reg [31:0] B_3;

    // addr: 0x6004_0000,  output enable
    reg [3:0] C;

    // write register
    always @ (posedge clk) begin
        if (~rst) begin
            A_0 <= 32'b0;
            B_0 <= 32'b0;
            A_0 <= 32'b0;
            B_0 <= 32'b0;
            A_0 <= 32'b0;
            B_0 <= 32'b0;
            A_0 <= 32'b0;
            B_0 <= 32'b0;
            C <= 4'b0;
        end

    end


    gen_pulse u_gen_pulse_0(
        .clk(clk),
        .rst(rst),
        .en(C[0]),
        .freq_cnt(A_0),
        .duty_cnt(B_0),
        .pulse(pwm_o[0])
    );

    gen_pulse u_gen_pulse_1(
        .clk(clk),
        .rst(rst),
        .en(C[1]),
        .freq_cnt(A_1),
        .duty_cnt(B_1),
        .pulse(pwm_o[1])
    );
    
    gen_pulse u_gen_pulse_2(
        .clk(clk),
        .rst(rst),
        .en(C[2]),
        .freq_cnt(A_2),
        .duty_cnt(B_2),
        .pulse(pwm_o[2])
    );

    gen_pulse u_gen_pulse_3(
        .clk(clk),
        .rst(rst),
        .en(C[3]),
        .freq_cnt(A_3),
        .duty_cnt(B_3),
        .pulse(pwm_o[3])
    );

endmodule