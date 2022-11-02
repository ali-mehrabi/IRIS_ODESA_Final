`timescale 1ns/1ns

module iris_odesa_tb();

reg          r_clk;
reg          r_rst_n;
reg   [4:1] r_events_in;
wire  [3:1]  w_spike_out;

always #10 r_clk <= ~r_clk; 
initial 
begin
      r_events_in = 0;
      r_clk = 0; 
      r_rst_n = 0; 
#100  r_rst_n = 1; 
end

////////////////
iris_odesa
#(
.p_width(8),
.p_sample_num(45),
.p_sample_len(30),
.p_spike_delay(10), 
.p_pattern_delay(800),
.p_epochs(401),
.p_clk_tst(20),
.p_clk_1(20),
.p_clk_2(80),
.p_eta_l1(10), //fixed to 10 
.p_eta_l2(7)
) uut
(
.i_clk(r_clk),
.i_rst_n(r_rst_n),
.i_event(r_events_in),
.o_spike_out(w_spike_out)
);
///////////////////////////////
endmodule
