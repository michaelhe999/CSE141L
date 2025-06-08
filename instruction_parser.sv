module instruction_parser(
    input logic [8:0] instruction, // 9-bit instruction input
    output logic [2:0] opcode, // 3-bit opcode output
    output logic [1:0] r_a, // 2-bit register A output
    output logic [1:0] r_b, // 2-bit register B output
    output logic [7:0] immediate // 8-bit immediate value output
);

    always_comb begin
        opcode = instruction[6:4]; // Extracting the opcode from the instruction
        r_a = instruction[3:2]; // Extracting register A from the instruction
        r_b = instruction[1:0]; // Extracting register B from the instruction
        immediate = {instruction[6], instruction[6:0]}; // Sign-extend the immediate value
    end

endmodule