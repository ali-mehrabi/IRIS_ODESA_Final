`timescale 1ns/1ns

module spikeout_gen_tb();

reg   r_clk;
reg   r_rst_n;

wire  [10:1]  w_spike_out;
reg           r_spike_in;
reg   [10:1]  r_events;

spikeout_gen
#(.p_num(10)) uut
(
.i_clk(r_clk),
.i_rst_n(r_rst_n),
.i_spike_in(r_spike_in),
.i_spike(r_events),
.o_spike(w_spike_out)
);

always #20 r_clk <= ~r_clk;
initial 
begin
		r_clk = 0;
		r_rst_n = 0;
		r_spike_in = 0;
		r_events = 0;
#40     r_rst_n = 1; 
#40     r_spike_in = 1;
#20     r_spike_in = 0;
#120    r_events = 10'h040;
#20     r_events = 10'h000;

#280;
#40     r_spike_in = 1;
#20     r_spike_in = 0;
#120    r_events = 10'h080;
#20     r_events = 10'h000;


#160    r_events = 10'h080;
#20     r_events = 10'h000;

#300;
#40     r_spike_in = 1;
#20     r_spike_in = 0;
#80     r_events = 10'h200;
#20     r_events = 10'h000;

#160    r_events = 10'h002;
#20     r_events = 10'h000;


#300;
#40     r_spike_in = 1;
#20     r_spike_in = 0;
#80     r_events = 10'h040;
#20     r_events = 10'h000;

#160    r_events = 10'h080;
#20     r_events = 10'h000;

end

endmodule