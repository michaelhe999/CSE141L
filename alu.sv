module alu (
    input logic [7:0] alu_input_a, // first operand
    input logic [7:0] alu_input_b, // second operand
    input logic [2:0] alu_opcode, // operation code
    output logic [7:0] alu_out, // result of the operation
    output logic zero // 1 if result is 0, 0 otherwise 
);
    always_comb begin
        case (alu_opcode)
            3'b000: alu_out = alu_input_a & alu_input_b; // bitwise AND
            3'b001: alu_out = alu_input_a + alu_input_b; // ADD
            3'b010: alu_out = alu_input_a ^ alu_input_b; // bitwise XOR
            3'b011: alu_out = (alu_input_a < alu_input_b) ? 8'b1 : 8'b0; // store less than
            3'b100: alu_out = alu_input_a << alu_input_b; // shift left logical
            3'b101: alu_out = alu_input_a >> alu_input_b; // shift right logical
            3'b110: alu_out = (alu_input_a != alu_input_b) ? 8'b1 : 8'b0; // compare not equal
            3'b111: alu_out = 8'b0; // temporary; no operation here yet
            default: alu_out = 8'b0;  // default case
        endcase

        zero = (alu_out == 8'b0); // set zero flag if result is zero
    end

    always @(alu_input_a, alu_input_b, alu_opcode) begin
        $display("[%0t] ALU Inputs: a=%h, b=%h, opcode=%b", 
                $time, alu_input_a, alu_input_b, alu_opcode);
    end

endmodule