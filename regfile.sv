`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.11.2026 11:30:33
// Design Name: 
// Module Name: regfile
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

module regfile (
    input  logic        clk,
    input  logic        we,
    input  logic [4:0]  rs1,
    input  logic [4:0]  rs2,
    input  logic [4:0]  rd,
    input  logic [31:0] wd,
    output logic [31:0] rd1,
    output logic [31:0] rd2
);

    logic [31:0] regs [0:31];

    initial begin
        for (int i = 0; i < 32; i++) regs[i] = 32'h0;
    end

    always_ff @(posedge clk) begin
        if (we && rd != 5'd0)
            regs[rd] <= wd;
    end

    assign rd1 = (rs1 == 5'd0) ? 32'h0 : regs[rs1];
    assign rd2 = (rs2 == 5'd0) ? 32'h0 : regs[rs2];

endmodule
