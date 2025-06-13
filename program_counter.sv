module program_counter (
    input  logic        clk,
    input  logic        reset,
    input  logic        branch_en,
    input  logic        zero,
    input  logic [7:0]  immediate,
    output logic [31:0] current_pc_out
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_pc_out <= 32'd0;
        end else begin
            // Calculate next PC value internally
            if (branch_en && zero) begin
                current_pc_out <= current_pc_out + 1 + {{24{immediate[7]}}, immediate};
            end else begin
                current_pc_out <= current_pc_out + 1;
            end
        end
    end
endmodule