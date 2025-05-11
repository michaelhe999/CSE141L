module register_file (
    input  logic        clk,
    input  logic        reset,             // async reset
    input  logic        finished_step,     // 1 if finished with 1 instruction
    input  logic [8:0]  instruction,       // instruction bits
    input  logic        write_reg,         // 1 to write to register
    input  logic        mem_read,          // 1 if reading from memory
    input  logic        use_immediate,     // 1 if instruction uses immediate
    input  logic        branch,            // 1 if branch
    input  logic [7:0]  write_value,       // value to write
    output logic [1:0]  write_dest,        // destination register
    output logic [7:0]  r_a,               // read value A
    output logic [7:0]  r_b                // read value B
);

    logic [7:0] registers [3:0]; // 4 registers, 8 bits each

    // Write destination combinational logic
    assign write_dest = (mem_read) ? instruction[1:0] : 2'b01;

    // Read logic (combinational)
    always_comb begin
        // Default values
        r_a = 8'b0;
        r_b = 8'b0;

        if (mem_read) begin
            r_a = registers[instruction[3:2]];
        end else if (use_immediate) begin
            r_a = registers[0]; // r0
        end else if (branch) begin
            r_a = registers[0];
            r_b = registers[1];
        end else begin
            r_a = registers[instruction[3:2]];
            r_b = registers[instruction[1:0]];
        end
    end

    // Reset and write logic (sequential)
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            registers[0] <= 8'b0;
            registers[1] <= 8'b0;
            registers[2] <= 8'b0;
            registers[3] <= 8'b0;
        end else if (finished_step && write_reg) begin
            registers[write_dest] <= write_value;
        end
    end

endmodule
