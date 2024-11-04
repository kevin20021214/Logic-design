module player_control (
	input clk, 
	input reset, 
	input state, 
	output reg [11:0] ibeat
);
	
	parameter LEN = 4095;
    reg [15:0] next_ibeat;
	reg [15:0] load_ibeat = 0;

	always @(posedge clk, posedge reset) begin
		if (reset) ibeat <= 0;
		else ibeat <= next_ibeat;
	end

    always @(*) begin
        next_ibeat = (ibeat + 1 < LEN) ? (ibeat + 1) : 0;
    end
endmodule