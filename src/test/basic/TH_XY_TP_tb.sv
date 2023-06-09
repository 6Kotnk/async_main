`timescale 1ns / 1ps


module TH_XY_TP_tb();


wire out;

reg in1 = 0;
reg in2 = 0;

reg en = 0;




reg rst_tb;


TH_XY#
(
  .ENC  ("TP"),
  .CFG  ("2_0_2")
)
DUT
(
//---------CTRL----------------
	.rst(rst_tb),
//-----------------------------
	.en(en),
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
	
	
	en = !en;
	#100;
	en = !en;
	#100;
	
	in1 = !in1;
	#100;
	in2 = !in2;
    #100;
	
	en = !en;
	#100;
	en = !en;
	#100;
	
	in1 = !in1;
	#100;
	in2 = in2;
    #100;
	
	en = !en;
	#100;
	en = !en;
	#100;
	
	in1 = in1;
	#100;
	in2 = !in2;
    #100;
	
	en = !en;
	#100;
	en = !en;
	#100;	
	
	in1 = !in1;
	#100;
	in2 = !in2;
    #100;
	
	en = !en;
	#100;
	en = !en;
	#100;
	
	in1 = !in1;
	#100;
	in2 = !in2;
    #100;
	
	en = !en;
	#100;
	en = !en;
	#100;
	
    #1000;
    $finish;  
    
    
    
end

endmodule
