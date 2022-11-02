`timescale 1ns/1ns

module comparator_6in_tb();

parameter p_width =22; 

reg r_clk;
reg r_rst_n;
reg [p_width-1:0]  r_a;
reg [p_width-1:0]  r_b;
reg [p_width-1:0]  r_c;
reg [p_width-1:0]  r_d;
reg [p_width-1:0]  r_e;
reg [p_width-1:0]  r_f;
wire [6:1]  w_index;
wire [p_width-1:0] w_result;

comparator_6in
#(.p_width(22)) uut
(
.i_clk(r_clk),
.i_rst_n(r_rst_n),
.i_a(r_a),
.i_b(r_b),
.i_c(r_c),
.i_d(r_d),
.i_e(r_e),
.i_f(r_f),
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
	   r_d = 0;
	   r_e = 0;
	   r_f = 0;	   
#10    r_rst_n = 1;

#50    r_a = 3;
       r_b = 2;
	   r_c = 1;
	   r_d = 0;
	   r_e = 0;
	   r_f = 0;	  
	   
#50    r_a = 6;
       r_b = 7;
	   r_c = 4;
	   r_d = 7;
	   r_e = 5;
	   r_f = 1;	  
	   
#50    r_a = 5;
       r_b = 4;
	   r_c = 7;
	   r_d = 7;
	   r_e = 3;
	   r_f = 5;	  
	   
#50    r_a = 10;
       r_b = 11;
	   r_c = 11;

#50    r_a = 12;
       r_b = 12;
	   r_c = 11;
	   r_d = 12;
	   r_e = 11;
	   r_f = 10;	  
	   
#50    r_a = 15;
       r_b = 15;
	   r_c = 16;
	   r_d = 17;
	   r_e = 15;
	   r_f = 16;	  
	   
#50    r_a = 18;
       r_b = 18;
	   r_c = 18;
	   r_d = 18;
	   r_e = 13;
	   r_f = 19;	  
	   
#50    r_a = 21;
       r_b = 20;
	   r_c = 21;

#50    r_a = 32;
       r_b = 33;
	   r_c = 33;
	   r_d = 23;
	   r_e = 22;
	   r_f = 11;	  
	   
#50    r_a = 0;
       r_b = 0;
	   r_c = 0;	 
	   r_d = 0;
	   r_e = 1;
	   r_f = 0;	  
	   
#50    r_a = 33;
       r_b = 33;
	   r_c = 33;
	   r_d = 33;
	   r_e = 33;
	   r_f = 33;	  	   
end

always #10 r_clk <= ~r_clk;

endmodule	   