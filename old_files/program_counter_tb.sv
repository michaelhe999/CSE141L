`timescale 1ns/1ps

module program_counter_tb;

    // Inputs
    logic [31:0] current_pc;
    logic [8:0] instruction;
    logic branch;
    logic zero;

    // Output
    logic [31:0] next_pc;

    // Instantiate the DUT (Design Under Test)
    program_counter dut (
        .current_pc(current_pc),
        .instruction(instruction),
        .branch(branch),
        .zero(zero),
        .next_pc(next_pc)
    );

    // Task to display output
    task print_state;
        $display("Time = %0t | current_pc = %0d | instruction = %0b | branch = %0b | zero = %0b | next_pc = %0d",
                 $time, current_pc, instruction, branch, zero, next_pc);
    endtask

    initial begin
        // Test 1: Normal PC increment without branch
        current_pc = 32'h0000_0000;
        instruction = 9'b000000000; // irrelevant
        branch = 0;
        zero = 0;
        #10;
        print_state();

        // Test 2: Branch taken (branch = 1, zero = 1) with positive offset
        current_pc = 32'h0000_0004;
        instruction = 9'b000001010; // offset = 0x0A = 10
        branch = 1;
        zero = 1;
        #10;
        print_state();

        // Test 3: Branch not taken (branch = 1, zero = 0)
        current_pc = 32'h0000_0008;
        instruction = 9'b111111111; // large offset, but should not be taken
        branch = 1;
        zero = 0;
        #10;
        print_state();

        // Test 4: Branch taken with negative offset
        current_pc = 32'h0000_000C;
        instruction = 9'b111111100; // offset = -4 (2's complement of 0b1111100)
        branch = 1;
        zero = 1;
        #10;
        print_state();

        $finish;
    end

endmodule
