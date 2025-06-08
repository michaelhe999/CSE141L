module mux #(parameter WIDTH = 8) // Width of the input signals
(
    input  logic [WIDTH-1:0] input_0, // chosen when select is 0
    input  logic [WIDTH-1:0] input_1, // chosen when select is 1
    input  logic select, // 0 or 1 to choose between input_0 and input_1
    output logic [WIDTH-1:0] output // output based on select
);

    always_comb begin
        if (select) begin
            output = input_1; // if select is 1, choose input_1
        end else begin
        output = input_0; // if select is 0, choose input_0
        end
    end

endmodule