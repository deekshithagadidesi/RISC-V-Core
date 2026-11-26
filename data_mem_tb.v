`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.11.2026 10:11:44
// Design Name: 
// Module Name: data_mem_tb
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

module data_mem_tb;
    logic        clk = 0;
    logic        mem_write, mem_read;
    logic [2:0]  funct3;
    logic [31:0] addr, wdata, rdata;

    data_mem dut (.*);

    always #5 clk = ~clk;

    task automatic check(input logic [31:0] expected, input string name);
        #1;
        if (rdata === expected) $display("PASS: %s", name);
        else $display("FAIL: %s  got=%h expected=%h", name, rdata, expected);
    endtask

    task automatic store(input logic [2:0] f3, input logic [31:0] a, input logic [31:0] d);
        mem_write = 1; mem_read = 0; funct3 = f3; addr = a; wdata = d;
        @(posedge clk); #1;
        mem_write = 0;
    endtask

    task automatic load(input logic [2:0] f3, input logic [31:0] a);
        mem_read = 1; mem_write = 0; funct3 = f3; addr = a;
    endtask

    initial begin
        mem_write = 0; mem_read = 0; funct3 = 0; addr = 0; wdata = 0;
        @(posedge clk); #1;

        store(3'b010, 32'h00, 32'hDEADBEEF);
        load (3'b010, 32'h00); check(32'hDEADBEEF, "sw then lw");

        load (3'b100, 32'h00); check(32'h000000EF, "lbu byte 0");
        load (3'b100, 32'h01); check(32'h000000BE, "lbu byte 1");
        load (3'b100, 32'h02); check(32'h000000AD, "lbu byte 2");
        load (3'b100, 32'h03); check(32'h000000DE, "lbu byte 3");

        load (3'b000, 32'h00); check(32'hFFFFFFEF, "lb sign-extends 0xEF");
        load (3'b101, 32'h00); check(32'h0000BEEF, "lhu low half");
        load (3'b001, 32'h02); check(32'hFFFFDEAD, "lh sign-extends upper half");
        load (3'b101, 32'h02); check(32'h0000DEAD, "lhu upper half");

        store(3'b000, 32'h05, 32'h000000AB);     // sb at address 5
        load (3'b010, 32'h04); check(32'h0000AB00, "sb writes only byte 1");

        store(3'b010, 32'h08, 32'h11223344);
        store(3'b001, 32'h0A, 32'h0000AABB);     // sh upper half
        load (3'b010, 32'h08); check(32'hAABB3344, "sh writes only upper half");

        store(3'b000, 32'h08, 32'h000000FF);     // sb byte 0
        load (3'b010, 32'h08); check(32'hAABB33FF, "sb keeps other bytes");

        mem_write = 1; funct3 = 3'b010; addr = 32'h10; wdata = 32'h12345678; mem_read = 1;
        #1; check(32'h00000000, "write not visible before clock edge");
        @(posedge clk); #1; mem_write = 0;
        check(32'h12345678, "write visible after clock edge");

        load (3'b010, 32'h0C); mem_read = 0; check(32'h0, "no read when mem_read=0");

        $finish;
    end
endmodule
