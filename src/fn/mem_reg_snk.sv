`timescale 1ns / 1ps

module mem_reg_snk#(
  parameter                    ENC = "TP",
  parameter                    WIDTH = 1,
  localparam                   RAIL_NUM = 2
)
(
//---------CTRL-----------------------
  input                           rst,
//---------LINK-IN--------------------
  output                          ack_o,
  input [WIDTH-1:0][RAIL_NUM-1:0] in,
//------------------------------------
);


cmpl_det#
(
  .ENC                        (ENC),
  .WIDTH                      (WIDTH)
)
reg_cmpl_det
(
//---------CTRL----------------
  .rst(rst),
//-----------------------------
  .in(in),
  .cmpl(ack_o)
//-----------------------------
);

endmodule
