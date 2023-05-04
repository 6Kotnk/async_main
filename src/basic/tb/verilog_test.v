`timescale 1ns / 1ps


module verilog_test();

localparam CFG = "IN:2 THR:2 D:X";

localparam IN =  CFG[10*8 +: 4];
localparam THR = CFG[4*8  +: 4];
localparam D =   CFG[0*8  +: 8];
localparam D_USED =   D != "X";

localparam IN_TOTAL = IN + D_USED;

localparam FB_NEEDED = (IN_TOTAL + 1) != (THR * 2);


wire fb;

generate
  if(FB_NEEDED)
  begin
    assign fb = 1;
  end
  else
  begin
    assign fb = 0;
  end
endgenerate

initial
begin
  $display("%h", IN_TOTAL+1);
  $display("%h", THR * 2);
  
  
  $display("%h", fb);
  #1000;
  $finish;  
    
end

endmodule
