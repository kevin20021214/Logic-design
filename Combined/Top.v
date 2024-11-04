module Top (
    input   clk,					// 100Mhz onboard clock
	input   rst,					// Button D
	input   MISO,					// Master In Slave Out, Pin 3, Port JA
	input   [2:0] SW,				// Switches 2, 1, and 0
	output  SS,      			    // Slave Select, Pin 1, Port JA
	output  MOSI,				    // Master Out Slave In, Pin 2, Port JA
	output  SCLK,				    // Serial Clock, Pin 4, Port JA
	output  [15:0] led,			
    output  IN1,
    output  IN2,
    output  IN3, 
    output  IN4,
    output  left_pwm,
    output  right_pwm,
    input   volume_up,              // volume up button
    input   volume_down,            // volume down button
    output  audio_mclk,             // master clock
    output  audio_lrck,             // left-right clock
    output  audio_sck,              // serial clock
    output  audio_sdin,             // serial audio data input
    output  [3:0] vgaRed,           // red VGA output
    output  [3:0] vgaGreen,         // green VGA output
    output  [3:0] vgaBlue,          // blue VGA output
    output  hsync,                  // horizontal sync
    output  vsync,                   // vertical sync
    output  trig,                  // trigger
	input   echo,                   // echo
    output  [6:0] display,          // 7-segment display
    output  [3:0] digit,            // 7-segment digit select
	inout   PS2_DATA,
	inout   PS2_CLK
);
    // ===========================================================================
	// 				    STATE PART
	// ===========================================================================
    // START = 0;
    // PLAY  = 1;
    // LOSE  = 2;
    // WIN   = 3;
    wire [1:0] state;
    stateTrasition stTra(
        .clk(clk),
        .rst(rst),
        .trig(trig),
        .echo(echo),
        .state(state),
        .display(display),
        .digit(digit),
        .PS2_DATA(PS2_DATA),
        .PS2_CLK(PS2_CLK)
    ); // State transition

    // ===========================================================================
	// 				    MUSIC PART
	// ===========================================================================
    wire clk_div_22, clk_div_15;
    clock_divider #(22) c0(.clk(clk), .clk_div(clk_div_22));
    clock_divider #(15) c1(.clk(clk), .clk_div(clk_div_15));

    wire Debounce_VolUp, Debounce_VolDown;
    wire One_VolUp, One_VolDown;
    debounce d0(.clk(clk_div_15), .pb(volume_up),              .pb_debounced(Debounce_VolUp));
    debounce d1(.clk(clk_div_15), .pb(volume_down),            .pb_debounced(Debounce_VolDown));
    onepulse o0(.clk(clk_div_15), .signal(Debounce_VolUp),     .op(One_VolUp));
    onepulse o1(.clk(clk_div_15), .signal(Debounce_VolDown),   .op(One_VolDown));

    wire [15:0] audio_in_left, audio_in_right;  // Internal Signal
    wire [11:0] ibeatNum;                       // Beat counter
    wire [31:0] freqL, freqR;                   // Raw frequency, produced by music module     
    wire [21:0] freq_outL, freq_outR;           // Processed frequency, adapted to the clock rate of Basys3 
    wire [1:0]  volume;                         // Volume control

    // Note gen makes no sound, if freq_out = 50000000 / `silence = 1
    assign freq_outL = 50000000 / freqL;
    assign freq_outR = 50000000 / freqR;

    music_example music_00 (
        .clk(clk),
        .rst(rst),
        .ibeatNum(ibeatNum),
        .state(state),
        .toneL(freqL),
        .toneR(freqR)
    ); // Music module
    player_control #(.LEN(128)) playerCtrl0 ( 
        .clk(clk_div_22),
        .reset(rst),
        .state(state),
        .ibeat(ibeatNum)
    ); // Player control
    note_gen noteGen0(
        .clk(clk), 
        .rst(rst),
        .volume_up(One_VolUp),            // volume up button
        .volume_down(One_VolDown),            // volume down button   
        .note_div_left(freq_outL), 
        .note_div_right(freq_outR), 
        .audio_left(audio_in_left),         // left sound audio
        .audio_right(audio_in_right),       // right sound audio
        .volume(volume)
    ); // Note generator
    speaker_control sc(
        .clk(clk), 
        .rst(rst), 
        .audio_in_left(audio_in_left),      // left channel audio data input
        .audio_in_right(audio_in_right),    // right channel audio data input
        .audio_mclk(audio_mclk),            // master clock
        .audio_lrck(audio_lrck),            // left-right clock
        .audio_sck(audio_sck),              // serial clock
        .audio_sdin(audio_sdin)             // serial audio data input
    ); // Speaker controller

    // ===========================================================================
	// 				    MOTOR PART
	// ===========================================================================
    wire [3:0] mode;
    JSTK2 pjstk2_ctrl(
        .CLK(clk),
        .RST(rst),
        .MISO(MISO),
        .SW(SW),
        .SS(SS),
        .MOSI(MOSI),
        .SCLK(SCLK),
        .mode(mode)
    ); // Joystick control
    motor motor_ctrl(
        .clk(clk),
        .rst(rst),
        .pwm({left_pwm, right_pwm}),
        .l_IN({IN1, IN2}),
        .r_IN({IN3, IN4}),
        .mode(mode),
        .state(state)
    ); // Motor control

    // ===========================================================================
	// 				    SCREEN PART
	// ===========================================================================
    Screen screen(
        .clk(clk),
        .rst(rst),
        .state(state),
        .volume(volume),
        .vgaRed(vgaRed),
        .vgaGreen(vgaGreen),
        .vgaBlue(vgaBlue),
        .hsync(hsync),
        .vsync(vsync)
    ); // Screen control

    // ===========================================================================
	// 				    LED PART
	// ===========================================================================
    ledCtrl Led(
        .state(state),
        .mode(mode),
        .led(led)
    ); // Led control
endmodule