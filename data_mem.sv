`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.11.2026 10:10:56
// Design Name: 
// Module Name: data_mem
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

module data_mem #(
    parameter DEPTH = 256               // number of 32-bit words
)(
    input  logic        clk,
    input  logic        mem_write,
    input  logic        mem_read,
    input  logic [2:0]  funct3,
    input  logic [31:0] addr,           // byte address
    input  logic [31:0] wdata,
    output logic [31:0] rdata
);

    logic [31:0] mem [0:DEPTH-1];

    logic [$clog2(DEPTH)-1:0] word_idx;
    logic [1:0]               byte_off;
    logic [31:0]              word;

    assign word_idx = addr[$clog2(DEPTH)+1:2];
    assign byte_off = addr[1:0];
    assign word     = mem[word_idx];

    initial begin
        for (int i = 0; i < DEPTH; i++) mem[i] = 32'h0;
    end

    // ---------------- write ----------------
    always_ff @(posedge clk) begin
        if (mem_write) begin
            case (funct3)
                3'b000: begin                                   // sb
                    case (byte_off)
                        2'd0: mem[word_idx][7:0]   <= wdata[7:0];
                        2'd1: mem[word_idx][15:8]  <= wdata[7:0];
                        2'd2: mem[word_idx][23:16] <= wdata[7:0];
                        2'd3: mem[word_idx][31:24] <= wdata[7:0];
                    endcase
                end
                3'b001: begin                                   // sh
                    if (byte_off[1]) mem[word_idx][31:16] <= wdata[15:0];
                    else             mem[word_idx][15:0]  <= wdata[15:0];
                end
                3'b010: mem[word_idx] <= wdata;                 // sw
                default: ;
            endcase
        end
    end

    // ---------------- read ----------------
    logic [7:0]  rbyte;
    logic [15:0] rhalf;

    always_comb begin
        case (byte_off)
            2'd0: rbyte = word[7:0];
            2'd1: rbyte = word[15:8];
            2'd2: rbyte = word[23:16];
            default: rbyte = word[31:24];
        endcase
        rhalf = byte_off[1] ? word[31:16] : word[15:0];

        rdata = 32'h0;
        if (mem_read) begin
            case (funct3)
                3'b000: rdata = {{24{rbyte[7]}}, rbyte};        // lb
                3'b001: rdata = {{16{rhalf[15]}}, rhalf};       // lh
                3'b010: rdata = word;                           // lw
                3'b100: rdata = {24'b0, rbyte};                 // lbu
                3'b101: rdata = {16'b0, rhalf};                 // lhu
                default: rdata = 32'h0;
            endcase
        end
    end

endmodule
