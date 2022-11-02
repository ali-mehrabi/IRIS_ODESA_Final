module leaky_accu
#(
parameter  p_base_width = 6
)
(
input   i_clk,
input   i_rst_n, 
input   i_event,
output  o_clr,
output  [p_base_width+1:0]  o_ln  //was p_base_width+2 changed for iris dataset
);
reg                           r_clr;
reg  [p_base_width+1:0]       r_counter; //was p_base_width+2 changed for iris dataset

assign o_ln = r_counter;
assign o_clr = r_clr;

always @(posedge i_clk or negedge i_rst_n) 
begin 
  if(!i_rst_n)
    begin	
      r_counter <= 0;
	  r_clr <= 1'b0;
    end	  
  else
    if(i_event) 
	  begin
        r_counter <= r_counter + {p_base_width{1'b1}}; 
		r_clr <= 1'b1;
	  end	
    else if(r_counter > 0)
	  begin
        r_counter <= r_counter - 1;
		r_clr <= 1'b0;
	  end
end	
endmodule