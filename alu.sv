module alu (
    input logic [7:0] a, // first operand
    input logic [7:0] b, // second operand
    input logic [2:0] alu_op, // operation code
    output logic [7:0] result, // result of the operation
    output logic zero // 1 if result is 0, 0 otherwise 
);
    always_comb begin
        case (alu_op)
            3'b000: result = a & b; // bitwise AND
            3'b001: result = a + b; // ADD
            3'b010: result = a ^ b; // bitwise XOR
            3'b011: result = (a < b) ? 8'b1 : 8'b0 // store less than
            3'b100: result = a << b; // shift left logical
            3'b101: result = a >> b; // shift right logical
            3'b110: result = !(a == b); // compare not equal
            3'b111: result = 8'b0; // temporary; no operation here yet
            default: result = 8'b0;  // default case
        endcase

        zero = (result == 8'b0); // set zero flag if result is zero
    end

endmodule