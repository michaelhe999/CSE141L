module instruction_memory(
    input logic clk,
    input logic reset,
    input logic [31:0] pc,
    output logic [8:0] instruction
);

    always_comb begin
        instruction = 9'b000000000; //value at pc; temporary value for now
    end

endmodule