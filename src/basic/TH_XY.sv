`timescale 1ns / 1ps

module TH_XY#(
  parameter                       ENC = "FP",
  parameter                       CFG = "2_0_2",
  localparam                      IN_NUM = 4
)
(
//---------CTRL-----------------------
  input                           rst,
//------------------------------------
  input                            en,
  input  [IN_NUM-1 : 0]            in,            
//---------OUT------------------------
  output                          out
//------------------------------------
);

wire [IN_NUM-1:0] in_p;

generate
  if (ENC == "TP")
  begin
    genvar idx;
    for (idx = 0; idx < IN_NUM; idx = idx + 1) 
    begin
      P p
      (
        .rst(rst),
        
        .en(en),
        .fb(out),
        .in(in[idx]),
        
        .out(in_p[idx])
      );
    end
  end
  else if (ENC == "FP")
  begin
    assign in_p = in;
  end
endgenerate

TH_XY_core #
(
  .ENC  (ENC),
  .CFG  (CFG)
)
TH_XY_core_inst
(
  .rst  (rst),
  .in   (in_p),
  .out  (out)
);

endmodule