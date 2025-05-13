module data_memory(
    input logic clk,
    input logic reset,
    input logic mem_read,
    input logic mem_write,
    input logic [7:0] r_a, //address for where to read from and also where to write to
    input logic [7:0] r_b, //value to write to memory if it's a write
    output logic [7:0] data_out
);

always_comb begin
    data_out = 8'b0; // default value
    if (mem_read) begin
        data_out = 0; //value at address r_a (fake value for now)
    end else if (mem_write) begin
        data_out = 0; //address at r_a gets value r_b (fake value for now)
    end else begin
        data_out = 8'b0; // default value
    end
endcase



endmodule