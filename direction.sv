module direction(
	output logic LEFT, RIGHT, UP, DOWN, STILL,
	input logic left, right, up, down,
	input logic clk, reset
);

	enum logic [2:0] {ST = 3'b000, L = 3'b100, U = 3'b101, D = 3'b110, R = 3'b111} ps, ns;
	
	assign STILL = (ps == ST);
	assign LEFT = (ps == L);
	assign RIGHT = (ps == R);
	assign UP = (ps == U);
	assign DOWN = (ps == D);
	
	always_ff @(posedge clk)
		if(reset)
			ps <= ST;
		else
			ps <= ns;
			
	
	
	always_comb
		case(ps)
			ST: begin
				if(up) ns = U;
				else if(down) ns = D;
				else if(right) ns = R;
				else ns = ST;
			end
			L: begin
				if(up) ns = U;
				else if(down) ns = D;
				else ns = L;
			end
			U: begin
				if(left) ns = L;
				else if (right) ns = R;
				else ns = U;
			end
			D: begin
				if(left) ns = L;
				else if (right) ns = R;
				else ns = D;
			end
			R: begin
				if(up) ns = U;
				else if(down) ns = D;
				else ns = R;
			end
		endcase
		
endmodule
