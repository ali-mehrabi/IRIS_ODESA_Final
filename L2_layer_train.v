
module L2_train
#(parameter p_width = 9,
  parameter p_eta_l2 = 3)
(
 input                        i_clk,
 input                        i_rst_n,
 input  [4:1]                 i_event,
 input  [3:1]                 i_label,
 input  [3:1]                 i_l2_spikeout,
 input  [(4*p_width)-1:0]     i_ts,
 input  [3*(2*p_width+2)-1:0] i_lv,
 input                        i_endof_epochs,
 output                       o_las,
 output                       o_gas,
 output [3*(4*p_width)-1:0]   o_weights,
 output [3*(2*p_width+2)-1:0] o_thresholds
 );

parameter p_deltaT = 'h03f;
parameter p_default_thr = 'h0ff00;// 20'h0_7f_00; //20'h0_ff_00; 
parameter p_default_w = 'h0ff;
parameter p_wait_clks = 7;
parameter p_pass_lvl_2 = 6;
parameter p_z  = 0;//p_deltaT; //{(p_width){1'b1}} -1;
parameter p_ratio = 2; 
wire                         w_is_label;
wire                         w_is_winner;
reg                          r_stop_n;
reg  [3:1]                   r_winner;
reg  [3:1]                   r_label;
reg                          r_is_winner;
reg                          r_is_label;
reg                          r_training_active;
reg  [$clog2(p_wait_clks):0] r_counter;
reg  [p_width-1:0]           r_w1[3:1];
reg  [p_width-1:0]           r_w2[3:1];
reg  [p_width-1:0]           r_w3[3:1];
reg  [p_width-1:0]           r_w4[3:1];
reg  [p_width-1:0]           r_ts[4:1];
reg  [(2*p_width+2)-1:0]     r_threshold[3:1];
wire [4*p_width-1:0]         w_weight[3:1];
reg  [3:0]                   r_eta[3:1];
reg  [10:0]                  r_delta[3:1];
genvar i;


function [3:0] f_eta; 
input [(2*p_width+2)-1:0] f_in;
begin
  if (f_in > 'hfff) 
	f_eta = 'h7; 
  else  
	f_eta = 'h3; 
end
endfunction

function [10:0] f_delta; 
input [(2*p_width+2)-1:0] f_in;
begin
  if (f_in > 'hffff) 
	f_delta = 'h7ff; 
  else if (f_in > 'hfff) 
	f_delta = 'h1ff; 
  else if (f_in > 'hff) 
	f_delta = 'hf;
  else 
	f_delta = 'h1;	
end
endfunction

function [(2*p_width+2)-1:0] incthr;
input [(2*p_width+2)-1:0] a, b;
input [3:0] c;
begin 
  incthr = a + (b[(2*p_width+2)-1:0]>> c) + (a[(2*p_width+2)-1:0]>>c);
end	
endfunction

function [(2*p_width+2)-1:0] calthr;
input [(2*p_width+2)-1:0] a, b;
input [3:0] c;
begin 
  calthr = a + (b[(2*p_width+2)-1:0]>> c) - (a[(2*p_width+2)-1:0]>>c);
end	
endfunction

function [p_width-1:0] calwt;
input [p_width-1:0] a, b;
begin
  calwt = a + b[p_width-1:p_eta_l2]-a[p_width-1:p_eta_l2]; 
end	
endfunction	 


assign w_is_winner = i_l2_spikeout[3] ^ i_l2_spikeout[2] ^ i_l2_spikeout[1];
assign w_is_label = i_label[3] ^ i_label[2] ^ i_label[1];
assign w_pass_l2 = (r_counter == p_pass_lvl_2)? 1:0;
assign w_weight[1] = {r_w4[1], r_w3[1], r_w2[1], r_w1[1]};
assign w_weight[2] = {r_w4[2], r_w3[2], r_w2[2], r_w1[2]};
assign w_weight[3] = {r_w4[3], r_w3[3], r_w2[3], r_w1[3]};
assign o_weights = {w_weight[3], w_weight[2], w_weight[1]};
assign o_thresholds = {r_threshold[3],r_threshold[2],r_threshold[1]};
assign o_las = w_is_winner; 
assign o_gas = w_is_label; 

always @(posedge w_is_winner or negedge i_rst_n)
   begin	
	 if(!i_rst_n)
		begin
		  r_ts[1]  <= {p_width{1'b0}};
		  r_ts[2]  <= {p_width{1'b0}};		
		  r_ts[3]  <= {p_width{1'b0}};
		  r_ts[4]  <= {p_width{1'b0}};
		end
	 else
		begin
		  r_ts[1]  <= i_ts[p_width-1:0];
		  r_ts[2]  <= i_ts[2*p_width-1:1*p_width];	
		  r_ts[3]  <= i_ts[3*p_width-1:2*p_width];	
		  r_ts[4]  <= i_ts[4*p_width-1:3*p_width];		
		end
   end

///////////////////open training window/////////////////////////////
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
always @(posedge w_is_label or negedge r_stop_n)
begin
  if(!r_stop_n)
    r_training_active <= 1'b0;
  else
    r_training_active <= 1'b1;
end
///////////////////run counter if training is on /////////////
always @(posedge ~i_clk or negedge r_stop_n)
begin 
   if(!r_stop_n)
     r_counter <= 0;
   else if(r_training_active && !i_endof_epochs)
     r_counter <= r_counter +1; 
end	
/////////////////////////////////////////////////////////////
//latch winner
generate
for(i=1;i<=3;i=i+1) 
  begin:gen_r_winner
	always @(posedge i_l2_spikeout[i] or negedge r_training_active)
	begin
	  if(!r_training_active)
		  r_winner[i] <= 1'b0;
	  else 
		  r_winner[i] <= 1'b1; 
	end 
  end
endgenerate 

// Latch label
always @(posedge w_is_label or negedge r_stop_n)
begin
  if(!r_stop_n)
    r_is_label <= 1'b0;
  else
    r_is_label <= 1'b1;
end

always @(posedge w_is_label or negedge r_stop_n)
begin
  if(!r_stop_n)
    r_label <= 4'b0;
  else
    r_label <= i_label;
end

always @(posedge w_is_winner or negedge r_training_active)
begin
  if(!r_training_active)
    r_is_winner <= 1'b0;
  else
    r_is_winner <= 1'b1;
end


always@(posedge ~i_clk )
begin
  r_eta[1]   <= f_eta(i_lv[(2*p_width+2)-1:0]);
  r_eta[2]   <= f_eta(i_lv[2*(2*p_width+2)-1:(2*p_width+2)]);
  r_eta[3]   <= f_eta(i_lv[3*(2*p_width+2)-1:2*(2*p_width+2)]);
  r_delta[1] <= f_delta(r_threshold[1]);//i_lv[(2*p_width+2)-1:0]);
  r_delta[2] <= f_delta(r_threshold[2]);//i_lv[2*(2*p_width+2)-1:(2*p_width+2)]);
  r_delta[3] <= f_delta(r_threshold[3]);//i_lv[3*(2*p_width+2)-1:2*(2*p_width+2)]);
end


always@(posedge i_clk or negedge i_rst_n)
begin 
  if(!i_rst_n)
    begin
	  r_w1[1] <= p_default_w;
	  r_w2[1] <= p_default_w;
      r_w3[1] <= p_default_w;
      r_w4[1] <= p_default_w;
	  r_w1[2] <= p_default_w;
	  r_w2[2] <= p_default_w;
      r_w3[2] <= p_default_w;
      r_w4[2] <= p_default_w;
	  r_w1[3] <= p_default_w;
	  r_w2[3] <= p_default_w;
      r_w3[3] <= p_default_w;
      r_w4[3] <= p_default_w;	  
	  r_threshold[1] <= p_default_thr;
	  r_threshold[2] <= p_default_thr; 
	  r_threshold[3] <= p_default_thr;  
	end  
  else
	begin
	  if(w_pass_l2 & r_is_label) 
	     begin
           case(r_label)
		     3'b001:begin
			          if(r_winner == 3'b001)
						begin
						  r_w1[1] <= calwt(r_w1[1],r_ts[1]);
						  r_w2[1] <= calwt(r_w2[1],r_ts[2]);
						  r_w3[1] <= calwt(r_w3[1],r_ts[3]);
						  r_w4[1] <= calwt(r_w4[1],r_ts[4]);
						  r_threshold[1] <= calthr(r_threshold[1] ,i_lv[(2*p_width+2)-1:0], r_eta[1]);										  
						end	
                      else
					    begin
					      if(r_threshold[1]> r_delta[1])
					        r_threshold[1] <= r_threshold[1] - r_delta[1];
						  else
						    r_threshold[1] <=  i_lv[(2*p_width+2)-1:0];//p_z;//
					    end
			        end
		     3'b010:begin
			          if(r_winner == 3'b010)
					    begin
						  r_w1[2] <= calwt(r_w1[2],r_ts[1]);
						  r_w2[2] <= calwt(r_w2[2],r_ts[2]);
						  r_w3[2] <= calwt(r_w3[2],r_ts[3]);
						  r_w4[2] <= calwt(r_w4[2],r_ts[4]);
						  r_threshold[2] <= calthr(r_threshold[2] ,i_lv[2*(2*p_width+2)-1:(2*p_width+2)],r_eta[2]);						
						end
					  else
					    begin
					      if(r_threshold[2]> r_delta[2])
					        r_threshold[2] <= r_threshold[2] - r_delta[2];
						  else
						    r_threshold[2] <= i_lv[2*(2*p_width+2)-1:(2*p_width+2)];//p_z;//
					    end
			        end				
		     3'b100:begin
			          if(r_winner == 3'b100)
						begin
						  r_w1[3] <= calwt(r_w1[3],r_ts[1]);
						  r_w2[3] <= calwt(r_w2[3],r_ts[2]);
						  r_w3[3] <= calwt(r_w3[3],r_ts[3]);
						  r_w4[3] <= calwt(r_w4[3],r_ts[4]);
						  r_threshold[3] <= calthr(r_threshold[3] ,i_lv[3*(2*p_width+2)-1:2*(2*p_width+2)], r_eta[3]);						
						end						  
					  else
					    begin
					      if(r_threshold[3] > r_delta[3])
					        r_threshold[3] <= r_threshold[3] - r_delta[3];							
						  else
						    r_threshold[3] <= i_lv[3*(2*p_width+2)-1:2*(2*p_width+2)];//p_z;//
					    end
					end	
           endcase
         end
	  else if(w_is_winner & !r_is_label)
	    begin
	      case(i_l2_spikeout)
            3'b001:begin
			         r_threshold[1] <= incthr(r_threshold[1] ,i_lv[(2*p_width+2)-1:0], r_eta[1]);
				   end
            3'b010:begin
			         r_threshold[2] <= incthr(r_threshold[2] ,i_lv[2*(2*p_width+2)-1:(2*p_width+2)], r_eta[2]);
				   end			
            3'b100:begin
			         r_threshold[3] <= incthr(r_threshold[3] ,i_lv[3*(2*p_width+2)-1:2*(2*p_width+2)], r_eta[3]);
				   end			
		  endcase
		end
	end	
end	

endmodule