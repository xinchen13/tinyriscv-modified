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
    output wire[3:0] pwm_o
);

    // addr: 0x6000_0000, 1/freq
    reg [31:0] A0;
    localparam PWM_A0 = 8'h00;
    // addr: 0x6010_0000, duty
    reg [31:0] B0;
    localparam PWM_B0 = 8'h10;
    // addr: 0x6001_0000, 1/freq
    reg [31:0] A1;
    localparam PWM_A1 = 8'h01;
    // addr: 0x6011_0000, duty
    reg [31:0] B1;
    localparam PWM_B1 = 8'h11;
    // addr: 0x6002_0000, 1/freq
    reg [31:0] A2;
    localparam PWM_A2 = 8'h02;
    // addr: 0x6012_0000, duty
    reg [31:0] B2;
    localparam PWM_B2 = 8'h12;
    // addr: 0x6003_0000, 1/freq
    reg [31:0] A3;
    localparam PWM_A3 = 8'h03;
    // addr: 0x6013_0000, duty
    reg [31:0] B3;
    localparam PWM_B3 = 8'h13;
    // addr: 0x6004_0000,  output enable
    reg [3:0] C;
    localparam PWM_C = 8'h04;

    // write register
    always @ (posedge clk) begin
        if (~rst) begin
            A0 <= 32'b0;
            B0 <= 32'b0;
            A1 <= 32'b0;
            B1 <= 32'b0;
            A2 <= 32'b0;
            B2 <= 32'b0;
            A3 <= 32'b0;
            B3 <= 32'b0;
            C <= 4'b0;
        end
        else begin
            if (we_i == 1'b1) begin
                case (addr_i[23:16])
                    PWM_A0: begin
                        A0 <= data_i;
                    end
                    PWM_A1: begin
                        A1 <= data_i;
                    end
                    PWM_A2: begin
                        A2 <= data_i;
                    end
                    PWM_A3: begin
                        A3 <= data_i;
                    end
                    PWM_B0: begin
                        B0 <= data_i;
                    end
                    PWM_B1: begin
                        B1 <= data_i;
                    end
                    PWM_B2: begin
                        B2 <= data_i;
                    end
                    PWM_B3: begin
                        B3 <= data_i;
                    end
                    PWM_C: begin
                        C <= data_i[3:0];
                    end
                    default: begin
                    end
                endcase
            end
        end
    end

    // read register
    always @ (*) begin
        if (~rst) begin
            data_o = 32'h0;
        end
        else begin
            case (addr_i[23:16])
                PWM_A0: begin
                    data_o = A0;
                end
                PWM_A1: begin
                    data_o = A1;
                end
                PWM_A2: begin
                    data_o = A2;
                end
                PWM_A3: begin
                    data_o = A3;
                end
                PWM_B0: begin
                    data_o = B0;
                end
                PWM_B1: begin
                    data_o = B1;
                end
                PWM_B2: begin
                    data_o = B2;
                end
                PWM_B3: begin
                    data_o = B3;
                end
                PWM_C: begin
                    data_o = {28'b0, C[3:0]};
                end
                default: begin
                    data_o = 32'h0;
                end
            endcase
        end
    end


    gen_pulse u_gen_pulse_0(
        .clk(clk),
        .rst(rst),
        .en(C[0]),
        .freq_cnt(A0),
        .duty_cnt(B0),
        .pulse(pwm_o[0])
    );

    gen_pulse u_gen_pulse_1(
        .clk(clk),
        .rst(rst),
        .en(C[1]),
        .freq_cnt(A1),
        .duty_cnt(B1),
        .pulse(pwm_o[1])
    );
    
    gen_pulse u_gen_pulse_2(
        .clk(clk),
        .rst(rst),
        .en(C[2]),
        .freq_cnt(A2),
        .duty_cnt(B2),
        .pulse(pwm_o[2])
    );

    gen_pulse u_gen_pulse_3(
        .clk(clk),
        .rst(rst),
        .en(C[3]),
        .freq_cnt(A3),
        .duty_cnt(B3),
        .pulse(pwm_o[3])
    );

endmodule