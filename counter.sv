module counter (
	output logic [6:0] HUNDREDS, TENS, ONES,
	output logic [2:0][6:0] MESSAGE,
	input int curr_len,
	input logic clk, reset, lose
);
	
	int score;
	assign score = curr_len - 3;
	
	int ones, tens, hundreds;
	assign ones = score % 10;
	assign tens = (score / 10) % 10;
	assign hundreds = score / 100;
	
	
	
	always_ff @(posedge clk)
		if(reset) begin
			HUNDREDS <= 7'b1000000;
			TENS <= 7'b1000000;
			ONES <= 7'b1000000;
			MESSAGE <= {7'b1111111, 7'b1111111, 7'b1111111};
		end
		else begin
			case(ones)
				0: ONES <= 7'b1000000;
				1: ONES <= 7'b1111001;
				2: ONES <= 7'b0100100;
				3: ONES <= 7'b0110000;
				4: ONES <= 7'b0011001;
				5: ONES <= 7'b0010010;
				6: ONES <= 7'b0000010;
				7: ONES <= 7'b1111000;
				8: ONES <= 7'b0000000;
				9: ONES <= 7'b0010000;
			endcase
			
			
			case(tens)
				0: TENS <= 7'b1000000;
				1: TENS <= 7'b1111001;
				2: TENS <= 7'b0100100;
				3: TENS <= 7'b0110000;
				4: TENS <= 7'b0011001;
				5: TENS <= 7'b0010010;
				6: TENS <= 7'b0000010;
				7: TENS <= 7'b1111000;
				8: TENS <= 7'b0000000;
				9: TENS <= 7'b0010000;
			endcase
			
			case(hundreds)
				0: HUNDREDS <= 7'b1000000;
				1: HUNDREDS <= 7'b1111001;
				2: HUNDREDS <= 7'b0100100;
				3: HUNDREDS <= 7'b0110000;
				4: HUNDREDS <= 7'b0011001;
				5: HUNDREDS <= 7'b0010010;
				6: HUNDREDS <= 7'b0000010;
				7: HUNDREDS <= 7'b1111000;
				8: HUNDREDS <= 7'b0000000;
				9: HUNDREDS <= 7'b0010000;
			endcase
			
			if(lose)
				MESSAGE <= {7'b0101111, 7'b1001111, 7'b0001100};
			else if(score == 253)
				MESSAGE <= {7'b0010001, 7'b0001000, 7'b0010001};
				
		end

endmodule
