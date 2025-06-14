module data_memory(
    input logic clk,
    input logic reset,
    input logic mem_read,
    input logic mem_write,
    input logic [7:0] data_a, //address for where to read from and also where to write to
    input logic [7:0] data_b, //value to write to memory if it's a write
    output logic [7:0] data_out
);

    logic [7:0] mem_core [256]; // 256 bytes of memory

    always_ff @(posedge clk)
        if(mem_write) begin
            $display("WRITE: mem[%0d] <= %h at time %t", data_a, data_b, $time);
            mem_core[data_a] <= data_b;
        end

    assign data_out = mem_core[data_a];

endmodule