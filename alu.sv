module alu (
    input logic [7:0] alu_input_a, // first operand
    input logic [7:0] alu_input_b, // second operand
    input logic [2:0] alu_opcode, // operation code
    output logic [7:0] alu_out, // result of the operation
    output logic zero // 1 if result is 0, 0 otherwise 
);

logic [7:0] test_overflow ; // temporary variable for overflow output
logic overflow; // overflow flag
    always_comb begin
        test_overflow = 8'b0; // initialize test_overflow to zero
        overflow = 1'b0; // reset overflow flag
        case (alu_opcode)
            3'b000: alu_out = alu_input_a & alu_input_b; // bitwise AND
            3'b001: alu_out = alu_input_a + alu_input_b; // ADD
            3'b010: alu_out = alu_input_a ^ alu_input_b; // bitwise XOR
            3'b011: alu_out = (alu_input_a < alu_input_b) ? 8'b00000001 : 8'b0; // store less than
            3'b100: alu_out = alu_input_a << alu_input_b; // shift left logical
            3'b101: alu_out = alu_input_a >> alu_input_b; // shift right logical
            3'b110: alu_out = (alu_input_a != alu_input_b) ? 8'b00000001 : 8'b0; // compare not equal
            3'b111: begin
                test_overflow = alu_input_a + alu_input_b;
                overflow = 1'b0; // reset overflow flag
                
                // Correct overflow detection for signed addition
                overflow = (alu_input_a[7] == alu_input_b[7]) &&  // Same sign
                        (test_overflow[7] != alu_input_a[7]);  // Different result sign
                alu_out = overflow ? 8'b00000001 : 8'b00000000;
            end

        endcase

        zero = (alu_out == 8'b0); // set zero flag if result is zero
    end

// always @(alu_input_a, alu_input_b, alu_opcode, zero) begin
//     $display("[%0t] ALU Inputs: a=%h, b=%h, opcode=%b, zero=%b, output=%h", 
//              $time, alu_input_a, alu_input_b, alu_opcode, zero, alu_out);
// end

endmodule