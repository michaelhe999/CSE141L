module register_file (
    input logic reset, // reset signal
    input logic finished_step, // 0 if not finished, 1 if finished with 1 instruction (need to maybe write)
    input logic[8:0] instruction, // instruction
    input logic write_reg, // 0 if not writing to register, 1 if writing to register
    input logic mem_read, // 0 if not reading from memory, 1 if reading from memory
    input logic use_immediate, // 0 if not r1 = r0 + immediate, 1 if r1 = r0 + immediate
    input logic branch, // 0 if not branch, 1 if branch
    input logic[7:0] write_value, // value to write to register
    output logic[1:0] write_dest, // destination register to write to
    output logic[7:0] r_a, // value in first read register
    output logic[7:0] r_b // value in second read register
);

    logic [7:0] registers [0:3]; // 4 registers, 8 bits each
    registers[0] = 8'b00000000; // r0
    if (reset) begin
        registers[1] = 8'b00000000; // r1
        registers[2] = 8'b00000000; // r2
        registers[3] = 8'b00000000; // r3
    end

    always_comb begin
        logic[1:0] write_dest;
        write_dest = 2'b01; // default value
        if (mem_read) begin
            r_a = registers[instruction[3:2]];
            r_b = registers[0]; // r0; default; doesn't matter
            write_dest = instruction[1:0];
        //mem_write is handled with the else
        end else if (use_immediate) begin
            r_a = registers[0]; // r0
            r_b = registers[0]; // r0; default; doesn't matter
        end else if (branch) begin
            r_a = registers[0];
            r_b = registers[1];
        end else begin
            r_a = registers[instruction[3:2]]
            r_b = registers[instruction[1:0]]
        end
        if (finished_step) begin
            if (write_reg) begin
                registers[write_dest] = write_value;
            end
        end
    end

    

    

endmodule