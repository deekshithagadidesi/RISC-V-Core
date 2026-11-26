`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.11.2026 11:06:55
// Design Name: 
// Module Name: pc
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
module pc (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] next_pc,
    output logic [31:0] pc
);

    always_ff @(posedge clk) begin
        if (reset) pc <= 32'h00000000;
        else       pc <= next_pc;
    end

endmodule
