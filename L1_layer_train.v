/* 
if there is an event, wait until an spike appears at the level outputs
if there is no winner (spike) and GAS is active, punish all neurons of the level. else, reward the winner. 
wait more to see if LAS will asserted due to the winner spike, if LAS asserted, then reward all neurons with trace > 0.1 and punish neurons with trace <0.1. 
 */
module L1_train
#(parameter  p_width = 9,
  parameter  p_eta_l1 = 3)
(
 input                         i_clk,
 input                         i_rst_n,
 input  [4:1]                  i_event,
 input  [4:1]                  i_l1_spikeout,
 input  [4*(4*p_width)-1:0]    i_ts,
 input  [4*p_width-1:0]        i_tr,
 input  [4*(2*p_width+2)-1:0]  i_lv,
 input                         i_las,
 input                         i_gas,
 input                         i_endof_epochs,
 output                        o_las,
 output [4*(4*p_width)-1:0]    o_weights,
 output [4*(2*p_width+2)-1:0]  o_thresholds
 );

parameter p_deltaT = 9'h1f;
parameter p_default_thr = 'h30000; //20'h0_7f_00;
parameter p_default_w = 'h0ff;//{p_width{1'b1}};
parameter p_trace_ll = (({(p_width){1'b1}})/'d10); // the length of trace is p_width
parameter p_wait_clks = 4;
parameter p_pass_lvl_1 = 3;
parameter p_n = 4; // number of neurons
parameter p_z  = 0;// 10*p_deltaT;//{(p_width){1'b1}} -1;
parameter p_ratio = 2; 
genvar    i;

wire                          w_input_event_on;
wire                          w_pass_l1;
wire  [4*p_width-1:0]         w_weights[p_n:1];
wire                          w_las;
reg   [p_width-1:0]       	  r_w1[p_n:1];
reg   [p_width-1:0]       	  r_w2[p_n:1];
reg   [p_width-1:0]       	  r_w3[p_n:1];
reg   [p_width-1:0]       	  r_w4[p_n:1];
reg   [(2*p_width+2)-1:0] 	  r_threshold[p_n:1];
reg   [p_width-1:0]       	  r_ts[4*p_n:1];
reg   [p_width-1:0]       	  r_tr[p_n:1];
reg                       	  r_gas;
reg                       	  r_training_active;
reg   [p_n:1]                 r_winner;
reg                      	  r_stop_n;
reg   [$clog2(p_wait_clks):0] r_counter;

reg   [3:0]                   r_eta[p_n:1];
reg   [8:0]                   r_delta[p_n:1];

assign w_input_event_on  = i_event[4] | i_event[3] | i_event[2] | i_event[1];
assign o_las = r_winner[4] | r_winner[3] | r_winner[2] | r_winner[1];
assign o_thresholds = {r_threshold[4], r_threshold[3], r_threshold[2], r_threshold[1]};
assign w_weights[1] = {r_w4[1], r_w3[1], r_w2[1], r_w1[1]};
assign w_weights[2] = {r_w4[2], r_w3[2], r_w2[2], r_w1[2]};
assign w_weights[3] = {r_w4[3], r_w3[3], r_w2[3], r_w1[3]};
assign w_weights[4] = {r_w4[4], r_w3[4], r_w2[4], r_w1[4]};
assign o_weights = {w_weights[4], w_weights[3], w_weights[2], w_weights[1]} ;
assign w_pass_l1 = (r_counter == p_pass_lvl_1)? 1:0;


pulse_gen  u_las(
.i_event(i_las),
.i_clk(i_clk),
.i_rst_n(i_rst_n),
.o_spike(w_las)
);


function [3:0] f_eta; 
input [(2*p_width+2)-1:0] f_in;
begin
  if (f_in > 'hffff) 
	f_eta = 'h7; //10
  else if (f_in > 'h0fff) 
	f_eta = 'h4; // 11;	
  else
	f_eta = 'h2;	
end
endfunction

function [10:0] f_delta; 
input [(2*p_width+2)-1:0] f_in;
begin
  if (f_in > 'hffff) 
	f_delta = 'h1ff; 
  else if (f_in > 'h0fff) 
	f_delta = 'h3f; 
  else if (f_in > 'h00ff) 
	f_delta = 'hf;
  else
	f_delta = 'h1;	
end
endfunction

function [(2*p_width+2)-1:0] calthr;
input [(2*p_width+2)-1:0] a, b;
input [3:0] c;
begin
  calthr = a + (b[(2*p_width+2)-1:0]>> c) - (a[(2*p_width+2)-1:0]>>c);
end	
endfunction

function [(2*p_width+2)-1:0] incthr;
input [(2*p_width+2)-1:0] a, b;
input [3:0] c;
begin 
  incthr = a + (b[(2*p_width+2)-1:0]>> c) + (a[(2*p_width+2)-1:0]>>c);
end	
endfunction

function [p_width-1:0] calwt;
input [p_width-1:0] a, b;
begin
calwt = a + b[p_width-1:p_eta_l1]-a[p_width-1:p_eta_l1];
end	
endfunction	 

///// latch time surface when there is a spike
generate
for(i=1;i<=p_n;i=i+1)
  begin: gen_ts_latch
    always @(posedge i_l1_spikeout[i] or negedge i_rst_n)
       begin	
         if(!i_rst_n)
		    begin
			  r_ts[4*(i-1)+1] <= {p_width{1'b0}};
			  r_ts[4*(i-1)+2] <= {p_width{1'b0}};
			  r_ts[4*(i-1)+3] <= {p_width{1'b0}};
			  r_ts[4*(i-1)+4] <= {p_width{1'b0}};			  
			end
		  else
            begin
              r_ts[4*(i-1)+1] <= i_ts[p_width*4*(i-1)+  p_width-1:p_width*4*(i-1)];
		      r_ts[4*(i-1)+2] <= i_ts[p_width*4*(i-1)+2*p_width-1:p_width*4*(i-1)+1*p_width];
			  r_ts[4*(i-1)+3] <= i_ts[p_width*4*(i-1)+3*p_width-1:p_width*4*(i-1)+2*p_width];
			  r_ts[4*(i-1)+4] <= i_ts[p_width*4*(i-1)+4*p_width-1:p_width*4*(i-1)+3*p_width];
            end
       end
  end
endgenerate	

//latch trace when next layer spikes
always @(posedge i_las or negedge i_rst_n)
begin	
  if(!i_rst_n)
	begin
	  r_tr[1] <= {p_width{1'b0}};
	  r_tr[2] <= {p_width{1'b0}};
	  r_tr[3] <= {p_width{1'b0}};
	  r_tr[4] <= {p_width{1'b0}};
	end
  else
	begin
	  r_tr[1] <= i_tr[p_width-1:0];
	  r_tr[2] <= i_tr[2*p_width-1:p_width];
	  r_tr[3] <= i_tr[3*p_width-1:2*p_width];
	  r_tr[4] <= i_tr[4*p_width-1:3*p_width];
	end
end
// reset training
always @(posedge i_clk or negedge i_rst_n) 
begin
  if(!i_rst_n)
     r_stop_n <= 1'b0;
  else 
    if(r_counter >= p_wait_clks) 
      r_stop_n <= 1'b0;
    else
      r_stop_n <= 1'b1; 
end
// start training
always @(posedge w_input_event_on or negedge r_stop_n)
begin
  if(!r_stop_n)
    r_training_active <= 1'b0;
  else
    r_training_active <= 1'b1;
end

always @(posedge ~i_clk or negedge r_stop_n)
begin 
   if(!r_stop_n)
     r_counter <= 0;
   else if(r_training_active && !i_endof_epochs)
     r_counter <= r_counter +1; 
end	

//latch winner
generate
for(i=1;i<=p_n;i=i+1) 
  begin:gen_r_winner
	always @(posedge i_l1_spikeout[i] or negedge r_stop_n) 
	begin
	  if(!r_stop_n)
		  r_winner[i] <= 1'b0;
	  else 
		  r_winner[i] <= 1'b1; 
	end 
  end
endgenerate 

always @(posedge i_gas or negedge r_stop_n)
begin
  if(!r_stop_n)
    r_gas <= 1'b0;
  else 
    r_gas <= 1'b1;
end


always@(posedge ~i_clk )
begin
  r_eta[1]   <= f_eta(i_lv[(2*p_width+2)-1:0]);
  r_eta[2]   <= f_eta(i_lv[2*(2*p_width+2)-1:(2*p_width+2)]);
  r_eta[3]   <= f_eta(i_lv[3*(2*p_width+2)-1:2*(2*p_width+2)]);
  r_eta[4]   <= f_eta(i_lv[4*(2*p_width+2)-1:3*(2*p_width+2)]);
  r_delta[1] <= f_delta(r_threshold[1]);//i_lv[(2*p_width+2)-1:0]);
  r_delta[2] <= f_delta(r_threshold[2]);//i_lv[2*(2*p_width+2)-1:(2*p_width+2)]);
  r_delta[3] <= f_delta(r_threshold[3]);//i_lv[3*(2*p_width+2)-1:2*(2*p_width+2)]);
  r_delta[4] <= f_delta(r_threshold[4]);//i_lv[4*(2*p_width+2)-1:3*(2*p_width+2)]);
end
//main 
always@(posedge i_clk or negedge i_rst_n)
begin 
  if(!i_rst_n)
    begin
	  r_w1[1]  <= p_default_w;
	  r_w2[1]  <= p_default_w;
	  r_w3[1]  <= p_default_w;
	  r_w4[1]  <= p_default_w;
	  
	  r_w1[2]  <= p_default_w;
	  r_w2[2]  <= p_default_w;
	  r_w3[2]  <= p_default_w;
	  r_w4[2]  <= p_default_w;

	  r_w1[3]  <= p_default_w;
	  r_w2[3]  <= p_default_w;
	  r_w3[3]  <= p_default_w;
	  r_w4[3]  <= p_default_w;

	  r_w1[4]  <= p_default_w;
	  r_w2[4]  <= p_default_w;
	  r_w3[4]  <= p_default_w;
	  r_w4[4]  <= p_default_w;
	  
	  r_threshold[1]  <= p_default_thr;
	  r_threshold[2]  <= p_default_thr; 
	  r_threshold[3]  <= p_default_thr;
	  r_threshold[4]  <= p_default_thr; 
	end  
  else 
	begin
	   if(r_gas & w_pass_l1)
		  begin // award the winner
			  if(r_winner[1])
			    begin
				  r_w1[1] <= calwt(r_w1[1],r_ts[1]);
				  r_w2[1] <= calwt(r_w2[1],r_ts[2]);
				  r_w3[1] <= calwt(r_w3[1],r_ts[3]);
				  r_w4[1] <= calwt(r_w4[1],r_ts[4]);
				  r_threshold[1] <= calthr(r_threshold[1] ,i_lv[(2*p_width+2)-1:0], r_eta[1]);
											
				  // r_w1[1] <= r_w1[1] - r_w1[1][p_width-1:p_eta_l1] + r_ts[1][p_width-1:p_eta_l1]; // eta = 1/2^p_eta_l1
				  // r_w2[1] <= r_w2[1] - r_w2[1][p_width-1:p_eta_l1] + r_ts[2][p_width-1:p_eta_l1];
				  // r_w3[1] <= r_w3[1] - r_w3[1][p_width-1:p_eta_l1] + r_ts[3][p_width-1:p_eta_l1];
				  // r_w4[1] <= r_w4[1] - r_w4[1][p_width-1:p_eta_l1] + r_ts[4][p_width-1:p_eta_l1];
				  // r_threshold[1] <= r_threshold[1] - r_threshold[1][(2*p_width+2)-1:p_eta_l1+p_ratio] + i_lv[(2*p_width+2)-1:p_eta_l1+p_ratio];
				end				
			  else if(r_winner[2])
			    begin
				  r_w1[2] <= calwt(r_w1[2],r_ts[5]);
				  r_w2[2] <= calwt(r_w2[2],r_ts[6]);
				  r_w3[2] <= calwt(r_w3[2],r_ts[7]);
				  r_w4[2] <= calwt(r_w4[2],r_ts[8]);
				  r_threshold[2] <= calthr(r_threshold[2] ,i_lv[2*(2*p_width+2)-1:(2*p_width+2)], r_eta[2]);
															
				  // r_w1[2] <= r_w1[2] - r_w1[2][p_width-1:p_eta_l1] + r_ts[5][p_width-1:p_eta_l1]; 
				  // r_w2[2] <= r_w2[2] - r_w2[2][p_width-1:p_eta_l1] + r_ts[6][p_width-1:p_eta_l1];
				  // r_w3[2] <= r_w3[2] - r_w3[2][p_width-1:p_eta_l1] + r_ts[7][p_width-1:p_eta_l1];
				  // r_w4[2] <= r_w4[2] - r_w4[2][p_width-1:p_eta_l1] + r_ts[8][p_width-1:p_eta_l1];
				  // r_threshold[2] <= r_threshold[2] - r_threshold[2][(2*p_width+2)-1:p_eta_l1+p_ratio] + i_lv[2*(2*p_width+2)-1:(2*p_width+2)+p_eta_l1+p_ratio];
				end
		      else if(r_winner[3])
			    begin
				  r_w1[3] <= calwt(r_w1[3],r_ts[9]);
				  r_w2[3] <= calwt(r_w2[3],r_ts[10]);
				  r_w3[3] <= calwt(r_w3[3],r_ts[11]);
				  r_w4[3] <= calwt(r_w4[3],r_ts[12]);
				  r_threshold[3] <= calthr(r_threshold[3] ,i_lv[3*(2*p_width+2)-1:2*(2*p_width+2)], r_eta[3]);				
				  // r_w1[3] <= r_w1[3] - r_w1[3][p_width-1:p_eta_l1] + r_ts[9][p_width-1:p_eta_l1]; 
				  // r_w2[3] <= r_w2[3] - r_w2[3][p_width-1:p_eta_l1] + r_ts[10][p_width-1:p_eta_l1];
				  // r_w3[3] <= r_w3[3] - r_w3[3][p_width-1:p_eta_l1] + r_ts[11][p_width-1:p_eta_l1];
				  // r_w4[3] <= r_w4[3] - r_w4[3][p_width-1:p_eta_l1] + r_ts[12][p_width-1:p_eta_l1];
				  // r_threshold[3] <= r_threshold[3] - r_threshold[3][(2*p_width+2)-1:p_eta_l1+p_ratio] + i_lv[3*(2*p_width+2)-1:2*(2*p_width+2)+p_eta_l1+p_ratio];
				end	
		      else if(r_winner[4])
			    begin
				  r_w1[4] <= calwt(r_w1[4],r_ts[13]);
				  r_w2[4] <= calwt(r_w2[4],r_ts[14]);
				  r_w3[4] <= calwt(r_w3[4],r_ts[15]);
				  r_w4[4] <= calwt(r_w4[4],r_ts[16]);
				  r_threshold[4] <= calthr(r_threshold[4] ,i_lv[4*(2*p_width+2)-1:3*(2*p_width+2)], r_eta[4]);				
				  // r_w1[4] <= r_w1[4] - r_w1[4][p_width-1:p_eta_l1] + r_ts[13][p_width-1:p_eta_l1]; 
				  // r_w2[4] <= r_w2[4] - r_w2[4][p_width-1:p_eta_l1] + r_ts[14][p_width-1:p_eta_l1];
				  // r_w3[4] <= r_w3[4] - r_w3[4][p_width-1:p_eta_l1] + r_ts[15][p_width-1:p_eta_l1];
				  // r_w4[4] <= r_w4[4] - r_w4[4][p_width-1:p_eta_l1] + r_ts[16][p_width-1:p_eta_l1];
				  // r_threshold[4] <= r_threshold[4] - r_threshold[4][(2*p_width+2)-1:p_eta_l1+p_ratio] + i_lv[4*(2*p_width+2)-1:3*(2*p_width+2)+p_eta_l1+p_ratio];
				end					
			else //punish all
			   begin
				 if (r_threshold[1]>= r_delta[1]) r_threshold[1] <= r_threshold[1] - r_delta[1];// p_deltaT;
                 else if(r_threshold[1]< r_delta[1]) r_threshold[1] <= i_lv[(2*p_width+2)-1:0];		 
				 if (r_threshold[2]>= r_delta[2]) r_threshold[2] <= r_threshold[2] - r_delta[2];//p_deltaT;
                 else if(r_threshold[2]< r_delta[2]) r_threshold[2] <= i_lv[2*(2*p_width+2)-1:(2*p_width+2)];//p_z;//{(2*p_width+2){1'b0}};
				 if (r_threshold[3]>= r_delta[3]) r_threshold[3] <= r_threshold[3] - r_delta[3];//p_deltaT;
                 else if(r_threshold[3]< r_delta[3]) r_threshold[3] <= i_lv[3*(2*p_width+2)-1:2*(2*p_width+2)];//p_z;//{(2*p_width+2){1'b0}};
				 if (r_threshold[4]>= r_delta[4]) r_threshold[4] <= r_threshold[4] - r_delta[4];//p_deltaT;
                 else if(r_threshold[4]< r_delta[4]) r_threshold[4] <= i_lv[4*(2*p_width+2)-1:3*(2*p_width+2)];//p_z;//{(2*p_width+2){1'b0}};			 
			   end
			end	
		  if(!r_gas & w_pass_l1)
		    begin
			  case(r_winner) 
			    4'h1:begin
				       r_threshold[1] <= incthr(r_threshold[1] ,i_lv[(2*p_width+2)-1:0], r_eta[1]);
				     end
			    4'h2:begin
				       r_threshold[2] <= incthr(r_threshold[2] ,i_lv[2*(2*p_width+2)-1:(2*p_width+2)], r_eta[2]);
				     end
			    4'h4:begin
				       r_threshold[3] <= incthr(r_threshold[3] ,i_lv[3*(2*p_width+2)-1:2*(2*p_width+2)], r_eta[3]);
				     end
			    4'h8:begin
				       r_threshold[4] <= incthr(r_threshold[4] ,i_lv[4*(2*p_width+2)-1:3*(2*p_width+2)], r_eta[4]);
				     end
			  endcase	 
			end
	      if(w_las) // if LAS =1
		    begin
			  if(r_tr[1]> p_trace_ll)
			    begin	
				  r_w1[1] <= calwt(r_w1[1],r_ts[1]);
				  r_w2[1] <= calwt(r_w2[1],r_ts[2]);
				  r_w3[1] <= calwt(r_w3[1],r_ts[3]);
				  r_w4[1] <= calwt(r_w4[1],r_ts[4]);				
				  // r_w1[1] <= r_w1[1] - r_w1[1][p_width-1:p_eta_l1] + r_ts[1][p_width-1:p_eta_l1]; 
				  // r_w2[1] <= r_w2[1] - r_w2[1][p_width-1:p_eta_l1] + r_ts[2][p_width-1:p_eta_l1];
				  // r_w3[1] <= r_w3[1] - r_w3[1][p_width-1:p_eta_l1] + r_ts[3][p_width-1:p_eta_l1];
				  // r_w4[1] <= r_w4[1] - r_w4[1][p_width-1:p_eta_l1] + r_ts[4][p_width-1:p_eta_l1];
				end		  
	         else if(r_tr[1]<= p_trace_ll)
			   begin
				 if(r_threshold[1]>= r_delta[1]) r_threshold[1] <= r_threshold[1] - r_delta[1];//p_deltaT;
                 else if(r_threshold[1]< r_delta[1]) r_threshold[1] <= i_lv[(2*p_width+2)-1:0];//p_z;//{(2*p_width+2){1'b0}};
               end				 
             if(r_tr[2]> p_trace_ll)
			    begin
				  r_w1[2] <= calwt(r_w1[2],r_ts[5]);
				  r_w2[2] <= calwt(r_w2[2],r_ts[6]);
				  r_w3[2] <= calwt(r_w3[2],r_ts[7]);
				  r_w4[2] <= calwt(r_w4[2],r_ts[8]);				
				  // r_w1[2] <= r_w1[2] - r_w1[2][p_width-1:p_eta_l1] + r_ts[5][p_width-1:p_eta_l1]; 
				  // r_w2[2] <= r_w2[2] - r_w2[2][p_width-1:p_eta_l1] + r_ts[6][p_width-1:p_eta_l1];
				  // r_w3[2] <= r_w3[2] - r_w3[2][p_width-1:p_eta_l1] + r_ts[7][p_width-1:p_eta_l1];
				  // r_w4[2] <= r_w4[2] - r_w4[2][p_width-1:p_eta_l1] + r_ts[8][p_width-1:p_eta_l1];
				end	  
              else if(r_tr[2]<= p_trace_ll)
			    begin
				  if(r_threshold[2]>= r_delta[2]) r_threshold[2] <= r_threshold[2] - r_delta[2];//p_deltaT;
                  else if(r_threshold[2]< r_delta[2]) r_threshold[2] <= i_lv[2*(2*p_width+2)-1:(2*p_width+2)];//p_z;//{(2*p_width+2){1'b0}};
                end				
		      if(r_tr[3]> p_trace_ll)
			    begin
				  r_w1[3] <= calwt(r_w1[3],r_ts[9]);
				  r_w2[3] <= calwt(r_w2[3],r_ts[10]);
				  r_w3[3] <= calwt(r_w3[3],r_ts[11]);
				  r_w4[3] <= calwt(r_w4[3],r_ts[12]);				
				  // r_w1[3] <= r_w1[3] - r_w1[3][p_width-1:p_eta_l1] + r_ts[9][p_width-1:p_eta_l1]; 
				  // r_w2[3] <= r_w2[3] - r_w2[3][p_width-1:p_eta_l1] + r_ts[10][p_width-1:p_eta_l1];
				  // r_w3[3] <= r_w3[3] - r_w3[3][p_width-1:p_eta_l1] + r_ts[11][p_width-1:p_eta_l1];
				  // r_w4[3] <= r_w4[3] - r_w4[3][p_width-1:p_eta_l1] + r_ts[12][p_width-1:p_eta_l1];
				end					  
			  else if(r_tr[3]<= p_trace_ll)
                begin			  
				  if(r_threshold[3]>= r_delta[3]) r_threshold[3] <= r_threshold[3] - r_delta[3];//p_deltaT;
                  else if(r_threshold[3]< r_delta[3]) r_threshold[3] <= i_lv[3*(2*p_width+2)-1:2*(2*p_width+2)];//p_z;//{(2*p_width+2){1'b0}};
				end
		     if(r_tr[4]> p_trace_ll)
			    begin
				  r_w1[4] <= calwt(r_w1[4],r_ts[13]);
				  r_w2[4] <= calwt(r_w2[4],r_ts[14]);
				  r_w3[4] <= calwt(r_w3[4],r_ts[15]);
				  r_w4[4] <= calwt(r_w4[4],r_ts[16]);				
				  // r_w1[4] <= r_w1[4] - r_w1[4][p_width-1:p_eta_l1] + r_ts[13][p_width-1:p_eta_l1]; 
				  // r_w2[4] <= r_w2[4] - r_w2[4][p_width-1:p_eta_l1] + r_ts[14][p_width-1:p_eta_l1];
				  // r_w3[4] <= r_w3[4] - r_w3[4][p_width-1:p_eta_l1] + r_ts[15][p_width-1:p_eta_l1];
				  // r_w4[4] <= r_w4[4] - r_w4[4][p_width-1:p_eta_l1] + r_ts[16][p_width-1:p_eta_l1];
				end	
			 else if(r_tr[4]<= p_trace_ll) 
                begin			  
				  if(r_threshold[4]>= r_delta[4]) r_threshold[4] <= r_threshold[4] - r_delta[4];//p_deltaT;
                  else if(r_threshold[4]< r_delta[4]) r_threshold[4] <= i_lv[4*(2*p_width+2)-1:3*(2*p_width+2)];//p_z;//{(2*p_width+2){1'b0}};
				end
            end
	end
end	
  
endmodule