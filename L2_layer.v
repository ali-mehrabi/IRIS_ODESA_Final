module L2_layer
#(parameter p_width = 9)
(
input                          i_clk,
input                          i_rst_n,
input   [6:1]                  i_event,
input   [3*(6*p_width)-1:0]    i_weight,
input   [3*(2*p_width+4)-1:0]  i_threshold,
input                          i_sp_control,
output  [6*(p_width+1)-1:0]    o_tr,
output  [3*(2*p_width+4)-1:0]  o_lv,
output  [3:1]                  o_spike_out
);
parameter p_n = 3; //number of neurons
parameter p_th_width = (2*p_width+4);
parameter p_tr_width = (p_width+1);
genvar i;
wire [p_width-1:0]       w_weight_1[p_n:1];
wire [p_width-1:0]       w_weight_2[p_n:1];
wire [p_width-1:0]       w_weight_3[p_n:1];
wire [p_width-1:0]       w_weight_4[p_n:1];
wire [p_width-1:0]       w_weight_5[p_n:1];
wire [p_width-1:0]       w_weight_6[p_n:1];
wire [(2*p_width+3)-1:0] w_threshold[p_n:1];

wire [p_tr_width-1:0]   w_tr_1;
wire [p_tr_width-1:0]   w_tr_2;
wire [p_tr_width-1:0]   w_tr_3;
wire [p_tr_width-1:0]   w_tr_4;
wire [p_tr_width-1:0]   w_tr_5;
wire [p_tr_width-1:0]   w_tr_6;

wire [p_th_width-1:0]      w_lv[p_n:1];
wire [p_th_width-1:0]      w_neuron_out[p_n:1];
wire [p_n:1]               w_spike_out;
wire [p_n:1]               w_index;
wire [6:1]                 w_event;
wire                       w_spike_in;
assign o_tr = {w_tr_6, w_tr_5, w_tr_4, w_tr_3, w_tr_2, w_tr_1};
assign o_lv = {w_lv[3], w_lv[2], w_lv[1]};
assign o_spike_out = w_spike_out;
assign w_event = {i_event[6], i_event[5],i_event[4], i_event[3],i_event[2], i_event[1]};
assign w_spike_in = i_event[6] | i_event[5] | i_event[4] | i_event[3] | i_event[2] | i_event[1];

generate
for(i=1;i<= p_n; i=i+1)
  begin : gen_wt
	assign w_weight_1[i]  = i_weight[(6*(i-1)+1)*p_width-1:(6*(i-1)  )*p_width];
	assign w_weight_2[i]  = i_weight[(6*(i-1)+2)*p_width-1:(6*(i-1)+1)*p_width];
	assign w_weight_3[i]  = i_weight[(6*(i-1)+3)*p_width-1:(6*(i-1)+2)*p_width];
	assign w_weight_4[i]  = i_weight[(6*(i-1)+4)*p_width-1:(6*(i-1)+3)*p_width];
	assign w_weight_5[i]  = i_weight[(6*(i-1)+5)*p_width-1:(6*(i-1)+4)*p_width];
	assign w_weight_6[i]  = i_weight[(6*(i-1)+6)*p_width-1:(6*(i-1)+5)*p_width];	
	assign w_threshold[i] = i_threshold[i*(2*p_width+3)-1:(i-1)*(2*p_width+3)];
  end
endgenerate


neuron_6in
#(.p_input_width(p_width),
  .p_weight_width(p_width)) u_neuron_6in_1
(
.i_clk(i_clk),
.i_spike(w_spike_out[1]),
.i_rst_n(i_rst_n),
.i_event(w_event),
.i_weight_1(w_weight_1[1]),
.i_weight_2(w_weight_2[1]),
.i_weight_3(w_weight_3[1]),
.i_weight_4(w_weight_4[1]),
.i_weight_5(w_weight_5[1]),
.i_weight_6(w_weight_6[1]),
.i_threshold(w_threshold[1]),
.o_tr_1(w_tr_1),
.o_tr_2(w_tr_2),
.o_tr_3(w_tr_3),
.o_tr_4(w_tr_4),
.o_tr_5(w_tr_5),
.o_tr_6(w_tr_6),
.o_lv(w_lv[1]),
.o_neuron_out(w_neuron_out[1])
); 

neuron_6in
#(.p_input_width(p_width),
  .p_weight_width(p_width)) u_neuron_6in_2
(
.i_clk(i_clk),
.i_spike(w_spike_out[2]),
.i_rst_n(i_rst_n),
.i_event(w_event),
.i_weight_1(w_weight_1[2]),
.i_weight_2(w_weight_2[2]),
.i_weight_3(w_weight_3[2]),
.i_weight_4(w_weight_4[2]),
.i_weight_5(w_weight_5[2]),
.i_weight_6(w_weight_6[2]),
.i_threshold(w_threshold[2]),
.o_tr_1(),
.o_tr_2(),
.o_tr_3(),
.o_tr_4(),
.o_tr_5(),
.o_tr_6(),
.o_lv(w_lv[2]),
.o_neuron_out(w_neuron_out[2])
); 

neuron_6in
#(.p_input_width(p_width),
  .p_weight_width(p_width)) u_neuron_6in_3
(
.i_clk(i_clk),
.i_spike(w_spike_out[3]),
.i_rst_n(i_rst_n),
.i_event(w_event),
.i_weight_1(w_weight_1[3]),
.i_weight_2(w_weight_2[3]),
.i_weight_3(w_weight_3[3]),
.i_weight_4(w_weight_4[3]),
.i_weight_5(w_weight_5[3]),
.i_weight_6(w_weight_6[3]),
.i_threshold(w_threshold[3]),
.o_tr_1(),
.o_tr_2(),
.o_tr_3(),
.o_tr_4(),
.o_tr_5(),
.o_tr_6(),
.o_lv(w_lv[3]),
.o_neuron_out(w_neuron_out[3])
); 

comparator_3in 
#(.p_width(p_th_width)) u_comp3
(   
.i_clk(i_clk),
.i_rst_n(i_rst_n),
.i_a(w_neuron_out[1]),
.i_b(w_neuron_out[2]),
.i_c(w_neuron_out[3]),
.o_result(),
.o_index(w_index)
);

spikeout_gen2 
#(.p_num(3),
  .p_delay(2)) u_spg(
.i_clk(i_clk),
.i_rst_n(i_rst_n),
.i_spike_in(w_spike_in),
.i_control(i_sp_control),
.i_spike(w_index),
.o_spike(w_spike_out)
);

endmodule 