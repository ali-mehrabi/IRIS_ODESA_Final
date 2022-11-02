module neuron_6in
#(
parameter  p_input_width = 8,
parameter  p_weight_width = 8
)
(
input                                       i_clk,
input                                       i_spike,
input                                       i_rst_n,
input   [6:1]                               i_event,
input   [p_weight_width-1:0]                i_weight_1,
input   [p_weight_width-1:0]                i_weight_2,
input   [p_weight_width-1:0]                i_weight_3,
input   [p_weight_width-1:0]                i_weight_4,
input   [p_weight_width-1:0]                i_weight_5,
input   [p_weight_width-1:0]                i_weight_6,
input   [p_input_width+p_weight_width+2:0]  i_threshold,
output  [p_input_width:0]                   o_tr_1,
output  [p_input_width:0]                   o_tr_2,
output  [p_input_width:0]                   o_tr_3,
output  [p_input_width:0]                   o_tr_4,
output  [p_input_width:0]                   o_tr_5,
output  [p_input_width:0]                   o_tr_6,
output  [p_input_width+p_weight_width+3:0]  o_lv,
output  [p_input_width+p_weight_width+3:0]  o_neuron_out
);

genvar i;
wire [p_weight_width+p_input_width:0]    w_synapse_out[6:1];
wire [p_weight_width-1:0]                w_weight[6:1];
wire [p_input_width:0]                   w_tr[6:1];
wire [p_weight_width+p_input_width+3:0]  w_add_value;
assign  w_weight[1] = i_weight_1;
assign  w_weight[2] = i_weight_2;
assign  w_weight[3] = i_weight_3;
assign  w_weight[4] = i_weight_4;
assign  w_weight[5] = i_weight_5;
assign  w_weight[6] = i_weight_6;
assign  o_tr_1 = w_tr[1];
assign  o_tr_2 = w_tr[2];
assign  o_tr_3 = w_tr[3];
assign  o_tr_4 = w_tr[4];
assign  o_tr_5 = w_tr[5];
assign  o_tr_6 = w_tr[6];

assign o_neuron_out = (w_add_value > i_threshold)? w_add_value:{(p_input_width+p_weight_width+4){1'h0}};


csa_adder_6in
#(.p_input_width(p_input_width+p_weight_width+1)) u_adder
( 	.i_a(w_synapse_out[1]),
	.i_b(w_synapse_out[2]),
	.i_c(w_synapse_out[3]),
	.i_d(w_synapse_out[4]),
	.i_e(w_synapse_out[5]),
	.i_f(w_synapse_out[6]),
	.o_s(w_add_value)
);

lv_reg
#(.p_width(p_input_width+p_weight_width+4)) u_lv
(
.i_spike(i_spike),
.i_rst_n(i_rst_n),
.i_addvalue(w_add_value),
.o_lv(o_lv)
);

generate
for(i=1; i <= 6; i=i+1)
  begin: gen_synapse
	synapse
	#(
	.p_width(p_input_width),
	.p_weight_width(p_weight_width)) u_sp_i 
	(
		.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		.i_event(i_event[i]),
		.i_weight(w_weight[i]),
		.o_tr(w_tr[i]),
		.o_cell_out(w_synapse_out[i])
	);
  end
endgenerate

endmodule

