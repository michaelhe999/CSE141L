module control_decoder (
    input logic [8:0] instruction,
    output logic branch_en, // 0 if not branch, 1 if branch
    output logic write_en, // 0 if not writing to register, 1 if writing to register
    output logic mem_read, // 0 if not reading from memory, 1 if reading from memory
    output logic mem_write, // 0 if not writing to memory, 1 if writing to memory
    output logic use_immediate, // 0 if not r1 = r0 + immediate, 1 if r1 = r0 + immediate
    output logic done, // 0 if not done, 1 if done
    output logic write_reg_en, // 0 if writing to r1, 1 if writing to any register
    output logic special_en // 0 if not special instruction, 1 if special instruction
);
    logic [1:0] instruction_type;
    logic r_w;
    logic [1:0] i_type; // Instruction type: 00 for R-type, 01 for branch, 10 for I-type, 11 for load/store

    always_comb begin
        branch_en = 0; // default value: will we maybe branch if condition is met
        write_en = 0; // default value: will we write to a register
        mem_read = 0; // default value: will we read from memory
        mem_write = 0; // default value: will we write to memory
        use_immediate = 0; // default value: will we use immediate value (custom to our ISA); basically if we load an immediate into r1
        done = 0; // default value: will we be done with the instruction
        write_reg_en = 0; // default value: will we write to r1

        // Handle special instructions
        if (instruction == 9'b010000000) begin
            done = 1; // Special instruction to indicate done
        end else if (instruction == 9'b000000100) begin // move r0 r1: AND R1 R0
            write_en = 1; // will write to a register
            write_reg_en = 1; // will write to any register
            special_en = 1; // special instruction
        end else if (instruction == 9'b000001000) begin // move r0 r2: AND R2 R0
            write_en = 1; // will write to a register
            write_reg_en = 1; // will write to any register
            special_en = 1; // special instruction
        end else if (instruction == 9'b000001100) begin // move r0 r3: AND R3 R0
            write_en = 1; // will write to a register
            write_reg_en = 1; // will write to any register
            special_en = 1; // special instruction
        end else if (instruction == 9'b000001001) begin // move r1 r0: AND R2 R1
            write_en = 1; // will write to a register
            write_reg_en = 1; // will write to any register
            special_en = 1; // special instruction
        end else if (instruction == 9'b000001101) begin // move r1 r2: AND R3 R1
            write_en = 1; // will write to a register
            write_reg_en = 1; // will write to any register
            special_en = 1; // special instruction
        end else if (instruction == 9'b000001110) begin // move r1 r3: AND R3 R2
            write_en = 1; // will write to a register
            write_reg_en = 1; // will write to any register
            special_en = 1; // special instruction
        end else if (instruction == 9'b000010100) begin // move r2 r0: ADD R1 R0
            write_en = 1; // will write to a register
            write_reg_en = 1; // will write to any register
            special_en = 1; // special instruction
        end else if (instruction == 9'b000011000) begin // move r2 r1: ADD R2 R0
            write_en = 1; // will write to a register
            write_reg_en = 1; // will write to any register
            special_en = 1; // special instruction
        end else if (instruction == 9'b000011100) begin // move r2 r3: ADD R3 R0
            write_en = 1; // will write to a register
            write_reg_en = 1; // will write to any register
            special_en = 1; // special instruction
        end else if (instruction == 9'b000011001) begin // move r3 r0: ADD R2 R1
            write_en = 1; // will write to a register
            write_reg_en = 1; // will write to any register
            special_en = 1; // special instruction
        end else if (instruction == 9'b000011101) begin // move r3 r1: ADD R3 R1
            write_en = 1; // will write to a register
            write_reg_en = 1; // will write to any register
            special_en = 1; // special instruction
        end else if (instruction == 9'b000011110) begin // move r3 r2: ADD R3 R2
            write_en = 1; // will write to a register
            write_reg_en = 1; // will write to any register
            special_en = 1; // special instruction
        end

        i_type = instruction[8:7];
        
        r_w = instruction[6];
        if (i_type == 2'b00) begin // R-type instruction
            write_en = 1; //will write to r1
        end 
        else if (i_type == 2'b01) begin // Branch instruction
            branch_en = 1;
        end
        else if (i_type == 2'b10) begin // I-type instruction
            write_en = 1; //will write to any register
            use_immediate = 1; //will use immediate value
        end
        else begin // Load/Store instruction
            if (r_w) begin
                mem_write = 1;
            end
            else begin
                mem_read = 1;
                write_reg_en = 1; // will write to any register
                write_en = 1; //will write to a register
            end
        end
    end
    always_comb begin
        $display("Control: use_immediate=%b, write_en=%b, mem_read=%b, mem_write=%b, write_reg_en=%b, 
        special_en=%b, instruction=%b", use_immediate, write_en, mem_read, mem_write, write_reg_en, 
        special_en, instruction);
    end

endmodule