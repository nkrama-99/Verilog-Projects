module fill
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
		KEY,							// On Board Keys
		LEDR,
		SW,
        HEX0,
        HEX1,
        HEX2,
        HEX3,
        HEX4,
        HEX5,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			    CLOCK_50;				//	50 MHz
	input	[3:0]	    KEY;					
	output [9:0]    LEDR;
	input [9:0]         SW;
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
    // Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[7:0]	VGA_R;   				//	VGA Red[7:0] Changed from 10 to 8-bit DAC
	output	[7:0]	VGA_G;	 				//	VGA Green[7:0]
	output	[7:0]	VGA_B;   				//	VGA Blue[7:0]
	
	wire resetn;
	assign resetn = 1'b1;
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.

    // FSM wires
	wire [23:0] colour;
	wire [10:0] x;
	wire [10:0] y;
	wire writeEn;
    wire [3:0] state;

    wire [10:0] useless;

    // rate divider wires
    wire [25:0] counter_out;
    wire clock_out;
    wire [25:0] upperBound_out;
    wire [1:0] clock_setting;

    //NOTE: Position marks the place to be printed so 
    // sasuke & shuriken wires
    wire [10:0] sasukePositionX;
    wire [10:0] sasukePositionY;
    wire [10:0] shurikenOriginX;
    wire [10:0] shurikenOriginY;
    wire [3:0] shurikenDirection;
    wire [10:0] shurikenPosX;
    wire [10:0] shurikenPosY;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 8;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn
	// for the VGA controller, in addition to any other functionality your design may require.

    sasukeOrigin sasuke0 (
        .keyInput(~KEY[3:0]),
        .sasukeOriginX(sasukePositionX),
        .sasukeOriginY(sasukePositionY),
        .LEDoutput(useless[3:0])
    );

    shurikenOrigin shuriken0 (
        .LEDoutput(LEDR[3:0]),
        .clk(CLOCK_50),
        .keyInput(SW[9:6]),
        .shurikenOriginX(shurikenOriginX),
        .shurikenOriginY(shurikenOriginY),
        .shurikenDirection(shurikenDirection)
    );

    wire [25:0] test_wait_counter;

    controller D0 (
        .LEDoutput(LEDR[9:6]),
        .clk(CLOCK_50),
        .test(test_wait_counter),
        .resetGame(SW[1]),
        .playAgain(SW[0]),
        .sasukePosX(sasukePositionX),
        .sasukePosY(sasukePositionY),
        .shurikenOriginX(shurikenOriginX),
        .shurikenOriginY(shurikenOriginY),
        .shurikenDirection(shurikenDirection),
        .x(x),
        .y(y),
        .colour(colour),
        .writeEn(writeEn)
    );

    hex_decoder H0( //originY
        .hex_digit(test_wait_counter[3:0]), 
        .segments(HEX0)
    );

    hex_decoder H1( //originX
        .hex_digit(test_wait_counter[7:4]), 
        .segments(HEX1)
    );
	 
			
endmodule

module sasukeOrigin (keyInput, sasukeOriginX, sasukeOriginY, LEDoutput);

	localparam 		S_UP		= 4'b0100,
					S_DOWN		= 4'b0010,
					S_LEFT 		= 4'b1000,
					S_RIGHT		= 4'b0001,
					S_NONE	 	= 4'b0000;

	input [3:0] keyInput;
	output reg [10:0] sasukeOriginX;
    output reg [10:0] sasukeOriginY;
    output reg [3:0] LEDoutput;
	
	always @(*) 
	begin
		case (keyInput[3:0])
			S_LEFT: begin 
				sasukeOriginX <= 11'd55;
                sasukeOriginY <= 11'd60;
                LEDoutput <= S_LEFT;
			end
			
			S_UP: begin 
				sasukeOriginX <= 11'd80;
                sasukeOriginY <= 11'd35;
                LEDoutput <= S_UP;
			end
			
			S_DOWN: begin 
				sasukeOriginX <= 11'd80;
                sasukeOriginY <= 11'd85;
                LEDoutput <= S_DOWN;
			end
			
			S_RIGHT: begin 
				sasukeOriginX <= 11'd105;
                sasukeOriginY <= 11'd60;
                LEDoutput <= S_RIGHT;
			end
			
			// S_NONE: begin //none pressed - center
            //     sasukeOriginX <= ;
            //     sasukeOriginY <= ;
			// end
			
			default: begin //default (including none pressed) - position at center
                sasukeOriginX <= 11'd80;
                sasukeOriginY <= 11'd60;
                LEDoutput <= S_NONE;
            end
		endcase
	end
	
endmodule

module shurikenOrigin (LEDoutput, clk, keyInput, shurikenOriginX, shurikenOriginY, shurikenDirection);

	localparam 		S_UP		= 4'b0100,
					S_DOWN		= 4'b0010,
					S_LEFT 		= 4'b1000,
					S_RIGHT		= 4'b0001,
					S_NONE	 	= 4'b0000;

	input [3:0] keyInput;
    input clk;
	output reg [10:0] shurikenOriginX;
    output reg [10:0] shurikenOriginY;
    output reg [3:0] shurikenDirection;
    output reg [3:0] LEDoutput;
	
	always@(clk) 
	begin
		case (keyInput[3:0])
			S_LEFT: begin 
				shurikenOriginX <= 11'd30;
                shurikenOriginY <= 11'd60;
                shurikenDirection <= S_LEFT;
                LEDoutput <= S_LEFT;
			end
			
			S_UP: begin 
				shurikenOriginX <= 11'd80;
                shurikenOriginY <= 11'd20;
                shurikenDirection <= S_UP;
                LEDoutput <= S_UP;
			end
			
			S_DOWN: begin 
				shurikenOriginX <= 11'd80;
                shurikenOriginY <= 11'd100;
                shurikenDirection <= S_DOWN;
                LEDoutput <= S_DOWN;
			end
			
			S_RIGHT: begin 
				shurikenOriginX <= 11'd130;
                shurikenOriginY <= 11'd60;
                shurikenDirection <= S_RIGHT;
                LEDoutput <= S_RIGHT;
			end
			
			// S_NONE: begin //none pressed - center
            //     shurikenOriginX <= ;
            //     shurikenOriginY <= ;
			// end
			
			default: begin //default (including none pressed) - position at center
                // do nothing
                shurikenDirection <= S_NONE;
                LEDoutput <= S_NONE;
            end
		endcase
	end
	
endmodule

module controller (
        LEDoutput, clk, test, resetGame, playAgain,
        sasukePosX, sasukePosY,
        shurikenOriginX, shurikenOriginY, shurikenDirection,
        x, y, colour, writeEn
    );

 	localparam	S_DRAW_BG		    = 7'b00000001,
                S_LOCATE_SHURIKEN   = 7'b00000010,
                S_DRAW_SHURIKEN     = 7'b00000100,
                S_DRAW_SASUKE       = 7'b00001000,
                S_WAIT              = 7'b00010000,
                S_RESET             = 7'b00100000, //is the start page & also the pause page
                S_GAMEOVER          = 7'b01000000,
                S_GAMEOVER_CHECK    = 7'b10000000;

    output reg [10:0] x;
    output reg [10:0] y;
    output reg writeEn;
    output reg [23:0] colour;

    input resetGame;
    input playAgain;
    input [10:0] sasukePosX;
    input [10:0] sasukePosY;
    input [10:0] shurikenOriginX;
    input [10:0] shurikenOriginY;
    input [3:0] shurikenDirection;
    
    output reg [3:0] LEDoutput;
	input clk;
    output [25:0] test;

    reg [10:0] currentState;
    reg [10:0] nextState;

    // counter wires
    reg [10:0] x_loop_bg;
    reg [10:0] y_loop_bg;
    wire [23:0] getBackgroundColour;
    reg [5:0] x_loop_sasuke;
    reg [5:0] y_loop_sasuke;
    wire [23:0] getSasukeColour;
    reg [10:0] x_loop_shu;
    reg [10:0] y_loop_shu;
    reg [5:0] x_loop_shuriken;
    reg [5:0] y_loop_shuriken;
    wire [23:0] getNarutoColour;
    reg [20:0] counter_naruto_background;
    reg [20:0] counter_bg;
    reg [20:0] counter_draw_background;
    reg [25:0] counter_wait;
    reg [10:0] counter_sasuke;
    reg [10:0] counter_draw_sasuke;
    reg [10:0] counter_draw_naruto;
    reg [10:0] counter_shuriken;
    reg [10:0] x_loop_reset;
    reg [10:0] y_loop_reset;
    reg [10:0] x_loop_go;
    reg [10:0] y_loop_go;
    reg [10:0] counter_goc;
    reg [10:0] counter_go;
    reg [10:0] shurikenUsedCounter;
    reg whoWon; // 1-NARUTO LOST || 0-SASUKE LOST
	 reg [20:0] counter_draw_endscreen;
	 wire [23:0] getEndscreenColour;
	 wire [23:0] getEndscreen2Colour;
	 reg [20:0] counter_draw_startscreen;
	 wire [23:0] getStartscreenColour;
	 
	 sasuke s1 (
			.address(counter_draw_sasuke),
			.clock(clk),
			.data(1'b0),
			.wren(1'b0),
			.q(getSasukeColour)
	 );
	 
	 valleyofdeath background (
			.address(counter_draw_background),
			.clock(clk),
			.data(1'b0),
			.wren(1'b0),
			.q(getBackgroundColour)
	 );
	 
	 rasenshuriken naruto (
			.address(counter_draw_naruto),
			.clock(clk),
			.data(1'b0),
			.wren(1'b0),
			.q(getNarutoColour)
	 );
	 
	 endscreen endscreen (
			.address(counter_draw_endscreen),
			.clock(clk),
			.data(1'b0),
			.wren(1'b0),
			.q(getEndscreenColour)
	 );
	 
	 	 endscreen2 endscreen2 (
			.address(counter_draw_endscreen),
			.clock(clk),
			.data(1'b0),
			.wren(1'b0),
			.q(getEndscreen2Colour)
	 );
	 
	 startscreen startscreen (
			.address(counter_draw_startscreen),
			.clock(clk),
			.data(1'b0),
			.wren(1'b0),
			.q(getStartscreenColour)
	 );

    // state transition definition
    always@(posedge clk) 
    begin
        case (currentState)
            
            S_DRAW_BG: begin 

                if (counter_draw_background < 19199) begin
                    counter_draw_background <= counter_draw_background + 1;
                    
                    if (counter_draw_background % 160 == 0) begin
                        y_loop_bg <= y_loop_bg + 1;
                        x_loop_bg <= 0;
                    end
        
                    else begin
                    x_loop_bg <= x_loop_bg + 1;
                    end
                end

                else begin
                    counter_draw_background <= 0;
                    x_loop_bg <= 0;
                    y_loop_bg <= 0;
                end
				
                x = x_loop_bg;
                y = y_loop_bg;
                colour = getBackgroundColour;
					 
                writeEn = 1'b1;

                // conditions to switch state
                if (counter_draw_background == 19199) begin
                    counter_sasuke = 0; //reset counter for sasuke
                    x_loop_sasuke = 0;
                    y_loop_sasuke = 0;
                    nextState = S_DRAW_SASUKE;
                end
                else begin
                    counter_bg = counter_bg + 1;
                    nextState = S_DRAW_BG;
                end

            end
            
            S_DRAW_SASUKE: begin
          
                if (counter_draw_sasuke < 299) begin
                    counter_draw_sasuke <= counter_draw_sasuke + 1;
                    if (counter_draw_sasuke % 15 == 0) begin
                        y_loop_sasuke <= y_loop_sasuke + 1;
                        x_loop_sasuke <= 0;
                    end
        
                    else begin
                    x_loop_sasuke <= x_loop_sasuke + 1;
                    end
                end

                else begin
                    counter_draw_sasuke <= 0;
                    x_loop_sasuke <= 0;
                    y_loop_sasuke <= 0;
                end
    
                // assignment of vga wires
                x = sasukePosX + x_loop_sasuke - 8;
                y = sasukePosY + y_loop_sasuke - 10;
                    
                colour = getSasukeColour;
					 
                writeEn <= (getSasukeColour < 24'b111110001111100011111000);
					
                // conditions to switch state
                if (counter_draw_sasuke == 299) begin
                    nextState = S_LOCATE_SHURIKEN;
                end
                else begin
                    counter_sasuke = counter_sasuke + 1;
                    nextState = S_DRAW_SASUKE;
                end

            end

            S_LOCATE_SHURIKEN: begin
                
                // execute shuriken printing
                // reached center so must reset
                // move from right
                if (shurikenDirection == 4'b1000) begin
                    if (x_loop_shu == 11'd80 && y_loop_shu == 11'd60) begin
                        x_loop_shu = shurikenOriginX;
                        y_loop_shu = shurikenOriginY;
                        shurikenUsedCounter = shurikenUsedCounter + 1; //incrementing shuriken used to decide game over
                    end
                    
                    if (x_loop_shu == 11'd161 && y_loop_shu == 11'd121) begin //if none reset condition
                        x_loop_shu = shurikenOriginX;
                        y_loop_shu = shurikenOriginY;
                    end
                    
                    else begin
                        x_loop_shu = x_loop_shu + 1;
                        y_loop_shu = y_loop_shu;
                    end

                    // LEDoutput = 4'b1000;
                    writeEn = 1'b1;
                end

                //move from left
                if (shurikenDirection == 4'b0001) begin
                    if (x_loop_shu == 11'd80 && y_loop_shu == 11'd60) begin //reached center so reset
                        x_loop_shu = shurikenOriginX;
                        y_loop_shu = shurikenOriginY;
                        shurikenUsedCounter = shurikenUsedCounter + 1; //incrementing shuriken used to decide game over
                    end
                    
                    if (x_loop_shu == 11'd161 && y_loop_shu == 11'd121) begin //if none reset condition
                        x_loop_shu = shurikenOriginX;
                        y_loop_shu = shurikenOriginY;
                    end
                    
                    else begin
                        x_loop_shu = x_loop_shu - 1;
                        y_loop_shu = y_loop_shu;
                    end

                    // LEDoutput = 4'b0001;
                    writeEn = 1'b1;
                end

                //move from down
                if (shurikenDirection == 4'b0010) begin
                    if (x_loop_shu == 11'd80 && y_loop_shu == 11'd60) begin //reached center so reset
                        x_loop_shu = shurikenOriginX;
                        y_loop_shu = shurikenOriginY;
                        shurikenUsedCounter = shurikenUsedCounter + 1; //incrementing shuriken used to decide game over
                    end
                    
                    if (x_loop_shu == 11'd161 && y_loop_shu == 11'd121) begin //if none reset condition
                        x_loop_shu = shurikenOriginX;
                        y_loop_shu = shurikenOriginY;
                    end
                    
                    else begin
                        x_loop_shu = x_loop_shu;
                        y_loop_shu = y_loop_shu - 1;
                    end

                    // LEDoutput = 4'b0010;
                    writeEn = 1'b1;
                end

                //move from up
                if (shurikenDirection == 4'b0100) begin
                    if (x_loop_shu == 11'd80 && y_loop_shu == 11'd60) begin //reached center so reset
                        x_loop_shu = shurikenOriginX;
                        y_loop_shu = shurikenOriginY;
                        shurikenUsedCounter = shurikenUsedCounter + 1; //incrementing shuriken used to decide game over
                    end
                    
                    if (x_loop_shu == 11'd161 && y_loop_shu == 11'd121) begin //if none reset condition
                        x_loop_shu = shurikenOriginX;
                        y_loop_shu = shurikenOriginY;
                    end
                    
                    else begin
                        x_loop_shu = x_loop_shu;
                        y_loop_shu = y_loop_shu + 1;
                    end

                    // LEDoutput = 4'b0100;
                    writeEn = 1'b1;
                end

                //if NONE
                if (shurikenDirection == 4'b0000) begin
                    x_loop_shu =  11'd161;
                    y_loop_shu = 11'd121;
                    writeEn = 1'b0;
                end
                
                // conditions to switch state
                counter_shuriken = 0;
                nextState = S_DRAW_SHURIKEN;

            end

            S_DRAW_SHURIKEN: begin 
                
                if (counter_draw_naruto < 35) begin
                    
                    counter_draw_naruto <= counter_draw_naruto + 1;

                    if (counter_draw_naruto % 6 == 0) begin
                        y_loop_shuriken <= y_loop_shuriken + 1;
                        x_loop_shuriken <= 0;
                    end
        
                    else begin
                        x_loop_shuriken <= x_loop_shuriken + 1;
                    end

                end
                else begin
                    counter_draw_naruto <= 0;
                    x_loop_shuriken <= 0;
                    y_loop_shuriken <= 0;
                end

                // assignment of vga wires
                x = x_loop_shu + x_loop_shuriken - 5;
                y = y_loop_shu + y_loop_shuriken - 5;
                colour = getNarutoColour;
					 
                if(shurikenDirection ==  4'b0000) begin
                    writeEn = 1'b0;
                end
                
                else begin
                    writeEn = 1'b1;
                end

                // conditions to switch state
                if (counter_draw_naruto == 11'd35) begin
                    counter_wait = 0; //reset counter for sasuke
                    nextState = S_WAIT;
                end
                else begin
                    counter_shuriken = counter_shuriken + 1;
                    nextState = S_DRAW_SHURIKEN;
                end

            end

            S_WAIT: begin

                // do nothing for about 200ms just to allow the human eyes to see
                // if (counter_wait == 26'd10000000) begin
                if (counter_wait == 50*50000) begin
                    counter_goc = 0;
                    nextState = S_GAMEOVER_CHECK;
                end
                else begin
                    counter_wait = counter_wait + 1;
                    nextState = S_WAIT;
                end

            end

            S_GAMEOVER_CHECK: begin 

                // state indicator
                if (x_loop_shu < sasukePosX + 5 && x_loop_shu > sasukePosX - 5 && y_loop_shu < sasukePosY + 5 && y_loop_shu > sasukePosY - 5) begin
                    // LEDoutput <= 4'b0110;
                    counter_go <= 0;
                    nextState <= S_GAMEOVER;
                    whoWon <= 0; //shuriken hits sasuke - sasuke lost
                end
                else if (shurikenUsedCounter == 10) begin
                    counter_go <= 0;
                    nextState <= S_GAMEOVER;
                    whoWon <= 1; //ran out of shurikens - naruto lost
                end
                else begin
                    counter_bg <= 0; //reset loop condiditon for bg
                    nextState <= S_DRAW_BG;
                end

            end

            S_GAMEOVER: begin

                // state indicator
                // LEDoutput = 4'b1111;
                
                // execute reset printing
                if (counter_draw_endscreen < 19199) begin
                    counter_draw_endscreen <= counter_draw_endscreen + 1;
                    if (counter_draw_endscreen % 160 == 0) begin
                        y_loop_go <= y_loop_go + 1;
                        x_loop_go <= 0;
                    end
        
                    else begin
                    x_loop_go <= x_loop_go + 1;
                    end
                end

                else begin
                    counter_draw_endscreen <= 0;
                    x_loop_go <= 0;
                    y_loop_go <= 0;
                end
                
                // assignment of vga wires
                x = x_loop_go;
                y = y_loop_go;
                // colour = 3'b110;

                if (whoWon == 1) colour = getEndscreenColour; //naruto lost - red
                else colour = getEndscreen2Colour; //sasuke lost - green
                
                writeEn = 1'b1;

                // counter_bg = 0; //reset loop condiditon for bg
                counter_draw_background = 0;
                x_loop_shu = 11'd161; //resetting shuriken position for playagain
                y_loop_shu = 11'd121; //resetting shuriken position for playagain
                shurikenUsedCounter = 0; //resetting shuriken used counter
            end

            S_RESET: begin

                // state indicator
                // LEDoutput = LEDoutput + 1;

                // execute reset printing
                if (counter_draw_startscreen < 19199) begin
                    counter_draw_startscreen <= counter_draw_startscreen + 1;
                    if (counter_draw_startscreen % 160 == 0) begin
                        y_loop_reset <= y_loop_reset + 1;
                        x_loop_reset <= 0;
                    end
        
                    else begin
                    x_loop_reset <= x_loop_reset + 1;
                    end
                end

                else begin
                    counter_draw_startscreen <= 0;
                    x_loop_reset <= 0;
                    y_loop_reset <= 0;
                end
                
                // assignment of vga wires
                x = x_loop_reset;
                y = y_loop_reset;
                colour = getStartscreenColour;
                writeEn = 1'b1;

                // if exit the state move to bg
                nextState = S_DRAW_BG;

            end

            default: begin 
                // LEDoutput = 4'b1111;
                nextState = S_DRAW_BG;
            end

        endcase
	 
	 end

    assign test = shurikenUsedCounter;
    
    // state changer
    always@(posedge clk)
    begin
        // special reset condition for gameover
        if (currentState == S_GAMEOVER) begin
            if (playAgain == 1) begin
                LEDoutput <= 4'b0110;
                currentState = S_RESET;
            end
            else begin
                LEDoutput <= 4'b1111;
                currentState <= S_GAMEOVER;
            end
        end

        // condition to check for pause/start game state
        else if (resetGame == 1) begin 
            LEDoutput <= 4'b1001;
            currentState <= S_RESET; //note: no shurikens or sasuke position change during reset
        end

        else begin
            LEDoutput <= LEDoutput + 1;
            currentState <= nextState;
        end
    end

endmodule

module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
endmodule