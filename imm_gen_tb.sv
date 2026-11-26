`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.11.2026 09:36:23
// Design Name: 
// Module Name: imm_gen_tb
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


module imm_gen_tb;
    logic [31:0] instr, imm;

    imm_gen dut (.instr(instr), .imm(imm));

    task automatic check(input logic [31:0] expected, input string name);
        #1;
        if (imm === expected) $display("PASS: %s", name);
        else $display("FAIL: %s  got=%h expected=%h", name, imm, expected);
    endtask

    initial begin
        instr = 32'h00500093; check(32'h00000005, "I-type addi x1,x0,5");
        instr = 32'hFFF00093; check(32'hFFFFFFFF, "I-type addi x1,x0,-1 (sign extend)");
        instr = 32'h00A02223; check(32'h00000004, "S-type sw x10,4(x0)");
        instr = 32'hFEA02E23; check(32'hFFFFFFFC, "S-type sw x10,-4(x0) (negative)");
        instr = 32'h00208463; check(32'h00000008, "B-type beq x1,x2,+8");
        instr = 32'hFE208CE3; check(32'hFFFFFFF8, "B-type beq x1,x2,-8 (backward)");
        instr = 32'h123450B7; check(32'h12345000, "U-type lui x1,0x12345");
        instr = 32'h008000EF; check(32'h00000008, "J-type jal x1,+8");
        instr = 32'hFF9FF0EF; check(32'hFFFFFFF8, "J-type jal x1,-8 (backward)");
        instr = 32'h00000033; check(32'h00000000, "R-type add gives 0");
        $finish;
    end
endmodule
