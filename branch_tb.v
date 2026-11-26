`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.11.2026 11:12:51
// Design Name: 
// Module Name: branch_tb
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

module branch_cmp_tb;
    logic [31:0] a, b;
    logic [2:0]  funct3;
    logic        taken;

    branch_cmp dut (.a(a), .b(b), .funct3(funct3), .taken(taken));

    task automatic check(input logic expected, input string name);
        #1;
        if (taken === expected) $display("PASS: %s", name);
        else $display("FAIL: %s  got=%b expected=%b", name, taken, expected);
    endtask

    initial begin
        a = 5; b = 5; funct3 = 3'b000; check(1, "beq equal");
        a = 5; b = 6; funct3 = 3'b000; check(0, "beq not equal");
        a = 5; b = 6; funct3 = 3'b001; check(1, "bne different");
        a = 5; b = 5; funct3 = 3'b001; check(0, "bne same");
        a = 32'hFFFFFFFF; b = 1; funct3 = 3'b100; check(1, "blt signed: -1 < 1");
        a = 32'hFFFFFFFF; b = 1; funct3 = 3'b110; check(0, "bltu unsigned: big < 1 is false");
        a = 1; b = 32'hFFFFFFFF; funct3 = 3'b101; check(1, "bge signed: 1 >= -1");
        a = 1; b = 32'hFFFFFFFF; funct3 = 3'b111; check(0, "bgeu unsigned: 1 >= big is false");
        a = 7; b = 7; funct3 = 3'b101; check(1, "bge equal");
        a = 7; b = 7; funct3 = 3'b010; check(0, "invalid funct3 gives 0");
        $finish;
    end
endmodule
