module note_gen(
    input clk,                  // clock from crystal
    input rst,                  // active high reset
    input volume_up,            // volume up button
    input volume_down,          // volume down button   
    input [21:0] note_div_left, // div for note generation
    input [21:0] note_div_right,
    output [15:0] audio_left,
    output [15:0] audio_right
);

    // Declare internal signals
    reg [21:0] clk_cnt_next, clk_cnt;
    reg [21:0] clk_cnt_next_2, clk_cnt_2;
    reg b_clk, b_clk_next;
    reg c_clk, c_clk_next;

    // Note frequency generation
    // clk_cnt, clk_cnt_2, b_clk, c_clk
    always @(posedge clk or posedge rst)
        if (rst == 1'b1)
            begin
                clk_cnt <= 22'd0;
                clk_cnt_2 <= 22'd0;
                b_clk <= 1'b0;
                c_clk <= 1'b0;
            end
        else
            begin
                clk_cnt <= clk_cnt_next;
                clk_cnt_2 <= clk_cnt_next_2;
                b_clk <= b_clk_next;
                c_clk <= c_clk_next;
            end
    
    // clk_cnt_next, b_clk_next
    always @*
        if (clk_cnt == note_div_left)
            begin
                clk_cnt_next = 22'd0;
                b_clk_next = ~b_clk;
            end
        else
            begin
                clk_cnt_next = clk_cnt + 1'b1;
                b_clk_next = b_clk;
            end

    // clk_cnt_next_2, c_clk_next
    always @*
        if (clk_cnt_2 == note_div_right)
            begin
                clk_cnt_next_2 = 22'd0;
                c_clk_next = ~c_clk;
            end
        else
            begin
                clk_cnt_next_2 = clk_cnt_2 + 1'b1;
                c_clk_next = c_clk;
            end

    // Assign the amplitude of the note
    // Volume is controlled here 
    reg [5:0] scalar;
    reg [2:0] volume = 3'd3;
    wire [15:0] amplitude_u, amplitude_d;
    
    assign amplitude_u = (16'hE000 / scalar);
    assign amplitude_d = (16'h2000 / scalar);

    assign audio_left = (note_div_left == 22'd1) ? 16'h0000 : 
                                (b_clk == 1'b0) ? amplitude_u : amplitude_d;
    assign audio_right = (note_div_right == 22'd1) ? 16'h0000 : 
                                (c_clk == 1'b0) ? amplitude_u : amplitude_d;

    always @(posedge clk) begin
        if(volume + 1 <= 5 && volume_up) volume <= volume + 1;
        else if(volume - 1 >= 0 && volume_down) volume <= volume - 1;
        else volume <= volume;
    end

    always @(*) begin
        case (volume)
            3'd1: scalar = 5'd20;
            3'd2: scalar = 5'd16;
            3'd3: scalar = 5'd8;
            3'd4: scalar = 5'd4;
            3'd5: scalar = 5'd1;
            default: scalar = 5'd1;
        endcase
    end
endmodule