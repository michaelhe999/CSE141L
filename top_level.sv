module top_level (
    input  logic clk,
    input  logic reset,
    input  logic start, 
    output logic done
);

pc = 0;
done = 0;
done_count = 0;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        pc = 0;
        done = 0;
        done_count = 0;
    end
    while (done_count < 3) begin
        wait(!start);
        // Do first program
        // if done == 1, then break out of the loop
        while (!done) begin
            // read instruction at pc
            instruction_memory im(
                .clk(clk),
                .reset(reset),
                .pc(pc),
                .instruction(instruction)
            );
            if instruction == 010000000 begin
                done = 1;
            end
            // decode instruction
            control_decoder cd(
                .instruction(instruction),
                .branch(branch),
                .alu_op(alu_op),
                .write_reg(write_reg),
                .mem_to_reg(mem_to_reg),
                .mem_read(mem_read),
                .mem_write(mem_write),
                .use_immediate(use_immediate)
            );
            alu_control ac(
                .alu_op(alu_op),
                .instruction(instruction),
                .branch(branch),
                .alu_opcode(alu_opcode)
            );
            register_file rf(
                .clk(clk),
                .reset(reset),
                .finished_step(0),
                .instruction(instruction),
                .write_reg(write_reg),
                .mem_read(mem_read),
                .use_immediate(use_immediate),
                .branch(branch),
                .write_value(0),
                .r_a(r_a),
                .r_b(r_b)
            );
            // execute instruction
            // do mux to see if we are using immediate or not
            alu_src_mux asm(
                .use_immediate(use_immediate),
                .r_b(r_b),
                .immediate(instruction[6:0]),
                .alu_input2(alu_input2)
            );
            alu alu(
                .a(r_a),
                .b(alu_input2),
                .alu_op(alu_opcode),
                .result(result),
                .zero(zero)
            );
             // memory access :(
            data_memory dm(
                .clk(clk),
                .reset(reset),
                .mem_read(mem_read),
                .mem_write(mem_write),
                .r_a(r_a),
                .r_b(r_b),
                .data_out(data_out),
            );
            mem_to_reg_mux mtrm(
                .mem_to_reg(mem_to_reg),
                .alu_out(result),
                .mem_out(data_out),
                .write_value(write_value)
            );
            register_file rf (
                .clk(clk),
                .reset(reset),  
                .finished_step(1),  
                .instruction(instruction),
                .write_reg(write_reg), 
                .mem_read(mem_read),     
                .use_immediate(use_immediate),
                .branch(branch),
                .write_value(write_value),
                .r_a(r_a),  
                .r_b(r_b)
            );
            // increment pc
            program_counter pc(
                .clk(clk),
                .reset(reset),
                .current_pc(pc),
                .instruction(instruction),
                .branch(branch),
                .zero(zero),
                .next_pc(pc)
            );
        end
        done_count = done_count + 1;
        wait(start);
        done = 0;
        // SECOND PROGRAM
        wait(!start);
        // Do second program
        // if done == 1, then break out of the loop
        while (!done) begin
            // read instruction at pc
            instruction_memory im(
                .clk(clk),
                .reset(reset),
                .pc(pc),
                .instruction(instruction)
            );
            if instruction == 010000000 begin
                done = 1;
            end
            // decode instruction
            control_decoder cd(
                .instruction(instruction),
                .branch(branch),
                .alu_op(alu_op),
                .write_reg(write_reg),
                .mem_to_reg(mem_to_reg),
                .mem_read(mem_read),
                .mem_write(mem_write),
                .use_immediate(use_immediate)
            );
            alu_control ac(
                .alu_op(alu_op),
                .instruction(instruction),
                .branch(branch),
                .alu_opcode(alu_opcode)
            );
            register_file rf(
                .clk(clk),
                .reset(reset),
                .finished_step(0),
                .instruction(instruction),
                .write_reg(write_reg),
                .mem_read(mem_read),
                .use_immediate(use_immediate),
                .branch(branch),
                .write_value(0),
                .r_a(r_a),
                .r_b(r_b)
            );
            // execute instruction
            // do mux to see if we are using immediate or not
            alu_src_mux asm(
                .use_immediate(use_immediate),
                .r_b(r_b),
                .immediate(instruction[6:0]),
                .alu_input2(alu_input2)
            );
            alu alu(
                .a(r_a),
                .b(alu_input2),
                .alu_op(alu_opcode),
                .result(result),
                .zero(zero)
            );
             // memory access :(
            data_memory dm(
                .clk(clk),
                .reset(reset),
                .mem_read(mem_read),
                .mem_write(mem_write),
                .r_a(r_a),
                .r_b(r_b),
                .data_out(data_out),
            );
            mem_to_reg_mux mtrm(
                .mem_to_reg(mem_to_reg),
                .alu_out(result),
                .mem_out(data_out),
                .write_value(write_value)
            );
            register_file rf (
                .clk(clk),
                .reset(reset),  
                .finished_step(1),  
                .instruction(instruction),
                .write_reg(write_reg), 
                .mem_read(mem_read),     
                .use_immediate(use_immediate),
                .branch(branch),
                .write_value(write_value),
                .r_a(r_a),  
                .r_b(r_b)
            );
            // increment pc
            program_counter pc(
                .clk(clk),
                .reset(reset),
                .current_pc(pc),
                .instruction(instruction),
                .branch(branch),
                .zero(zero),
                .next_pc(pc)
            );
        end
        done_count = done_count + 1;
        wait(start);
        done = 0;
        // THIRD PROGRAM
        wait(!start);
        // Do third program
        // if done == 1, then break out of the loop
        while (!done) begin
            // read instruction at pc
            instruction_memory im(
                .clk(clk),
                .reset(reset),
                .pc(pc),
                .instruction(instruction)
            );
            if instruction == 010000000 begin
                done = 1;
            end
            // decode instruction
            control_decoder cd(
                .instruction(instruction),
                .branch(branch),
                .alu_op(alu_op),
                .write_reg(write_reg),
                .mem_to_reg(mem_to_reg),
                .mem_read(mem_read),
                .mem_write(mem_write),
                .use_immediate(use_immediate)
            );
            alu_control ac(
                .alu_op(alu_op),
                .instruction(instruction),
                .branch(branch),
                .alu_opcode(alu_opcode)
            );
            register_file rf(
                .clk(clk),
                .reset(reset),
                .finished_step(0),
                .instruction(instruction),
                .write_reg(write_reg),
                .mem_read(mem_read),
                .use_immediate(use_immediate),
                .branch(branch),
                .write_value(0),
                .r_a(r_a),
                .r_b(r_b)
            );
            // execute instruction
            // do mux to see if we are using immediate or not
            alu_src_mux asm(
                .use_immediate(use_immediate),
                .r_b(r_b),
                .immediate(instruction[6:0]),
                .alu_input2(alu_input2)
            );
            alu alu(
                .a(r_a),
                .b(alu_input2),
                .alu_op(alu_opcode),
                .result(result),
                .zero(zero)
            );
             // memory access :(
            data_memory dm(
                .clk(clk),
                .reset(reset),
                .mem_read(mem_read),
                .mem_write(mem_write),
                .r_a(r_a),
                .r_b(r_b),
                .data_out(data_out),
            );
            mem_to_reg_mux mtrm(
                .mem_to_reg(mem_to_reg),
                .alu_out(result),
                .mem_out(data_out),
                .write_value(write_value)
            );
            register_file rf (
                .clk(clk),
                .reset(reset),  
                .finished_step(1),  
                .instruction(instruction),
                .write_reg(write_reg), 
                .mem_read(mem_read),     
                .use_immediate(use_immediate),
                .branch(branch),
                .write_value(write_value),
                .r_a(r_a),  
                .r_b(r_b)
            );
            // increment pc
            program_counter pc(
                .clk(clk),
                .reset(reset),
                .current_pc(pc),
                .instruction(instruction),
                .branch(branch),
                .zero(zero),
                .next_pc(pc)
            );
        end
        done_count = done_count + 1;
        wait(start);
        done = 0;
    end
end


endmodule