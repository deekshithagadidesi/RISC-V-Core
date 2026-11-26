`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.11.2026 09:42:59
// Design Name: 
// Module Name: pc_next
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


module pc_next (
    input  logic [31:0] pc,
    input  logic [31:0] imm,           // from immediate generator
    input  logic [31:0] rs1_data,      // from register file (for jalr)
    input  logic        branch,        // control: instruction is a branch
    input  logic        branch_taken,  // from branch_cmp
    input  logic        jal,           // control: instruction is jal
    input  logic        jalr,          // control: instruction is jalr
    output logic [31:0] pc_plus4,      // also goes to writeback for jal/jalr
    output logic [31:0] next_pc
);
    logic [31:0] pc_target;
    logic [31:0] jalr_target;
    logic        take_pc_rel;

    assign pc_target   = pc + imm;                        // branch and jal
    assign jalr_target = (rs1_data + imm) & 32'hFFFFFFFE; // clear bit 0
    assign take_pc_rel = jal | (branch & branch_taken);
    assign pc_plus4    = pc + 32'd4;

    always_comb begin
        if (jalr)             next_pc = jalr_target;
        else if (take_pc_rel) next_pc = pc_target;
        else                  next_pc = pc_plus4;
    end
endmodule
