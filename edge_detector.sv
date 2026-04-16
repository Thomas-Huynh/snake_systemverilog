// Simple FSM to recognize sequences of 1-1 on input w.
// out is raised when w has been true for two consecutive clock cycles.

module edge_detector (
  input  logic clk, reset, in,
  output logic out
  );

  //represents all possible states
  enum logic [1:0]{S_0 = 2'b00, S_1 = 2'b01, S_11 = 2'b11} ps, ns;

  // FSM Next State Logic
  always_comb
    case (ps)
      S_0:  if (in) ns = S_11;   
            else   ns = S_0;
      S_11: if (in) ns = S_1;  
            else   ns = S_0;
		S_1:  if(in) ns = S_1;
				else ns = S_0;
      default:    ns = ps;
    endcase
	  //output
	  assign out = (ns == S_11);

  //reset
  always_ff @(posedge clk)
    if (reset)
      ps <= S_0;
    else
      ps <= ns;

endmodule  // edge_detector
