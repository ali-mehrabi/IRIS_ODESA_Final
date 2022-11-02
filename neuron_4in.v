module neuron_4in
#(
parameter  p_input_width = 9,
parameter  p_weight_width = 9
)
(
input                                       i_clk,
input                                       i_spike,
input                                       i_rst_n,
input   [4:1]                               i_event,
input   [p_weight_width-1:0]                i_weight_1,
input   [p_weight_width-1:0]                i_weight_2,
input   [p_weight_width-1:0]                i_weight_3,
input   [p_weight_width-1:0]                i_weight_4,
input   [p_input_width+p_weight_width+1:0]  i_threshold,
output  [p_input_width-1:0]                 o_tr_1,
output  [p_input_width-1:0]                 o_tr_2,
output  [p_input_width-1:0]                 o_tr_3,
output  [p_input_width-1:0]                 o_tr_4,
output  [p_input_width+p_weight_width+1:0]  o_lv,
output  [p_input_width+p_weight_width+1:0]  o_neuron_out
);


wire [p_weight_width+p_input_width-1:0]  w_synapse_out[4:1];
wire [p_weight_width+p_input_width+1:0]  w_add_value;
assign o_neuron_out = (w_add_value > i_threshold)? w_add_value:{(p_input_width+p_weight_width+3){1'h0}};

csa_adder_4in
#(.p_input_width(p_input_width+p_weight_width)) u_adder
( 	.i_a(w_synapse_out[1]),
	.i_b(w_synapse_out[2]),
	.i_c(w_synapse_out[3]),
	.i_d(w_synapse_out[4]),
	.o_s(w_add_value)
);

lv_reg
#(.p_width(p_input_width+p_weight_width+2)) u_lv
(
.i_spike(i_spike),
.i_rst_n(i_rst_n),
.i_addvalue(w_add_value),
.o_lv(o_lv)
);

synapse
#(
.p_width(p_input_width),
.p_weight_width(p_weight_width)) u_sp_1 
(
.i_clk(i_clk),
.i_rst_n(i_rst_n),
.i_event(i_event[1]),
.i_weight(i_weight_1),
.o_tr(o_tr_1),
.o_cell_out(w_synapse_out[1])
);

synapse
#(
.p_width(p_input_width),
.p_weight_width(p_weight_width)) u_sp_2 
(
.i_clk(i_clk),
.i_rst_n(i_rst_n),
.i_event(i_event[2]),
.i_weight(i_weight_2),
.o_tr(o_tr_2),
.o_cell_out(w_synapse_out[2])
);

synapse
#(
.p_width(p_input_width),
.p_weight_width(p_weight_width)) u_sp_3 
(
.i_clk(i_clk),
.i_rst_n(i_rst_n),
.i_event(i_event[3]),
.i_weight(i_weight_3),
.o_tr(o_tr_3),
.o_cell_out(w_synapse_out[3])
);

synapse
#(
.p_width(p_input_width),
.p_weight_width(p_weight_width)) u_sp_4 
(
.i_clk(i_clk),
.i_rst_n(i_rst_n),
.i_event(i_event[4]),
.i_weight(i_weight_4),
.o_tr(o_tr_4),
.o_cell_out(w_synapse_out[4])
);

endmodule

