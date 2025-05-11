module control_decoder (
    input logic [8:0] instruction,
    output logic branch, // 0 if not branch, 1 if branch
    output logic [2:0] alu_op, // 3-bit ALU operation code
    output logic write_reg, // 0 if not writing to register, 1 if writing to register
    output logic mem_to_reg, // 0 if not writing to memory, 1 if writing to memory
    output logic mem_read, // 0 if not reading from memory, 1 if reading from memory
    output logic mem_write // 0 if not writing to memory, 1 if writing to memory
    output logic use_immediate // 0 if not r1 = r0 + immediate, 1 if r1 = r0 + immediate
    
);

    always_comb begin
        branch = 0; // default value: will we maybe branch if condition is met
        alu_op = 0; // default value: do we need to use the alu
        write_reg = 0; // default value: will we write to a register
        mem_to_reg = 0; // default value: will we use output of ALU or data in memory to write to r1
        mem_read = 0; // default value: will we read from memory
        mem_write = 0; // default value: will we write to memory
        use_immediate = 0; // default value: will we use immediate value (custom to our ISA); basically if we load an immediate into r1

        logic [1:0] type;
        type = instruction[8:7];
        logic r_w;
        r_w = instruction[6];
        if type == 2'b00 begin
            alu_op = 1;
            write_reg = 1; //will write to r1
        end 
        else if type == 2'b01 begin
            branch = 1;
            alu_op = 1;
        end
        else if type == 2'b10 begin
            write_reg = 1; //will write to any register
            alu_op = 1;
            use_immediate = 1; //will use immediate value
        end
        else begin
            if r_w begin
                mem_write = 1;
            end
            else begin
                mem_read = 1;
                write_reg = 1; //will write to r1
                mem_to_reg = 1; //chooses data from memory instead of output of ALU
            end
        end
    end
);

endmodule