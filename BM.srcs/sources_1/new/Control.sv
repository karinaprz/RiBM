import alg_op_pkg::*;
module Control(
    input logic [DATA_WIDTH-1:0] delta,
    input logic signed [DATA_WIDTH-1:0] k,
    output logic signed [DATA_WIDTH-1:0] k_new,
    output logic MC
);
    always_comb begin
        if((delta != 127'b0) && (k >= 0)) begin
            MC = 1'b1;
            k_new = -k - 1;
        end else begin
            MC = 1'b0;
            k_new = k + 1;
        end
    end
    
endmodule