module motor(
    input       clk,
    input       rst,
    input       [3:0] mode,
    input       [1:0] state,
    output      [1:0] pwm,
    output reg  [1:0] r_IN,
    output reg  [1:0] l_IN
);
	parameter NONE      = 4'b0000;
	
	parameter UP        = 4'b0010;
    parameter DOWN      = 4'b1000;
	parameter LEFT      = 4'b0001;
	parameter RIGHT     = 4'b0100;
    
	parameter LEFTUP    = 4'b0011;
	parameter LEFTDOWN  = 4'b0101;
	parameter RIGHTUP   = 4'b0110;
	parameter RIGHTDOWN = 4'b0111;

    parameter START     = 0;
    parameter PLAY      = 1;
    parameter LOSE      = 2;
    parameter WIN       = 3;

    reg [9:0] left_motor, right_motor;
    wire left_pwm, right_pwm;

    motor_pwm m0(.clk(clk), .reset(rst), .duty(left_motor),  .pmod_1(left_pwm));
    motor_pwm m1(.clk(clk), .reset(rst), .duty(right_motor), .pmod_1(right_pwm));

    assign pwm = {left_pwm, right_pwm};
    // use left_motor and right_motor to change the speed
    // 1024  100%
    // 768   75%
    // 512   50%
    // 256   25%
    // 0     0%

    // Right for up and down; Left for left and right
    always @(*) begin
        if(state == PLAY) begin
            if (mode == UP) begin
                r_IN = 2'b10;
                l_IN = 2'b00;
                right_motor = 10'd600;
                left_motor = 10'd0;
            end
            if (mode == DOWN) begin
                r_IN = 2'b01;
                l_IN = 2'b00;
                right_motor = 10'd600;
                left_motor = 10'd0;
            end
            else if (mode == LEFTDOWN || mode == LEFTUP || mode == LEFT) begin
                r_IN = 2'b00;
                l_IN = 2'b10;
                right_motor = 10'd0;
                left_motor = 10'd600;
            end
            else if (mode == RIGHTDOWN || mode == RIGHTUP || mode == RIGHT) begin
                r_IN = 2'b00;
                l_IN = 2'b01;
                right_motor = 10'd0;
                left_motor = 10'd600;
            end
            else if (mode == NONE) begin
                r_IN = 2'b00;
                l_IN = 2'b00;
                right_motor = 10'd0;
                left_motor = 10'd0;
            end 
        end
        else begin
            r_IN = 2'b00;
            l_IN = 2'b00;
            right_motor = 10'd0;
            left_motor = 10'd0;
        end 
    end
endmodule

module motor_pwm (
    input clk,
    input reset,
    input [9:0] duty,
	output pmod_1 // PWM
);
    PWM_gen pwm_0 ( 
        .clk(clk), 
        .reset(reset), 
        .freq(32'd25000),
        .duty(duty), 
        .PWM(pmod_1)
    );
endmodule

//generte PWM by input frequency & duty cycle
module PWM_gen (
    input wire clk,
    input wire reset,
	input [31:0] freq,
    input [9:0] duty, // 1024 or 512 or 128...
    output reg PWM
);
    wire [31:0] count_max = 100_000_000 / freq;
    wire [31:0] count_duty = count_max * duty / 1024;
    reg [31:0] count;
        
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            count <= 0;
            PWM <= 0;
        end 
        else if (count < count_max) begin
            count <= count + 1;
            if(count < count_duty) PWM <= 1;
            else PWM <= 0;
        end
        else begin
            count <= 0;
            PWM <= 0;
        end
    end
endmodule

