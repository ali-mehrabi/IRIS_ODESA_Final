module spike_generator(
input      i_event,
input      i_clk,
input      i_rst_n,
output     o_spike
);

wire   w_q2, w_q1;
assign o_spike = w_q2; 

flipflop u1
( 
	.i_d(1'b1),
	.i_clk(i_event),
	.i_clr(w_q2 | ~i_rst_n),
	.o_q(w_q1),
	.o_qb()
);

flipflop u2
( 
	.i_d(w_q1),
	.i_clk(i_clk),
	.i_clr(~i_rst_n),
	.o_q(w_q2),
	.o_qb()
);

endmodule

