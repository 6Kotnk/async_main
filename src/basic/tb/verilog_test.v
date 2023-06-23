`timescale 1ns / 1ps


module verilog_test();
/*
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
*/


wire out;

reg [3:0] in = 0;
reg rst = 1;

TH_XY #
(
  .ENC  ("FP"),
  .CFG  ("2_0_2")
)
TH_XY_inst
(
  .rst  (rst),
  .in   (in),
  .out  (out)
);




initial
begin

  #1000;
  rst <= 0;
  #1000;
  
  in[0] <= 1;
  #100;
  in[1] <= 1;
  #1000;
  
  in[1] <= 0;
  #100;
  in[0] <= 0;
  #1000;
  
/*
  $display("%h", IN_TOTAL+1);
  $display("%h", THR * 2);
  
  
  $display("%h", fb);
  */
  $finish;  
    
end

endmodule
