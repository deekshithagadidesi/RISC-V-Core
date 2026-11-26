`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.11.2026 09:47:00
// Design Name: 
// Module Name: pc_next_tb
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


module pc_next_tb;
    logic [31:0] pc, imm, rs1_data;
    logic        branch, branch_taken, jal, jalr;
    logic [31:0] pc_plus4, next_pc;

    pc_next dut (.pc(pc), .imm(imm), .rs1_data(rs1_data),
                 .branch(branch), .branch_taken(branch_taken),
                 .jal(jal), .jalr(jalr),
                 .pc_plus4(pc_plus4), .next_pc(next_pc));

    task automatic check(input logic [31:0] expected, input string name);
        #1;
        if (next_pc === expected) $display("PASS: %s", name);
        else $display("FAIL: %s  got=%h expected=%h", name, next_pc, expected);
    endtask

    initial begin
        pc = 32'h100; imm = 32'h20; rs1_data = 32'h500;
        branch = 0; branch_taken = 0; jal = 0; jalr = 0;
        check(32'h104, "normal PC+4");

        branch = 1; branch_taken = 0;
        check(32'h104, "branch not taken");

        branch = 1; branch_taken = 1;
        check(32'h120, "branch taken");

        branch = 0; branch_taken = 1;
        check(32'h104, "taken flag ignored when not a branch");

        branch = 0; branch_taken = 0; jal = 1;
        check(32'h120, "jal");

        jal = 0; jalr = 1; rs1_data = 32'h501;
        check(32'h520, "jalr (bit 0 cleared)");

        jalr = 0; imm = 32'hFFFFFFF0;   // -16
        branch = 1; branch_taken = 1;
        check(32'h0F0, "backward branch");

        if (pc_plus4 === 32'h104) $display("PASS: pc_plus4 output");
        else $display("FAIL: pc_plus4 got=%h", pc_plus4);

        $finish;
    end
endmodule
