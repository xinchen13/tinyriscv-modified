module debounce (
    input  logic clk_i,      // Clock input
    input  logic button_in,  // Raw button input
    output logic button_out  // Debounced button output
);

    // Constants
    localparam integer DEBOUNCE_INTERVAL = 4000000;  // 80ms at 50MHz

    // Internal signals
    logic [21:0] counter;  // 22-bit counter to handle up to 4 million cycles
    logic        button_state;  // Internal stable state of the button

    // Debouncing logic
    always_ff @(posedge clk_i) begin
        if (button_in == button_state) begin
            // Increment counter if the state is stable
            if (counter < DEBOUNCE_INTERVAL) begin
                counter <= counter + 1;
            end
            else begin
                // Only update the output if the counter reaches its maximum value
                button_out <= button_state;
            end
        end
        else begin
            // Reset the counter if the state changes
            counter      <= 0;
            button_state <= button_in;
        end
    end
endmodule
