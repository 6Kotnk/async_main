`timescale 1ns / 1ps


module TOGGLE_tb();


wire [1:0] out;

reg in = 0;





reg rst_tb;


TOGGLE
DUT
(
//---------CTRL----------------
	.rst(rst_tb),
//-----------------------------
	.in(in),
	.out(out)
//-----------------------------
);

initial
begin

    rst_tb = 1;
    #100;    
    rst_tb = 0;
    #1000;
	
    in = !in;
    #100;   
    in = !in;
    #100; 
    in = !in;
    #100; 

    rst_tb = 1;
    #100;    
    rst_tb = 0;
    #100;
	
    in = !in;
    #100;   
    in = !in;
    #100; 
    in = !in;
    #100; 

    #1000;
    $finish;  
    
    
    
end

endmodule
