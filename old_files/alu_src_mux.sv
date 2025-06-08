module alu_src_mux (
    input logic use_immediate, 
    input  signed [7:0] r_b, 
    input  signed [6:0] immediate,
    output logic signed [7:0] alu_input2
);

    always_comb begin
        if (use_immediate) begin
            alu_input2 = {immediate[6], immediate}; // explicit sign extension
        end else begin
            alu_input2 = r_b;
        end
    end

endmodule