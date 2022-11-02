
module synchronizer
(
input                 i_event,
input                 i_clk,
input                 i_rst_n,
output                o_syncout
);

wire w_q1;
wire w_clr;
wire w_syncout;

assign  w_clr = ~i_rst_n;
assign  o_syncout = w_syncout;

flipflop ff1
( 
	.i_d(1'b1),
	.i_clk(i_event),
	.i_clr(w_clr),
	.o_q(w_q1),
	.o_qb()
);

flipflop ff2
( 
	.i_d(w_q1),
	.i_clk(i_clk),
	.i_clr(w_clr),
	.o_q(w_syncout),
	.o_qb()
);

endmodule 