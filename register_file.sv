module register_file (
    input  logic        clk,
    input  logic        reset,             // async reset
    input  logic [1:0]  r_a,               // register A to read from (0-3)
    input  logic [1:0]  r_b,               // register B to read from (0-3)
    input  logic        write_en,          // 1 to write to register
    input  logic [1:0]  write_reg,          // register to write to (0-3)
    input  logic [7:0]  write_value,       // value to write
    output logic [7:0]  data_a,            // data value in register A
    output logic [7:0]  data_b,             // data value in register B
    output logic [7:0]  data_r1            // data value in register 1
);

    logic [7:0] registers [3:0]; // 4 registers, 8 bits each
    // Async read paths (critical fix)
    assign data_a = registers[r_a];
    assign data_b = registers[r_b]; 
    assign data_r1 = registers[1];

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            registers <= '{default: 8'b0};  // SystemVerilog array init
        end else if (write_en) begin
            registers[write_reg] <= write_value;
        end
    end

    // Debug outside always_ff
    always_comb begin
        $display("Register Reads: r_a=%d (0x%h) r_b=%d (0x%h) @ %t", 
                r_a, data_a, r_b, data_b, $time);
    end

endmodule
