// Top-level module that defines the I/Os for the DE-1 SoC board
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, SW, LEDR, GPIO_1, CLOCK_50);
    output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	 output logic [9:0]  LEDR;
    input  logic [3:0]  KEY;
    input  logic [9:0]  SW;
    output logic [35:0] GPIO_1;
    input logic CLOCK_50;

	 
	 
	 
	 /* Set up system base clock to 1526 Hz (50 MHz / 2**(14+1))
	    ===========================================================*/
	 logic [31:0] clk;
	 logic SYSTEM_CLOCK;
	 
	 clock_divider divider (.clock(CLOCK_50), .divided_clocks(clk));
	 
	 assign SYSTEM_CLOCK = clk[14]; // 1526 Hz clock signal	 
	 
	 /* If you notice flickering, set SYSTEM_CLOCK faster.
	    However, this may reduce the brightness of the LED board. */
	
	 
	 /* Set up LED board driver
	    ================================================================== */
	 logic [15:0][15:0]RedPixels; // 16 x 16 array representing red LEDs
    logic [15:0][15:0]GrnPixels; // 16 x 16 array representing green LEDs
	 logic system_reset;                   // reset - toggle this on startup
	 
	 assign system_reset = SW[9];
	 
	 /* Standard LED Driver instantiation - set once and 'forget it'. 
	    See LEDDriver.sv for more info. Do not modify unless you know what you are doing! */
	 LEDDriver Driver (.CLK(SYSTEM_CLOCK), .RST(system_reset), .EnableCount(1'b1), .RedPixels, .GrnPixels, .GPIO_1);
	 
	 
	 /* LED board test submodule - paints the board with a static pattern.
	    Replace with your own code driving RedPixels and GrnPixels.
		 
	 	 KEY0      : Reset
		 =================================================================== */
	 logic left_synch, up_synch, down_synch, right_synch;
	 synchronizer LEFT_S (.out(left_synch), .clk(SYSTEM_CLOCK), .reset(system_reset), .in(~KEY[3]));
	 synchronizer UP_S (.out(up_synch), .clk(SYSTEM_CLOCK), .reset(system_reset), .in(~KEY[2]));
	 synchronizer DOWN_S (.out(down_synch), .clk(SYSTEM_CLOCK), .reset(system_reset), .in(~KEY[1]));
	 synchronizer RIGHT_S (.out(right_synch), .clk(SYSTEM_CLOCK), .reset(system_reset), .in(~KEY[0]));
	 
	 logic LEFT, UP, DOWN, RIGHT;
	 edge_detector L (.out(LEFT), .clk(SYSTEM_CLOCK), .reset(system_reset), .in(left_synch));
	 edge_detector U (.out(UP), .clk(SYSTEM_CLOCK), .reset(system_reset), .in(up_synch));
	 edge_detector D (.out(DOWN), .clk(SYSTEM_CLOCK), .reset(system_reset), .in(down_synch));
	 edge_detector R (.out(RIGHT), .clk(SYSTEM_CLOCK), .reset(system_reset), .in(right_synch));
	 
	 logic snake_left, snake_up, snake_down, snake_right, snake_still;
	 direction DIR (.LEFT(snake_left), .UP(snake_up), .DOWN(snake_down), .RIGHT(snake_right), .STILL(snake_still), .left(LEFT), .up(UP), .down(DOWN), .right(RIGHT), .clk(SYSTEM_CLOCK), .reset(system_reset));
	 
	 
	 
	 logic [255:0][1:0][3:0] snake;
	 logic [1:0][3:0] head;
	 logic [1:0][3:0] tail;
	 logic [1:0][3:0] apple, oldapple;
	 logic [7:0] LFSR_8;
	 logic lose;
	 int curr_len;
	 logic [8:0] speed_adjust;
	 
	 assign speed_adjust[8] = SW[2];
	 assign speed_adjust[7] = SW[1];
	 assign speed_adjust[6] = SW[0];
	 assign speed_adjust[5:0] = 6'b000000;
	 
	 snake SNEK (.head, .tail, .curr_len, .lose, .clk(SYSTEM_CLOCK), .reset(system_reset), .snake, .apple, .LEFT(snake_left), .UP(snake_up), .DOWN(snake_down), .RIGHT(snake_right), .STILL(snake_still), .PAUSE(SW[8]), .speed_adjust);
	 LFSR_8 lfsr (.res(LFSR_8), .clk(SYSTEM_CLOCK), .reset(system_reset));
	 apple APP (.apple, .oldapple, .LFSR_8, .clk(SYSTEM_CLOCK), .reset(system_reset), .snake, .curr_len, .speed_adjust);
	 board BOARD (.RedPixels, .GrnPixels, .head, .tail, .apple, .oldapple, .clk(SYSTEM_CLOCK), .reset(system_reset));
	 counter COUNT(.HUNDREDS(HEX2), .TENS(HEX1), .ONES(HEX0), .curr_len, .clk(SYSTEM_CLOCK), .reset(system_reset), .MESSAGE({HEX5, HEX4, HEX3}), .lose);
	 
	 
endmodule
