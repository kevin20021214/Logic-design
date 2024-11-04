module stateTrasition(
	input 	 	clk,
	input  		rst,
	output 		trig,
	input 		echo,
	output reg	[1:0] state,
	output wire [6:0] display,
	output wire [3:0] digit,
	inout wire 	PS2_DATA,
	inout wire 	PS2_CLK
	);
    wire clk_1hz;
    clock_divider #(.n(26)) clk1h(.clk(clk), .clk_div(clk_1hz));

    wire [19:0] distance;

    parameter START = 0;
    parameter PLAY 	= 1;
    parameter LOSE 	= 2;
    parameter WIN 	= 3;

    reg [9:0] sec, next_sec;
    wire [15:0] nums;

    // board
    wire [511:0] key_down;
    wire [8:0] last_change;
    wire been_ready;
    reg [3:0] key_num;
    parameter [8:0] KEY_CODES [0:21] = {
    	9'b0_0100_0101,	// 0 => 45
    	9'b0_0001_0110,	// 1 => 16
    	9'b0_0001_1110,	// 2 => 1E
    	9'b0_0010_0110,	// 3 => 26
    	9'b0_0010_0101,	// 4 => 25
    	9'b0_0010_1110,	// 5 => 2E
    	9'b0_0011_0110,	// 6 => 36
    	9'b0_0011_1101,	// 7 => 3D
    	9'b0_0011_1110,	// 8 => 3E
    	9'b0_0100_0110,	// 9 => 46
    
    	9'b0_0111_0000, // right_0 => 70
    	9'b0_0110_1001, // right_1 => 69
    	9'b0_0111_0010, // right_2 => 72
    	9'b0_0111_1010, // right_3 => 7A
    	9'b0_0110_1011, // right_4 => 6B
    	9'b0_0111_0011, // right_5 => 73
    	9'b0_0111_0100, // right_6 => 74
    	9'b0_0110_1100, // right_7 => 6C
    	9'b0_0111_0101, // right_8 => 75
    	9'b0_0111_1101,  // right_9 => 7D

    	9'b0_0101_1010,//enter=>5A
    	9'b0_0010_1001//space=>29
    };
    bin2bcd BCDchange(
        .bin(sec),
        .bcd(nums)
    );
    sonic_top Sonic(
    	.clk(clk), 
    	.rst(rst), 
    	.Echo(echo), 
    	.Trig(trig),
    	.distance(distance)
    );

    KeyboardDecoder KeyDecoder(
    	.key_down(key_down),
    	.last_change(last_change),
    	.key_valid(been_ready),
    	.PS2_DATA(PS2_DATA),
    	.PS2_CLK(PS2_CLK),
    	.rst(rst),
    	.clk(clk)
    );
    My_SevenSegment SevenSeg(
    	.display(display),
    	.digit(digit),
    	.nums(nums),
    	.rst(rst),
    	.clk(clk)
    );
	
    // Cnt for sec
    always @(posedge clk_1hz or posedge rst) begin
    	if (rst) sec <= 0;
    	else if (state == PLAY) sec <= next_sec;
        else sec <= 0;
    end
    always @(*) begin
    	if (state == PLAY) next_sec = sec + 1;
    	else next_sec = 0;
    end

    // State transition
    always @(posedge clk or posedge rst) begin
    	if (rst) state <= START;
    	else begin
    		case (state)
            START: begin 
                if(been_ready && key_down[last_change] == 1 && key_num == 10) state <= PLAY;
                else state <= state; 
            end
            PLAY: begin
                if(sec >= 300) state <= LOSE;
    			else if(distance < 30) state <= WIN;
                else state <= state;
            end
            LOSE: begin
                if(been_ready && key_down[last_change] == 1 && key_num == 10) state <= START;
                else state <= state;
            end
    		WIN: begin
    			if(been_ready && key_down[last_change] == 1 && key_num == 10) state <= START;
                else state <= state;
    		end 
    		default: state <= state;
    		endcase
        end
    end
    //key_of_keyboard
    always @ (*) begin
    	case (last_change)
    		KEY_CODES[00]: key_num = 4'b0000;
    		KEY_CODES[01]: key_num = 4'b0001;
    		KEY_CODES[02]: key_num = 4'b0010;
    		KEY_CODES[03]: key_num = 4'b0011;
    		KEY_CODES[04]: key_num = 4'b0100;
    		KEY_CODES[05]: key_num = 4'b0101;
    		KEY_CODES[06]: key_num = 4'b0110;
    		KEY_CODES[07]: key_num = 4'b0111;
    		KEY_CODES[08]: key_num = 4'b1000;
    		KEY_CODES[09]: key_num = 4'b1001;
    		KEY_CODES[10]: key_num = 4'b0000;
    		KEY_CODES[11]: key_num = 4'b0001;
    		KEY_CODES[12]: key_num = 4'b0010;
    		KEY_CODES[13]: key_num = 4'b0011;
    		KEY_CODES[14]: key_num = 4'b0100;
    		KEY_CODES[15]: key_num = 4'b0101;
    		KEY_CODES[16]: key_num = 4'b0110;
    		KEY_CODES[17]: key_num = 4'b0111;
    		KEY_CODES[18]: key_num = 4'b1000;
    		KEY_CODES[19]: key_num = 4'b1001;
    		KEY_CODES[20]: key_num = 4'b1010;
    		KEY_CODES[21]: key_num = 4'b1011;
    		default : key_num = 4'b1111;
    	endcase
    end
endmodule

module My_SevenSegment(
	output reg [6:0] display,
	output reg [3:0] digit,
	input wire [15:0] nums,
	input wire rst,
	input wire clk
);
    
    reg [15:0] clk_divider;
    reg [3:0] display_num;
    
    always @ (posedge clk, posedge rst) begin
    	if (rst) begin
    		clk_divider <= 15'b0;
    	end else begin
    		clk_divider <= clk_divider + 15'b1;
    	end
    end
    
    always @ (posedge clk_divider[15], posedge rst) begin
    	if (rst) begin
    		display_num <= 4'b0000;
    		digit <= 4'b1111;
    	end else begin
    		case (digit)
    			4'b1110 : begin
    					display_num <= nums[7:4];
    					digit <= 4'b1101;
    				end
    			4'b1101 : begin
						display_num <= nums[11:8];
						digit <= 4'b1011;
					end
    			4'b1011 : begin
						display_num <= nums[15:12];
						digit <= 4'b0111;
					end
    			4'b0111 : begin
						display_num <= nums[3:0];
						digit <= 4'b1110;
					end
    			default : begin
						display_num <= nums[3:0];
						digit <= 4'b1110;
					end				
    		endcase
    	end
    end
    
    always @ (*) begin
    	case (display_num)
    		0 : display = 7'b1000000;	//0000
			1 : display = 7'b1111001;   //0001                                                
			2 : display = 7'b0100100;   //0010                                                
			3 : display = 7'b0110000;   //0011                                             
			4 : display = 7'b0011001;   //0100                                               
			5 : display = 7'b0010010;   //0101                                               
			6 : display = 7'b0000010;   //0110
			7 : display = 7'b1111000;   //0111
			8 : display = 7'b0000000;   //1000
			9 : display = 7'b0010000;	//1001
			
			10:display=7'b0111111;//-
			default : display = 7'b1111111;
    	endcase
    end
    
endmodule

module bin2bcd (
    input [9:0] bin,
    output reg [15:0] bcd
);
    integer i;
    always @(bin) begin
    bcd = 0;		 	
    for(i=0; i<=9; i=i+1) begin
        if(bcd[3:0]>4) begin
            bcd[3:0] = bcd[3:0] + 3;
        end
        if(bcd[7:4]>4) begin
            bcd[7:4] = bcd[7:4] + 3;
        end
        if(bcd[11:8]>4) begin
            bcd[11:8] = bcd[11:8] + 3;
        end
        if(bcd[15:12]>4) begin
            bcd[15:12] = bcd[15:12] + 3;
        end
        bcd = {bcd[14:0], bin[9-i]};
    end
end
endmodule