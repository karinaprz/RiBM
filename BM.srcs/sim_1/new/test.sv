`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.10.2025 16:31:42
// Design Name: 
// Module Name: test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test();
import alg_op_pkg::*;

logic clk;
logic reset;
logic [DATA_WIDTH-1:0] syndrome [0:2*T-1] = {10'b1110000001, 10'b1111000011, 10'b0000011010, 10'b1111100011, 10'b0101110001, 10'b0101000100, 10'b1110111010, 10'b1111101010, 10'b1001000101, 10'b1101101100, 10'b1011111101, 10'b1001110100};
logic [DATA_WIDTH-1:0] lambda [0:T];

localparam int clk_PERIOD = 10;
initial begin
    clk = 1;
    reset = 1;
    #20
    reset = 0;
end

always #(clk_PERIOD) clk = ~clk;

main main(
    .clk(clk),
    .reset(reset),
    .syndrome(syndrome),
    .lambda(lambda)
);

endmodule
