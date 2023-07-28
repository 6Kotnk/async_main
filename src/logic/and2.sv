`timescale 1ns / 1ps

module and2#(
  parameter                    ENC = "TP",
  localparam                   RAIL_NUM = 2
)
(
//---------CTRL-----------------------
  input                           rst,
  input                           en,
//---------LINK-IN--------------------
  input            [RAIL_NUM-1:0] in0,
//---------LINK-IN--------------------
  input            [RAIL_NUM-1:0] in1,
//---------LINK-OUT-------------------
  output           [RAIL_NUM-1:0] out
//------------------------------------
);

TH_XY#
(
  .ENC  (ENC),
  .CFG  ("4_2_3")
)
and_false
(
//---------CTRL----------------
	.rst(rst),
//-----------------------------
	.en(en),
	.in({in1[1],in0[1],in1[0],in0[0]}),
	.out(out[0])
//-----------------------------
);

TH_XY#
(
  .ENC  (ENC),
  .CFG  ("2_0_2")
)
and_true
(
//---------CTRL----------------
	.rst(rst),
//-----------------------------
	.en(en),
	.in({in1[1],in0[1]}),
	.out(out[1])
//-----------------------------
);

endmodule
