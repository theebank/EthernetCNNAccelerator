`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/29/2025 03:44:27 PM
// Design Name: 
// Module Name: MatrixMult
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


module MatrixMult(
    input wire clk,
    input wire rst,
    input wire signed [71:0] i_f,
    input wire [7:0] i_img0,
    input wire [7:0] i_img1,
    input wire [7:0] i_img2,
    input wire [7:0] i_img3,
    input wire [7:0] i_img4,
    input wire [7:0] i_img5,
    input wire [7:0] i_img6,
    input wire [7:0] i_img7,
    input wire [7:0] i_img8,
    input wire i_ready,
    input wire i_valid,
    output wire o_valid,
    output wire [7:0] o_img
    );
    reg signed [15:0] multres [8:0];
    reg signed [15:0] addres0,addres1,addres2,addres3,addres4,addres5,addres6,addres7;
    reg signed [15:0] tempresult;
    
    integer i;
    reg [4:0] propagatingValid;
    
    function [15:0] clamp(input signed [15:0] value);
        if(value>255) begin
            clamp = 255;
        end else if (value <0)begin
            clamp = 0;
        end else begin
            clamp = value [7:0];
        end
    endfunction
    
    
    always @(posedge clk) begin
        if(rst) begin
            for(i = 0;i<=8;i=i+1) begin
                multres[i] = 0;                
            end
            propagatingValid = 0;
        end else begin
            if(i_ready) begin
                propagatingValid = {propagatingValid[4:0],i_valid};
                //pipelinestage1
                multres[0] <= $signed({{8{i_f[7]}},  i_f[7:0]})   * $signed({8'b0, i_img0});
                multres[1] <= $signed({{8{i_f[15]}}, i_f[15:8]})  * $signed({8'b0, i_img1});
                multres[2] <= $signed({{8{i_f[23]}}, i_f[23:16]}) * $signed({8'b0, i_img2});
                multres[3] <= $signed({{8{i_f[31]}}, i_f[31:24]}) * $signed({8'b0, i_img3});
                multres[4] <= $signed({{8{i_f[39]}}, i_f[39:32]}) * $signed({8'b0, i_img4});
                multres[5] <= $signed({{8{i_f[47]}}, i_f[47:40]}) * $signed({8'b0, i_img5});
                multres[6] <= $signed({{8{i_f[55]}}, i_f[55:48]}) * $signed({8'b0, i_img6});
                multres[7] <= $signed({{8{i_f[63]}}, i_f[63:56]}) * $signed({8'b0, i_img7});
                multres[8] <= $signed({{8{i_f[71]}}, i_f[71:64]}) * $signed({8'b0, i_img8});
                //pipelinestage2
                addres0 <= multres[0] + multres[1];
                addres1 <= multres[2] + multres[3];
                addres2 <= multres[4] + multres[5];
                addres3 <= multres[6] + multres[7];
                //pipelinestage3
                addres4 <= addres0 + addres1;
                addres5 <= addres2 + addres3;
                //pipelinestage4
                addres6 <= addres4 + addres5;
                //pipelinestage5
                addres7 <= addres6 + multres[8];
                //pipelinestage6
                tempresult <= clamp(addres7);
            end
        end
    end
    
    assign o_img = tempresult;
    assign o_valid = propagatingValid[4]& i_ready;
endmodule
