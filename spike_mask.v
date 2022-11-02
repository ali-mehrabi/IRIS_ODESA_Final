
module spike_mask
#(
parameter  p_clk_nom = 4,
parameter  p_spike_nom = 4
)
(
input           i_clk_tst,
input           i_clk_lvl_2, 
input           i_rst_n,
input    [4:1]  i_spike_in,
output          o_active
);

parameter  p_no_spike_period = 7'hf4;
wire   w_spike;
wire   w_reset_n;
reg    r_watchdog;
wire   w_q1;
wire   w_rst_n;

reg    [6:0]  r_wd_counter;
reg    [2:0]  r_clk_counter;
reg    [2:0]  r_sp_state;
reg	          r_sp_count_en;

assign w_spike = i_spike_in[1] | i_spike_in[2] | i_spike_in[3] | i_spike_in[4];
assign w_reset_n = (r_watchdog | ~i_rst_n)? 0:1;
assign w_rst_n = i_rst_n & ~w_spike;
assign w_reset_window = (r_clk_counter == p_clk_nom || !i_rst_n)? 1:0;
assign o_active = w_q1;

always @(posedge i_clk_tst or negedge w_rst_n)
begin
if(!w_rst_n)
  begin
    r_wd_counter <= 7'h0;
    r_watchdog <= 1'b0;
  end 
else 
  begin
    if (r_wd_counter >= p_no_spike_period) 
      begin
	    r_wd_counter <= 7'h0;
		r_watchdog <= 1'b1;
	  end
	else
      begin
        r_wd_counter <= r_wd_counter +1;
		r_watchdog <= 1'b0;
      end
  end	  
end


always @(posedge ~i_clk_lvl_2 or negedge w_reset_n)
begin
  if(!w_reset_n)
    r_clk_counter <= 3'b0;
  else if(w_q1)
    begin
      if (r_clk_counter >= p_clk_nom) 
	    r_clk_counter <= 3'b0;
	  else
        r_clk_counter <= r_clk_counter +1;
    end
end 


always @(posedge i_clk_tst or negedge w_reset_n)
begin
  if(!w_reset_n)
    begin
      r_sp_state <= 3'b000;
	  r_sp_count_en <= 0;
	end
  else
    case(r_sp_state)
	  0:begin
	      r_sp_count_en <= 0;
	      if(w_spike) 
	        r_sp_state <= 3'b001;
	    end
	  1:begin
	      if(w_spike) 
	        r_sp_state <= 3'b010;
	    end
	  2:begin
	      if(w_spike) 
	        r_sp_state <= 3'b011;
	    end
	  3:begin
	      if(w_spike) 
	        r_sp_state <= 3'b100;
	    end	
	  4:begin
	       r_sp_state <= 3'b000;
		   r_sp_count_en <= 1;
	    end			
	endcase
end 



flipflop  u_d1
( 
.i_d(1'b1),
.i_clk(r_sp_count_en),
.i_clr(w_reset_window),
.o_q(w_q1),
.o_qb()
);

endmodule