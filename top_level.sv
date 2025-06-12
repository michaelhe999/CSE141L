module top_level (
    input  logic        clk,
    input  logic        reset,             // async reset
    input  logic        start, 
    output logic        done 
);

    // Internal signals
    logic [31:0] current_pc; // Program counter
    assign current_pc = 32'd0; // Initial PC value

    logic [8:0] instruction; // Instruction from instruction memory

    logic branch_en; // Branch enable signal
    logic write_en; // Write enable signal
    logic mem_read; // Memory read signal
    logic mem_write; // Memory write signal
    logic use_immediate; // Use immediate value signal

    logic [2:0] opcode; // Opcode from instruction
    logic [1:0] r_a; // Register A from instruction
    logic [1:0] r_b; // Register B from instruction
    logic [7:0] immediate; // Immediate value from instruction

    logic [1:0] write_reg; // Register to write to

    logic [7:0] write_value; // Value to write to the register
    logic [7:0] data_a; // Data value in register A
    logic [7:0] data_b; // Data value in register B
    logic [7:0] data_r1; // Data value in register 1

    logic [2:0] alu_opcode; // ALU operation code

    logic [7:0] data_a_1; // Temporary data_a value for ALU operation
    logic [7:0] data_b_1; // Temporary data_b value for ALU operation

    logic [7:0] alu_input_a; // Input to ALU for operation
    logic [7:0] alu_input_b; // Input to ALU for operation

    logic [7:0] alu_out; // Output from ALU to write to register
    logic zero; // Zero flag for branch condition

    logic [7:0] data_out; // Data read from memory

    logic [31:0] next_pc; // Next PC value

    // Instantiate the modules

    program_counter pc (
        .clk(clk),
        .reset(reset),
        .current_pc(current_pc), // Initial PC value
        .current_pc_out(current_pc)
    );

    instruction_memory im (
        .clk(clk),
        .reset(reset),
        .pc(current_pc),
        .instruction(instruction)
    );

    control_decoder cd (
        .instruction(instruction),
        .branch_en(branch_en),
        .write_en(write_en),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .use_immediate(use_immediate), 
        .done(done) // Output done signal
        .write_reg_en(write_reg_en)
        .special_en(special_en) // Output special instruction enable signal
    );

    instruction_parser ip (
        .instruction(instruction),
        .opcode(opcode),
        .r_a(r_a),
        .r_b(r_b),
        .immediate(immediate)
    )

    mux write_reg_mux #(.WIDTH(2)) (
        .input_0(2'b01), // Default destination register
        .input_1(r_b), // Variable destination register for memory read
        .select(write_reg_en),
        .output_1(write_reg) // Destination register for writing
    )

    register_file rf (
        .clk(clk),
        .reset(reset),
        .r_a(r_a), // Register A to read from
        .r_b(r_b), // Register B to read from
        .write_en(write_en), // Write enable signal
        .write_reg(write_reg), // Register to write to
        .write_value(write_value), // Value to write to the register
        .data_a(data_a), // Data value in register A
        .data_b(data_b) // Data value in register B
        .data_r1(data_r1) // Data value in register 1
    );

    mux alu_opcode_mux #(.WIDTH(3)) (
        .input_0(opcode), // Given opcode
        .input_1(3'b110), // ALU operation for branching
        .select(branch_en), // Select ALU operation based on branch enable
        .output_1(alu_opcode) // ALU operation code
    );

    mux data_a_imm_mux (
        .input_0(data_a), // Data from register A
        .input_1(8'b00000000), // all 0s for setting immediate value
        .select(use_immediate), // Select between register data and 0s
        .output_1(data_a_1) // Temp data_a value
    );

    mux data_b_imm_mux (
        .input_0(data_b), // Data from register A
        .input_1(immediate), // Immediate value from instruction
        .select(use_immediate), // Select between register data and immediate value
        .output_1(data_b_1) // Temp data_b value
    );

    mux data_a_branch_mux (
        .input_0(data_a_1), // Data from register A
        .input_1(8'b00000000), // all 0s for checking branch condition
        .select(branch_en), // Select between data_a and 0s
        .output_1(alu_input_a) // Input to ALU for operation
    );

    mux data_b_branch_mux (
        .input_0(data_b_1), // Data from register A
        .input_1(data_r1), // Data from register 1
        .select(branch_en), // Select between data_a and data_r1
        .output_1(data_b_2) // Input to ALU for operation
    );

    mux special_en_mux (
        .input_0(data_b_2), // Data from register B
        .input_1(8'b00000000), // all 0s for special instruction
        .select(special_en), // Select between data_b and 0s
        .output_1(alu_input_b) // Input to ALU for operation
    );

    alu alu (
        .alu_input_a(alu_input_a), // Input A to ALU
        .alu_input_b(alu_input_b), // Input B to ALU
        .alu_opcode(alu_opcode), // ALU operation code
        .alu_out(alu_out) // Output from ALU to write to register
        .zero(zero) // Zero flag for branch condition
    );

    data_memory dm (
        .clk(clk),
        .reset(reset),
        .mem_read(mem_read), // Memory read signal
        .mem_write(mem_write), // Memory write signal
        .data_a(data_a), // address to read from/write to
        .data_b(data_b), // data to write to memory if mem_write = 1
        .data_out(data_out) // Data read from memory
    );
    
    mux mem_to_reg_mux (
        .input_0(alu_out), // ALU output
        .input_1(data_out), // Memory output
        .select(mem_read), // Select between ALU output and memory output
        .output_1(write_value) // Value to write to register file
    );

    mux #(.WIDTH(32)) pc_src_mux (
        .input_a(current_pc + 1), // Default next PC is current PC + 4
        .input_b(current_pc + 1 + {{24{immediate[7]}}, immediate}), // Sign-extended immediate value
        .select(branch_en & zero), // Select the branch target if branch is taken and zero flag is set
        .output_1(next_pc) // Output the next PC value
    );



// FSM STATES

// START STATE
// Transition into the next state immediately after the testbench starts
// and reset the registers and memory

// HOLD STATE
// While START = 1: hold the FSM in this state
// When START = 0, transition to the program state

// PROGRAM STATE
// ummm
// When program is done, output DONE = 1 and transition to the hold state

endmodule