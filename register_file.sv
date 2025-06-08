module register_file (
    input  logic        clk,
    input  logic        reset,             // async reset
    input  logic [1:0]  r_a,               // register A to read from (0-3)
    input  logic [1:0]  r_b,               // register B to read from (0-3)
    input  logic        write_en,          // 1 to write to register
    input  logic [1:0]  write_reg          // register to write to (0-3)
    input  logic [7:0]  write_value,       // value to write
    output logic [7:0]  data_a,            // data value in register A
    output logic [7:0]  data_b             // data value in register B
    output logic [7:0]  data_r1            // data value in register 1
);

    logic [7:0] registers [3:0]; // 4 registers, 8 bits each
    assign data_a = registers[r_a]; // Read from register A
    assign data_b = registers[r_b]; // Read from register B
    assign data_r1 = registers[1]; // Read from register 1

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            registers[0] <= 8'b0;
            registers[1] <= 8'b0;
            registers[2] <= 8'b0;
            registers[3] <= 8'b0;
        end else if (write_en) begin
            registers[write_reg] <= write_value;
        end
    end

endmodule
