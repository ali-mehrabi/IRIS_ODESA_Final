
module flipflop 
( 
input   i_d,
input   i_clk,
input   i_clr,
output  o_q,
output  o_qb
);

reg     r_q;
assign  o_q  = (i_clr)? 0: r_q;
assign  o_qb = (i_clr)? 1:~r_q;

always @(posedge i_clk or negedge ~i_clr)
begin
if(i_clr)
  r_q <= 0;
else 
  r_q <= i_d;
end

endmodule
