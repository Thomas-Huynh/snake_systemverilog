module apple(
	output logic [1:0][3:0] apple,
	output logic [1:0][3:0] oldapple,
	input logic [7:0] LFSR_8,
	input logic clk, reset,
	input logic [255:0][1:0][3:0] snake,
	input int curr_len,
	input logic [8:0] speed_adjust
);
	
	enum logic {AVAILABLE = 1'b0, GEN = 1'b1} ps, ns;
	
	logic [8:0] enable;
	assign enable = 9'b111111111 - speed_adjust;
	
	logic [8:0] counter;
	
	
	
	always_ff @(posedge clk)
		if(reset) begin
			apple[0] <= 4'b1000;
			apple[1] <= 4'b0011;
			oldapple[0] <= 4'b0000;
			oldapple[1] <= 4'b0000;
			
			ps <= AVAILABLE;
			counter <= 0;
		end
		else if(counter != enable)
			counter <= counter + 1'b1;
		else begin
			if(ns == GEN) begin
				apple[0] <= LFSR_8[3:0];
				apple[1] <= LFSR_8[7:4];
				
				oldapple <= apple;
			end
			ps <= ns;
			counter <= 0;
		end
	
	always_comb
		case(ps)
			AVAILABLE: begin
				if(apple == snake[0])
					ns = GEN;
				else
					ns = AVAILABLE;
				end
			GEN: begin
				ns = AVAILABLE;
				for(int i = 0; i < 256; i++) begin
					if(i > curr_len - 1)
						break;
					else begin
						if(apple == snake[i]) begin
							ns = GEN;
							break;
						end
					end
				end
				
			end
	
		endcase
		
endmodule
