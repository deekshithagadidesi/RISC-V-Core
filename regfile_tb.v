`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.11.2026 11:33:05
// Design Name: 
// Module Name: regfile_tb
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


module regfile_tb;
    logic        clk = 0;
    logic        we;
    logic [4:0]  rs1, rs2, rd;
    logic [31:0] wd, rd1, rd2;

    regfile dut (.clk(clk), .we(we), .rs1(rs1), .rs2(rs2),
                 .rd(rd), .wd(wd), .rd1(rd1), .rd2(rd2));

    always #5 clk = ~clk;

    task automatic check(input logic [31:0] got, input logic [31:0] expected,
                         input string name);
        if (got === expected) $display("PASS: %s", name);
        else $display("FAIL: %s  got=%h expected=%h", name, got, expected);
    endtask

    initial begin
        we = 0; rs1 = 0; rs2 = 0; rd = 0; wd = 0;
        @(posedge clk); #1;

        // write x1 = 5
        we = 1; rd = 5'd1; wd = 32'd5;
        @(posedge clk); #1;
        // write x2 = 7
        rd = 5'd2; wd = 32'd7;
        @(posedge clk); #1;
        we = 0;

        // two reads at once
        rs1 = 5'd1; rs2 = 5'd2; #1;
        check(rd1, 32'd5, "read x1 on port 1");
        check(rd2, 32'd7, "read x2 on port 2");

        // x0 write attempt must be ignored
        we = 1; rd = 5'd0; wd = 32'hDEADBEEF;
        @(posedge clk); #1;
        rs1 = 5'd0; #1;
        check(rd1, 32'd0, "x0 stays 0 after write attempt");

        // we = 0 must not write
        we = 0; rd = 5'd3; wd = 32'd99;
        @(posedge clk); #1;
        rs1 = 5'd3; #1;
        check(rd1, 32'd0, "no write when we=0");

        // write is not visible before the clock edge
        we = 1; rd = 5'd4; wd = 32'd44; rs1 = 5'd4; #1;
        check(rd1, 32'd0, "write not visible before clock edge");
        @(posedge clk); #1;
        check(rd1, 32'd44, "write visible after clock edge");

        // same register on both ports
        rs1 = 5'd4; rs2 = 5'd4; #1;
        check(rd2, 32'd44, "same register on both ports");

        // highest register
        we = 1; rd = 5'd31; wd = 32'hFFFFFFFF;
        @(posedge clk); #1;
        we = 0; rs1 = 5'd31; #1;
        check(rd1, 32'hFFFFFFFF, "x31 write and read");

        $finish;
    end
endmodule