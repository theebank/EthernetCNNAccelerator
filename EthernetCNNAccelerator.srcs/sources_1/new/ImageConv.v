`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/22/2025 10:05:32 PM
// Design Name: 
// Module Name: ImageConv
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


module ImageConv(
    input wire clk,
    input wire reset,
    input wire signed [71:0] i_f,
    input wire i_valid,
    input wire i_ready,
    input wire [7:0] i_x,
    output wire o_valid,
    output wire o_ready,
    output wire [7:0] o_y
    );
    
    localparam PIXEL_WIDTH=8;
    localparam ROW_LENGTH=512;
    
    wire [(PIXEL_WIDTH*9)-1:0] o_window_wire;
    wire mem_o_valid_wire;
    
    reg [ROW_LENGTH-1:0] i_col_idx_wire;
    reg [ROW_LENGTH-1:0] i_row_idx_wire;
    
    wire matmul_o_valid_wire;
    wire [PIXEL_WIDTH-1:0] matmul_o_img_wire;
    
    reg startup_done;
    
    always @(posedge clk) begin
        if (reset) begin
            i_col_idx_wire <= 0;
            i_row_idx_wire <= 0;
            startup_done <= 0;
        end else begin
        if(i_valid) begin
                if(i_col_idx_wire<ROW_LENGTH-1) begin
                    i_col_idx_wire <= i_col_idx_wire +1;
                end else begin
                    i_col_idx_wire <= 0;
                    i_row_idx_wire <= i_row_idx_wire + 1;
                end
            end
        end
    end
    
    
    bramBuffer #(
        .PIXEL_WIDTH(PIXEL_WIDTH),
        .ROW_LENGTH(ROW_LENGTH))
    mem(
        .clk(clk),        
        .reset(reset),
        .i_valid(i_valid),
        .i_ready(i_ready),     
        .i_x(i_x),
        .i_col_idx(i_col_idx_wire),
        .i_row_idx(i_row_idx_wire),        
        .o_window(o_window_wire),
        .o_valid(mem_o_valid_wire)   
    );
    
    MatrixMult #(
        .PIXEL_DATAW(PIXEL_WIDTH), 
        .PIXEL_DATAFLATW(PIXEL_WIDTH*9)
    ) matmul (
        .clk(clk),
        .reset(reset),
        .i_f(i_f),
        .i_img(o_window_wire),
        .i_ready(i_ready),
        .i_valid(mem_o_valid_wire),
        .o_valid(matmul_o_valid_wire),
        .o_img(matmul_o_img_wire)
    );
    
    assign o_valid = matmul_o_valid_wire;
    assign o_y = matmul_o_img_wire;
    assign o_ready = 1;
endmodule
