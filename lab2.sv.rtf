{\rtf1\ansi\ansicpg1252\cocoartf2759
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 // This module implements 2D covolution between a 3x3 filter and a 512-pixel-wide image of any height.\
// It is assumed that the input image is padded with zeros such that the input and output images have\
// the same size. The filter coefficients are symmetric in the x-direction (i.e. f[0][0] = f[0][2], \
// f[1][0] = f[1][2], f[2][0] = f[2][2] for any filter f) and their values are limited to integers\
// (but can still be positive of negative). The input image is grayscale with 8-bit pixel values ranging\
// from 0 (black) to 255 (white).\
module lab2 (\
	input  logic 	clk,			// Operating clock\
	input  logic	reset,			// Active-high reset signal (reset when set to 1)\
	input  logic	signed [71:0] i_f,		// Nine 8-bit signed convolution filter coefficients in row-major format (i.e. i_f[7:0] is f[0][0], i_f[15:8] is f[0][1], etc.)\
	input  logic	i_valid,			// Set to 1 if input pixel is valid\
	input  logic	i_ready,			// Set to 1 if consumer block is ready to receive a new pixel\
	input  logic	[7:0] i_x,		// Input pixel value (8-bit unsigned value between 0 and 255)\
	output logic	o_valid,			// Set to 1 if output pixel is valid\
	output logic	o_ready,			// Set to 1 if this block is ready to receive a new pixel\
	output logic	[7:0] o_y		// Output pixel value (8-bit unsigned value between 0 and 255)\
) /* synthesis multstyle = "dsp" */;\
\
localparam FILTER_SIZE = 3;	// Convolution filter dimension (i.e. 3x3)\
localparam PIXEL_DATAW = 8;	// Bit width of image pixels and filter coefficients (i.e. 8 bits)\
\
// The following code is intended to show you an example of how to use paramaters and\
// for loops in SytemVerilog. It also arrages the input filter coefficients for you\
// into a nicely-arranged and easy-to-use 2D array of registers. However, you can ignore\
// this code and not use it if you wish to.\
\
\
\
logic signed [PIXEL_DATAW-1:0] r_f [FILTER_SIZE-1:0][FILTER_SIZE-1:0]; // 2D array of registers for filter coefficients\
integer col, row; // variables to use in the for loop\
always_ff @ (posedge clk) begin\
	// If reset signal is high, set all the filter coefficient registers to zeros\
	// We're using a synchronous reset, which is recommended style for recent FPGA architectures\
	if(reset)begin\
		for(row = 0; row < FILTER_SIZE; row = row + 1) begin\
			for(col = 0; col < FILTER_SIZE; col = col + 1) begin\
				r_f[row][col] <= 0;\
			end\
		end\
	// Otherwise, register the input filter coefficients into the 2D array signal\
	end else begin\
		for(row = 0; row < FILTER_SIZE; row = row + 1) begin\
			for(col = 0; col < FILTER_SIZE; col = col + 1) begin\
				// Rearrange the 72-bit input into a 3x3 array of 8-bit filter coefficients.\
				// signal[a +: b] is equivalent to signal[a+b-1 : a]. You can try to plug in\
				// values for col and row from 0 to 2, to understand how it operates.\
				// For example at row=0 and col=0: r_f[0][0] = i_f[0+:8] = i_f[7:0]\
				//	       at row=0 and col=1: r_f[0][1] = i_f[8+:8] = i_f[15:8]\
				r_f[row][col] <= i_f[(row * FILTER_SIZE * PIXEL_DATAW)+(col * PIXEL_DATAW) +: PIXEL_DATAW];\
			end\
		end\
	end\
end\
\
\
// Start of your code\
\
//Input data needs to be buffered before processing \
/*\
	- Every image is 512 pixels in width(511:0)\
	- At initial startup, need to wait for 1024 inputs (2 rows)\
	-  + 2 additional inputs for first 2 pixels on third row\
	- Once the 3rd pixel of 3rd row is in, can start applying the filter\
	- One buffer register per buffer row\
	- once third row is fully in: 2 -> 1, 3->2\
*/\
logic [PIXEL_DATAW-1:0] bufferRow1 [513:0];\
logic [PIXEL_DATAW-1:0] bufferRow2 [513:0];\
logic [PIXEL_DATAW-1:0] bufferRow3 [513:0];\
int currPixelptr = 0;//Pointer to decide where to store each pixel\
int startupTimer = 0;//Counter to wait till the registers are filled up correctly before starting process\
int loops = 0;//wait till this reaches 2 before propogating.\
\
logic propogatingReady;\
logic calculated_O;\
\
\
logic signed [15:0] temp0, temp1, temp2, temp3, temp4 ,temp5, temp6, temp7, temp8;\
logic signed [15:0] temp15out;\
logic [7:0] tempout;\
\
\
function [15:0] clamp(input signed [15:0] value);\
	if(value > 255) begin\
		clamp = 255;\
	end else if (value <0) begin\
		clamp = 0;\
	end else begin\
		clamp = value[7:0];\
	end\
\
endfunction\
\
always_comb begin	\
	temp0 = $signed(\{\{8\{i_f[7]\}\},i_f[7:0]\}) * $signed(\{8'b0, bufferRow1[currPixelptr-2]\});\
	temp1 = $signed(\{\{8\{i_f[15]\}\},i_f[15:8]\}) * $signed(\{8'b0, bufferRow1[currPixelptr-1]\});\
	temp2 = $signed(\{\{8\{i_f[23]\}\},i_f[23:16]\}) * $signed(\{8'b0, bufferRow1[currPixelptr]\});\
	temp3 = $signed(\{\{8\{i_f[31]\}\},i_f[31:24]\}) * $signed(\{8'b0, bufferRow2[currPixelptr-2]\});\
	temp4 = $signed(\{\{8\{i_f[39]\}\},i_f[39:32]\}) * $signed(\{8'b0, bufferRow2[currPixelptr-1]\});\
	temp5 = $signed(\{\{8\{i_f[47]\}\},i_f[47:40]\}) * $signed(\{8'b0, bufferRow2[currPixelptr]\});\
	temp6 = $signed(\{\{8\{i_f[55]\}\},i_f[55:48]\}) * $signed(\{8'b0, bufferRow3[currPixelptr-2]\});\
	temp7 = $signed(\{\{8\{i_f[63]\}\},i_f[63:56]\}) * $signed(\{8'b0, bufferRow3[currPixelptr-1]\});\
	temp8 = $signed(\{\{8\{i_f[71]\}\},i_f[71:64]\}) * $signed(\{8'b0, i_x\});\
	\
	temp15out = temp0 + temp1 + temp2 + temp3 + temp4 + temp5 + temp6 + temp7 + temp8;\
	tempout = clamp(temp15out);\
end\
always_ff @(posedge clk)begin\
	calculated_O <= 1'b0;\
	propogatingReady <= 1'b1;\
	if(i_valid && i_ready)begin\
		//Waiting 1028 cycles to start convolution\
		if(startupTimer <=1027)begin\
			if(startupTimer<513)begin\
				bufferRow1[currPixelptr] <= i_x;\
			end else if(startupTimer==513)begin\
				bufferRow1[currPixelptr] <= i_x;\
				bufferRow2[0] <= i_x;\
			end else if(startupTimer>513)begin\
				bufferRow2[currPixelptr] <= i_x;\
			end \
			startupTimer = startupTimer +1;\
		end else begin//Startup has completed\
			bufferRow3[currPixelptr] <= i_x;\
		end\
		//Updating pointer to decide where to store each pixel - Needs to loop once it gets to the end\
		if(loops>2) begin\
			if(currPixelptr==0)begin\
				propogatingReady <= 1'b0;\
				bufferRow1<=bufferRow2;\
				bufferRow2<=bufferRow3;\
				currPixelptr = currPixelptr +1;\
			end else if(currPixelptr<513)begin\
				currPixelptr = currPixelptr +1;\
			end else begin\
				currPixelptr = 0;\
				loops = loops+1;\
			end\
		end else begin\
			if(currPixelptr<513)begin\
				currPixelptr = currPixelptr +1;\
			end else begin\
				currPixelptr = 0;\
				loops = loops+1;\
			end\
		end\
	end\
end\
\
assign o_y = tempout;\
assign o_ready = i_ready & propogatingReady;\
//assign o_valid = calculated_O & i_ready & (loops>1);\
assign o_valid = i_ready & (currPixelptr>1) & (loops>1);\
// End of your code\
\
endmodule\
}