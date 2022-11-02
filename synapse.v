
module synapse
#(
parameter  p_width = 9,
parameter  p_weight_width = 9)
(
input                                       i_clk,
input                                       i_rst_n,
input                                       i_event,
input   [p_weight_width-1:0]                i_weight,
output  [p_width:0]                         o_tr,
output  [p_weight_width+p_width:0]          o_cell_out
);
wire               w_syncout;
wire [p_width:0]   w_decaying;
wire               w_rst;

synchronizer  u_sync
(
.i_event(i_event),
.i_clk(i_clk),
.i_rst_n(~w_rst),
.o_syncout(w_syncout)
);

leaky_accu
#(.p_base_width(p_width-1)) u_la
(
	.i_clk(i_clk),
	.i_rst_n(i_rst_n), 
	.i_event(w_syncout),
	.o_clr(w_rst),
	.o_ln(w_decaying)
);

trace_reg 
#(.p_width(p_width+1)
) u_tr
(
	 .i_clk(i_clk),
	 .i_rst_n(i_rst_n),
	 .i_tr(w_decaying),
	 .o_tr(o_tr)
);

synaps_weight #(
.p_input_width(p_width+1),
.p_weight_width(p_weight_width)
) u_weights
(
	.i_synaps(w_decaying),
	.i_weight(i_weight),
	.o_cell_out(o_cell_out)
);

endmodule 