module snake_tb ();
	logic [1:0][3:0] head;
	logic [1:0][3:0] tail;
	int curr_len;
	logic lose;
	logic [1:0][3:0] apple;
	logic clk, reset;
	logic LEFT, UP, DOWN, RIGHT, STILL, PAUSE;
	logic [8:0] speed_adjust;
	
	snake dut (.head, .tail, .curr_len, .lose, .clk, .reset, .apple, .LEFT, .UP, .DOWN, .RIGHT, .STILL, .PAUSE, .speed_adjust);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk;
	end
	
	initial begin
		reset <= 1; PAUSE <= 0; LEFT <= 0; UP <= 0; DOWN <= 0; RIGHT <= 0; STILL <= 1; apple <= {4'b0000, 4'b0000}; speed_adjust = 9'b111111111; @(posedge clk);
		reset <= 0;																							@(posedge clk);
																												@(posedge clk);
													          RIGHT <= 1; STILL <= 0;				@(posedge clk);
					                      												            @(posedge clk);
																												@(posedge clk);
																												@(posedge clk);
																												@(posedge clk);
									  UP <= 1;            RIGHT <= 0;                        @(posedge clk);
									                                                         @(posedge clk);
																												@(posedge clk);
																												@(posedge clk);
						LEFT <= 1;			  UP <= 0;		                                 @(posedge clk);
																										      @(posedge clk);
																												@(posedge clk);
																												@(posedge clk);
																												@(posedge clk);
						LEFT <= 0;          DOWN <= 1;                                    @(posedge clk);
						                                                                  @(posedge clk);
																												@(posedge clk);
																												@(posedge clk);
																												@(posedge clk);
		reset <= 1;							  DOWN <= 0;				 STILL <= 1; 				@(posedge clk); //EATS AN APPLE
		reset <= 0;                                RIGHT <= 1; STILL <= 0;  apple <= {4'b0111, 4'b1000}; @(posedge clk);
																								  apple <= {4'b0111, 4'b1000}; @(posedge clk);
																								  apple <= {4'b0000, 4'b0000}; @(posedge clk);
																				                        @(posedge clk);
												  DOWN <= 1; RIGHT <= 0;								@(posedge clk);
																												@(posedge clk);
												   															@(posedge clk);
																												@(posedge clk);
												  DOWN <= 0; RIGHT <= 1;                        @(posedge clk);
												  DOWN <= 1; RIGHT <= 0;                        @(posedge clk);
					   LEFT <= 1;          DOWN <= 0;                                    @(posedge clk);
						LEFT <= 0; UP <= 1;                                               @(posedge clk); //DIES
						           UP <= 0;                                               @(posedge clk);
																									         @(posedge clk);
																 							               @(posedge clk);
																											   @(posedge clk);
		reset <= 1; 												 						STILL <= 1; @(posedge clk);
																  RIGHT <= 1;				STILL <= 0; @(posedge clk);
						PAUSE <= 1;                                                       @(posedge clk);
																											   @(posedge clk);
		
	$stop;
	end
endmodule
	
						