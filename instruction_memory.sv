module instruction_memory(
    input logic clk,
    input logic reset,
    input logic [31:0] current_pc,
    output logic [8:0] instruction
);

    logic [8:0] memory_array [4096]; // up to 4096 instructions (can change), 9-bit each

    initial begin
        $readmemb("machine_code.txt", memory_array); // load instruction memory from file
    end

    always_comb begin
        instruction = memory_array[current_pc[11:0]]; // use lower 12 bits of PC (2^12 is our soft limit)
    end

endmodule

