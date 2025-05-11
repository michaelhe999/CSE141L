module program_counter (
    input logic clk,
    input logic reset,
    input logic [31:0] current_pc, // Instruction memory should not exceed 2^12, but we use 2^32 because it's okay if we do exceed
    input logic [8:0] instruction,
    input logic branch,
    input logic zero,
    output logic [31:0] next_pc
);

    logic [31:0] pc_plus_4;
    always_comb begin
        pc_plus_4 = current_pc + 4;
        // use the pc_src_mux to select the next pc
        // if the pc_src is 1, then use the branch_pc
        // if the pc_src is 0, then use the next_pc
    end
    pc_src_mux psm(
            .next_pc(pc_plus_4),
            .instruction(instruction),
            .branch(branch),
            .zero(zero),
            .pc_out(next_pc)
        );
    // if reset is 1, then set the pc to 0
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            next_pc <= 0;
        end else begin
            next_pc <= next_pc;
        end
    end

endmodule