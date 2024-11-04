module music_part(
    input clk,
    input rst,
    input volume_up,
    input volume_down,
    output audio_mclk,      // master clock
    output audio_lrck,      // left-right clock
    output audio_sck,       // serial clock
    output audio_sdin       // serial audio data input
);
    wire clk_div_22;
    clock_divider #(22) c0(.clk(clk), .clk_div(clk_div_22));
    
    wire Debounce_VolUp, Debounce_VolDown;
    wire One_VolUp, One_VolDown;
    debounce d0(.clk(clk), .pb(_volUP), .pb_debounced(Debounce_VolUp));
    debounce d1(.clk(clk), .pb(_volDOWN), .pb_debounced(Debounce_VolDown));
    onepulse o0(.clk(clk), .signal(Debounce_VolUp), .op(One_VolUp));
    onepulse o1(.clk(clk), .signal(Debounce_VolDown), .op(One_VolDown));

    wire [15:0] audio_in_left, audio_in_right;  // Internal Signal
    wire [11:0] ibeatNum;                       // Beat counter
    wire [31:0] freqL, freqR;                   // Raw frequency, produced by music module     
    wire [21:0] freq_outL, freq_outR;           // Processed frequency, adapted to the clock rate of Basys3 

    // Note gen makes no sound, if freq_out = 50000000 / `silence = 1
    assign freq_outL = 50000000 / freqL;
    assign freq_outR = 50000000 / freqR;

    music_example music_00 (
        .clk(clk),
        .rst(rst),
        .ibeatNum(ibeatNum),
        .mode(1),
        .toneL(freqL),
        .toneR(freqR)
    );
    player_control #(.LEN(128)) playerCtrl0 ( 
        .clk(clk_div_22),
        .reset(rst),
        .mode(1),
        .ibeat(ibeatNum)
    );

    // Note generator
    note_gen noteGen0(
        .clk(clk), 
        .rst(rst),
        .volume_up(One_VolDown),            // volume up button
        .volume_down(One_VolUp),          // volume down button   
        .note_div_left(freq_outL), 
        .note_div_right(freq_outR), 
        .audio_left(audio_in_left),     // left sound audio
        .audio_right(audio_in_right)    // right sound audio
    );

    // Speaker controller
    speaker_control sc(
        .clk(clk), 
        .rst(rst), 
        .audio_in_left(audio_in_left),      // left channel audio data input
        .audio_in_right(audio_in_right),    // right channel audio data input
        .audio_mclk(audio_mclk),            // master clock
        .audio_lrck(audio_lrck),            // left-right clock
        .audio_sck(audio_sck),              // serial clock
        .audio_sdin(audio_sdin)             // serial audio data input
    );


endmodule