

module synchronizer (
  input logic clk, reset, in,
  output logic out
  );
  
  logic between;
  
  always_ff @(posedge clk)
	 if(reset)
	   between <= 0;
    else
		between <= in;

	always_ff @(posedge clk)
	  if(reset)
	    out <= 0;
		else
		  out <= between;
endmodule //synchronizer