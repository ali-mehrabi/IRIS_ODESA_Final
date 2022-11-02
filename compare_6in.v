
module comparator_6in
#(parameter  p_width = 19)
(
input  i_clk,
input  i_rst_n,
input  [p_width-1:0]  i_a,
input  [p_width-1:0]  i_b,
input  [p_width-1:0]  i_c,
input  [p_width-1:0]  i_d,
input  [p_width-1:0]  i_e,
input  [p_width-1:0]  i_f,
output [p_width-1:0]  o_result,
output [5:0]          o_index
);

wire  [5:0]          w_l1, w_l2, w_index;
wire  [5:0]          w_l3, w_l4, w_l5;
wire  [p_width-1:0]  w_m1, w_m2, w_m3, w_m4, w_m5;
wire                 w_z;
reg   [5:0]          r_index;

assign w_z = ((i_a | i_b | i_c | i_d | i_e | i_f)==0)? 1:0;
assign w_l1 = (i_a>=i_b)? 6'b000001:6'b000010;
assign w_l2 = (i_c>=i_d)? 6'b000100:6'b001000;
assign w_l3 = (i_e>=i_f)? 6'b010000:6'b100000;
assign w_l4 = (w_m1 >= w_m2)? w_l1:w_l2;
assign w_l5 = (w_m4 >= w_m3)? w_l4:w_l3;
assign w_index = w_z? 6'b000000:w_l5;
assign o_index = r_index;
assign w_m1 = (i_a>=i_b)? i_a:i_b;
assign w_m2 = (i_c>=i_d)? i_c:i_d;
assign w_m3 = (i_e>=i_f)? i_e:i_f;
assign w_m4 = (w_m1 >= w_m2)? w_m1:w_m2;
assign w_m5 = (w_m4 >= w_m3)? w_m4:w_m3;
assign o_result = w_m5;

always @( posedge ~i_clk or negedge i_rst_n)
begin
if(!i_rst_n) 
  r_index <=0;
else 
  r_index <= w_index;
end

endmodule 