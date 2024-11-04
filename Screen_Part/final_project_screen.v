module ScreenPart(
    input clk,
    input rst,
    input en,
    input dir,
    input vmir,
    input hmir,
    input enlarge,
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue,
    output hsync,
    output vsync
);
//larger
wire [11:0] data;
wire clk_25MHz;
wire clk_26;
wire clk_22;
wire [16:0] pixel_addr;
wire [11:0] pixel;
wire valid;
reg [9:0] h_cnt_now; //640
reg [9:0] v_cnt_now;  //480
wire[9:0] v_cnt,h_cnt;
assign {vgaRed, vgaGreen, vgaBlue} = (valid==1'b1) ? pixel:12'h0;
reg [1:0]state,next_state;
parameter start = 0;
parameter play = 1;
parameter ed = 2;
my_clock_divider #(.n(26))clk26(.clk(clk), .clk_div(clk_26));
my_clock_divider #(.n(22))clk2(.clk(clk), .clk_div(clk_22));
wire rst_1pulse;
wire rst_debounce;
debounce Rst_debounce (.clk(clk_25MHz), .pb(rst), .pb_debounced(rst_debounce));
one_pulse Rst_one_pulse (.clk(clk_25MHz), .pb_in(rst_debounce), .pb_out(rst_1pulse));
//state
always @(posedge clk_25MHz or posedge rst_1pulse) begin
    if(rst_1pulse) state<=start;
    else state<=next_state;
end
always @(*) begin
    if(dir && !enlarge) next_state = play;
    else if(!dir && enlarge)next_state = ed;
    else if(!dir && !enlarge) next_state = start;
    else next_state = state;
end
//count
reg count;
always @(posedge  clk_26 or posedge rst_1pulse) begin
    if(rst_1pulse) count <= 0;
    else if(state==ed)count <= !count;
    else count <= 0; 
end
//hcnt
always @(posedge clk_25MHz or posedge rst_1pulse) begin
    if(rst_1pulse) begin
        h_cnt_now<=(h_cnt>>1);
        v_cnt_now<=(v_cnt>>1);
    end
    else begin
        case (state)
            start:begin
                h_cnt_now<=(h_cnt>>2);
                v_cnt_now<=v_cnt>>2;
            end
            ed:begin
                if(count%2==0)begin
                    h_cnt_now<=(h_cnt>>2)+80;
                    v_cnt_now<=v_cnt>>2;
                end
                else begin
                    h_cnt_now<=(h_cnt>>2)+160;
                    v_cnt_now<=(v_cnt>>2);
                end
            end
            play:begin
                h_cnt_now<=h_cnt>>2;
                v_cnt_now<=(v_cnt>>2)+60;
            end
            default:begin
                h_cnt_now<=(h_cnt>>2)+80; 
                v_cnt_now<=(v_cnt>>2)+60;
            end
        endcase
    end
end
clock_divider clk_wiz_0_inst(
.clk(clk),
.clk1(clk_25MHz)
);

my_mem_addr_gen mem_addr_gen_inst(
.clk(clk_22),
.clk1(clk_25MHz),
.rst(rst_1pulse),
.h_cnt(h_cnt_now),
.v_cnt(v_cnt_now),
.dir(dir),
.vmir(vmir),
.hmir(hmir),
.en(en),
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
.reset(rst_1pulse),
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
   input dir,
   input vmir,
   input hmir,
   input en,
   output reg [16:0] pixel_addr
   );
//address
always @(posedge clk1)begin
    pixel_addr <= ((h_cnt>>1)+320*(v_cnt>>1)) % 76800;
end
endmodule

module my_clock_divider #(
    parameter n = 27
)(
    input wire  clk,
    output wire clk_div  
);

    reg [n-1:0] num;
    wire [n-1:0] next_num;

    always @(posedge clk) begin
        num <= next_num;
    end

    assign next_num = num + 1;
    assign clk_div = num[n-1];
endmodule