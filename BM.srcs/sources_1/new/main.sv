
import alg_op_pkg::*;
module main(
    input logic clk,
    input logic reset,
    input logic [DATA_WIDTH-1:0] syndrome [0:T*2-1], 
    output logic [DATA_WIDTH-1:0] lambda [0:T]  
);
    
    logic MC;
    logic [DATA_WIDTH-1:0] delta [0:3*T+1]; 
    logic [DATA_WIDTH-1:0] theta [0:3*T];
    logic signed [DATA_WIDTH-1:0] k;
    logic [DATA_WIDTH-1:0] gamma;
    logic [DATA_WIDTH-1:0] delta_comb [0:3*T+1];     
    logic [DATA_WIDTH-1:0] theta_comb [0:3*T];   
    logic signed [DATA_WIDTH-1:0] k_new;
    logic [DATA_WIDTH-1:0] gamma_next;
    
    // —четчик итераций
    logic [3:0] iteration = 0;
    logic processing = 0;
    
    Control u_control(
        .delta(delta[0]),
        .k(k),
        .k_new(k_new),
        .MC(MC)
    );
    
    rDC_combinational u_rDC(
        .delta(delta),
        .theta(theta),
        .MC(MC),
        .gamma(gamma),
        .gamma_next(gamma_next),
        .theta_next(theta_comb),
        .delta_next(delta_comb)
    );
    
    always_ff @(posedge clk) begin
        if (reset) begin
            iteration <= 0;
            processing <= 1'b1;
            k <= 0;
            gamma <= 1'b1;
            for (int i = 0; i < 2*T; i++) begin
                delta[i] <= syndrome[i];
                theta[i] <= syndrome[i];
            end
            for (int i = 2*T; i <= 3*T-1; i++) begin
                delta[i] <= '0;
                theta[i] <= '0;
            end
            delta[3*T] <= 'b1;
            delta[3*T+1] <= 'b0;
            theta[3*T] <= 'b1;
            
        end else if (processing) begin 
            k <= k_new;
            gamma <= gamma_next;
            delta <= delta_comb;
            theta <= theta_comb;
            iteration <= iteration + 1;
            
            if (iteration == 2*T-1) begin 
                processing <= 1'b0;
            end
            
        end
    end

//    assign lambda[0] = delta[T];
//    assign lambda[1] = delta[T+1];
//    assign lambda[2] = delta[T+2];
//    assign lambda[3] = delta[T+3];
    assign lambda = delta[T:2*T];
    
endmodule