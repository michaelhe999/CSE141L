module pc_src_mux(
    input logic [31:0] next_pc, 
    input logic [8:0] instruction,
    input logic branch,
    input logic zero,
    output logic [31:0] pc_out
);

always_comb begin
    if (branch & zero) begin
        signed [7:0] branch_distance;
        branch_distance = $signed(instruction[6:0]);
        pc_out = next_pc + branch_distance; // branch offset
    end else begin
        pc_out = next_pc;
    end
end

endmodule