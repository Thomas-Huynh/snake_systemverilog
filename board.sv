module board(
	output logic [15:0][15:0] RedPixels,
	output logic [15:0][15:0] GrnPixels,
	input logic [1:0][3:0] head, tail, apple, oldapple,
	input logic clk, reset
);

	always_ff @(posedge clk)
		if(reset) begin
			RedPixels <= '0;
			GrnPixels <= '0;
		end
		else begin
			GrnPixels[head[0]][head[1]] <= 1'b1;
			GrnPixels[tail[0]][tail[1]] <= 1'b0;
			RedPixels[apple[0]][apple[1]] <= 1'b1;
			RedPixels[oldapple[0]][oldapple[1]] <= 1'b0;
		end
		
endmodule
			