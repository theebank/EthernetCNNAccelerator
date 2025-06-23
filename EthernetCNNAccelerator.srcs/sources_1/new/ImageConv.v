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
    
    localparam FILTER_SIZE = 3;
    localparam PIXEL_DATAW = 8;
    
    reg [PIXEL_DATAW-1:0] bufferRow1 [513:0];
    reg [PIXEL_DATAW-1:0] bufferRow2 [513:0];
    reg [PIXEL_DATAW-1:0] bufferRow3 [513:0];
    
    integer currPixelptr = 0;
    integer startupTimer = 0;
    integer loops = 0;
    integer i = 0;
    
    reg propagatingReady;
    reg calculated_O;
    
    reg signed [15:0] temp0,temp1,temp2,temp3,temp4,temp5,temp6,temp7,temp8;
    reg signed [15:0] temp15out;
    reg [7:0] tempout;
    
    function [15:0] clamp(input signed [15:0] value);
        if(value>255) begin
            clamp = 255;
        end else if (value <0)begin
            clamp = 0;
        end else begin
            clamp = value [7:0];
        end
    endfunction
    
    always @* begin
        temp0 = $signed({{8{i_f[7]}},  i_f[7:0]})   * $signed({8'b0, bufferRow1[currPixelptr-2]});
        temp1 = $signed({{8{i_f[15]}}, i_f[15:8]})  * $signed({8'b0, bufferRow1[currPixelptr-1]});
        temp2 = $signed({{8{i_f[23]}}, i_f[23:16]}) * $signed({8'b0, bufferRow1[currPixelptr]});
        temp3 = $signed({{8{i_f[31]}}, i_f[31:24]}) * $signed({8'b0, bufferRow2[currPixelptr-2]});
        temp4 = $signed({{8{i_f[39]}}, i_f[39:32]}) * $signed({8'b0, bufferRow2[currPixelptr-1]});
        temp5 = $signed({{8{i_f[47]}}, i_f[47:40]}) * $signed({8'b0, bufferRow2[currPixelptr]});
        temp6 = $signed({{8{i_f[55]}}, i_f[55:48]}) * $signed({8'b0, bufferRow3[currPixelptr-2]});
        temp7 = $signed({{8{i_f[63]}}, i_f[63:56]}) * $signed({8'b0, bufferRow3[currPixelptr-1]});
        temp8 = $signed({{8{i_f[71]}}, i_f[71:64]}) * $signed({8'b0, i_x});
    
        temp15out = temp0 + temp1 + temp2 + temp3 + temp4 + temp5 + temp6 + temp7 + temp8;
        tempout   = clamp(temp15out);
    end

    always @(posedge clk)begin
        calculated_O <= 1'b0;
        propagatingReady <= 1'b1;
        if(i_valid && i_ready)begin
            //Waiting 1028 cycles to start convolution\
            if(startupTimer <=1027)begin
                if(startupTimer<513)begin
                    bufferRow1[currPixelptr] <= i_x;
                end else if(startupTimer==513)begin
                    bufferRow1[currPixelptr] <= i_x;
                    bufferRow2[0] <= i_x;
                end else if(startupTimer>513)begin
                    bufferRow2[currPixelptr] <= i_x;
                end 
                startupTimer = startupTimer +1;
            end else begin//Startup has completed\
                bufferRow3[currPixelptr] <= i_x;
            end
            //Updating pointer to decide where to store each pixel - Needs to loop once it gets to the end\
            if(loops>2) begin
                if(currPixelptr==0)begin
                    propagatingReady <= 1'b0;
                    for (i = 0; i <= 513; i = i + 1) begin
                        bufferRow1[i] <= bufferRow2[i];
                        bufferRow2[i] <= bufferRow3[i];
                    end
                    currPixelptr = currPixelptr +1;
                end else if(currPixelptr<513)begin
                    currPixelptr = currPixelptr +1;
                end else begin
                    currPixelptr = 0;
                    loops = loops+1;
                end
            end else begin
                if(currPixelptr<513)begin
                    currPixelptr = currPixelptr +1;
                end else begin
                    currPixelptr = 0;
                    loops = loops+1;
                end
            end
        end
    end
    
    assign o_y = tempout;
    assign o_ready = i_ready & propagatingReady;
    //assign o_valid = calculated_O & i_ready & (loops>1);
    assign o_valid = i_ready & (currPixelptr>1) & (loops>1);
    
    
endmodule
