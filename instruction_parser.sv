module instruction_parser(
    input logic [8:0] instruction, // 9-bit instruction input
    output logic [2:0] opcode, // 3-bit opcode output
    output logic [1:0] r_a, // 2-bit register A output
    output logic [1:0] r_b, // 2-bit register B output
    output logic [7:0] immediate // 8-bit immediate value output
);

    always_comb begin
        if (instruction == 9'b000000100) begin // move r0 r1: AND R1 R0
            opcode = 3'b001; // ADD operation
        end else if (instruction == 9'b000001000) begin // move r0 r2: AND R2 R0
            opcode = 3'b001; // ADD operation
        end else if (instruction == 9'b000001100) begin // move r0 r3: AND R3 R0
            opcode = 3'b001; // ADD operation
        end else if (instruction == 9'b000001001) begin // move r1 r0: AND R2 R1
            opcode = 3'b001; // ADD operation
        end else if (instruction == 9'b000001101) begin // move r1 r2: AND R3 R1
            opcode = 3'b001; // ADD operation
        end else if (instruction == 9'b000001110) begin // move r1 r3: AND R3 R2
            opcode = 3'b001; // ADD operation
        end else if (instruction == 9'b000010100) begin // move r2 r0: ADD R1 R0
            opcode = 3'b001; // ADD operation
        end else if (instruction == 9'b000011000) begin // move r2 r1: ADD R2 R0
            opcode = 3'b001; // ADD operation
        end else if (instruction == 9'b000011100) begin // move r2 r3: ADD R3 R0
            opcode = 3'b001; // ADD operation
        end else if (instruction == 9'b000011001) begin // move r3 r0: ADD R2 R1
            opcode = 3'b001; // ADD operation
        end else if (instruction == 9'b000011101) begin // move r3 r1: ADD R3 R1
            opcode = 3'b001; // ADD operation
        end else if (instruction == 9'b000011110) begin // move r3 r2: ADD R3 R2
            opcode = 3'b001; // ADD operation
        end else begin
            opcode = instruction[6:4]; // Extracting the opcode from the instruction
            r_a = instruction[3:2]; // Extracting register A from the instruction
            r_b = instruction[1:0]; // Extracting register B from the instruction
            immediate = {instruction[6], instruction[6:0]}; // Sign-extend the immediate value
        end
    end

endmodule