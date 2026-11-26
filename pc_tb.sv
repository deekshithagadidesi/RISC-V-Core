`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.11.2026 11:07:44
// Design Name: 
// Module Name: pc_tb
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

module pc_tb;
    logic        clk = 0;
    logic        reset;
    logic [31:0] next_pc;
    logic [31:0] pc;

    pc dut (.clk(clk), .reset(reset), .next_pc(next_pc), .pc(pc));

    always #5 clk = ~clk;

    task automatic check(input logic [31:0] expected, input string name);
        if (pc === expected) $display("PASS: %s", name);
        else                 $display("FAIL: %s  got=%h expected=%h", name, pc, expected);
    endtask

    initial begin
        reset = 1; next_pc = 32'h0;
        @(posedge clk); #1;
        check(32'h0, "reset gives 0");

        reset = 0; next_pc = 32'h4;
        @(posedge clk); #1;
        check(32'h4, "loads 4");

        next_pc = 32'h8;
        @(posedge clk); #1;
        check(32'h8, "loads 8");

        next_pc = 32'h20;
        @(posedge clk); #1;
        check(32'h20, "loads 0x20");

        reset = 1; next_pc = 32'h99;
        @(posedge clk); #1;
        check(32'h0, "reset overrides next_pc");

        $finish;
    end
endmodule
