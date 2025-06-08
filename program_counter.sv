module program_counter (
    input logic clk,
    input logic reset,
    input logic [31:0] current_pc, // Instruction memory should not exceed 2^12, but we use 2^32 because it's okay if we do exceed
    input logic [31:0] next_pc, // Next PC value to be set
    output logic [31:0] current_pc_out
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_pc_out <= 32'd0;
        end else begin
            current_pc_out <= current_pc;
            current_pc <= next_pc; // Update PC to next PC value
        end
    end

endmodule
