module apple_tb();
	logic [1:0][3:0] apple, oldapple;
	logic [255:0][1:0][3:0] snake;
	logic clk, reset;
	logic [7:0] LFSR_8;
	int curr_len;
	logic [8:0] speed_adjust;
	
	apple dut (.apple, .oldapple, .snake, .clk, .reset, .LFSR_8, .curr_len, .speed_adjust);
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		reset <= 1; LFSR_8 <= 8'b00000000; curr_len <= 3; snake[0] <= {4'b1000, 4'b1000}; snake[1] <= {4'b0111, 4'b1000}; snake[2] <= {4'b0110, 4'b1000}; speed_adjust = 9'b111111111; @(posedge clk);
		reset <= 0; LFSR_8 <= 8'b00000001; 											 @(posedge clk); //AVAIL -> AVAIL
						LFSR_8 <= 8'b00000011; snake[0] <= {4'b0011, 4'b1000}; @(posedge clk); //AVAIL -> GEN
						LFSR_8 <= 8'b00000111; snake[1] <= {4'b0000, 4'b0011}; @(posedge clk); //GEN -> GEN
						LFSR_8 <= 8'b00011110; 										    @(posedge clk); //GEN -> AVAIL
					   LFSR_8 <= 8'b00111101; 		                            @(posedge clk);
		$stop;
	end

endmodule
