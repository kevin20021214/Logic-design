module Screen(
    input clk,
    input rst,
    input [1:0] state,
    input [3:0] volume,
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue,
    output hsync,
    output vsync
);
    wire clk_25MHz;
    wire clk_26;
    wire clk_22;
    clock_divider1  clk_wiz_0_inst(.clk(clk), .clk1(clk_25MHz));
    clock_divider   #(.n(22)) clk2(.clk(clk), .clk_div(clk_22));
    clock_divider   #(.n(26)) clk26(.clk(clk), .clk_div(clk_26));

    wire [11:0] data;
    wire [16:0] pixel_addr;
    wire [11:0] pixel;
    wire valid;
    reg [9:0] h_cnt_now; //640
    reg [9:0] v_cnt_now;  //480
    wire[9:0] v_cnt, h_cnt;
    assign {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel : 12'h0;
    parameter START = 0;
    parameter PLAY  = 1;
    parameter LOSE  = 2;
    parameter WIN   = 3;


    // Cnt for 1 sec
    reg count;
    always @(posedge clk_26 or posedge rst) begin
        if (rst) count <= 0;
        else if (state == LOSE || state == WIN)count <= !count;
        else count <= 0; 
    end

    always @(posedge clk_25MHz or posedge rst) begin
        if(rst) begin
            h_cnt_now <= (h_cnt >> 2);
            v_cnt_now <= (v_cnt >> 2);
        end
        else begin
            case (state)
                START: begin
                    h_cnt_now <= (h_cnt >> 2);
                    v_cnt_now <= (v_cnt >> 2);
                end
                PLAY: begin
                    case (volume)
                        0:begin
                            h_cnt_now <= (h_cnt >> 2);
                            v_cnt_now <= (v_cnt >> 2) + 120;
                        end
                        1:begin
                            h_cnt_now <= (h_cnt >> 2) + 160;
                            v_cnt_now <= (v_cnt >> 2) + 120;                            
                        end
                        2:begin
                            h_cnt_now <= (h_cnt >> 2) + 320;
                            v_cnt_now <= (v_cnt >> 2) + 120;
                        end
                        3: begin
                            h_cnt_now <= (h_cnt >> 2) + 480;
                            v_cnt_now <= (v_cnt >> 2) + 240;
                        end
                        default: begin
                            h_cnt_now <= (h_cnt >> 2);
                            v_cnt_now <= (v_cnt >> 2) + 120;
                        end
                    endcase
                end
                LOSE: begin
                     if(count[0] == 0)begin
                        h_cnt_now <= (h_cnt >> 2) + 480;
                        v_cnt_now <= (v_cnt >> 2) + 120;
                    end
                    else begin
                        h_cnt_now <= (h_cnt >> 2) + 480;
                        v_cnt_now <= (v_cnt >> 2);
                    end
                end
                WIN:begin
                     if(count[0] == 0)begin
                        h_cnt_now <= (h_cnt >> 2) + 160;
                        v_cnt_now <= (v_cnt >> 2);
                    end
                    else begin
                        h_cnt_now <=(h_cnt >> 2) + 320;
                        v_cnt_now <= (v_cnt >> 2);
                    end
                end
                default: begin
                    h_cnt_now <= (h_cnt >> 2) + 80; 
                    v_cnt_now <= (v_cnt >> 2) + 60;
                end
            endcase
        end
    end

    my_mem_addr_gen mem_addr_gen_inst(
        .clk(clk_22),
        .clk1(clk_25MHz),
        .rst(rst),
        .h_cnt(h_cnt_now),
        .v_cnt(v_cnt_now),
        .pixel_addr(pixel_addr)
    );
    blk_mem_gen_0 blk_mem_gen_0_inst(
        .clka(clk_25MHz),
        .wea(0),
        .addra(pixel_addr),
        .dina(data[11:0]),
        .douta(pixel)
    ); 
    vga_controller   vga_inst(
        .pclk(clk_25MHz),
        .reset(rst),
        .hsync(hsync),
        .vsync(vsync),
        .valid(valid),
        .h_cnt(h_cnt),
        .v_cnt(v_cnt)
    );
endmodule

module my_mem_addr_gen (
   input clk,
   input clk1,
   input rst,
   input [9:0] h_cnt,
   input [9:0] v_cnt,
   output reg [16:0] pixel_addr
);
    // address
    always @(posedge clk1)begin
        pixel_addr <= ((h_cnt >> 1) + 320 * (v_cnt >> 1)) % 76800;
    end
endmodule

module clock_divider1(clk1, clk);
    input clk;
    output clk1;

    reg [1:0] num;
    wire [1:0] next_num;

    always @(posedge clk) begin
        num <= next_num;
    end

    assign next_num = num + 1'b1;
    assign clk1 = num[1];

endmodule
