module snake #(parameter MAX_LEN = 256) (
	output logic [1:0][3:0] head ,
	output logic [1:0][3:0] tail,
	output logic  [255:0][1:0][3:0] snake,
	output int curr_len,
	output logic lose,
	input logic clk, reset, 
	input [1:0][3:0] apple,
	input logic LEFT, UP, DOWN, RIGHT, STILL,
	input logic PAUSE,
	input logic [8:0] speed_adjust
);

	enum logic [1:0] {ALIVE = 2'b00, DEAD = 2'b11, GROW = 2'b01} ps, ns;
	
	
	assign head = snake[0];
	assign lose = (ps == DEAD);
	
	logic died;
	logic [8:0] enable;
	assign enable = 9'b111111111 - speed_adjust;
	
	logic [8:0] counter;                                                                                                                                                                        
	
	always_ff @(posedge clk)
		if(reset) begin
			curr_len <= 3'd3;
			ps <= ALIVE;
			
			//rows
			snake[0][0] <= 4'b1000;
			snake[1][0] <= 4'b1000;
			snake[2][0] <= 4'b1000;
			
			//columns
			snake[0][1] <= 4'b1000;
			snake[1][1] <= 4'b1001;
			snake[2][1] <= 4'b1010;
			
			tail[0] <= 4'b1000;
			tail[1] <= 4'b1011;
			counter <= 9'b0;
		
		end
		else if(counter != enable)
			counter <= counter + 1'b1;
		else begin
			if(STILL | ns == DEAD | curr_len >= 256 | PAUSE)
				snake <= snake;
			else begin
				if(LEFT)
					snake[0][1] <= snake[0][1] + 1'b1;
				else if(UP)
					snake[0][0] <= snake[0][0] - 1'b1;
				else if(DOWN)
					snake[0][0] <= snake[0][0] + 1'b1;
				else if (RIGHT)
					snake[0][1] <= snake[0][1] - 1'b1;
				else
					snake[0] <= snake[0];
						

				for(int i = 1; i < 256; i++) begin
					if(i > curr_len - 1)
						break;
					else
						snake[i] <= snake[i - 1];
				end
					
					
				if(ns == GROW) begin
					curr_len <= curr_len + 1;
					snake[curr_len] <= snake[curr_len - 1];
					if(snake[curr_len - 1][0] > snake[curr_len - 2][0]) begin
						tail[0] <= snake[curr_len - 1][0] + 1'b1;
						tail[1] <= snake[curr_len - 1][1];
					end
					else if(snake[curr_len - 1][0] < snake[curr_len - 2][0]) begin
						tail[0] <= snake[curr_len - 1][0] - 1'b1;
						tail[1] <= snake[curr_len - 1][1];
					end
					else if(snake[curr_len - 1][1] > snake[curr_len - 2][1]) begin
						tail[0] <= snake[curr_len - 1][0];
						tail[1] <= snake[curr_len - 1][1] + 1'b1;
					end
					else begin
						tail[0] <= snake[curr_len - 1][0];
						tail[1] <= snake[curr_len - 1][1] - 1'b1;
					end
				end
				else
					tail <= snake[curr_len - 1];
					
			end
		
			ps <= ns;
			counter <= 9'b0;
		
		end
				
			
		
	always_comb begin
		died = 0;
		for(int i = 1; i < 256; i++) begin
			if(i > curr_len - 1)
				break;
			else begin
				if(snake[0] == snake[i]) begin
					died = 1;
					break;
				end
			end
		end
		
		case(ps)
			DEAD: ns = DEAD;
			ALIVE: begin
				if(died)
					ns = DEAD;
				else if(snake[0] == apple)
					ns = GROW;
				else
					ns = ALIVE;
			end
			GROW: begin
				if(died)
					ns = DEAD;
				else
					ns = ALIVE;
			end
		endcase
	end
		
endmodule
				