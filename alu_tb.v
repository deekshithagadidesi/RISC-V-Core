`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.11.2026 11:52:26
// Design Name: 
// Module Name: alu_tb
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
module alu_tb;
    logic [31:0] a, b, result;
    logic [3:0]  alu_ctrl;
    logic        zero;

    alu dut (.a(a), .b(b), .alu_ctrl(alu_ctrl), .result(result), .zero(zero));

    task automatic check(input logic [31:0] expected, input string name);
        #1;
        if (result === expected) $display("PASS: %s", name);
        else $display("FAIL: %s  got=%h expected=%h", name, result, expected);
    endtask

    initial begin
        a = 10; b = 5;  alu_ctrl = 4'b0000; check(32'd15, "ADD 10+5");
        a = 32'hFFFFFFFF; b = 1; alu_ctrl = 4'b0000; check(32'h0, "ADD overflow wraps to 0");
        a = 10; b = 5;  alu_ctrl = 4'b0001; check(32'd5, "SUB 10-5");
        a = 0;  b = 1;  alu_ctrl = 4'b0001; check(32'hFFFFFFFF, "SUB 0-1 = -1");
        a = 32'hF0F0F0F0; b = 32'h0FF00FF0; alu_ctrl = 4'b0010; check(32'h00F000F0, "AND");
        a = 32'hF0F0F0F0; b = 32'h0FF00FF0; alu_ctrl = 4'b0011; check(32'hFFF0FFF0, "OR");
        a = 32'hF0F0F0F0; b = 32'h0FF00FF0; alu_ctrl = 4'b0100; check(32'hFF00FF00, "XOR");
        a = 1; b = 4;   alu_ctrl = 4'b0101; check(32'd16, "SLL 1<<4");
        a = 1; b = 32;  alu_ctrl = 4'b0101; check(32'd1, "SLL by 32 uses only low 5 bits (shift 0)");
        a = 32'h80000000; b = 4; alu_ctrl = 4'b0110; check(32'h08000000, "SRL fills with zeros");
        a = 32'h80000000; b = 4; alu_ctrl = 4'b0111; check(32'hF8000000, "SRA keeps sign bit");
        a = 32'hFFFFFFFF; b = 1; alu_ctrl = 4'b1000; check(32'd1, "SLT signed: -1 < 1");
        a = 32'hFFFFFFFF; b = 1; alu_ctrl = 4'b1001; check(32'd0, "SLTU unsigned: big < 1 is false");
        a = 5; b = 5;   alu_ctrl = 4'b1000; check(32'd0, "SLT equal gives 0");
        a = 7; b = 32'h12345000; alu_ctrl = 4'b1010; check(32'h12345000, "PASS B (lui)");
        a = 7; b = 7;   alu_ctrl = 4'b0001; #1;
        if (zero === 1'b1) $display("PASS: zero flag set"); else $display("FAIL: zero flag");
        a = 7; b = 3;   alu_ctrl = 4'b0001; #1;
        if (zero === 1'b0) $display("PASS: zero flag clear"); else $display("FAIL: zero flag clear");
        $finish;
    end
endmodule
