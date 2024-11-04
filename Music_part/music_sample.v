module music_example (
    input clk,
    input rst,
	input [11:0] ibeatNum,
    input mode,
	output reg [31:0] toneL,
    output reg [31:0] toneR
);
    parameter sc = 32'd50000000;
    
    parameter C3 = 32'd131;
    parameter D3 = 32'd147;
    parameter E3 = 32'd165;
    parameter F3 = 32'd174;
    parameter G3 = 32'd196;
    parameter A3 = 32'd220;
    parameter B3 = 32'd247;

    parameter C4 = C3 * 2;
    parameter D4 = D3 * 2;
    parameter E4 = E3 * 2;
    parameter F4 = 32'd349;
    parameter G4 = G3 * 2;
    parameter GSharp4 = 32'd415;
    parameter A4 = A3 * 2;
    parameter B4 = B3 * 2;


    parameter C5 = C4 * 2;
    parameter D5 = D4 * 2;
    parameter E5 = E4 * 2;
    parameter F5 = F4 * 2;
    parameter G5 = G4 * 2;
    parameter A5 = A4 * 2;
    parameter B5 = B4 * 2;

    parameter STARTGAME = 3'd0;
    parameter PLAYING = 3'd1;
    parameter ENDGAME = 3'd2;


    // --- Tone_R ---
    always @(*) begin
        if(mode == STARTGAME || mode == ENDGAME) begin
             case (ibeatNum)
                // --- Measure 1 ---
                12'd0: toneR = C4;      12'd1: toneR = C4; 
                12'd2: toneR = C4;      12'd3: toneR = C4;
                12'd4: toneR = C4;      12'd5: toneR = C4;
                12'd6: toneR = C4;      12'd7: toneR = C4;
                12'd8: toneR = C4;      12'd9: toneR = C4; 
                12'd10: toneR = C4;     12'd11: toneR = C4;
                12'd12: toneR = C4;     12'd13: toneR = C4;
                12'd14: toneR = C4;     12'd15: toneR = C4; 

                12'd16: toneR = D4;     12'd17: toneR = D4;
                12'd18: toneR = D4;     12'd19: toneR = D4;
                12'd20: toneR = D4;     12'd21: toneR = D4;
                12'd22: toneR = D4;     12'd23: toneR = D4;
                12'd26: toneR = B4;     12'd27: toneR = B4; 
                12'd24: toneR = B4;     12'd25: toneR = B4;
                12'd28: toneR = B4;     12'd29: toneR = B4;
                12'd30: toneR = B4;     12'd31: toneR = B4;

                12'd34: toneR = C5;     12'd35: toneR = C5;
                12'd32: toneR = C5;     12'd33: toneR = C5;
                12'd36: toneR = C5;     12'd37: toneR = C5;
                12'd38: toneR = C5;     12'd39: toneR = C5;
                12'd40: toneR = C5;     12'd41: toneR = C5; 
                12'd42: toneR = C5;     12'd43: toneR = C5;
                12'd44: toneR = C5;     12'd45: toneR = C5;
                12'd46: toneR = C5;     12'd47: toneR = C5;

                12'd48: toneR = GSharp4;     12'd49: toneR = GSharp4;
                12'd50: toneR = GSharp4;     12'd51: toneR = GSharp4;
                12'd52: toneR = GSharp4;     12'd53: toneR = GSharp4;
                12'd54: toneR = GSharp4;     12'd55: toneR = GSharp4;
                12'd56: toneR = G4;     12'd57: toneR = G4; 
                12'd58: toneR = G4;     12'd59: toneR = G4;
                12'd60: toneR = G4;     12'd61: toneR = G4;
                12'd62: toneR = G4;     12'd63: toneR = G4;

                // --- Measure 2 ---
                12'd64: toneR = C4;     12'd65: toneR = C4;
                12'd66: toneR = C4;     12'd67: toneR = C4;
                12'd68: toneR = C4;     12'd69: toneR = C4;
                12'd70: toneR = C4;     12'd71: toneR = C4;
                12'd72: toneR = C4;     12'd73: toneR = C4; 
                12'd74: toneR = C4;     12'd75: toneR = C4;
                12'd76: toneR = C4;     12'd77: toneR = C4;
                12'd78: toneR = C4;     12'd79: toneR = C4;

                12'd80: toneR = D4;     12'd81: toneR = D4;
                12'd82: toneR = D4;     12'd83: toneR = D4;
                12'd84: toneR = D4;     12'd85: toneR = D4;
                12'd86: toneR = D4;     12'd87: toneR = D4;
                12'd88: toneR = B4;     12'd89: toneR = B4;
                12'd90: toneR = B4;     12'd91: toneR = B4;
                12'd92: toneR = B4;     12'd93: toneR = B4;
                12'd94: toneR = B4;     12'd95: toneR = B4;

                12'd96: toneR = C5;     12'd97: toneR = C5; 
                12'd98: toneR = C5;     12'd99: toneR = C5;
                12'd100: toneR = C5;    12'd101: toneR = C5;
                12'd102: toneR = C5;    12'd103: toneR = C5; 
                12'd104: toneR = C5;    12'd105: toneR = C5; 
                12'd106: toneR = C5;    12'd107: toneR = C5;
                12'd108: toneR = C5;    12'd109: toneR = C5;
                12'd110: toneR = C5;    12'd111: toneR = C5; 

                12'd112: toneR = E4;    12'd113: toneR = E4; 
                12'd114: toneR = E4;    12'd115: toneR = E4;
                12'd116: toneR = E4;    12'd117: toneR = E4;
                12'd118: toneR = E4;    12'd119: toneR = E4;
                12'd120: toneR = D4;    12'd121: toneR = D4;
                12'd122: toneR = D4;    12'd123: toneR = D4;
                12'd124: toneR = D4;    12'd125: toneR = D4;
                12'd126: toneR = D4;    12'd127: toneR = D4;
                default: toneR = sc;
            endcase 
        end
        else if(mode == PLAYING) begin
              case (ibeatNum)
                // --- Measure 1 ---
                12'd0: toneR = G4;      12'd1: toneR = G4; 
                12'd2: toneR = G4;      12'd3: toneR = G4;
                12'd4: toneR = G4;     12'd5: toneR = G4;
                12'd6: toneR = G4;      12'd7: toneR = G4;
                12'd8: toneR = GSharp4;      12'd9: toneR = GSharp4; 
                12'd10: toneR = GSharp4;     12'd11: toneR = GSharp4;
                12'd12: toneR = GSharp4;     12'd13: toneR = GSharp4;
                12'd14: toneR = GSharp4;     12'd15: toneR = GSharp4; 

                12'd16: toneR = G4;     12'd17: toneR = G4;
                12'd18: toneR = G4;     12'd19: toneR = G4;
                12'd20: toneR = G4;     12'd21: toneR = G4;
                12'd22: toneR = G4;     12'd23: toneR = G4;
                12'd26: toneR = A4;     12'd27: toneR = A4; 
                12'd24: toneR = A4;     12'd25: toneR = A4;
                12'd28: toneR = A4;     12'd29: toneR = A4;
                12'd30: toneR = A4;     12'd31: toneR = A4;

                12'd34: toneR = G4;     12'd35: toneR = G4;
                12'd32: toneR = G4;     12'd33: toneR = G4;
                12'd36: toneR = G4;     12'd37: toneR = G4;
                12'd38: toneR = G4;     12'd39: toneR = G4;
                12'd40: toneR = GSharp4;     12'd41: toneR = GSharp4; 
                12'd42: toneR = GSharp4;     12'd43: toneR = GSharp4;
                12'd44: toneR = GSharp4;     12'd45: toneR = GSharp4;
                12'd46: toneR = GSharp4;     12'd47: toneR = GSharp4;

                12'd48: toneR = G4;     12'd49: toneR = G4;
                12'd50: toneR = G4;     12'd51: toneR = G4;
                12'd52: toneR = G4;     12'd53: toneR = G4;    
                12'd54: toneR = G4;     12'd55: toneR = G4;
                12'd56: toneR = B4;     12'd57: toneR = B4; 
                12'd58: toneR = B4;     12'd59: toneR = B4;
                12'd60: toneR = B4;     12'd61: toneR = B4;
                12'd62: toneR = B4;     12'd63: toneR = B4;

                // --- Measure 2 ---
                12'd64: toneR = B4;     12'd65: toneR = B4;
                12'd66: toneR = B4;     12'd67: toneR = B4;
                12'd68: toneR = B4;     12'd69: toneR = B4;
                12'd70: toneR = B4;     12'd71: toneR = B4;
                12'd72: toneR = C5;     12'd73: toneR = C5; 
                12'd74: toneR = C5;     12'd75: toneR = C5;
                12'd76: toneR = C5;     12'd77: toneR = C5;
                12'd78: toneR = C5;     12'd79: toneR = C5;

                12'd80: toneR = B4;     12'd81: toneR = B4;
                12'd82: toneR = B4;     12'd83: toneR = B4;
                12'd84: toneR = B4;     12'd85: toneR = B4;
                12'd86: toneR = B4;     12'd87: toneR = B4;
                12'd88: toneR = D5;     12'd89: toneR = D5;
                12'd90: toneR = D5;     12'd91: toneR = D5;
                12'd92: toneR = D5;     12'd93: toneR = D5;
                12'd94: toneR = D5;     12'd95: toneR = D5;

                12'd96: toneR = B4;     12'd97: toneR = B4; 
                12'd98: toneR = B4;     12'd99: toneR = B4;
                12'd100: toneR = B4;    12'd101: toneR = B4;
                12'd102: toneR = B4;    12'd103: toneR = B4; 
                12'd104: toneR = C5;    12'd105: toneR = C5; 
                12'd106: toneR = C5;    12'd107: toneR = C5;
                12'd108: toneR = C5;    12'd109: toneR = C5;
                12'd110: toneR = C5;    12'd111: toneR = C5; 

                12'd112: toneR = B4;    12'd113: toneR = B4; 
                12'd114: toneR = B4;    12'd115: toneR = B4;
                12'd116: toneR = B4;    12'd117: toneR = B4;
                12'd118: toneR = B4;    12'd119: toneR = B4;
                12'd120: toneR = E5;    12'd121: toneR = E5;
                12'd122: toneR = E5;    12'd123: toneR = E5;
                12'd124: toneR = E5;    12'd125: toneR = E5;
                12'd126: toneR = E5;    12'd127: toneR = E5;
                default: toneR = sc;
            endcase
        end
    end

    // --- Tone_L ---
    always @(*) begin
        if(mode == STARTGAME || mode == ENDGAME) begin
            case (ibeatNum) 
                12'd0: toneL = C5;      12'd1: toneL = C5; // HC (one-beat)
                12'd2: toneL = C5;      12'd3: toneL = C5;
                12'd4: toneL = C5;      12'd5: toneL = C5;
                12'd6: toneL = C5;      12'd7: toneL = C5;
                12'd8: toneL = C5;      12'd9: toneL = C5; 
                12'd10: toneL = C5;     12'd11: toneL = C5;
                12'd12: toneL = C5;     12'd13: toneL = C5;
                12'd14: toneL = C5;     12'd15: toneL = C5;

                12'd16: toneL = D5;     12'd17: toneL = D5; // HC (one-beat)
                12'd18: toneL = D5;     12'd19: toneL = D5;
                12'd20: toneL = D5;     12'd21: toneL = D5;
                12'd22: toneL = D5;     12'd23: toneL = D5;
                12'd24: toneL = D5;     12'd25: toneL = D5;
                12'd26: toneL = D5;     12'd27: toneL = D5;
                12'd28: toneL = D5;     12'd29: toneL = D5;
                12'd30: toneL = D5;     12'd31: toneL = D5;

                12'd32: toneL = E5;     12'd33: toneL = E5; 
                12'd34: toneL = E5;     12'd35: toneL = E5;
                12'd36: toneL = E5;     12'd37: toneL = E5;
                12'd38: toneL = E5;     12'd39: toneL = E5;
                12'd40: toneL = E5;     12'd41: toneL = E5;
                12'd42: toneL = E5;     12'd43: toneL = E5;
                12'd44: toneL = E5;     12'd45: toneL = E5;
                12'd46: toneL = E5;     12'd47: toneL = E5;

                12'd48: toneL = sc;     12'd49: toneL = sc;
                12'd50: toneL = sc;     12'd51: toneL = sc;
                12'd52: toneL = sc;     12'd53: toneL = sc;
                12'd54: toneL = sc;     12'd55: toneL = sc;
                12'd56: toneL = sc;     12'd57: toneL = sc;
                12'd58: toneL = sc;     12'd59: toneL = sc;
                12'd60: toneL = sc;     12'd61: toneL = sc;
                12'd62: toneL = sc;     12'd63: toneL = sc;
                    // --- Measure 2 ---
                12'd64: toneL = C5;     12'd65: toneL = C5; 
                12'd66: toneL = C5;     12'd67: toneL = C5;
                12'd68: toneL = C5;     12'd69: toneL = C5;
                12'd70: toneL = C5;     12'd71: toneL = C5;
                12'd72: toneL = C5;     12'd73: toneL = C5; 
                12'd74: toneL = C5;     12'd75: toneL = C5;
                12'd76: toneL = C5;     12'd77: toneL = C5;
                12'd78: toneL = C5;     12'd79: toneL = C5;

                12'd80: toneL = D5;     12'd81: toneL = D5;
                12'd82: toneL = D5;     12'd83: toneL = D5;
                12'd84: toneL = D5;     12'd85: toneL = D5;
                12'd86: toneL = D5;     12'd87: toneL = D5;
                12'd88: toneL = D5;     12'd89: toneL = D5; 
                12'd90: toneL = D5;     12'd91: toneL = D5;
                12'd92: toneL = D5;     12'd93: toneL = D5;
                12'd94: toneL = D5;     12'd95: toneL = D5;

                12'd96: toneL = E5;     12'd97: toneL = E5; // G (one-beat)
                12'd98: toneL = E5;     12'd99: toneL = E5;
                12'd100: toneL = E5;    12'd101: toneL = E5;
                12'd102: toneL = E5;    12'd103: toneL = E5;
                12'd104: toneL = E5;    12'd105: toneL = E5;
                12'd106: toneL = E5;    12'd107: toneL = E5;
                12'd108: toneL = E5;    12'd109: toneL = E5;
                12'd110: toneL = E5;    12'd111: toneL = E5;

                12'd112: toneL = sc;    12'd113: toneL = sc; // B (one-beat)
                12'd114: toneL = sc;    12'd115: toneL = sc;
                12'd116: toneL = sc;    12'd117: toneL = sc;
                12'd118: toneL = sc;    12'd119: toneL = sc;
                12'd120: toneL = sc;    12'd121: toneL = sc;
                12'd122: toneL = sc;    12'd123: toneL = sc;
                12'd124: toneL = sc;    12'd125: toneL = sc;
                12'd126: toneL = sc;    12'd127: toneL = sc;
                default: toneL = sc;
            endcase
        end
        else if(mode == PLAYING) begin
            case (ibeatNum)
                12'd0: toneL = C4;       12'd1: toneL = C4; // HC (one-beat)
                12'd2: toneL = C4;       12'd3: toneL = C4;
                12'd4: toneL = C4;       12'd5: toneL = C4;
                12'd6: toneL = C4;       12'd7: toneL = C4;
                12'd8: toneL = C4;       12'd9: toneL = C4; 
                12'd10: toneL = C4;     12'd11: toneL = C4;
                12'd12: toneL = C4;     12'd13: toneL = C4;
                12'd14: toneL = C4;     12'd15: toneL = C4;

                12'd16: toneL = C4;     12'd17: toneL = C4;
                12'd18: toneL = C4;     12'd19: toneL = C4;
                12'd20: toneL = C4;     12'd21: toneL = C4;
                12'd22: toneL = C4;     12'd23: toneL = C4;
                12'd24: toneL = C4;     12'd25: toneL = C4;
                12'd26: toneL = C4;     12'd27: toneL = C4;
                12'd28: toneL = C4;     12'd29: toneL = C4;
                12'd30: toneL = C4;     12'd31: toneL = C4;

                12'd32: toneL = C4;     12'd33: toneL = C4; // G (one-beat)
                12'd34: toneL = C4;     12'd35: toneL = C4;
                12'd36: toneL = C4;     12'd37: toneL = C4;
                12'd38: toneL = C4;     12'd39: toneL = C4;
                12'd40: toneL = C4;     12'd41: toneL = C4;
                12'd42: toneL = C4;     12'd43: toneL = C4;
                12'd44: toneL = C4;     12'd45: toneL = C4;
                12'd46: toneL = C4;     12'd47: toneL = C4;

                12'd48: toneL = C4;     12'd49: toneL = C4; // B (one-beat)
                12'd50: toneL = C4;     12'd51: toneL = C4;
                12'd52: toneL = C4;     12'd53: toneL = C4;
                12'd54: toneL = C4;     12'd55: toneL = C4;
                12'd56: toneL = D4;     12'd57: toneL = D4;
                12'd58: toneL = D4;     12'd59: toneL = D4;
                12'd60: toneL = D4;     12'd61: toneL = D4;
                12'd62: toneL = D4;     12'd63: toneL = D4;

                // --- Measure 2 ---
                12'd64: toneL = E4;     12'd65: toneL = E4; // HC (one-beat)
                12'd66: toneL = E4;     12'd67: toneL = E4;
                12'd68: toneL = E4;     12'd69: toneL = E4;
                12'd70: toneL = E4;     12'd71: toneL = E4;
                12'd72: toneL = E4;     12'd73: toneL = E4; 
                12'd74: toneL = E4;     12'd75: toneL = E4;
                12'd76: toneL = E4;     12'd77: toneL = E4;
                12'd78: toneL = E4;     12'd79: toneL = E4;

                12'd80: toneL = E4;     12'd81: toneL = E4; // HC (one-beat)
                12'd82: toneL = E4;     12'd83: toneL = E4;
                12'd84: toneL = E4;     12'd85: toneL = E4;
                12'd86: toneL = E4;     12'd87: toneL = E4;
                12'd88: toneL = E4;     12'd89: toneL = E4; 
                12'd90: toneL = E4;     12'd91: toneL = E4;
                12'd92: toneL = E4;     12'd93: toneL = E4;
                12'd94: toneL = E4;     12'd95: toneL = E4;

                12'd96: toneL = E4;     12'd97: toneL = E4; // G (one-beat)
                12'd98: toneL = E4;     12'd99: toneL = E4;
                12'd100: toneL = E4;    12'd101: toneL = E4;
                12'd102: toneL = E4;    12'd103: toneL = E4;
                12'd104: toneL = E4;    12'd105: toneL = E4;
                12'd106: toneL = E4;    12'd107: toneL = E4;
                12'd108: toneL = E4;    12'd109: toneL = E4;
                12'd110: toneL = E4;    12'd111: toneL = E4;

                12'd112: toneL = E4;    12'd113: toneL = E4; // B (one-beat)
                12'd114: toneL = E4;    12'd115: toneL = E4;
                12'd116: toneL = E4;    12'd117: toneL = E4;
                12'd118: toneL = E4;    12'd119: toneL = E4;
                12'd120: toneL = E4;    12'd121: toneL = E4;
                12'd122: toneL = E4;    12'd123: toneL = E4;
                12'd124: toneL = E4;    12'd125: toneL = E4;
                12'd126: toneL = E4;    12'd127: toneL = E4;
                default: toneL = sc;
            endcase
        end      
    end

endmodule