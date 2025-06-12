module program_counter (
    input logic clk,
    input logic reset,
    // input logic [31:0] current_pc, // Instruction memory should not exceed 2^12, but we use 2^32 because it's okay if we do exceed
    input logic zero, 
    input logic branch_en,
    input logic [7:0] immediate,
    output logic [31:0] current_pc_out
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_pc_out <= 32'd0;
        end else begin
            if (branch_en && zero) begin
                // If branch is enabled and zero flag is set, add immediate value to current PC
                current_pc_out <=  current_pc_out + 1 + {{24{immediate[7]}}, immediate};
            end else begin
                current_pc_out <= current_pc_out + 1;
            end
        end
    end

endmodule
