`timescale 1ns/1ns
module pulse_gen_tb();

wire w_pulse;
reg r_rst_n;
reg r_clk; 
reg r_event;



pulse_gen  uut_pg(
.i_event(r_event),
.i_clk(r_clk),
.i_rst_n(r_rst_n),
.o_spike(w_pulse)
);

always #5 r_clk = ~r_clk;
initial 
begin
		r_rst_n = 0;
		r_clk =0;
		r_event = 0; 
		
#12     r_rst_n = 1;
#51     r_event =1;
#12     r_event = 0; 
#110    r_event =1;
#8      r_event = 0; 
#110    r_event =1;
#25     r_event = 0; 
#10     r_rst_n = 0;
#18     r_rst_n = 1;
#20     r_event =1;
#8      r_event = 0; 
#110    r_event =1;
#50     r_event = 0;
#50     r_event =1;
#2      r_event = 0; 
#50     r_event =1;
#200    r_event = 0;

end

endmodule


