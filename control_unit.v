`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.11.2026 10:00:09
// Design Name: 
// Module Name: control_unit
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


module control_unit (
    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    input  logic       funct7_b5,   // instr[30]
    output logic       reg_write,
    output logic       alu_src_a,   // 0 = rs1, 1 = pc
    output logic       alu_src_b,   // 0 = rs2, 1 = imm
    output logic       mem_read,
    output logic       mem_write,
    output logic [1:0] wb_sel,      // 00 = ALU, 01 = MEM, 10 = PC+4
    output logic       branch,
    output logic       jal,
    output logic       jalr,
    output logic [3:0] alu_ctrl
);

    always_comb begin
        // defaults: no side effects
        reg_write = 1'b0;
        alu_src_a = 1'b0;
        alu_src_b = 1'b0;
        mem_read  = 1'b0;
        mem_write = 1'b0;
        wb_sel    = 2'b00;
        branch    = 1'b0;
        jal       = 1'b0;
        jalr      = 1'b0;
        alu_ctrl  = 4'b0000;

        case (opcode)
            7'b0110011: begin                        // R-type
                reg_write = 1'b1;
                case (funct3)
                    3'b000: alu_ctrl = funct7_b5 ? 4'b0001 : 4'b0000; // SUB / ADD
                    3'b001: alu_ctrl = 4'b0101;                       // SLL
                    3'b010: alu_ctrl = 4'b1000;                       // SLT
                    3'b011: alu_ctrl = 4'b1001;                       // SLTU
                    3'b100: alu_ctrl = 4'b0100;                       // XOR
                    3'b101: alu_ctrl = funct7_b5 ? 4'b0111 : 4'b0110; // SRA / SRL
                    3'b110: alu_ctrl = 4'b0011;                       // OR
                    3'b111: alu_ctrl = 4'b0010;                       // AND
                endcase
            end

            7'b0010011: begin                        // I-type ALU
                reg_write = 1'b1;
                alu_src_b = 1'b1;
                case (funct3)
                    3'b000: alu_ctrl = 4'b0000;                       // ADDI
                    3'b001: alu_ctrl = 4'b0101;                       // SLLI
                    3'b010: alu_ctrl = 4'b1000;                       // SLTI
                    3'b011: alu_ctrl = 4'b1001;                       // SLTIU
                    3'b100: alu_ctrl = 4'b0100;                       // XORI
                    3'b101: alu_ctrl = funct7_b5 ? 4'b0111 : 4'b0110; // SRAI / SRLI
                    3'b110: alu_ctrl = 4'b0011;                       // ORI
                    3'b111: alu_ctrl = 4'b0010;                       // ANDI
                endcase
            end

            7'b0000011: begin                        // loads
                reg_write = 1'b1;
                alu_src_b = 1'b1;
                mem_read  = 1'b1;
                wb_sel    = 2'b01;
                alu_ctrl  = 4'b0000;                 // address = rs1 + imm
            end

            7'b0100011: begin                        // stores
                alu_src_b = 1'b1;
                mem_write = 1'b1;
                alu_ctrl  = 4'b0000;                 // address = rs1 + imm
            end

            7'b1100011: begin                        // branches
                branch = 1'b1;
            end

            7'b1101111: begin                        // JAL
                reg_write = 1'b1;
                jal       = 1'b1;
                wb_sel    = 2'b10;
            end

            7'b1100111: begin                        // JALR
                reg_write = 1'b1;
                jalr      = 1'b1;
                alu_src_b = 1'b1;
                wb_sel    = 2'b10;
            end

            7'b0110111: begin                        // LUI
                reg_write = 1'b1;
                alu_src_b = 1'b1;
                alu_ctrl  = 4'b1010;                 // PASS B
            end

            7'b0010111: begin                        // AUIPC
                reg_write = 1'b1;
                alu_src_a = 1'b1;
                alu_src_b = 1'b1;
                alu_ctrl  = 4'b0000;                 // pc + imm
            end

            default: ;                               // unknown opcode: all zeros
        endcase
    end

endmodule