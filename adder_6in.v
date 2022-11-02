module csa_adder_6in
#(parameter p_input_width = 14)
(
input  [p_input_width-1:0]  i_a,
input  [p_input_width-1:0]  i_b,
input  [p_input_width-1:0]  i_c,
input  [p_input_width-1:0]  i_d,
input  [p_input_width-1:0]  i_e,
input  [p_input_width-1:0]  i_f,
output [p_input_width+2:0]  o_s
);

wire [p_input_width-1:0]  w_p0;
wire [p_input_width-1:0]  w_p1;
wire [p_input_width-1:0]  w_p2;
wire [p_input_width-1:0]  w_g0;
wire [p_input_width-1:0]  w_g1;
wire [p_input_width-1:0]  w_g2;
wire [p_input_width-1:0]  w_s0;
wire [p_input_width  :0]  w_co1;
wire [p_input_width+1:0]  w_co2;

assign  w_p0 = i_a^i_b;
assign  w_p1 = i_c^i_d;
assign  w_p2 = i_e^i_f;
assign  w_g0 = i_a & i_b;
assign  w_g1 = i_c & i_d;
assign  w_g2 = i_e & i_f;

assign  w_s0 = w_p0 ^ w_p1 ^ w_p2;
assign  w_co1= {(((w_p0 & w_p1) ^ (w_p0 & w_p2) ^ (w_p1 & w_p2)) ^ (w_g0 ^ w_g1 ^ w_g2)),1'b0};
assign  w_co2= {(((w_g0 & w_g1) | (w_g0 & w_g2) | (w_g1 & w_g2)) | ((w_p0 & w_p1 & w_g2) | (w_p0 & w_p2 & w_g1) | (w_p1 & w_p2 & w_g0))),2'b0};
assign o_s = {2'b0, w_s0} + w_co1 + w_co2;


endmodule