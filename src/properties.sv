`ifdef FORMAL

// start is asserted only once
property p_startonce;
	@(posedge clk) start |=> always !start; // Trigger on clk to check every cycle that the assume is not broken
endproperty

// whenever start is asserted, it is eventually followed by done
property p_evdone;
	@(posedge clk) start |-> ##[1:$] done;	// Trigger on every cycle to see if done is reached
endproperty

// at every start, if a_in <= b_in then result is eventually <= a_in
property p_sanity;
	@(posedge clk) start |-> (a_in >= b_in) implies ##[0:$] result <= a_in;	// Trigger on every posedge of clk to check evenetually, do not want to use start as trigger as it will register as a clk
endproperty

// when calculation is done, result divides both a_in and b_in
property p_divides;
	@(posedge done) (a_in % result == 0) && (b_in % result == 0);	// Trigger on done to regerster at the end of calc
endproperty

property p_nonzero;
	@(posedge clk) always (a_in > 0 & b_in > 0);	// trigger on clk to check every cycle
endproperty

property p_dontchange_inputs;
	@(posedge clk) start |-> ($stable(a_in) && $stable(b_in)) until $fell(done);	// Check every cycle to make sure changes do not occur
endproperty

`endif
// 
