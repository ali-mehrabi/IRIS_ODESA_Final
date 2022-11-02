module trace_reg
#(parameter p_width = 6)
(
input  [p_width - 1:0] i_tr,
input                  i_clk,
input                  i_rst_n,
output [p_width - 1:0] o_tr
);

reg [p_width - 1:0] r_tr;
assign o_tr = r_tr;

always @(posedge i_clk or negedge i_rst_n)
begin
if(!i_rst_n)
  r_tr <= {p_width{1'b0}};
else
  r_tr <= i_tr;
end  
endmodule