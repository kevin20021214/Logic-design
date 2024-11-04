module ledCtrl (
    input       state,
    input       mode,
    output wire [15:0] led
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

    reg [15:0] state_led;
    reg [15:0] mode_led;

    assign led = state_led | mode_led;
    
    // Led display the mode
    always @(*) begin
        if (mode == NONE) mode_led = 16'b000000000000_1111;
        else if (mode == UP) mode_led = 16'b000000000000_1000;
        else if (mode == DOWN) mode_led = 16'b000000000000_0100;
        else if (mode == LEFTDOWN || mode == LEFTUP || mode == LEFT) mode_led = 16'b000000000000_0010;
        else if (mode == RIGHTDOWN || mode == RIGHTUP || mode == RIGHT) mode_led = 16'b000000000000_0001;
    end

    always @(*) begin
        if(state == START) state_led = 16'b1000000000000000;
        else if(state == PLAY) state_led = 16'b0100000000000000;
        else if(state == LOSE) state_led = 16'b0010000000000000;
        else if(state == WIN) state_led = 16'b0001000000000000;
    end
endmodule