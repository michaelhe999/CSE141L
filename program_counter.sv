module program_counter (
    input  logic        clk,
    input  logic        reset,
    input  logic        should_run_processor,
    input  logic        branch_en,
    input  logic        zero,
    input  logic [7:0]  immediate,
    output logic [31:0] current_pc_out
);

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin  // Asynchronous reset (edge-sensitive)
        current_pc_out <= 32'd0;
    end
    else if (!should_run_processor) begin  // Synchronous control (level-sensitive)
        current_pc_out <= 32'd0;
    end
    else begin
        if (branch_en && zero) begin
            current_pc_out <= current_pc_out + 1 + {{24{immediate[7]}}, immediate};
        end else begin
            current_pc_out <= current_pc_out + 1;
        end
    end
end
endmodule