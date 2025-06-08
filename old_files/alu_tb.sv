`timescale 1ns/1ps

module alu_tb;

    // Inputs
    logic [7:0] a;
    logic [7:0] b;
    logic [2:0] alu_op;

    // Outputs
    logic [7:0] result;
    logic zero;

    // Instantiate the DUT (Device Under Test)
    alu dut (
        .a(a),
        .b(b),
        .alu_op(alu_op),
        .result(result),
        .zero(zero)
    );

    // Task to display results
    task print_result;
        $display("Time = %0t | a = %0d | b = %0d | alu_op = %b | result = %0d | zero = %0b",
                 $time, a, b, alu_op, result, zero);
    endtask

    initial begin
        // Test bitwise AND
        a = 8'hF0; b = 8'h0F; alu_op = 3'b000; #10; print_result();

        // Test ADD
        a = 8'd20; b = 8'd22; alu_op = 3'b001; #10; print_result();

        // Test bitwise XOR
        a = 8'hAA; b = 8'h55; alu_op = 3'b010; #10; print_result();

        // Test SLT (Set Less Than)
        a = 8'd10; b = 8'd15; alu_op = 3'b011; #10; print_result();
        a = 8'd20; b = 8'd10; alu_op = 3'b011; #10; print_result();

        // Test Shift Left Logical
        a = 8'b00000001; b = 8'd3; alu_op = 3'b100; #10; print_result();

        // Test Shift Right Logical
        a = 8'b10000000; b = 8'd7; alu_op = 3'b101; #10; print_result();

        // Test Not Equal
        a = 8'd25; b = 8'd25; alu_op = 3'b110; #10; print_result();
        a = 8'd25; b = 8'd30; alu_op = 3'b110; #10; print_result();

        $finish;
    end

endmodule
