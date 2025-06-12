module instruction_memory(
    input logic clk,
    input logic reset,
    input logic [31:0] current_pc,
    output logic [8:0] instruction
);

    logic [8:0] memory_array [4096]; // up to 4096 instructions (can change), 9-bit each

    initial begin
        $readmemb("C:/Users/mih024/Desktop/CSE_141L_Project_Files/program_1_machinecode.txt", memory_array); // load instruction memory from file
        //$readmemb("program_2_machinecode.txt", memory_array);
        //$readmemb("program_3_machinecode.txt", memory_array);
    end

    always_comb begin
        instruction = memory_array[current_pc[11:0]]; // use lower 12 bits of PC (2^12 is our soft limit)
    end

endmodule

