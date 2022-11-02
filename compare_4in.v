
module comparator_4in
#(parameter  p_width = 19)
(
input  i_clk,
input  i_rst_n,
input  [p_width-1:0]  i_a,
input  [p_width-1:0]  i_b,
input  [p_width-1:0]  i_c,
input  [p_width-1:0]  i_d,
output [p_width-1:0]  o_result,
output [3:0]          o_index
);

wire  [3:0]  w_l1, w_l2, w_index;
reg   [3:0]  r_index;
wire         w_z;
wire  [p_width-1:0] w_l3,w_l4;
assign w_z = ((i_a | i_b | i_c | i_d)==0)? 1:0;
assign w_l1 = (i_a>=i_b)? 4'b0001:4'b0010;
assign w_l2 = (i_c>=i_d)? 4'b0100:4'b1000;
assign w_index = w_z? 4'b0000:(w_l3 >= w_l4)? w_l1:w_l2;
assign o_index = r_index;
assign w_l3 = (i_a>=i_b)? i_a:i_b;
assign w_l4 = (i_c>=i_d)? i_c:i_d;
assign o_result = (w_l3 >= w_l4)? w_l3:w_l4;
always @( posedge ~i_clk or negedge i_rst_n)
begin
if(!i_rst_n) 
  r_index <=0;
else 
  r_index <= w_index;
end

// wire w_t1;
// wire w_t2;
// wire w_t3;
// wire w_t4;
// wire w_t5;
// wire w_t6;
// wire w_a,w_b,w_c,w_d;
// wire [3*p_width-1:0]  w_res;
// wire [3:0]            w_index;
// wire                  w_eq;
// assign w_t1  = (i_a>=i_b)?1:0;
// assign w_t2  = (i_a>=i_c)?1:0;
// assign w_t3  = (i_a>=i_d)?1:0;
// assign w_t4  = (i_b>=i_c)?1:0;
// assign w_t5  = (i_b>=i_d)?1:0;
// assign w_t6  = (i_c>=i_d)?1:0;
// assign w_eq  = (i_a == i_b && i_c==i_d && i_b==i_c )? 1:0;
// assign w_a  =  w_t1 && w_t2 && w_t3;
// assign w_b  = !w_t1 && w_t4 && w_t5;
// assign w_c  = ((!w_t1 && !w_t4) || (w_t1 && !w_t2)) && w_t6;
// assign w_d  = (!w_t1 && !w_t4 && !w_t6) || (w_t1 && w_t2&& !w_t3) || (!w_t1 && w_t4 && !w_t5);
// assign w_res   = (w_a)?i_a:((w_b)? i_b:((w_c)?i_c:((w_d)?i_d:0)));
// assign w_index = (w_res)? ((w_a)?4'h1:(w_b)? 4'h2:(w_c)?4'h4:4'h8):4'h0;
// assign o_index  = w_index;
// assign o_result = w_res;
endmodule 