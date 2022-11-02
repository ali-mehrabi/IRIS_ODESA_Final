
module L1
#(parameter p_width = 9,
 parameter  p_eta_l1 = 3 
)
(
input                  i_clk,
input                  i_rst_n,
input [4:1]            i_event,
input [6*(p_width+1)-1:0]  i_tr,
input                  i_las,
input                  i_gas,
input                  i_endof_epochs,
output                 o_las,
output  [6:1]          o_spike_out
);
parameter p_n = 6;
wire  [p_n:1]                  w_spike_out;
wire  [p_n*(4*p_width)-1:0]    w_weight;
wire  [p_n*(4*p_width)-1:0]    w_ts;
wire  [p_n*(2*p_width+2)-1:0]  w_lv;
wire  [p_n*(2*p_width+2)-1:0]  w_threshold;

assign  o_spike_out = w_spike_out;


L1_layer 
#(.p_width(p_width)) u_L1
(
.i_clk(i_clk),
.i_rst_n(i_rst_n),
.i_event(i_event),
.i_weight(w_weight),
.i_threshold(w_threshold),
.o_tr(w_ts),
.o_lv(w_lv),
.o_spike_out(w_spike_out)
);

L1_train_v #(.p_width(p_width),
           .p_eta_l1(p_eta_l1) 
) u_L1_train
(
.i_clk(i_clk),
.i_rst_n(i_rst_n),
.i_event(i_event),
.i_l1_spikeout(w_spike_out),
.i_ts(w_ts),
.i_lv(w_lv),
.i_tr(i_tr),
.i_las(i_las),
.i_gas(i_gas),
.o_las(o_las),
.o_weights(w_weight),
.o_thresholds(w_threshold),
.i_endof_epochs(i_endof_epochs)
 );
 
endmodule