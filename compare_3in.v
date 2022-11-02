
module comparator_3in
#(parameter  p_width = 22)
(
input  i_clk,
input  i_rst_n,
input  [p_width-1:0]  i_a,
input  [p_width-1:0]  i_b,
input  [p_width-1:0]  i_c,
output [p_width-1:0]  o_result,
output [2:0]          o_index
);

wire  [2:0]  w_l1, w_l2, w_index;
reg   [2:0]  r_index;
wire         w_z;
wire  [p_width-1:0] w_l3,w_l4;
assign w_z = ((i_a | i_b | i_c)==0)? 1:0;
assign w_l3 = (i_a>=i_b)? i_a:i_b;
assign w_l4 = (w_l3>=i_c)? w_l3:i_c;
assign w_l1 = (i_a>=i_b)? 3'b001:3'b010;
assign w_l2 = (w_l3>=i_c)? w_l1:3'b100;
assign w_index = w_z? 3'b000: w_l2;
assign o_index = r_index;
assign o_result = w_l4;

always @( posedge ~i_clk or negedge i_rst_n)
begin
if(!i_rst_n) 
  r_index <=0;
else 
  r_index <= w_index;
end

endmodule 