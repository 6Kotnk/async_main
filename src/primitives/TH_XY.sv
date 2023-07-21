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

localparam IN_NUM_ACTUAL = CFG[39:32] - 48;

logic [IN_NUM-1:0] in_p;
logic out_pre;
assign #43 out = out_pre;

generate

  if(IN_NUM > IN_NUM_ACTUAL)
  begin
    assign in_p[IN_NUM-1:IN_NUM_ACTUAL] = 0;
  end

  if (ENC == "TP")
  begin
    genvar idx;
    for (idx = 0; idx < IN_NUM_ACTUAL; idx = idx + 1) 
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
  .out  (out_pre)
);

endmodule