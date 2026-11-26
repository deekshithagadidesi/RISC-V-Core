`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.11.2026 10:31:23
// Design Name: 
// Module Name: instruction_mem
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

module instruction_mem #(
    parameter DEPTH     = 256,
    parameter INIT_FILE = "program.txt"
)(
    input  logic [31:0] addr,    // byte address from the PC
    output logic [31:0] instr
);

    logic [31:0] mem [0:DEPTH-1];

    initial begin
        for (int i = 0; i < DEPTH; i++) mem[i] = 32'h00000013;  // fill with NOP
        $readmemh(INIT_FILE, mem);
    end

    assign instr = mem[addr[$clog2(DEPTH)+1:2]];

endmodule
