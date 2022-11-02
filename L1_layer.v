module L1_layer
#(parameter p_width = 9)
(
input                         i_clk,
input                         i_rst_n,
input   [4:1]                 i_event,
input   [6*(4*p_width)-1:0]   i_weight,
input   [6*(2*p_width+2)-1:0] i_threshold,
output  [6*(4*p_width)-1:0]   o_tr,
output  [6*(2*p_width+2)-1:0] o_lv,
output  [6:1]                 o_spike_out
);

genvar i;
genvar j;
parameter p_s = 4; //num of synapse in each neuron
parameter p_n = 6; //nuber of neurons
wire [p_width-1:0]       w_weight[p_n:1][p_s:1];
wire [p_width-1:0]       w_tr[p_n:1][p_s:1];
wire [(2*p_width+2)-1:0] w_threshold[p_n:1];
wire [(2*p_width+2)-1:0] w_lv[p_n:1];
wire [(2*p_width+2)-1:0] w_neuron_out[p_n:1];
wire [p_n:1]             w_spike_out;
wire [p_n:1]             w_index;
wire                     w_is_event;
assign o_spike_out = w_spike_out;
assign w_is_event = i_event[4] | i_event[3] | i_event[2] | i_event[1];


generate
for(i=1; i <= p_n; i=i+1)
begin:gen_i
  for(j=1; j <= p_s; j=j+1)
    begin:gen_w_tr_j
      assign  w_weight[i][j] = i_weight[(i-1)*(p_s*p_width)+j*p_width-1: (i-1)*(p_s*p_width)+(j-1)*p_width];
      assign  o_tr[(i-1)*(p_s*(p_width))+j*(p_width)-1:(i-1)*(p_s*(p_width))+(j-1)*(p_width)] = w_tr[i][j];
	 end	
end

for(i=1; i <= p_n; i=i+1)
begin :gen_th_lv
  assign  w_threshold[i] = i_threshold[i*(2*p_width+2)-1:(i-1)*(2*p_width+2)];
  assign  o_lv[i*(2*p_width+2)-1:(i-1)*(2*p_width+2)] = w_lv[i];
end

for(i=1;i <= p_n; i=i+1)
  begin: u_neuron_4in_l1 
	neuron_4in_v2
	#(
	.p_input_width(p_width),
    .p_weight_width(p_width)) u_neuron4in
	(
	.i_clk(i_clk),
	.i_spike(w_spike_out[i]),
	.i_rst_n(i_rst_n),
	.i_event(i_event),
	.i_weight_1(w_weight[i][1]),
	.i_weight_2(w_weight[i][2]),
	.i_weight_3(w_weight[i][3]),
	.i_weight_4(w_weight[i][4]),
	.i_threshold(w_threshold[i]),
	.o_tr_1(w_tr[i][1]),
	.o_tr_2(w_tr[i][2]),
	.o_tr_3(w_tr[i][3]),
	.o_tr_4(w_tr[i][4]),
	.o_lv(w_lv[i]),
	.o_neuron_out(w_neuron_out[i])
	);
  end
  
 endgenerate


spikeout_gen
#(.p_num(p_n),
  .p_delay(2)) u_spg(
.i_clk(i_clk),
.i_rst_n(i_rst_n),
.i_spike_in(w_is_event),
.i_spike(w_index),
.o_spike(w_spike_out)
);

comparator_6in 
#(.p_width((2*p_width+2))) u_comp
(
.i_clk(i_clk),
.i_rst_n(i_rst_n),
.i_a(w_neuron_out[1]),
.i_b(w_neuron_out[2]),
.i_c(w_neuron_out[3]),
.i_d(w_neuron_out[4]),
.i_e(w_neuron_out[5]),
.i_f(w_neuron_out[6]),
.o_result(),
.o_index(w_index)
);

endmodule 