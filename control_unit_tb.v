`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.11.2026 10:01:07
// Design Name: 
// Module Name: control_unit_tb
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

module control_unit_tb;
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic       funct7_b5;
    logic       reg_write, alu_src_a, alu_src_b, mem_read, mem_write;
    logic [1:0] wb_sel;
    logic       branch, jal, jalr;
    logic [3:0] alu_ctrl;

    control_unit dut (.*);

    int errors = 0;

    // expected: {reg_write, alu_src_a, alu_src_b, mem_read, mem_write, wb_sel, branch, jal, jalr, alu_ctrl}
    task automatic check(input logic [13:0] expected, input string name);
        logic [13:0] got;
        #1;
        got = {reg_write, alu_src_a, alu_src_b, mem_read, mem_write,
               wb_sel, branch, jal, jalr, alu_ctrl};
        if (got === expected) $display("PASS: %s", name);
        else begin
            $display("FAIL: %s  got=%b expected=%b", name, got, expected);
            errors++;
        end
    endtask

    initial begin
        //                                     rw sa sb mr mw wb  br jl jr alu
        opcode = 7'b0110011; funct3 = 3'b000; funct7_b5 = 0; check(14'b1_0_0_0_0_00_0_0_0_0000, "R add");
        opcode = 7'b0110011; funct3 = 3'b000; funct7_b5 = 1; check(14'b1_0_0_0_0_00_0_0_0_0001, "R sub");
        opcode = 7'b0110011; funct3 = 3'b101; funct7_b5 = 1; check(14'b1_0_0_0_0_00_0_0_0_0111, "R sra");
        opcode = 7'b0110011; funct3 = 3'b010; funct7_b5 = 0; check(14'b1_0_0_0_0_00_0_0_0_1000, "R slt");
        opcode = 7'b0010011; funct3 = 3'b000; funct7_b5 = 1; check(14'b1_0_1_0_0_00_0_0_0_0000, "I addi (bit30 ignored)");
        opcode = 7'b0010011; funct3 = 3'b111; funct7_b5 = 0; check(14'b1_0_1_0_0_00_0_0_0_0010, "I andi");
        opcode = 7'b0000011; funct3 = 3'b010; funct7_b5 = 0; check(14'b1_0_1_1_0_01_0_0_0_0000, "load lw");
        opcode = 7'b0100011; funct3 = 3'b010; funct7_b5 = 0; check(14'b0_0_1_0_1_00_0_0_0_0000, "store sw");
        opcode = 7'b1100011; funct3 = 3'b000; funct7_b5 = 0; check(14'b0_0_0_0_0_00_1_0_0_0000, "branch beq");
        opcode = 7'b1101111; funct3 = 3'b000; funct7_b5 = 0; check(14'b1_0_0_0_0_10_0_1_0_0000, "jal");
        opcode = 7'b1100111; funct3 = 3'b000; funct7_b5 = 0; check(14'b1_0_1_0_0_10_0_0_1_0000, "jalr");
        opcode = 7'b0110111; funct3 = 3'b000; funct7_b5 = 0; check(14'b1_0_1_0_0_00_0_0_0_1010, "lui");
        opcode = 7'b0010111; funct3 = 3'b000; funct7_b5 = 0; check(14'b1_1_1_0_0_00_0_0_0_0000, "auipc");
        opcode = 7'b1111111; funct3 = 3'b000; funct7_b5 = 0; check(14'b0_0_0_0_0_00_0_0_0_0000, "unknown opcode does nothing");

        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TESTS FAILED", errors);
        $finish;
    end
endmodule
