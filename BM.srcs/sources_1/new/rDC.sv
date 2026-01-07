import alg_op_pkg::*;

module rDC_combinational(
    input logic [DATA_WIDTH-1:0] delta [0:3*T+1],
    input logic [DATA_WIDTH-1:0] theta [0:3*T],
    input logic MC,
    input logic [DATA_WIDTH-1:0] gamma,
    output logic [DATA_WIDTH-1:0] gamma_next,
    output logic [DATA_WIDTH-1:0] theta_next [0:3*T],
    output logic [DATA_WIDTH-1:0] delta_next [0:3*T+1]
);
    for (genvar i = 0; i < 3*T+1; i++) begin : delta_theta_computation
        logic [DATA_WIDTH-1:0] mult_gamma_delta;
        logic [DATA_WIDTH-1:0] mult_delta0_theta;
        always_comb begin
            mult_gamma_delta = MULTGF(gamma, delta[i+1]);
            mult_delta0_theta = MULTGF(delta[0], theta[i]);
            delta_next[i] = mult_gamma_delta ^ mult_delta0_theta;
            if (MC == 1) begin
                theta_next[i] = delta[i+1];
            end else begin
                theta_next[i] = theta[i];
            end
        end
    end
    
    assign delta_next[3*T+1] = '0;
    assign gamma_next = (MC == 1) ? delta[0] : gamma;
    
endmodule