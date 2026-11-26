`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.11.2026 10:43:19
// Design Name: 
// Module Name: instr_mem_tb
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

module instr_mem_tb;
    logic [31:0] addr, instr;

    instruction_mem #(.DEPTH(256), .INIT_FILE("program.txt")) dut (
        .addr(addr),
        .instr(instr)
    );

    task automatic check(input logic [31:0] expected, input string name);
        #1;
        if (instr === expected) $display("PASS: %s", name);
        else $display("FAIL: %s  got=%h expected=%h", name, instr, expected);
    endtask

    initial begin
        addr = 32'h00; check(32'h00500093, "address 0x00");
        addr = 32'h04; check(32'h00700113, "address 0x04");
        addr = 32'h08; check(32'h002081B3, "address 0x08");
        addr = 32'h0C; check(32'h00000013, "past program end gives NOP");
        addr = 32'hFC; check(32'h00000013, "last word of memory");
        $finish;
    end
endmodule
