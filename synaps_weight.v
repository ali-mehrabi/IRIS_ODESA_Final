
module synaps_weight #(
parameter  p_input_width = 9,
parameter  p_weight_width = 9
)
 
(
input   [p_input_width -1:0]                    i_synaps,
input   [p_weight_width -1:0]                   i_weight,
output  [p_weight_width + p_input_width -1 :0]  o_cell_out
);

assign o_cell_out = i_synaps*i_weight;

endmodule	 
	 
  