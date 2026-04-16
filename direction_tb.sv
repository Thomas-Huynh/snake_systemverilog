module direction_tb();
	logic LEFT, RIGHT, UP, DOWN, STILL;
	logic left, right, up, down;
	logic clk, reset;
	
	direction dut (.LEFT, .RIGHT, .UP, .DOWN, .STILL, .left, .right, .up, .down, .clk, .reset);
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		reset <= 1; left <= 0; right <= 0; up <= 0; down <= 0; @(posedge clk);
		reset <= 0;                                            @(posedge clk); //ST -> ST
																				 @(posedge clk);
						left <= 1;                                 @(posedge clk); //ST -> ST
						left <= 0;                                 @(posedge clk);
							        right <= 1;                     @(posedge clk); //ST -> RIGHT
									  right <= 0; up <= 1;            @(posedge clk); //RIGHT -> UP
													  up <= 0;            @(posedge clk);
																  down <= 1; @(posedge clk);
									  right <= 1;          down <= 0; @(posedge clk); //UP -> RIGHT
									  right <= 0;                     @(posedge clk);
						left <= 1;                                 @(posedge clk);
						left <= 0;                      down <= 1; @(posedge clk); //RIGHT -> DOWN
						                                down <= 0; @(posedge clk);
													  up <= 1;            @(posedge clk);
									  right <= 1; up <= 0;            @(posedge clk); //DOWN -> RIGHT
						           right <= 0; up <= 1;            @(posedge clk); //RIGHT -> UP
						left <= 1;             up <= 0;            @(posedge clk); //UP -> LEFT
	               left <= 0;                      down <= 1; @(posedge clk); //LEFT -> DOWN
	               left <= 1;                      down <= 0; @(posedge clk); //DOWN -> LEFT
	               left <= 0;                      down <= 1; @(posedge clk); //LEFT -> DOWN
      reset <= 1;            right <= 0;                     @(posedge clk);
      reset <= 0;                        up <= 1;            @(posedge clk); //ST -> UP
      reset <= 1;                        up <= 0; 		       @(posedge clk);
		reset <= 0;                                 down <= 1; @(posedge clk);
																				 @(posedge clk); //ST -> DOWN
		$stop;
	end
	
endmodule
