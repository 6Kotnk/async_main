`timescale 1ns / 1ps

module xor2#(
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

logic in01;
logic in11;

TH_XY#
(
  .ENC  (ENC),
  .CFG  ("2_0_2")
)
xor01
(
//---------CTRL----------------
	.rst(rst),
//-----------------------------
	.en(en),
	.in({in1[0],in0[1]}),
	.out(in01)
//-----------------------------
);

TH_XY#
(
  .ENC  (ENC),
  .CFG  ("2_0_2")
)
xor11
(
//---------CTRL----------------
	.rst(rst),
//-----------------------------
	.en(en),
	.in({in1[1],in0[1]}),
	.out(in11)
//-----------------------------
);

TH_XY#
(
  .ENC  (ENC),
  .CFG  ("3_1_2")
)
xor_false
(
//---------CTRL----------------
	.rst(rst),
//-----------------------------
	.en(en),
	.in({in1[0],in0[0],in11}),
	.out(out[0])
//-----------------------------
);

TH_XY#
(
  .ENC  (ENC),
  .CFG  ("3_1_2")
)
xor_true
(
//---------CTRL----------------
	.rst(rst),
//-----------------------------
	.en(en),
	.in({in1[1],in0[0],in01}),
	.out(out[1])
//-----------------------------
);

endmodule
