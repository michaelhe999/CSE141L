module mem_to_reg_mux(
    input logic mem_to_reg, // 1 if we want to use memory value, 0 if we want to use ALU value
    input logic [7:0] alu_out, // output from ALU
    input logic [7:0] mem_out, // output from memory
    output logic [7:0] write_value // value to be written to register file
);

    always_comb begin
        if (mem_to_reg) begin
            write_value = mem_out; // use memory value
        end else begin
            write_value = alu_out; // use ALU value
        end
    end

endmodule