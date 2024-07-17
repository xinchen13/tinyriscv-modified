module gen_pulse(
    input wire clk,
    input wire rst,
    input wire en,
    input wire [31:0] freq_cnt,
    input wire [31:0] duty_cnt,
    output reg pulse
);

    reg [31:0] cntr; // counter

    always @ (posedge clk) begin
        if (~rst) begin
            cntr[31:0] <= 32'b0;
        end
        else if (en) begin
            if (cntr[31:0] == (freq_cnt - 1'b1)) begin
                cntr[31:0] <= 32'b0;
            end
            else begin
                cntr[31:0] <= cntr[31:0] + 1'b1;
            end
        end
    end

    always @ (*) begin
        if (~rst) begin
            pulse = 1'b0;
        end
        else if (en && (cntr < duty_cnt)) begin
            pulse = 1'b1;
        end
        else begin
            pulse = 1'b0;
        end
    end


endmodule