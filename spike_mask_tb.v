
`timescale 1ns/1ns

module spike_mask_tb();


parameter p_wait = 30;

reg          r_clk_tst;
reg          r_clk_lvl2;
reg          r_rst_n;
reg   [3:0]  r_spike;
reg   [3:0]  r_state;
reg   [6:0]  r_counter;
wire  [3:1]  w_spike_out;
wire         w_active;
wire         w_restart_n; 

always #5  r_clk_tst <=  ~r_clk_tst; 
always #20 r_clk_lvl2 <= ~r_clk_lvl2; 
//assign #20 w_restart_n =  r_rst_n;
initial 
begin
      r_spike = 0;
      r_clk_tst = 0; 
	  r_clk_lvl2 =0;
      r_rst_n = 0; 
#100  r_rst_n = 1; 
end

always @(posedge r_clk_tst or negedge r_rst_n)
  begin
    if(!r_rst_n)
	  begin
	    r_spike = 0;
		r_state <= 0;
		r_counter <= 0;
	  end
	else
	  begin
	  	case(r_state)
		  0:begin
		  	  r_spike <= 0;
              if(r_counter <= 4*p_wait) 
			    r_counter <= r_counter+1;
			  else
			    r_state <= 1;
            end 	  
		  1:begin
		      r_spike <= 1;
			  r_counter <= 0;
			  r_state <= 2;
		    end
		  2:begin
		  	  r_spike <= 0;
              if(r_counter <= p_wait) 
			    r_counter <= r_counter+1;
			  else
			    r_state <= 3;
            end 
		  3:begin
		      r_spike <= 2;
			  r_counter <= 0;
			  r_state <= 4;
		    end
	      4:begin
		  	  r_spike <= 0;
              if(r_counter <= p_wait) 
			    r_counter <= r_counter+1;
			  else
			    r_state <= 5;
		    end
		  5:begin
		      r_spike <= 4;
			  r_counter <= 0;
			  r_state <= 6;
		    end	
	      6:begin
		  	  r_spike <= 0;		  
              if(r_counter <= p_wait) 
			    r_counter <= r_counter+1;
			  else
			    r_state <= 7;				
		    end	
		  7:begin
		      r_spike <= 8;
			  r_counter <= 0;
			  r_state <= 8;
		    end	
	      8:begin
		  	  r_spike <= 0;
              if(r_counter <= 4*p_wait) 
			    r_counter <= r_counter+1;
			  else
			    r_state <= 0;
            end				
		endcase	
	  end
  end

spike_mask
#(
.p_clk_nom(5),
.p_spike_nom(4)
) uut
(
.i_clk_tst(r_clk_tst),
.i_clk_lvl_2(r_clk_lvl2), 
.i_rst_n(r_rst_n),
.i_spike_in(r_spike),
.o_active(w_active)
);

endmodule