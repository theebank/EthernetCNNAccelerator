`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/30/2025 04:16:19 PM
// Design Name: 
// Module Name: bramBuffer
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


module bramBuffer #(
    parameter PIXEL_WIDTH = 8,
    parameter ROW_LENGTH = 512
    )
    (
    input wire clk,
    input wire reset,
    input wire i_valid,
    input wire i_ready,
    
    input wire [PIXEL_WIDTH-1:0] i_x,
    input wire [ROW_LENGTH-1:0] i_col_idx,
    input wire [ROW_LENGTH-1:0] i_row_idx,
    
    output wire [(PIXEL_WIDTH*9)-1:0] o_window,
    output reg o_valid
    );
    
    wire [PIXEL_WIDTH-1:0] row0_p, row1_p, row2_p;

    
    linebufferBRAM #(.PIXEL_WIDTH(PIXEL_WIDTH), .ROW_LENGTH(ROW_LENGTH)) line0 (
        .clk(clk),
        .reset(reset),
        .we_a(i_valid && i_row_idx>=2),
        .addr_a(i_col_idx),
        .din_a(i_x),
        .re_b(i_valid && i_row_idx>=2 && i_col_idx >=2),
        .addr_b(i_col_idx-2),
        .dout_b(row0_p)
       );
       
    linebufferBRAM #(.PIXEL_WIDTH(PIXEL_WIDTH), .ROW_LENGTH(ROW_LENGTH)) line1 (
        .clk(clk),
        .reset(reset),
        .we_a(i_valid && i_row_idx >= 1),
        .addr_a(i_col_idx),
        .din_a(i_x),
        .re_b(i_valid && i_row_idx >= 2 && i_col_idx >= 2),
        .addr_b(i_col_idx-2),
        .dout_b(row1_p)
    );
    
    linebufferBRAM #(.PIXEL_WIDTH(PIXEL_WIDTH), .ROW_LENGTH(ROW_LENGTH)) line2 (
        .clk(clk),
        .reset(reset),
        .we_a(i_valid && i_row_idx >= 0),
        .addr_a(i_col_idx),
        .din_a(i_x),
        .re_b(i_valid && i_row_idx >= 2 && i_col_idx >= 2),
        .addr_b(i_col_idx-2),
        .dout_b(row2_p)
    );
    
    reg [PIXEL_WIDTH-1:0] row2_shift [2:0];
    reg [PIXEL_WIDTH-1:0] row1_shift [2:0];
    reg [PIXEL_WIDTH-1:0] row0_shift [2:0];
    
    integer i;
    always @(posedge clk) begin
        if(reset) begin
            for(i = 0;i<3;i= i+1) begin
                row2_shift[i] <= 0;
                row1_shift[i] <= 0;
                row0_shift[i] <= 0;
            end
            o_valid <= 0;
        end else begin
            row0_shift[0] <= row0_shift[1];
            row0_shift[1] <= row0_shift[2];
            row0_shift[2] <= row0_p;
            
            row1_shift[0] <= row1_shift[1];
            row1_shift[1] <= row1_shift[2];
            row1_shift[2] <= row1_p;
            
            row2_shift[0] <= row2_shift[1];
            row2_shift[1] <= row2_shift[2];
            row2_shift[2] <= i_x;
            
            o_valid <= (i_row_idx >= 2 && i_col_idx >= 5);
        end
    end   
    
    assign o_window = { row0_shift[0],row0_shift[1],row0_shift[2],
                        row1_shift[0],row1_shift[1],row1_shift[2],
                        row2_shift[0],row2_shift[1],row2_shift[2]};
endmodule
