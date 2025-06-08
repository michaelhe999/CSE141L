module pc_src_mux(
    input  logic [31:0] next_pc, 
    input  logic [8:0]  instruction,
    input  logic        branch,
    input  logic        zero,
    output logic [31:0] pc_out
);

    // Sign-extend instruction[8:0] before shifting
    logic signed [8:0] branch_offset;

    always_comb begin
        branch_offset = $signed({instruction[6:0], 2'b00}); // sign-extend and shift left by 1 (×2)
        if (branch & zero) begin
            pc_out = next_pc + branch_offset;
        end else begin
            pc_out = next_pc;
        end
    end

endmodule