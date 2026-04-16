module LFSR_8_tb ();
	logic [7:0] res;
	logic clk, reset;
	
	LFSR_8 dut (.res, .clk, .reset);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		reset <= 1; @(posedge clk);
		reset <= 0; 
		repeat (256)
			@(posedge clk);
	$stop;
	end
endmodule
