module div_yw
    import tinyriscv_pkg::*;
#(
    parameter WIDTH = 32
) (
    input  logic             clk_i,
    input  logic             rst_ni,
    input  logic             valid_i,
    input  logic [WIDTH-1:0] dividend_i,
    input  logic [WIDTH-1:0] divisor_i,
    input        [      2:0] op_i,
    output logic [WIDTH-1:0] data_o,
    output logic             ready_o
);

    // Internal states and signals
    typedef enum logic [1:0] {
        STATE_IDLE,
        STATE_CALC,
        STATE_END,
        STATE_ERROR
    } state_t;

    state_t state, next_state;
    logic [WIDTH-1:0] quotient_reg, remainder_reg;
    logic [WIDTH-1:0] temp_remainder;
    logic [WIDTH-1:0] abs_dividend, abs_divisor;
    logic dividend_neg, result_neg;
    logic [5:0] count;
    logic       is_signed;

    assign is_signed = (op_i == INST_DIV) || (op_i == INST_REM);

    // State machine
    always_ff @(posedge clk_i) begin
        if (~rst_ni) state <= STATE_IDLE;
        else state <= next_state;
    end

    always_comb begin
        next_state = state;
        if (~valid_i) next_state = STATE_IDLE;
        else
            unique case (state)
                STATE_IDLE: begin
                    next_state = STATE_CALC;

                    if (divisor_i == 32'b0) next_state = STATE_ERROR;
                    else if (divisor_i == 32'hffff_ffff && dividend_i == 32'h8000_0000) next_state = STATE_ERROR;
                end
                STATE_CALC: begin
                    if (count == 0) next_state = STATE_END;
                end
                STATE_END: next_state = STATE_IDLE;
                STATE_ERROR: begin
                    next_state = STATE_IDLE;
                end
            endcase
    end

    // Counters and registers
    always_ff @(posedge clk_i) begin
        if (~rst_ni | ~valid_i) begin
            count          <= '0;
            quotient_reg   <= '0;
            remainder_reg  <= '0;
            temp_remainder <= '0;
            abs_dividend   <= '0;
            abs_divisor    <= '0;
            dividend_neg   <= '0;

            result_neg     <= '0;
            ready_o        <= '0;

            data_o         <= '0;
        end
        else begin
            case (state)
                STATE_IDLE: begin
                    count          <= WIDTH - 1;
                    dividend_neg   <= is_signed && dividend_i[WIDTH-1];

                    abs_dividend   <= is_signed && dividend_i[WIDTH-1] ? -dividend_i : dividend_i;
                    abs_divisor    <= is_signed && divisor_i[WIDTH-1] ? -divisor_i : divisor_i;

                    quotient_reg   <= '0;
                    remainder_reg  <= '0;
                    temp_remainder <= '0;
                    result_neg     <= is_signed && (dividend_i[WIDTH-1] ^ divisor_i[WIDTH-1]);
                    ready_o        <= '0;

                    data_o         <= '0;
                end
                STATE_CALC: begin
                    temp_remainder = {remainder_reg[WIDTH-2:0], abs_dividend[WIDTH-1]};
                    abs_dividend   = abs_dividend << 1;
                    if (temp_remainder >= abs_divisor) begin
                        temp_remainder = temp_remainder - abs_divisor;
                        quotient_reg   = {quotient_reg[WIDTH-2:0], 1'b1};
                    end
                    else begin
                        quotient_reg = {quotient_reg[WIDTH-2:0], 1'b0};
                    end
                    remainder_reg = temp_remainder;
                    count <= count - 1;
                end
                STATE_END: begin
                    if (op_i == INST_DIV || op_i == INST_DIVU) data_o <= result_neg ? -quotient_reg : quotient_reg;
                    else if (op_i == INST_REM || op_i == INST_REMU) data_o <= dividend_neg ? -remainder_reg : remainder_reg;
                    ready_o <= '1;
                end
                STATE_ERROR: begin
                    ready_o <= '1;
                    if (divisor_i == 32'b0)
                        case (op_i)
                            INST_DIV:  data_o <= '1;
                            INST_DIVU: data_o <= '1;
                            INST_REM:  data_o <= dividend_i;
                            INST_REMU: data_o <= dividend_i;
                            default:   data_o <= '0;
                        endcase
                    else if (divisor_i == 32'hffff_ffff && dividend_i == 32'h8000_0000)
                        case (op_i)
                            INST_DIV: data_o <= dividend_i;
                            INST_REM: data_o <= '0;
                            default:  data_o <= '0;
                        endcase
                end
            endcase
        end
    end
endmodule
