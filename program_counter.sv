module program_counter (
    input logic [31:0] current_pc, // Instruction memory should not exceed 2^12, but we use 2^32 because it's okay if we do exceed
    input logic [8:0] instruction,
    input logic branch,
    input logic zero,
    output logic [31:0] next_pc
);

    always_comb begin
        next_pc = current_pc + 4;
        // use the pc_src_mux to select the next pc
        // if the pc_src is 1, then use the branch_pc
        // if the pc_src is 0, then use the next_pc
        pc_src_mux psm(
            .next_pc(next_pc),
            .instruction(instruction),
            .branch(branch),
            .zero(zero),
            .pc_out(next_pc)
        );
    end

endmodule