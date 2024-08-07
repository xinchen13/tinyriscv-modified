module mult (
    input               clk_i,
    input               rst_ni,
    input               valid_i,
    input        [ 2:0] op_i,
    input        [31:0] multiplicand_i,  // 34-bit signed multiplicand
    input        [31:0] multiplier_i,    // 34-bit signed multiplier
    output logic [31:0] result_o,      // 68-bit signed product
    output logic        ready_o
);

    // Internal states and signals
    typedef enum logic [1:0] {
        STATE_IDLE,
        STATE_CALC,
        STATE_END,
        STATE_ERROR
    } state_t;

    state_t state, next_state;

    logic [33:0] A, S, P_t;
    logic [68:0] P;  // Registers for Booth's algorithm
    logic [ 4:0] count;  // To keep track of the number of cycles
    logic [33:0] multiplicand_ext, multiplier_ext;

    always_comb begin
        multiplicand_ext = {multiplicand_i[31], multiplicand_i[31], multiplicand_i};
        multiplier_ext   = {multiplier_i[31], multiplier_i[31], multiplier_i};
    end

    // State machine
    always_ff @(posedge clk_i) begin
        if (~rst_ni) state <= STATE_IDLE;
        else state <= next_state;
    end

    always_comb begin
        next_state = state;
        if (~valid_i) next_state = STATE_IDLE;
        else
            case (state)
                STATE_IDLE: begin
                    next_state = STATE_CALC;
                end
                STATE_CALC: begin
                    if (count == 4'd0) next_state = STATE_END;
                end
                STATE_END: next_state = STATE_IDLE;
                STATE_ERROR: begin
                    next_state = STATE_IDLE;
                end
            endcase
    end

    always_comb begin
        // Booth's Radix-4 Algorithm steps
        case (P[2:0])
            3'b001, 3'b010: P_t = P[68-:34] + A;  // +1 * multiplicand
            3'b011:         P_t = P[68-:34] + (A << 1);  // +2 * multiplicand
            3'b100:         P_t = P[68-:34] + (S << 1);  // -2 * multiplicand
            3'b101, 3'b110: P_t = P[68-:34] + S;  // -1 * multiplicand
            default:        P_t = P[68-:34];  // 3'b000, 3'b111 do nothing
        endcase
    end

    always @(posedge clk_i) begin
        if (~rst_ni | ~valid_i) begin
            result_o <= '0;
            ready_o  <= '0;
            A        <= '0;
            S        <= '0;
            P        <= '0;
            count    <= '0;
        end
        else
            case (state)
                STATE_IDLE: begin
                    case (op_i)
                        3'b000, 3'b001: begin
                            A <= multiplicand_ext;
                            S <= ~multiplicand_ext + 1;
                            P <= {34'b0, multiplier_ext, 1'b0};
                        end
                        3'b010: begin
                            A <= multiplicand_ext;
                            S <= ~multiplicand_ext + 1;
                            P <= {36'b0, multiplier_i, 1'b0};
                        end
                        3'b011: begin
                            A <= {2'b00, multiplicand_i};
                            S <= ~{2'b0, multiplicand_i} + 1;
                            P <= {36'b0, multiplier_i, 1'b0};
                        end
                    endcase
                    count <= 5'd16;  // 34 bits / 2 (Radix-4) = 17 iterations
                    ready_o <= 1'b0;
                end
                STATE_CALC: begin
                    P     <= {P_t[33], P_t[33], P_t, P[34:2]};  // Arithmetic right shift by 2
                    count <= count - 5'b1;
                end
                STATE_END: begin
                    ready_o <= 1'b1;
                    case(op_i)
                        3'b000: result_o <= P[32:1];
                        3'b001, 3'b010, 3'b011: result_o <= P[64:33];
                    endcase
                end
            endcase
    end
endmodule
