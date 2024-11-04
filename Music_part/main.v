module main (
    input clk,
    input rst,
    input volume_up,
    input volume_down,
    output audio_mclk,      // master clock
    output audio_lrck,      // left-right clock
    output audio_sck,       // serial clock
    output audio_sdin       // serial audio data input
);

    music_part Mp0(
        .clk(clk),
        .rst(rst),
        .audio_mclk(audio_mclk),      // master clock
        .audio_lrck(audio_lrck),      // left-right clock
        .audio_sck(audio_sck),       // serial clock
        .audio_sdin(audio_sdin) 
    );

endmodule