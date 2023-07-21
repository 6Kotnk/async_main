`timescale 1ns / 1ps


module TH_XY_FP_tb();


wire out;

reg in1 = 0;
reg in2 = 0;




reg rst_tb;


TH_XY#
(
  .ENC  ("FP"),
  .CFG  ("2_0_2")
)
DUT
(
//---------CTRL----------------
	.rst(rst_tb),
//-----------------------------
	.in({in2,in1}),
	.out(out)
//-----------------------------
);

initial
begin

    rst_tb = 1;
    #100;    
    rst_tb = 0;
    #1000;
	
	in1 = 1;
	#100;
	in1 = 0;
    #100;
	in2 = 1;
	#100;
	in2 = 0;
    #100;
	in1 = 1;
	#100;
	in2 = 1;
    #100;
	
	in2 = 0;
	#100;
	in2 = 1;
    #100;
	in1 = 0;
	#100;
	in1 = 1;
    #100;
	in1 = 0;
	#100;
	in2 = 0;
    #100;
	
	
	
	
    #1000;
    $finish;  
    
    
    
end

endmodule
