
module iris_network
#(parameter p_width = 9)
(
input                  i_clk,
input                  i_rst_n,
input  [20:1]          i_event,
output [3:1]           o_spike_out
);


wire [10:1]           w_spikeout_l1;
wire                  w_endof_epochs;
wire [10*p_width-1:0] w_tr_l2;
wire [20:1]           w_test_events;
wire [20:1]           w_events;
wire [3:1]            w_labels;
assign   w_events = (w_endof_epochs)? i_event: w_test_events;


clock_gen u_clk_sys
(
	.i_clk(i_clk),
	.i_rst_n(i_rst_n),
	.o_clk_tst(w_clk_test),
	.o_clk_lvl_1(w_clk_lvl_1),
	.o_clk_lvl_2(w_clk_lvl_2)
);


L2
#(.p_width(p_width)) u_l2
(
.i_clk(w_clk_lvl_2),
.i_rst_n(i_rst_n),
.i_event(w_spikeout_l1),
.i_label(w_labels),
.i_endof_epochs(w_endof_epochs),
.o_tr(w_tr_l2),
.o_las(w_las_l2),
.o_gas(w_gas),
.o_spike_out(o_spike_out)
);

L1
#(.p_width(p_width)) u_l1
(
.i_clk(w_clk_lvl_1),
.i_rst_n(i_rst_n),
.i_event(w_events),
.i_tr(w_tr_l2),
.i_las(w_las_l2),
.i_gas(w_gas),
.o_las(),
.i_endof_epochs(w_endof_epochs),
.o_spike_out(w_spikeout_l1)
);


auto_trainer u_at(
.i_clk(w_clk_test),//w_clk_lvl_1),
.i_rst_n(i_rst_n),
.o_end_of_epochs(w_endof_epochs),
.o_test_vector(w_test_events),
.o_label(w_labels)
);



endmodule