
module iris_odesa
#(
parameter  p_width = 9,
parameter  p_sample_num = 75,
parameter  p_sample_len = 80,
parameter  p_spike_delay = 2,
parameter  p_pattern_delay = 5000,
parameter  p_epochs = 350,
parameter   p_clk_tst = 2*200,
parameter   p_clk_1 = 2*200, //2*390
parameter   p_clk_2 = 2*450, //2*1000
parameter   p_eta_l1 = 8, 
parameter   p_eta_l2 = 5
)
(
input                  i_clk,
input                  i_rst_n,
input  [4:1]           i_event,
output [3:1]           o_spike_out
);


wire [6:1]            w_spikeout_l1;
wire                  w_endof_epochs;
wire                  w_gas;
wire                  w_las_l2;
wire [6*(p_width+1)-1:0]  w_tr_l2;
wire [4:1]            w_test_events;
wire [4:1]            w_events;
wire [3:1]            w_labels;
wire                  w_active;
assign   w_events = (w_endof_epochs)? i_event: (w_test_events); 

//assign w_gas = w_labels[3] | w_labels[2] | w_labels[1]; 

clock_gen 
#(
.p_clk_tst(),
.p_clk_1(),
.p_clk_2() 
)

u_clk_sys
(
	.i_clk(i_clk),
	.i_rst_n(i_rst_n),
	.o_clk_tst(w_clk_tst),
	.o_clk_lvl_1(w_clk_lvl_1),
	.o_clk_lvl_2(w_clk_lvl_2)
);


L2
#(.p_width(p_width),
  .p_eta_l2(p_eta_l2)) u_l2
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
#(.p_width(p_width),
  .p_eta_l1(p_eta_l1)) u_l1
(
.i_clk(w_clk_lvl_1),
.i_rst_n(i_rst_n),
.i_event(w_events),
.i_tr(w_tr_l2),
.i_las(1'b0),//w_las_l2),
.i_gas(w_gas),
.i_endof_epochs(w_endof_epochs), 
.o_las(),
.o_spike_out(w_spikeout_l1)
);


iris_auto_trainer 
#(
.p_sample_num(p_sample_num),
.p_sample_len(p_sample_len),
.p_spike_delay(p_spike_delay),
.p_pattern_delay(p_pattern_delay),
.p_epochs(p_epochs)) u_at
(
.i_clk(w_clk_lvl_1),//(w_clk_tst),
.i_rst_n(i_rst_n),
.o_end_of_epochs(w_endof_epochs),
.o_test_vector(w_test_events),
.o_label(w_labels)
);

spike_mask
#(
.p_clk_nom(4),
.p_spike_nom(4)
) u_sm
(
.i_clk_tst(w_clk_tst),
.i_clk_lvl_2(w_clk_lvl_2), 
.i_rst_n(i_rst_n),
.i_spike_in(w_events),
.o_active(w_active)
);

endmodule