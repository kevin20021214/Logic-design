`timescale 1ns / 1ps

module JSTK2(
	input CLK,					// 100Mhz onboard clock
	input RST,					// Button D
	input MISO,					// Master In Slave Out, Pin 3, Port JA
	input [2:0] SW,				// Switches 2, 1, and 0
	output SS,					// Slave Select, Pin 1, Port JA
	output MOSI,				// Master Out Slave In, Pin 2, Port JA
	output SCLK,				// Serial Clock, Pin 4, Port JA
	output reg [3:0] mode		// mode
);
	// ===========================================================================
	// 							  Parameters, Regsiters, and Wires
	// ===========================================================================
	// Holds data to be sent to PmodJSTK
	wire [7:0] sndData;

	// Signal to send/receive data to/from PmodJSTK
	wire sndRec;

	// Data read from PmodJSTK
	wire [39:0] jstkData;

	// Signal carrying output data that user selected
	wire [9:0] posData;

	// ===========================================================================
	// 										Implementation
	// ===========================================================================

	//-----------------------------------------------
	//  	  			PmodJSTK Interface
	//-----------------------------------------------
	PmodJSTK PmodJSTK_Int(
			.CLK(CLK),
			.RST(RST),
			.sndRec(sndRec),
			.DIN(sndData),
			.MISO(MISO),
			.SS(SS),
			.SCLK(SCLK),
			.MOSI(MOSI),
			.DOUT(jstkData)
	);		
	//-----------------------------------------------
	//  			 Send Receive Generator
	//-----------------------------------------------
	ClkDiv_5Hz genSndRec(
			.CLK(CLK),
			.RST(RST),
			.CLKOUT(sndRec)
	);
	
	parameter NONE = 4'b0000;
	
	parameter UP = 4'b0010;
    parameter DOWN = 4'b1000;
	parameter LEFT = 4'b0001;
	parameter RIGHT = 4'b0100;

	parameter LEFTUP = 4'b0011;
	parameter LEFTDOWN = 4'b0101;
	parameter RIGHTUP =  4'b0110;
	parameter RIGHTDOWN = 4'b0111;
			
	// Use state of switch 0 to select output of X position or Y position data to SSD
	assign posData = (SW[0] == 1'b1) ? {jstkData[9:8], jstkData[23:16]} : {jstkData[25:24], jstkData[39:32]};
	wire [9:0] x, y;
	assign x = {jstkData[9:8], jstkData[23:16]};
	assign y = {jstkData[25:24], jstkData[39:32]};

	// Data to be sent to PmodJSTK, lower two bits will turn on leds on PmodJSTK
	assign sndData = {8'b100000, {SW[1], SW[2]}};

	wire clk1s;
	reg [3:0] xcount = 4, ycount = 4;
	clock_divider #(26) clk2(.clk(CLK), .clk_div(clk1s));

	parameter UPERBOUND = 6;
	parameter LOWERBOUND = 2;

	always @(sndRec or RST or jstkData) begin
		if (RST == 1'b1) mode <= NONE;
		else begin
			if (x > 700 && xcount > LOWERBOUND) begin // left
				if (y > 700 && ycount < UPERBOUND) mode <= LEFTUP;
				else if (y < 300 && ycount > LOWERBOUND) mode <= LEFTDOWN;
				else mode <= LEFT;
			end
			else if (x < 300 && xcount < UPERBOUND) begin // right
				if (y > 700 && ycount < UPERBOUND) mode <= RIGHTUP;
				else if (y < 300 && ycount > LOWERBOUND) mode <= RIGHTDOWN;
				else mode <= RIGHT;
			end
			else begin
				if (y > 700 && ycount < UPERBOUND) mode <= UP;
				else if (y < 300 && ycount > LOWERBOUND) mode <= DOWN;
				else mode <= NONE;
			end
		end
	end

	// Cnt range from 1 to 7
endmodule
