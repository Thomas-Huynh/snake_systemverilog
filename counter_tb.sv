module counter_tb();
	logic [6:0] HUNDREDS, TENS, ONES;
	logic [2:0][6:0] MESSAGE;
	int curr_len;
	logic clk, reset;
	logic lose;
	
	counter dut (.HUNDREDS, .TENS, .ONES, .MESSAGE, .curr_len, .clk, .reset, .lose);
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		reset <= 1; curr_len <= 3; lose <= 0; @(posedge clk);
		reset <= 0;						@(posedge clk);
											@(posedge clk);
						curr_len <= 4; @(posedge clk);
						curr_len <= 5; @(posedge clk);
						curr_len <= 6; @(posedge clk);
						curr_len <= 7; @(posedge clk);
						curr_len <= 8; @(posedge clk);
						curr_len <= 9; @(posedge clk);
						curr_len <= 10; @(posedge clk);
						curr_len <= 11; @(posedge clk);
						curr_len <= 12; @(posedge clk);
						curr_len <= 13; @(posedge clk);
						curr_len <= 23; @(posedge clk);
						curr_len <= 33; @(posedge clk);
						curr_len <= 43; @(posedge clk);
						curr_len <= 53; @(posedge clk);
						curr_len <= 63; @(posedge clk);
						curr_len <= 73; @(posedge clk);
						curr_len <= 83; @(posedge clk);
						curr_len <= 93; @(posedge clk);
						curr_len <= 103; @(posedge clk);
						curr_len <= 203; @(posedge clk);
						curr_len <= 256; @(posedge clk);
						curr_len <= 137; @(posedge clk);
						lose <= 1;       @(posedge clk);
											  @(posedge clk);
	$stop;
	end
endmodule
