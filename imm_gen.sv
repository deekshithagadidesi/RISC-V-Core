`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.11.2026 09:34:04
// Design Name: 
// Module Name: imm_gen
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

module imm_gen (
    input  logic [31:0] instr,
    output logic [31:0] imm
);

    always_comb begin
        case (instr[6:0])
            7'b0010011,                      // I-type ALU (addi, andi, ...)
            7'b0000011,                      // loads
            7'b1100111:                      // jalr
                imm = {{20{instr[31]}}, instr[31:20]};

            7'b0100011:                      // S-type (stores)
                imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};

            7'b1100011:                      // B-type (branches)
                imm = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};

            7'b0110111,                      // lui
            7'b0010111:                      // auipc
                imm = {instr[31:12], 12'b0};

            7'b1101111:                      // jal
                imm = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};

            default: imm = 32'h0;
        endcase
    end

endmodule
