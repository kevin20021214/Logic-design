module main(
    input CLK,					// 100Mhz onboard clock
	input RST,					// Button D
	input MISO,					// Master In Slave Out, Pin 3, Port JA
	input [2:0] SW,				// Switches 2, 1, and 0
	output SS,      			// Slave Select, Pin 1, Port JA
	output MOSI,				// Master Out Slave In, Pin 2, Port JA
	output SCLK,				// Serial Clock, Pin 4, Port JA
	output [3:0] LED,			// LEDs 2, 1, and 0
    output IN1,
    output IN2,
    output IN3, 
    output IN4,
    output left_pwm,
    output right_pwm
);

    wire [3:0] mode;
    JSTK2 pjstk2_ctrl(
        .CLK(CLK),
        .RST(RST),
        .MISO(MISO),
        .SW(SW),
        .SS(SS),
        .MOSI(MOSI),
        .SCLK(SCLK),
        .mode(mode)
    );

    motor motor_ctrl(
        .clk(CLK),
        .rst(RST),
        .pwm({left_pwm, right_pwm}),
        .l_IN({IN1, IN2}),
        .r_IN({IN3, IN4}),
        .mode(mode),
        .led(LED)
    );

endmodule