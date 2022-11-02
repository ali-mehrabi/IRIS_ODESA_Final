`timescale 1ns/1ns

module comparator_3in_tb();

parameter p_width =22; 

reg r_clk;
reg r_rst_n;
reg [p_width-1:0]  r_a;
reg [p_width-1:0]  r_b;
reg [p_width-1:0]  r_c;

wire [3:1]  w_index;
wire [p_width-1:0] w_result;

comparator_3in
#(.p_width(22)) uut
(
.i_clk(r_clk),
.i_rst_n(r_rst_n),
.i_a(r_a),
.i_b(r_b),
.i_c(r_c),
.o_result(w_result),
.o_index(w_index)
);

initial
begin 
       r_clk = 0;
	   r_rst_n = 0;
	   r_a = 0;
	   r_b = 0;
	   r_c = 0;
#10    r_rst_n = 1;

#50    r_a = 3;
       r_b = 2;
	   r_c = 1;

#50    r_a = 6;
       r_b = 7;
	   r_c = 4;

#50    r_a = 5;
       r_b = 4;
	   r_c = 7;

#50    r_a = 10;
       r_b = 11;
	   r_c = 11;

#50    r_a = 12;
       r_b = 12;
	   r_c = 11;

#50    r_a = 15;
       r_b = 15;
	   r_c = 16;

#50    r_a = 18;
       r_b = 18;
	   r_c = 18;

#50    r_a = 21;
       r_b = 20;
	   r_c = 21;

#50    r_a = 32;
       r_b = 33;
	   r_c = 33;
	   
#50    r_a = 0;
       r_b = 0;
	   r_c = 0;	 

#50    r_a = 33;
       r_b = 33;
	   r_c = 33;	   
end

always #10 r_clk <= ~r_clk;

endmodule	   