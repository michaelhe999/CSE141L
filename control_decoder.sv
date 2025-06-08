module control_decoder (
    input logic [8:0] instruction,
    output logic branch_en, // 0 if not branch, 1 if branch
    output logic write_en, // 0 if not writing to register, 1 if writing to register
    output logic mem_read, // 0 if not reading from memory, 1 if reading from memory
    output logic mem_write, // 0 if not writing to memory, 1 if writing to memory
    output logic use_immediate // 0 if not r1 = r0 + immediate, 1 if r1 = r0 + immediate
);
    logic [1:0] instruction_type;
    logic r_w;

    always_comb begin
        branch = 0; // default value: will we maybe branch if condition is met
        write_reg = 0; // default value: will we write to a register
        mem_read = 0; // default value: will we read from memory
        mem_write = 0; // default value: will we write to memory
        use_immediate = 0; // default value: will we use immediate value (custom to our ISA); basically if we load an immediate into r1

        i_type = instruction[8:7];
        
        r_w = instruction[6];
        if (i_type == 2'b00) begin // R-type instruction
            write_reg = 1; //will write to r1
        end 
        else if (i_type == 2'b01) begin // Branch instruction
            branch = 1;
        end
        else if (i_type == 2'b10) begin // I-type instruction
            write_reg = 1; //will write to any register
            use_immediate = 1; //will use immediate value
        end
        else begin //Load/Store instruction
            if (r_w) begin
                mem_write = 1;
            end
            else begin
                mem_read = 1;
                write_reg = 1; //will write to r1
            end
        end
    end

endmodule