module csa_adder_4in
#(parameter p_input_width = 14)
(
input  [p_input_width-1:0]  i_a,
input  [p_input_width-1:0]  i_b,
input  [p_input_width-1:0]  i_c,
input  [p_input_width-1:0]  i_d,
output [p_input_width+1:0]  o_s
);

wire [p_input_width-1:0]  w_p10;
wire [p_input_width-1:0]  w_p11;
wire [p_input_width-1:0]  w_g10;
wire [p_input_width-1:0]  w_g11;
wire [p_input_width-1:0]  w_s11;
wire [p_input_width-1:0]  w_s12;
wire [p_input_width  :0]  w_co11;
wire [p_input_width+1:0]  w_co12;

assign  w_p10 = i_a^i_b;
assign  w_p11 = i_c^i_d;
assign  w_g10 = i_a & i_b;
assign  w_g11 = i_c & i_d;
assign  w_s11 = w_p10^w_p11;
assign  w_co11= {((w_g10 & ~w_g11) |  (~w_g10 & w_g11) | (w_p10 & w_p11)), 1'b0};
assign  w_co12= {(w_g10 & w_g11), 2'b0};
assign o_s = {2'b0, w_s11} + w_co11 + w_co12;


endmodule