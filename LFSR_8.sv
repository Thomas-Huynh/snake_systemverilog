module LFSR_8 (
	output logic [7:0] res,
	input logic clk, reset
);

	logic [7:0] cycle_num;
	always_ff @(posedge clk)
		if(reset) begin
			res <= 8'b0;
			cycle_num <= 8'b0;
		end
		else begin
			res[1] <= res[0];
			res[2] <= res[1];
			res[3] <= res[2];
			res[4] <= res[3];
			res[5] <= res[4];
			res[6] <= res[5];
			res[7] <= res[6];
			
			res[0] <= ~(res[7] ^ res[5] ^ res[4] ^ res[3]);
			
			if(res == 8'b0)
				cycle_num <= 8'b0;
			else
				cycle_num <= cycle_num + 1'b1;
		end
endmodule
