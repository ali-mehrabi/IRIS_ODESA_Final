module spikeout_gen2
#(parameter p_num = 10,
  parameter p_delay = 2)
(
input  i_clk,
input  i_rst_n,
input  i_spike_in,
input  i_control,
input  [p_num-1:0]  i_spike,
output [p_num-1:0]  o_spike
);
//parameter p_delay = 4;

reg [$clog2(p_delay):0] r_counter;
reg       r_event_on;
reg [p_num-1:0] r_spike;
//wire      w_event_on;
wire      w_reset_n;
wire      w_en_spike;
wire      w_rst_counter_n;
wire   [p_num-1:0] w_control;
assign w_control = {p_num{i_control}};   
assign o_spike = r_spike;
assign w_rst_counter_n = ~i_spike_in & i_rst_n; 
//assign w_event_on = i_spike_in[0] | i_spike_in[1];
assign w_en_spike = (r_counter >=1 && (r_counter <= p_delay) )? 1'b1:1'b0;
assign w_reset_n = ((r_counter > p_delay) || !i_rst_n)? 1'b0:1'b1;

always @(posedge i_spike_in or negedge w_reset_n) 
begin 
  if(!w_reset_n) 
    r_event_on <= 1'b0;
  else 
    r_event_on <= 1'b1;
end

always @(posedge ~i_clk or negedge w_rst_counter_n)
begin
  if(!w_rst_counter_n)
     r_counter <= 0; 
  else if(r_counter <= p_delay  && r_event_on) 
     r_counter <= r_counter+1; 
  else 
     r_counter <= 0;
end

always @(posedge ~i_clk)
begin
  if(r_counter == p_delay)
     r_spike <= i_spike & w_control;  
  else 
     r_spike <= {(p_num){1'b0}};
end

// genvar i;
// generate
  // begin: gen_spg_i
    // for(i=0; i< p_num; i= i+1)
	  // begin
		// spike_generator u_spg(
		// .i_event(i_spike[i]),
		// .i_clk(i_clk),
		// .i_rst_n(r_event_on),//_en_spike),
		// .o_spike(o_spike[i])
		// );
      // end
  // end  
// endgenerate  

endmodule