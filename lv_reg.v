
module lv_reg
#(
parameter  p_width = 21
)
(
input                        i_spike,
input                        i_rst_n,
input   [p_width-1:0]        i_addvalue,
output  [p_width-1:0]        o_lv
);
reg  [p_width-1:0] r_last_value;

assign  o_lv = r_last_value; 
always @(posedge i_spike or negedge i_rst_n)
begin
	if(!i_rst_n) 
	  r_last_value <= {(p_width){1'h0}};
	else 
	  r_last_value <= i_addvalue;
end
endmodule