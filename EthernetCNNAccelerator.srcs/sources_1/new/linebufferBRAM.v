`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/30/2025 04:02:54 PM
// Design Name: 
// Module Name: linebufferBRAM
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


module linebufferBRAM #(
    parameter PIXEL_WIDTH = 8,
    parameter ROW_LENGTH = 512
    )(
    input wire clk,
    input wire reset,
    input wire we_a,
    input wire [ROW_LENGTH-1:0] addr_a,
    input wire [PIXEL_WIDTH-1:0] din_a,
    
    input wire re_b,
    input wire [ROW_LENGTH-1:0] addr_b,
    output reg [PIXEL_WIDTH-1:0] dout_b
    );
    integer i;
    (* ram_style = "block" *) reg [PIXEL_WIDTH-1:0] brm [0:ROW_LENGTH-1];
    
    always @(posedge clk) begin
        if (reset) begin
            for(i = 0;i<ROW_LENGTH;i = i+1) begin
                brm[i] <= 0;
            end
        end else begin
            if(we_a) begin
              brm[addr_a] <= din_a;  
            end
        end
    end
    
    always @(posedge clk) begin
        if(re_b) begin
            dout_b <= brm[addr_b];
        end
    end
endmodule
