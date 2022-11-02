module clock_gen #(
parameter   p_clk_tst = 2*200,
parameter   p_clk_1 = 2*200, //2*390
parameter   p_clk_2 = 2*450 //2*1000
)
(
input    i_clk,
input    i_rst_n,
output   o_clk_tst,
output   o_clk_lvl_1,
output   o_clk_lvl_2
);


reg  [$clog2(p_clk_1):0]  r_counter_1; 
reg  [$clog2(p_clk_2):0]  r_counter_2; 
reg  [$clog2(p_clk_tst):0]  r_counter_3;
assign o_clk_lvl_1 = (r_counter_1 < p_clk_1/2)? 0:1; 
assign o_clk_lvl_2 = (r_counter_2 < p_clk_2/2)? 0:1; 
assign o_clk_tst =   (r_counter_3 < p_clk_tst/2)? 0:1; 

always @(posedge i_clk or negedge i_rst_n)
begin
if(!i_rst_n)
   r_counter_1 <= 0;
else if(r_counter_1 < p_clk_1)
   r_counter_1 <= r_counter_1 +1;
else 
   r_counter_1 <= 0;
end

always @(posedge i_clk or negedge i_rst_n)
begin
if(!i_rst_n)
   r_counter_2 <= 0;
else if(r_counter_2 < p_clk_2)
   r_counter_2 <= r_counter_2 +1;
else 
   r_counter_2 <= 0;
end

always @(posedge i_clk or negedge i_rst_n)
begin
if(!i_rst_n)
   r_counter_3 <= 0;
else if(r_counter_3 < p_clk_tst)
   r_counter_3 <= r_counter_3 +1;
else 
   r_counter_3 <= 0;
end


endmodule