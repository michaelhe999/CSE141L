module alu_control (
    input logic alu_op, // operation code from control unit
    input logic [8:0] instruction, // instruction
    input logic branch, // branch signal
    output logic [2:0] alu_opcode // ALU control signal
);

    always_comb begin
        alu_opcode = 3'b000; // default value
        if (alu_op == 1) begin
            if (branch == 1) begin
                alu_opcode = 3'b110; // compare not equal
            end 
            else begin
                alu_opcode = instruction[6:4];
            end
        end
    end

endmodule