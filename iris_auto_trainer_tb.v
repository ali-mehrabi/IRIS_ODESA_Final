`timescale 1ns/1ns 

module iris_auto_trainer_tb();
reg  r_clk; 
reg  r_rst_n;
wire  [20:1]  w_test_vec;
wire  [23:21] w_label;
wire          w_end_of_epochs;

iris_auto_trainer  uut (
.i_clk(r_clk),
.i_rst_n(r_rst_n),
.o_end_of_epochs(w_end_of_epochs),
.o_test_vector(w_test_vec),
.o_label(w_label)
);



initial
begin
r_clk = 0;
r_rst_n = 0;

#15  r_rst_n = 1;
end

always #10  r_clk <= ~r_clk; 

endmodule